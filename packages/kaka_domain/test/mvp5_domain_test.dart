import 'package:kaka_domain/kaka_domain.dart';
import 'package:test/test.dart';

class _Accounts implements AccountRepository {
  final items = <String, Account>{};
  @override
  Future<Account?> findById(String id) async => items[id];
  @override
  Future<List<Account>> getAll() async => items.values.toList();
  @override
  Future<void> upsert(Account a) async => items[a.id] = a;
  @override
  Stream<List<Account>> watchAll() => Stream.value(items.values.toList());
}

class _Txns implements TransactionRepository {
  final items = <LedgerTransaction>[];
  @override
  Future<void> insert(LedgerTransaction t) async => items.add(t);
  @override
  Future<void> markVoided(String id, DateTime at) async {
    final i = items.indexWhere((t) => t.id == id);
    final t = items[i];
    items[i] = LedgerTransaction(
      id: t.id,
      kind: t.kind,
      occurredAt: t.occurredAt,
      note: t.note,
      postings: t.postings,
      voidedAt: at,
    );
  }

  @override
  Stream<List<LedgerTransaction>> watchRecent({int limit = 200}) => Stream.value(items);
  @override
  Stream<Map<String, int>> watchPostedSums() {
    final sums = <String, int>{};
    for (final t in items.where((t) => !t.isVoided)) {
      for (final p in t.postings) {
        sums.update(p.accountId, (v) => v + p.amount.minor, ifAbsent: () => p.amount.minor);
      }
    }
    return Stream.value(sums);
  }
}

class _Assets implements AssetRepository {
  final movements = <AssetMovement>[];
  @override
  Future<void> insertMovement(AssetMovement m) async => movements.add(m);
  @override
  Future<void> voidMovement(String id, DateTime at) async {
    final i = movements.indexWhere((m) => m.id == id);
    final m = movements[i];
    movements[i] = AssetMovement(
      id: m.id,
      assetTypeId: m.assetTypeId,
      quantityMilli: m.quantityMilli,
      date: m.date,
      total: m.total,
      transactionId: m.transactionId,
      voidedAt: at,
    );
  }

  @override
  Future<void> upsertPrice(AssetPrice p) async {}
  @override
  Future<void> upsertType(AssetType t) async {}
  @override
  Stream<List<AssetMovement>> watchMovements() => Stream.value(movements);
  @override
  Stream<List<AssetPrice>> watchPrices() => const Stream.empty();
  @override
  Stream<List<AssetType>> watchTypes() => const Stream.empty();
}

void main() {
  late _Accounts accounts;
  late _Txns txns;
  late _Assets assets;
  late LedgerService ledger;
  late AssetTrading trading;
  late Account wallet;

  setUp(() async {
    accounts = _Accounts();
    txns = _Txns();
    assets = _Assets();
    ledger = LedgerService(accounts, txns);
    trading = AssetTrading(assets, ledger);
    wallet = await ledger.createAccount(
      name: 'w',
      type: AccountType.asset,
      currency: Currency.irr,
      openingBalance: const Money(1000000, Currency.irr),
    );
  });

  Future<int> walletBalance() async =>
      (await ledger.watchBalances().first).firstWhere((b) => b.account.id == wallet.id).balance.minor;

  test('buy from an account moves cash; net worth counts market value, not cost', () async {
    final m = await trading.trade(
      assetTypeId: 'coin_emami',
      quantityMilli: 1000,
      buy: true,
      total: const Money(600000, Currency.irr),
      cash: wallet,
    );
    expect(await walletBalance(), 400000);
    expect(m.transactionId, isNotNull);
    expect(txns.items.last.kind, TransactionKind.asset);
    final holdings = AssetMath.holdings(AssetType.builtIn, assets.movements, [
      AssetPrice(id: 'p', assetTypeId: 'coin_emami', date: DateTime(2026), price: const Money(700000, Currency.irr)),
    ]);
    final nw = NetWorth.of(await ledger.watchBalances().first, holdings, CurrencyConverter(Currency.irr, const []));
    expect(nw.total.minor, 400000 + 700000);
  });

  test('sell credits cash; voiding a movement voids its cash transaction', () async {
    await trading.trade(
      assetTypeId: 'gold18',
      quantityMilli: 2500,
      buy: true,
      total: const Money(500000, Currency.irr),
      cash: wallet,
    );
    final sell = await trading.trade(
      assetTypeId: 'gold18',
      quantityMilli: 1000,
      buy: false,
      heldMilli: 2500,
      total: const Money(250000, Currency.irr),
      cash: wallet,
    );
    expect(sell.quantityMilli, -1000);
    expect(await walletBalance(), 750000);
    await trading.voidMovement(sell);
    expect(await walletBalance(), 500000);
    expect(assets.movements.last.voidedAt, isNotNull);
  });

  test('rejects overselling, missing total and currency mismatch; holdings-only trades still work', () async {
    expect(
      () => trading.trade(assetTypeId: 'gold18', quantityMilli: 1, buy: false, heldMilli: 0),
      throwsA(isA<DomainException>().having((e) => e.code, 'code', 'asset.sell_more_than_held')),
    );
    expect(
      () => trading.trade(assetTypeId: 'gold18', quantityMilli: 1, buy: true, cash: wallet),
      throwsA(isA<DomainException>()),
    );
    expect(
      () => trading.trade(
        assetTypeId: 'gold18',
        quantityMilli: 1,
        buy: true,
        cash: wallet,
        total: const Money(1, Currency.usd),
      ),
      throwsA(isA<DomainException>()),
    );
    final m = await trading.trade(assetTypeId: 'gold18', quantityMilli: 1000, buy: true);
    expect(m.transactionId, isNull);
    expect(await walletBalance(), 1000000);
  });

  test('opening balances never post into FX/Assets system accounts', () async {
    await ledger.fxAccount(Currency.usd);
    await trading.trade(
      assetTypeId: 'gold18',
      quantityMilli: 1000,
      buy: true,
      total: const Money(1, Currency.irr),
      cash: wallet,
    );
    final usd = await ledger.createAccount(
      name: 'u',
      type: AccountType.asset,
      currency: Currency.usd,
      openingBalance: const Money(100, Currency.usd),
    );
    final opening = txns.items.lastWhere((t) => t.kind == TransactionKind.opening);
    final other = opening.postings.firstWhere((p) => p.accountId != usd.id).accountId;
    expect(accounts.items[other]!.name, 'Opening balances USD');
  });

  test('settings: new keys round-trip; old JSON gets safe defaults; backup reminder', () {
    final s = AppSettings.defaultsFor(
      'fa',
    ).copyWith(smsBackground: true, lastBackupAt: () => DateTime(2026, 10, 1), backupReminderDays: 7);
    final back = AppSettings.fromJson(s.toJson());
    expect((back.smsBackground, back.lastBackupAt, back.backupReminderDays), (true, DateTime(2026, 10, 1), 7));
    final old = AppSettings.defaultsFor('en').toJson()
      ..remove('sms_background')
      ..remove('last_backup_at')
      ..remove('backup_reminder_days');
    final o = AppSettings.fromJson(old);
    expect((o.smsBackground, o.lastBackupAt, o.backupReminderDays), (false, null, 14));

    expect(o.backupDue(DateTime(2026, 10, 20), firstActivity: null), isFalse, reason: 'no data yet');
    expect(o.backupDue(DateTime(2026, 10, 20), firstActivity: DateTime(2026, 10, 10)), isFalse);
    expect(o.backupDue(DateTime(2026, 10, 24), firstActivity: DateTime(2026, 10, 10)), isTrue);
    expect(back.backupDue(DateTime(2026, 10, 7), firstActivity: DateTime(2026, 9, 1)), isFalse);
    expect(back.backupDue(DateTime(2026, 10, 8), firstActivity: DateTime(2026, 9, 1)), isTrue);
    expect(back.copyWith(backupReminderDays: 0).backupDue(DateTime(2027), firstActivity: DateTime(2026)), isFalse);
  });
}
