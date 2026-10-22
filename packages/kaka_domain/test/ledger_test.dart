import 'dart:async';

import 'package:kaka_domain/kaka_domain.dart';
import 'package:test/test.dart';

class _MemAccounts implements AccountRepository {
  final _items = <String, Account>{};
  final _ctrl = StreamController<List<Account>>.broadcast();
  @override
  Future<Account?> findById(String id) async => _items[id];
  @override
  Future<List<Account>> getAll() async => _items.values.toList();
  @override
  Future<void> upsert(Account a) async => _ctrl.add((_items[a.id] = a, _items.values.toList()).$2);
  @override
  Stream<List<Account>> watchAll() => _ctrl.stream;
}

class _MemTxns implements TransactionRepository {
  final items = <LedgerTransaction>[];
  @override
  Future<void> insert(LedgerTransaction t) async => items.add(t);
  @override
  Future<void> markVoided(String id, DateTime at) async {}
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

Account _acc(String id, AccountType type, [Currency c = Currency.irr]) =>
    Account(id: id, name: id, type: type, currency: c, createdAt: DateTime(2026));

void main() {
  final wallet = _acc('wallet', AccountType.asset);
  final food = _acc('food', AccountType.expense);
  final salary = _acc('salary', AccountType.income);
  final usdCash = _acc('usd', AccountType.asset, Currency.usd);
  final accounts = {
    for (final a in [wallet, food, salary, usdCash]) a.id: a,
  };

  group('LedgerRules', () {
    test('factory transactions balance per currency', () {
      final t = TransactionFactory.expense(
        from: wallet,
        category: food,
        amount: const Money(5000, Currency.irr),
        at: DateTime(2026),
      );
      expect(() => LedgerRules.validate(t, accounts), returnsNormally);
      expect(t.postings.map((p) => p.amount.minor).fold<int>(0, (a, b) => a + b), 0);
    });

    test('rejects an unbalanced transaction', () {
      final t = LedgerTransaction(
        id: 't',
        kind: TransactionKind.expense,
        occurredAt: DateTime(2026),
        postings: [
          Posting(id: 'a', accountId: 'food', amount: const Money(100, Currency.irr)),
          Posting(id: 'b', accountId: 'wallet', amount: const Money(-90, Currency.irr)),
        ],
      );
      expect(
        () => LedgerRules.validate(t, accounts),
        throwsA(isA<DomainException>().having((e) => e.code, 'code', 'ledger.unbalanced')),
      );
    });

    test('rejects a posting in the wrong currency for its account', () {
      final t = LedgerTransaction(
        id: 't',
        kind: TransactionKind.transfer,
        occurredAt: DateTime(2026),
        postings: [
          Posting(id: 'a', accountId: 'usd', amount: const Money(100, Currency.irr)),
          Posting(id: 'b', accountId: 'wallet', amount: const Money(-100, Currency.irr)),
        ],
      );
      expect(
        () => LedgerRules.validate(t, accounts),
        throwsA(isA<DomainException>().having((e) => e.code, 'code', 'ledger.currency_mismatch')),
      );
    });

    test('no cross-currency transfers without FX accounts', () {
      expect(
        () => TransactionFactory.transfer(
          from: wallet,
          to: usdCash,
          amount: const Money(1, Currency.irr),
          at: DateTime(2026),
        ),
        throwsA(isA<DomainException>()),
      );
    });

    test('categories must have the right type', () {
      expect(
        () => TransactionFactory.expense(
          from: wallet,
          category: salary,
          amount: const Money(1, Currency.irr),
          at: DateTime(2026),
        ),
        throwsA(isA<DomainException>()),
      );
    });
  });

  group('LedgerService', () {
    test('opening balance, income, expense and transfer give correct balances', () async {
      final svc = LedgerService(_MemAccounts(), _MemTxns(), clock: () => DateTime(2026, 10, 23));
      final bank = await svc.createAccount(
        name: 'Bank',
        type: AccountType.asset,
        currency: Currency.irr,
        openingBalance: const Money(1000000, Currency.irr),
      );
      final cash = await svc.createAccount(name: 'Cash', type: AccountType.asset, currency: Currency.irr);
      final card = await svc.createAccount(
        name: 'Card',
        type: AccountType.liability,
        currency: Currency.irr,
        openingBalance: const Money(200000, Currency.irr),
      );
      final groceries = await svc.createAccount(name: 'Groceries', type: AccountType.expense, currency: Currency.irr);
      final pay = await svc.createAccount(name: 'Salary', type: AccountType.income, currency: Currency.irr);

      await svc.recordIncome(to: bank, category: pay, amount: const Money(500000, Currency.irr));
      await svc.recordExpense(from: bank, category: groceries, amount: const Money(120000, Currency.irr));
      await svc.recordTransfer(from: bank, to: cash, amount: const Money(80000, Currency.irr));

      final balances = {for (final b in await svc.watchBalances().first) b.account.id: b.balance.minor};
      expect(balances[bank.id], 1000000 + 500000 - 120000 - 80000);
      expect(balances[cash.id], 80000);
      expect(balances[card.id], -200000);
      expect(balances[groceries.id], 120000);
      expect(balances[pay.id], 500000);
    });

    test('empty account names are rejected', () async {
      final svc = LedgerService(_MemAccounts(), _MemTxns());
      expect(
        () => svc.createAccount(name: '  ', type: AccountType.asset, currency: Currency.irr),
        throwsA(isA<DomainException>()),
      );
    });
  });
}
