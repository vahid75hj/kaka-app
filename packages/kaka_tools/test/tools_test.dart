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
  });
}
