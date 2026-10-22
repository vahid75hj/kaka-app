import 'account.dart';
import 'ledger_transaction.dart';

/// Storage contracts implemented in `kaka_data`.
abstract interface class AccountRepository {
  Stream<List<Account>> watchAll();
  Future<List<Account>> getAll();
  Future<Account?> findById(String id);
  Future<void> upsert(Account account);
}

abstract interface class TransactionRepository {
  /// Stores the transaction and its postings in one atomic write.
  Future<void> insert(LedgerTransaction txn);

  /// Newest first, voided ones included.
  Stream<List<LedgerTransaction>> watchRecent({int limit = 200});

  Future<void> markVoided(String id, DateTime at);

  /// Raw posted sum (minor units) per account id, excluding voided transactions.
  Stream<Map<String, int>> watchPostedSums();
}
