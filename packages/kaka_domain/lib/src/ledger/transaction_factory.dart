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

  /// Cross-currency move: [fromAmount] leaves [from], [toAmount] arrives in [to].
  /// Each currency balances through its own `FX:<cur>` account.
  static LedgerTransaction exchange({
    required Account from,
    required Account to,
    required Money fromAmount,
    required Money toAmount,
    required Account fxFrom,
    required Account fxTo,
    required DateTime at,
    String note = '',
  }) {
    _require(from.id != to.id, 'ledger.same_account');
    _require(from.currency != to.currency, 'ledger.same_currency_exchange');
    _require(fromAmount.isPositive && toAmount.isPositive, 'amount.not_positive');
    _require(
      fromAmount.currency == from.currency &&
          fxFrom.currency == from.currency &&
          toAmount.currency == to.currency &&
          fxTo.currency == to.currency,
      'ledger.currency_mismatch',
    );
    return LedgerTransaction(
      id: Ids.next(),
      kind: TransactionKind.exchange,
      occurredAt: at,
      note: note.trim(),
      postings: [
        Posting(id: Ids.next(), accountId: to.id, amount: toAmount),
        Posting(id: Ids.next(), accountId: fxTo.id, amount: -toAmount),
        Posting(id: Ids.next(), accountId: fxFrom.id, amount: fromAmount),
        Posting(id: Ids.next(), accountId: from.id, amount: -fromAmount),
      ],
    );
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

  /// Buying gold/coins: [cash] pays [total] into the system [holdings] account.
  /// Selling: [cash] receives [total] from it.
  static LedgerTransaction assetTrade({
    required Account cash,
    required Account holdings,
    required Money total,
    required bool buy,
    required DateTime at,
    String note = '',
  }) {
    _require(cash.type.isBalanceSheet, 'ledger.not_money_account');
    _require(holdings.isSystem && holdings.type == AccountType.equity, 'ledger.not_holdings_account');
    return buy
        ? _pair(TransactionKind.asset, debit: holdings, credit: cash, amount: total, at: at, note: note)
        : _pair(TransactionKind.asset, debit: cash, credit: holdings, amount: total, at: at, note: note);
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
