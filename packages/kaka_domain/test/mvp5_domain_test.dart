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

void main() {
  late _Accounts accounts;
  late _Txns txns;
  late LedgerService ledger;
  late Account wallet;

  setUp(() async {
    accounts = _Accounts();
    txns = _Txns();
    ledger = LedgerService(accounts, txns);
    wallet = await ledger.createAccount(
      name: 'w',
      type: AccountType.asset,
      currency: Currency.irr,
      openingBalance: const Money(1000000, Currency.irr),
    );
  });

  test('opening balances never post into FX/Assets system accounts', () async {
    await ledger.fxAccount(Currency.usd);
    await ledger.systemAccount('Portfolio USD', AccountType.equity, Currency.usd);
    expect(wallet.currency, Currency.irr);
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

  test('category icons follow the name across currencies and new currencies inherit them', () async {
    await ledger.ensureCategory('غذا', AccountType.expense, Currency.irr);
    await ledger.ensureCategory('غذا', AccountType.expense, Currency.usd);
    await ledger.setCategoryIcon(AccountType.expense, 'غذا', 'food');
    expect(accounts.items.values.where((a) => a.name == 'غذا').map((a) => a.icon), everyElement('food'));
    final eur = await ledger.ensureCategory('غذا', AccountType.expense, Currency.byCode('EUR'));
    expect(eur.icon, 'food');
    await ledger.setCategoryIcon(AccountType.expense, 'غذا', null);
    expect(accounts.items.values.where((a) => a.name == 'غذا').map((a) => a.icon), everyElement(isNull));
    expect(() => ledger.setCategoryIcon(AccountType.asset, 'w', 'x'), throwsA(isA<DomainException>()));
  });

  test('budgets: spent from the monthly report, over / ahead-of-pace / ok, currency change tolerated', () {
    const irr = Currency.irr;
    final report = MonthlyReport(
      base: irr,
      income: const [],
      expense: const [CategoryTotal('غذا', Money(900, irr)), CategoryTotal('خرید', Money(600, irr))],
      skipped: 0,
    );
    final from = DateTime(2026, 10, 1), to = DateTime(2026, 11, 1);
    final s = BudgetMath.of(
      [
        Budget(id: Budget.idFor('غذا'), category: 'غذا', limit: const Money(800, irr)),
        Budget(id: Budget.idFor('خرید'), category: 'خرید', limit: const Money(1000, irr)),
        Budget(id: Budget.idFor('سلامت'), category: 'سلامت', limit: const Money(500, irr)),
        Budget(id: Budget.idFor('x'), category: 'x', limit: const Money(5, Currency.usd)),
      ],
      report,
      from: from,
      to: to,
      now: DateTime(2026, 10, 10), // ~29% of the month gone
    );
    expect(s.map((x) => (x.budget.category, x.state)), [
      ('غذا', BudgetState.over),
      ('خرید', BudgetState.ahead),
      ('سلامت', BudgetState.ok),
      ('x', BudgetState.ok),
    ]);
    expect(s.first.remaining, const Money(-100, irr));
    expect(s[2].spent, const Money(0, irr));
    expect(s.last.spent, isNull);
    // Late in the month 60% used is on pace.
    final late = BudgetMath.of(
      [Budget(id: 'b', category: 'خرید', limit: const Money(1000, irr))],
      report,
      from: from,
      to: to,
      now: DateTime(2026, 10, 28),
    );
    expect(late.single.state, BudgetState.ok);
  });
}
