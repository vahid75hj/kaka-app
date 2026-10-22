import '../failures.dart';
import '../ids.dart';
import '../money/currency.dart';
import '../money/money.dart';
import 'account.dart';
import 'ledger_rules.dart';
import 'ledger_transaction.dart';
import 'repositories.dart';
import 'transaction_factory.dart';

/// An account together with its balance in its own currency,
/// signed the way a human reads it (a credit card debt is negative).
class AccountBalance {
  const AccountBalance(this.account, this.balance);
  final Account account;
  final Money balance;
}

/// Application use cases for the ledger.
class LedgerService {
  LedgerService(this._accounts, this._transactions, {DateTime Function()? clock}) : _now = clock ?? DateTime.now;

  final AccountRepository _accounts;
  final TransactionRepository _transactions;
  final DateTime Function() _now;

  Future<Account> createAccount({
    required String name,
    required AccountType type,
    required Currency currency,
    Money? openingBalance,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) throw const DomainException('account.name_required');
    final account = Account(id: Ids.next(), name: trimmed, type: type, currency: currency, createdAt: _now());
    await _accounts.upsert(account);
    if (openingBalance != null && !openingBalance.isZero) {
      final equity = await _openingEquity(currency);
      // Liabilities are entered as a positive amount owed.
      final signed = type == AccountType.liability ? -openingBalance : openingBalance;
      await _record(TransactionFactory.opening(account: account, equity: equity, amount: signed, at: _now()));
    }
    return account;
  }

  Future<void> renameAccount(Account account, String name) async {
    if (name.trim().isEmpty) throw const DomainException('account.name_required');
    await _accounts.upsert(account.copyWith(name: name.trim()));
  }

  Future<void> setArchived(Account account, bool archived) => _accounts.upsert(account.copyWith(archived: archived));

  Future<void> recordExpense({
    required Account from,
    required Account category,
    required Money amount,
    DateTime? at,
    String note = '',
  }) =>
      _record(TransactionFactory.expense(from: from, category: category, amount: amount, at: at ?? _now(), note: note));

  Future<void> recordIncome({
    required Account to,
    required Account category,
    required Money amount,
    DateTime? at,
    String note = '',
  }) => _record(TransactionFactory.income(to: to, category: category, amount: amount, at: at ?? _now(), note: note));

  Future<void> recordTransfer({
    required Account from,
    required Account to,
    required Money amount,
    DateTime? at,
    String note = '',
  }) => _record(TransactionFactory.transfer(from: from, to: to, amount: amount, at: at ?? _now(), note: note));

  Future<void> voidTransaction(LedgerTransaction txn) => _transactions.markVoided(txn.id, _now());

  /// Balances of every account, human-signed.
  Stream<List<AccountBalance>> watchBalances() async* {
    // Combine the two streams by re-reading accounts on every postings change;
    // account lists are tiny so this stays simple and cheap.
    await for (final sums in _transactions.watchPostedSums()) {
      final accounts = await _accounts.getAll();
      yield [
        for (final a in accounts)
          AccountBalance(a, Money(a.type.displaysNegated ? -(sums[a.id] ?? 0) : (sums[a.id] ?? 0), a.currency)),
      ];
    }
  }

  /// Seeds default categories in the user's language on first run.
  Future<void> seedCategories(Currency currency, {required Map<AccountType, List<String>> names}) async {
    final existing = await _accounts.getAll();
    for (final entry in names.entries) {
      for (final n in entry.value) {
        final exists = existing.any((a) => a.type == entry.key && a.name == n && a.currency == currency);
        if (!exists) {
          await _accounts.upsert(
            Account(id: Ids.next(), name: n, type: entry.key, currency: currency, createdAt: _now()),
          );
        }
      }
    }
  }

  /// Categories are per-currency accounts. Returns the [type] category named
  /// [name] in [currency], creating it the first time it is used there.
  Future<Account> ensureCategory(String name, AccountType type, Currency currency) async {
    final all = await _accounts.getAll();
    for (final a in all) {
      if (a.type == type && a.name == name && a.currency == currency) return a;
    }
    final created = Account(id: Ids.next(), name: name, type: type, currency: currency, createdAt: _now());
    await _accounts.upsert(created);
    return created;
  }

  Future<void> _record(LedgerTransaction txn) async {
    final all = {for (final a in await _accounts.getAll()) a.id: a};
    LedgerRules.validate(txn, all);
    await _transactions.insert(txn);
  }

  Future<Account> _openingEquity(Currency currency) async {
    final all = await _accounts.getAll();
    final found = all.where((a) => a.isSystem && a.type == AccountType.equity && a.currency == currency);
    if (found.isNotEmpty) return found.first;
    final equity = Account(
      id: Ids.next(),
      name: 'Opening balances ${currency.code}',
      type: AccountType.equity,
      currency: currency,
      createdAt: _now(),
      isSystem: true,
    );
    await _accounts.upsert(equity);
    return equity;
  }
}
