import 'package:kaka_data/kaka_data.dart';
import 'package:kaka_domain/kaka_domain.dart';
import 'package:kaka_tools/kaka_tools.dart';

/// "Today" for every case: 1 Aban 1405.
final evalToday = DateTime(2026, 10, 23, 10);

/// A small, fixed ledger the model reads through the real tools.
class EvalFixture {
  EvalFixture._(this.db, this.runner, this.accountIds);
  final KakaDatabase db;
  final ToolRunner runner;

  /// Account name → id, so cases can name accounts.
  final Map<String, String> accountIds;

  /// Write calls the model made (drafts are never recorded).
  final drafts = <TransactionDraft>[];

  static Future<EvalFixture> create() async {
    final db = KakaDatabase.inMemory();
    final accounts = DriftAccountRepository(db);
    final txns = DriftTransactionRepository(db);
    final ledger = LedgerService(accounts, txns, clock: () => evalToday);
    final mellat = await ledger.createAccount(
      name: 'کارت ملت',
      type: AccountType.asset,
      currency: Currency.irr,
      openingBalance: const Money(250000000, Currency.irr),
    );
    final cash = await ledger.createAccount(
      name: 'کیف پول',
      type: AccountType.asset,
      currency: Currency.irr,
      openingBalance: const Money(8000000, Currency.irr),
    );
    final usd = await ledger.createAccount(
      name: 'حساب دلاری',
      type: AccountType.asset,
      currency: Currency.usd,
      openingBalance: const Money(120000, Currency.usd),
    );
    Future<void> spend(Account from, String category, int rial, int day, String note) async {
      final c = await ledger.ensureCategory(category, AccountType.expense, from.currency);
      await ledger.recordExpense(
        from: from,
        category: c,
        amount: Money(rial, from.currency),
        at: DateTime(2026, 10, day, 13),
        note: note,
      );
    }

    await spend(mellat, 'غذا', 4500000, 2, 'رستوران');
    await spend(mellat, 'غذا', 1800000, 15, 'سوپرمارکت');
    await spend(cash, 'حمل‌ونقل', 600000, 20, 'اسنپ');
    await spend(mellat, 'قبوض', 3200000, 10, 'قبض برق');
    await spend(usd, 'اشتراک', 1299, 5, 'Spotify');
    final salary = await ledger.ensureCategory('حقوق', AccountType.income, Currency.irr);
    await ledger.recordIncome(
      to: mellat,
      category: salary,
      amount: const Money(450000000, Currency.irr),
      at: DateTime(2026, 10, 1, 9),
      note: 'حقوق مهر',
    );
    final budgets = DriftBudgetRepository(db);
    await budgets.upsert(Budget(id: Budget.idFor('غذا'), category: 'غذا', limit: const Money(5000000, Currency.irr)));

    late final EvalFixture fixture;
    final runner = ToolRunner(
      accounts: accounts,
      transactions: txns,
      ledger: ledger,
      budgets: budgets,
      clock: () => evalToday,
      onDraft: (d) async => fixture.drafts.add(d),
    );
    fixture = EvalFixture._(db, runner, {
      for (final a in [mellat, cash, usd]) a.name: a.id,
    });
    return fixture;
  }

  Future<void> close() => db.close();
}
