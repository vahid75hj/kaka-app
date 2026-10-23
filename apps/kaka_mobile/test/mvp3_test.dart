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
}
