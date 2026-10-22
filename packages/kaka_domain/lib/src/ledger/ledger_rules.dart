import '../failures.dart';
import 'account.dart';
import 'ledger_transaction.dart';

/// Invariants every transaction must satisfy before it is stored.
abstract final class LedgerRules {
  /// - at least two postings, none zero
  /// - each posting's currency equals its account's currency
  /// - postings sum to zero *per currency*
  static void validate(LedgerTransaction txn, Map<String, Account> accounts) {
    if (txn.postings.length < 2) throw const DomainException('ledger.too_few_postings');
    final sums = <String, int>{};
    for (final p in txn.postings) {
      if (p.amount.isZero) throw const DomainException('ledger.zero_posting');
      final account = accounts[p.accountId];
      if (account == null) throw DomainException('ledger.unknown_account', p.accountId);
      if (account.currency != p.amount.currency) {
        throw DomainException('ledger.currency_mismatch', account.name);
      }
      sums.update(p.amount.currency.code, (v) => v + p.amount.minor, ifAbsent: () => p.amount.minor);
    }
    final unbalanced = sums.entries.where((e) => e.value != 0);
    if (unbalanced.isNotEmpty) {
      throw DomainException('ledger.unbalanced', unbalanced.map((e) => '${e.key}:${e.value}').join(','));
    }
  }
}
