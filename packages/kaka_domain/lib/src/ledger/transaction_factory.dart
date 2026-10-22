import '../failures.dart';
import '../ids.dart';
import '../money/money.dart';
import 'account.dart';
import 'ledger_transaction.dart';
import 'posting.dart';

/// Turns user intents into balanced postings.
abstract final class TransactionFactory {
  /// Money leaves [from] (asset/liability) into an expense [category].
  static LedgerTransaction expense({
    required Account from,
    required Account category,
    required Money amount,
    required DateTime at,
    String note = '',
  }) {
    _require(category.type == AccountType.expense, 'ledger.not_expense_category');
    return _pair(TransactionKind.expense, debit: category, credit: from, amount: amount, at: at, note: note);
  }

  /// Money arrives in [to] from an income [category].
  static LedgerTransaction income({
    required Account to,
    required Account category,
    required Money amount,
    required DateTime at,
    String note = '',
  }) {
    _require(category.type == AccountType.income, 'ledger.not_income_category');
    return _pair(TransactionKind.income, debit: to, credit: category, amount: amount, at: at, note: note);
  }

  /// Same-currency move between two of the user's accounts.
  /// (Cross-currency exchange via FX accounts lands in MVP-2.)
  static LedgerTransaction transfer({
    required Account from,
    required Account to,
    required Money amount,
    required DateTime at,
    String note = '',
  }) {
    _require(from.id != to.id, 'ledger.same_account');
    _require(from.currency == to.currency, 'ledger.cross_currency_transfer');
    return _pair(TransactionKind.transfer, debit: to, credit: from, amount: amount, at: at, note: note);
  }

  /// Opening balance of [account] against the per-currency equity account.
  static LedgerTransaction opening({
    required Account account,
    required Account equity,
    required Money amount,
    required DateTime at,
  }) {
    final debitAccount = amount.isPositive ? account : equity;
    final creditAccount = amount.isPositive ? equity : account;
    return _pair(
      TransactionKind.opening,
      debit: debitAccount,
      credit: creditAccount,
      amount: amount.abs(),
      at: at,
      note: '',
    );
  }

  static LedgerTransaction _pair(
    TransactionKind kind, {
    required Account debit,
    required Account credit,
    required Money amount,
    required DateTime at,
    required String note,
  }) {
    _require(amount.isPositive, 'amount.not_positive');
    _require(debit.currency == amount.currency && credit.currency == amount.currency, 'ledger.currency_mismatch');
    return LedgerTransaction(
      id: Ids.next(),
      kind: kind,
      occurredAt: at,
      note: note.trim(),
      postings: [
        Posting(id: Ids.next(), accountId: debit.id, amount: amount),
        Posting(id: Ids.next(), accountId: credit.id, amount: -amount),
      ],
    );
  }

  static void _require(bool ok, String code) {
    if (!ok) throw DomainException(code);
  }
}
