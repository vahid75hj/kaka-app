import 'dart:async';

import 'package:kaka_domain/kaka_domain.dart';
import 'package:test/test.dart';

class _MemAccounts implements AccountRepository {
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

class _NoTxns implements TransactionRepository {
  @override
  Future<void> insert(LedgerTransaction t) async {}
  @override
  Future<void> markVoided(String id, DateTime at) async {}
  @override
  Stream<List<LedgerTransaction>> watchRecent({int limit = 200}) => const Stream.empty();
  @override
  Stream<Map<String, int>> watchPostedSums() => const Stream.empty();
}

class _MemDrafts implements DraftRepository {
  final items = <String, Draft>{};
  @override
  Future<bool> existsWithDedupKey(String key) async => items.values.any((d) => d.dedupKey == key);
  @override
  Future<Draft?> findById(String id) async => items[id];
  @override
  Future<void> upsert(Draft d) async => items[d.id] = d;
  @override
  Stream<List<Draft>> watchPending() =>
      Stream.value(items.values.where((d) => d.status == DraftStatus.pending).toList());
}

void main() {
  group('categories', () {
    late _MemAccounts accounts;
    late LedgerService ledger;
    setUp(() {
      accounts = _MemAccounts();
      ledger = LedgerService(accounts, _NoTxns());
    });

    test('rename follows every currency and rejects duplicates', () async {
      await ledger.addCategory('Food', AccountType.expense, Currency.irr);
      await ledger.ensureCategory('Food', AccountType.expense, Currency.usd);
      await ledger.addCategory('Fun', AccountType.expense, Currency.irr);
      await ledger.renameCategory(AccountType.expense, 'Food', 'Groceries');
      expect(accounts.items.values.where((a) => a.name == 'Groceries'), hasLength(2));
      expect(
        () => ledger.renameCategory(AccountType.expense, 'Groceries', 'Fun'),
        throwsA(isA<DomainException>().having((e) => e.code, 'code', 'category.exists')),
      );
    });

    test('archive hides, adding again restores', () async {
      await ledger.addCategory('Gift', AccountType.income, Currency.irr);
      await ledger.setCategoryArchived(AccountType.income, 'Gift', true);
      expect(accounts.items.values.single.archived, isTrue);
      await ledger.addCategory('Gift', AccountType.income, Currency.irr);
      expect(accounts.items.values.single.archived, isFalse);
    });

    test('wallet accounts are not categories', () {
      expect(() => ledger.addCategory('x', AccountType.asset, Currency.irr), throwsA(isA<DomainException>()));
    });
  });

  group('question queue', () {
    test('dedups by key and leaves the queue on confirm/discard', () async {
      final repo = _MemDrafts();
      final service = DraftService(repo);
      Draft d(String id) => Draft(
        id: id,
        source: DraftSource.sms,
        isExpense: true,
        amount: const Money(1000, Currency.irr),
        createdAt: DateTime(2026),
        dedupKey: 'k',
      );
      expect(await service.enqueue(d('a')), isTrue);
      expect(await service.enqueue(d('b')), isFalse);
      await service.confirm('a');
      expect(await service.watchPending().first, isEmpty);
      expect(repo.items['a']!.status, DraftStatus.confirmed);
    });
  });

  group('transaction query', () {
    final wallet = Account(
      id: 'w',
      name: 'Melli card',
      type: AccountType.asset,
      currency: Currency.irr,
      createdAt: DateTime(2026),
    );
    final food = Account(
      id: 'f',
      name: 'غذا',
      type: AccountType.expense,
      currency: Currency.irr,
      createdAt: DateTime(2026),
    );
    final accounts = {'w': wallet, 'f': food};
    final txn = TransactionFactory.expense(
      from: wallet,
      category: food,
      amount: const Money(250000, Currency.irr),
      at: DateTime(2026, 10, 20, 13),
      note: 'Pizza night',
    );

    test('text matches notes, account names and amounts across digit styles', () {
      expect(const TransactionQuery(text: 'pizza').matches(txn, accounts), isTrue);
      expect(const TransactionQuery(text: 'غذا melli').matches(txn, accounts), isTrue);
      expect(const TransactionQuery(text: '۲۵۰۰۰۰').matches(txn, accounts), isTrue);
      expect(const TransactionQuery(text: 'taxi').matches(txn, accounts), isFalse);
    });

    test('kind, account and inclusive date range', () {
      expect(const TransactionQuery(kinds: {TransactionKind.income}).matches(txn, accounts), isFalse);
      expect(const TransactionQuery(accountId: 'f').matches(txn, accounts), isTrue);
      expect(TransactionQuery(from: DateTime(2026, 10, 20), to: DateTime(2026, 10, 20)).matches(txn, accounts), isTrue);
      expect(TransactionQuery(to: DateTime(2026, 10, 19)).matches(txn, accounts), isFalse);
    });
  });
}
