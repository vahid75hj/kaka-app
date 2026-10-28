import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaka_data/kaka_data.dart';
import 'package:kaka_domain/kaka_domain.dart';
import 'package:kaka_mobile/app/providers.dart';
import 'package:kaka_mobile/core/app_format.dart';
import 'package:kaka_mobile/core/money_input.dart';
import 'package:kaka_mobile/features/ai/ai_config.dart';
import 'package:kaka_mobile/features/budgets/budgets_screen.dart';
import 'package:kaka_mobile/features/home/home_screen.dart';
import 'package:kaka_mobile/features/queue/share_ingest.dart';
import 'package:kaka_sms/kaka_sms.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory dir;
  late KakaDatabase db;
  late ProviderContainer container;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('kaka_mvp3');
    db = KakaDatabase.open(File('${dir.path}/l.db'), key: 'k');
    container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        initialSettingsProvider.overrideWithValue(AppSettings.defaultsFor('fa').copyWith(onboarded: true)),
      ],
    );
  });
  tearDown(() async {
    container.dispose();
    await db.close();
    dir.deleteSync(recursive: true);
  });

  test('toman rates are stored per rial', () {
    final f = AppFormat(AppSettings.defaultsFor('fa'));
    expect(parseUserRate(f, '۱۰۵٬۰۰۰').toString(), '1050000');
    expect(showUserRate(f, Decimal.parse('1050000')), '۱۰۵۰۰۰');
  });

  test('exchange + rate → net worth in base; edit replaces and voids', () async {
    final ledger = container.read(ledgerProvider);
    final rial = await ledger.createAccount(
      name: 'ریالی',
      type: AccountType.asset,
      currency: Currency.irr,
      openingBalance: const Money(200000000, Currency.irr),
    );
    final usd = await ledger.createAccount(name: 'دلاری', type: AccountType.asset, currency: Currency.usd);
    await ledger.recordExchange(
      from: rial,
      to: usd,
      fromAmount: const Money(105000000, Currency.irr),
      toAmount: const Money(10000, Currency.usd),
    );
    await container
        .read(exchangeRateRepositoryProvider)
        .upsert(
          ExchangeRate(
            id: 'r',
            currency: Currency.usd,
            base: Currency.irr,
            date: DateTime.now(),
            rate: Decimal.parse('1100000'),
          ),
        );
    final balances = await ledger.watchBalances().first;
    final rates = await container.read(exchangeRateRepositoryProvider).getAll();
    final nw = NetWorth.of(balances, const [], CurrencyConverter(Currency.irr, rates));
    expect(nw.total.minor, 95000000 + 110000000);
    expect(nw.unconverted, isEmpty);

    // Edit = record the corrected one, void the original.
    final food = await ledger.ensureCategory('غذا', AccountType.expense, Currency.irr);
    await ledger.recordExpense(from: rial, category: food, amount: const Money(1000, Currency.irr));
    final txns = container.read(transactionRepositoryProvider);
    final original = (await txns.watchRecent().first).firstWhere((t) => t.kind == TransactionKind.expense);
    await ledger.replace(
      original,
      () => ledger.recordExpense(from: rial, category: food, amount: const Money(2000, Currency.irr)),
    );
    final after = (await txns.watchRecent().first).where((t) => t.kind == TransactionKind.expense).toList();
    expect(after.where((t) => t.isVoided), hasLength(1));
    expect(after.where((t) => !t.isVoided).single.postings.first.amount.minor, 2000);
  });

  test('a learned bank is used by share-in', () async {
    final learned = TemplateLearner.learn(
      [
        'بانک آینده\nبرداشت 1,000\nمانده 9,000',
        'بانک آینده\nواریز 2,500\nمانده 11,500',
        'بانک آینده\nبرداشت 500\nمانده 11,000',
      ],
      nameFa: 'آینده',
      nameEn: 'Ayandeh',
    );
    expect(learned.ok, isTrue);
    await container.read(customParserStoreProvider).save(learned.bank!.bankId, jsonEncode(learned.bank!.toJson()));
    final r = await container.read(shareIngestProvider).ingest('بانک آینده\nبرداشت 7,000\nمانده 4,000');
    expect(r, IngestResult.added);
    final d = (await container.read(draftServiceProvider).watchPending().first).single;
    expect((d.amount.minor, d.bankId, d.note), (7000, learned.bank!.bankId, 'آینده'));
  });

  test('AI add_transaction only creates a masked-safe draft', () async {
    final ledger = container.read(ledgerProvider);
    final wallet = await ledger.createAccount(name: 'کیف', type: AccountType.asset, currency: Currency.irr);
    final runner = container.read(toolRunnerProvider);
    final res = await maskedTool(runner, 'add_transaction', {
      'kind': 'expense',
      'amount': '50000',
      'account_id': wallet.id,
      'category': 'غذا',
    });
    expect(res['status'], 'pending_user_approval');
    expect(await container.read(transactionRepositoryProvider).watchRecent().first, isEmpty);
    final d = (await container.read(draftServiceProvider).watchPending().first).single;
    expect((d.source, d.amount.minor, d.accountId), (DraftSource.ai, 50000, wallet.id));
    final listed = await maskedTool(runner, 'list_accounts', {});
    expect(jsonEncode(listed), isNot(contains(RegExp(r'\d{8,}'))));
  });

  test('gold bought from an account: cash leaves, net worth = cash + market value, void restores', () async {
    final ledger = container.read(ledgerProvider);
    final wallet = await ledger.createAccount(
      name: 'کیف',
      type: AccountType.asset,
      currency: Currency.irr,
      openingBalance: const Money(10000000, Currency.irr),
    );
    await container.read(assetRepositoryProvider).ensureBuiltIns();
    final m = await container
        .read(assetTradingProvider)
        .trade(
          assetTypeId: 'gold18',
          quantityMilli: 2000,
          buy: true,
          total: const Money(8000000, Currency.irr),
          cash: wallet,
        );
    final assets = container.read(assetRepositoryProvider);
    await assets.upsertPrice(
      AssetPrice(id: 'p', assetTypeId: 'gold18', date: DateTime(2026), price: const Money(4500000, Currency.irr)),
    );
    final holdings = AssetMath.holdings(
      await assets.watchTypes().first,
      await assets.watchMovements().first,
      await assets.watchPrices().first,
    );
    final balances = await ledger.watchBalances().first;
    expect(balances.firstWhere((b) => b.account.id == wallet.id).balance.minor, 2000000);
    expect(NetWorth.of(balances, holdings, CurrencyConverter(Currency.irr, const [])).total.minor, 2000000 + 9000000);

    await container.read(assetTradingProvider).voidMovement(m);
    final after = await ledger.watchBalances().first;
    expect(after.firstWhere((b) => b.account.id == wallet.id).balance.minor, 10000000);
    expect((await assets.watchMovements().first).single.voidedAt, isNotNull);
  });

  test('AI transfer becomes a real transfer draft (from → to), not an expense', () async {
    final ledger = container.read(ledgerProvider);
    final a = await ledger.createAccount(name: 'ملت', type: AccountType.asset, currency: Currency.irr);
    final b = await ledger.createAccount(name: 'نقد', type: AccountType.asset, currency: Currency.irr);
    final res = await maskedTool(container.read(toolRunnerProvider), 'add_transaction', {
      'kind': 'transfer',
      'amount': '20000',
      'account_id': a.id,
      'to_account_id': b.id,
      'note': 'عابربانک',
    });
    expect(res['status'], 'pending_user_approval');
    final d = (await container.read(draftServiceProvider).watchPending().first).single;
    expect((d.isTransfer, d.accountId, d.toAccountId, d.note, d.category), (true, a.id, b.id, 'عابربانک', null));
  });

  test('backup reminder: due once an account is 14+ days old and never backed up; a backup clears it', () async {
    expect(container.read(backupDueProvider), isFalse, reason: 'nothing to back up yet');
    await container
        .read(accountRepositoryProvider)
        .upsert(
          Account(
            id: 'old',
            name: 'کیف',
            type: AccountType.asset,
            currency: Currency.irr,
            createdAt: DateTime.now().subtract(const Duration(days: 20)),
          ),
        );
    final sub = container.listen(accountsProvider, (_, _) {});
    addTearDown(sub.close);
    await container.read(accountsProvider.future);
    await Future<void>.delayed(Duration.zero);
    expect(container.read(backupDueProvider), isTrue);
    await container.read(settingsProvider.notifier).update((s) => s.copyWith(lastBackupAt: DateTime.now));
    expect(container.read(backupDueProvider), isFalse);
    await container
        .read(settingsProvider.notifier)
        .update((s) => s.copyWith(backupReminderDays: 0, lastBackupAt: () => null));
    expect(container.read(backupDueProvider), isFalse, reason: 'reminder off');
  });

  test('insecure AI endpoint warning: only plain http to public hosts', () {
    for (final ok in [
      'https://api.openai.com/v1',
      'http://localhost:11434',
      'http://127.0.0.1:8080',
      'http://192.168.1.10:11434',
      'http://10.0.0.5',
      'http://172.20.1.1',
      'http://my-pc.local:11434',
      '',
    ]) {
      expect(isInsecureEndpoint(ok), isFalse, reason: ok);
    }
    for (final bad in ['http://api.example.com/v1', 'http://8.8.8.8:11434', 'http://172.32.0.1']) {
      expect(isInsecureEndpoint(bad), isTrue, reason: bad);
    }
  });

  test('budgets: this month spending in toman, edit text round-trips, rename follows', () async {
    final ledger = container.read(ledgerProvider);
    final f = container.read(formatProvider);
    final cash = await ledger.createAccount(name: 'نقد', type: AccountType.asset, currency: Currency.irr);
    final food = await ledger.ensureCategory('غذا', AccountType.expense, Currency.irr);
    await ledger.recordExpense(from: cash, category: food, amount: const Money(6000000, Currency.irr));
    final limit = parseUserMoney(f, '۱۰۰٬۰۰۰', Currency.irr); // toman
    expect(limit.minor, 1000000);
    final repo = container.read(budgetRepositoryProvider);
    await repo.upsert(Budget(id: Budget.idFor('غذا'), category: 'غذا', limit: limit));
    // Editing shows the number in the user's unit; it must parse back to the same limit.
    expect(parseUserMoney(f, f.number(limit), Currency.irr), limit);

    final sub = container.listen(budgetStatusesProvider, (_, _) {});
    addTearDown(sub.close);
    await container.read(budgetsProvider.future);
    await container.read(transactionsProvider.future);
    await container.read(accountsProvider.future);
    final s = container.read(budgetStatusesProvider).single;
    expect((s.spent?.minor, s.state), (6000000, BudgetState.over));

    await ledger.renameCategory(AccountType.expense, 'غذا', 'خوراک');
    await repo.renameCategory('غذا', 'خوراک');
    expect((await repo.getAll()).single.category, 'خوراک');
  });
}
