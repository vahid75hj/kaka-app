import 'dart:convert';
import 'dart:io';

import 'package:kaka_domain/kaka_domain.dart';
import 'package:kaka_tools/kaka_tools.dart';
import 'package:test/test.dart';

class _Accounts implements AccountRepository {
  final m = <String, Account>{};
  @override
  Future<Account?> findById(String id) async => m[id];
  @override
  Future<List<Account>> getAll() async => m.values.toList();
  @override
  Future<void> upsert(Account a) async => m[a.id] = a;
  @override
  Stream<List<Account>> watchAll() => Stream.value(m.values.toList());
}

class _Txns implements TransactionRepository {
  final items = <LedgerTransaction>[];
  @override
  Future<void> insert(LedgerTransaction t) async => items.insert(0, t);
  @override
  Future<void> markVoided(String id, DateTime at) async {}
  @override
  Stream<List<LedgerTransaction>> watchRecent({int limit = 200}) => Stream.value(items.take(limit).toList());
  @override
  Stream<Map<String, int>> watchPostedSums() {
    final s = <String, int>{};
    for (final t in items) {
      for (final p in t.postings) {
        s.update(p.accountId, (v) => v + p.amount.minor, ifAbsent: () => p.amount.minor);
      }
    }
    return Stream.value(s);
  }
}

class _Budgets implements BudgetRepository {
  final items = <Budget>[];
  @override
  Future<void> delete(String id) async => items.removeWhere((b) => b.id == id);
  @override
  Future<List<Budget>> getAll() async => items;
  @override
  Future<void> upsert(Budget b) async => items.add(b);
  @override
  Stream<List<Budget>> watchAll() => Stream.value(items);
}

void main() {
  test('schema file is in sync with the Dart catalog', () {
    final file = jsonDecode(File('schema/tools.v1.json').readAsStringSync()) as Map;
    expect(file['tools_version'], toolsVersion);
    expect(jsonEncode(file['tools']), jsonEncode([for (final t in kakaTools) t.toMcp()]));
  });

  test('read tools return exact money and write tools only draft', () async {
    final accounts = _Accounts();
    final txns = _Txns();
    final ledger = LedgerService(accounts, txns, clock: () => DateTime.utc(2026, 10, 20));
    final drafts = <TransactionDraft>[];
    final runner = ToolRunner(
      accounts: accounts,
      transactions: txns,
      ledger: ledger,
      onDraft: (d) async => drafts.add(d),
    );

    final bank = await ledger.createAccount(
      name: 'Bank',
      type: AccountType.asset,
      currency: Currency.usd,
      openingBalance: const Money(10000, Currency.usd),
    );
    final food = await ledger.createAccount(name: 'Food', type: AccountType.expense, currency: Currency.usd);
    await ledger.recordExpense(from: bank, category: food, amount: const Money(1999, Currency.usd));

    final bal = await runner('get_balance', {'account_id': bank.id});
    expect(((bal['balances'] as List).single as Map)['balance'], {
      'amount_minor': 8001,
      'currency': 'USD',
      'scale': 2,
      'formatted': '80.01 \$',
    });

    final sum = await runner('summarize_spending', {'from': '2026-10-01', 'to': '2026-10-31'});
    expect(((sum['by_currency'] as Map)['USD'] as Map)['Food'], containsPair('amount_minor', 1999));

    final countBefore = txns.items.length;
    final r = await runner('add_transaction', {'kind': 'expense', 'amount': '5.00', 'account_id': bank.id});
    expect(r['status'], 'pending_user_approval');
    expect(drafts, hasLength(1));
    expect(txns.items.length, countBefore, reason: 'write tools never record directly');

    final bad = await runner('add_transaction', {'kind': 'expense', 'amount': 'lots', 'account_id': bank.id});
    expect(bad['error'], containsPair('code', 'amount.invalid'));

    // Transfers: target must be another visible money account in the same currency.
    final cash = await ledger.createAccount(name: 'Cash', type: AccountType.asset, currency: Currency.usd);
    final rial = await ledger.createAccount(name: 'Rial', type: AccountType.asset, currency: Currency.irr);
    Future<Object?> transfer(String? to) async =>
        ((await runner('add_transaction', {
              'kind': 'transfer',
              'amount': '1',
              'account_id': bank.id,
              'to_account_id': ?to,
            }))['error']
            as Map?)?['code'];
    expect(await transfer(null), 'unknown_to_account');
    expect(await transfer(food.id), 'unknown_to_account');
    expect(await transfer(bank.id), 'same_account');
    expect(await transfer(rial.id), 'cross_currency_transfer');
    expect(await transfer(cash.id), isNull);
    expect(drafts.last.arguments['to_account_id'], cash.id);
    final system = await ledger.fxAccount(Currency.usd);
    expect(
      (await runner('add_transaction', {'kind': 'expense', 'amount': '1', 'account_id': system.id}))['error'],
      containsPair('code', 'unknown_account'),
    );
    expect(
      (await runner('add_transaction', {'kind': 'opening', 'amount': '1', 'account_id': bank.id}))['error'],
      containsPair('code', 'bad_kind'),
    );
  });

  test('list_budgets: spent in the budget currency for the month, over flag', () async {
    final accounts = _Accounts();
    final txns = _Txns();
    final ledger = LedgerService(accounts, txns, clock: () => DateTime(2026, 10, 20));
    final budgets = _Budgets();
    final runner = ToolRunner(
      accounts: accounts,
      transactions: txns,
      ledger: ledger,
      onDraft: (_) async {},
      budgets: budgets,
      clock: () => DateTime(2026, 10, 25),
    );
    final bank = await ledger.createAccount(name: 'Bank', type: AccountType.asset, currency: Currency.usd);
    final food = await ledger.createAccount(name: 'Food', type: AccountType.expense, currency: Currency.usd);
    await ledger.recordExpense(from: bank, category: food, amount: const Money(1500, Currency.usd));
    await ledger.recordExpense(
      from: bank,
      category: food,
      amount: const Money(900, Currency.usd),
      at: DateTime(2026, 9, 30),
    );
    await budgets.upsert(Budget(id: Budget.idFor('Food'), category: 'Food', limit: const Money(1000, Currency.usd)));
    final r = await runner('list_budgets', {});
    expect((r['from'], r['to']), ('2026-10-01', '2026-10-31'));
    final b = (r['budgets'] as List).single as Map;
    expect((b['spent'] as Map)['amount_minor'], 1500);
    expect((b['remaining'] as Map)['amount_minor'], -500);
    expect(b['over'], isTrue);
    final sept = await runner('list_budgets', {'from': '2026-09-01', 'to': '2026-09-30'});
    expect(((sept['budgets'] as List).single as Map)['over'], isFalse);
  });

  test('list_recurring: next date, kind, masked note', () async {
    final accounts = _Accounts();
    final txns = _Txns();
    final ledger = LedgerService(accounts, txns);
    final bank = await ledger.createAccount(name: 'Bank', type: AccountType.asset, currency: Currency.usd);
    final rules = _Rules();
    await rules.upsert(
      RecurringRule(
        id: 'r',
        isExpense: true,
        accountId: bank.id,
        category: 'Rent',
        amount: const Money(50000, Currency.usd),
        every: RecurrenceEvery.monthly,
        start: DateTime(2026, 1, 31),
        lastDone: DateTime(2026, 1, 31),
        note: 'to 6037991234567890',
      ),
    );
    final runner = ToolRunner(
      accounts: accounts,
      transactions: txns,
      ledger: ledger,
      onDraft: (_) async {},
      recurring: rules,
    );
    final r = ((await runner('list_recurring', {}))['recurring'] as List).single as Map;
    expect((r['kind'], r['account'], r['next'], r['every']), ('expense', 'Bank', '2026-02-28', 'monthly'));
    expect(r['note'], isNot(contains('1234567890')));
  });
}

class _Rules implements RecurringRepository {
  final items = <RecurringRule>[];
  @override
  Future<void> delete(String id) async => items.removeWhere((r) => r.id == id);
  @override
  Future<List<RecurringRule>> getAll() async => items;
  @override
  Future<void> upsert(RecurringRule r) async => items.add(r);
  @override
  Stream<List<RecurringRule>> watchAll() => Stream.value(items);
}
