import 'package:meta/meta.dart';

import '../format/digits.dart';
import 'account.dart';
import 'ledger_transaction.dart';

/// Search + filters over the transaction history. Pure, so it is testable and
/// the same rules can later back the `list_transactions` tool.
@immutable
class TransactionQuery {
  const TransactionQuery({
    this.text = '',
    this.kinds = const {},
    this.accountId,
    this.from,
    this.to,
    this.showVoided = true,
    this.category,
  });

  /// Income/expense category by name (any currency).
  final String? category;

  /// Matched (case-insensitive, digit-normalized) against note, account and category names.
  final String text;

  /// Empty = every kind.
  final Set<TransactionKind> kinds;

  /// Any posting on this account (wallet or category).
  final String? accountId;
  final DateTime? from;

  /// Inclusive end day.
  final DateTime? to;
  final bool showVoided;

  bool get isEmpty =>
      text.trim().isEmpty &&
      kinds.isEmpty &&
      accountId == null &&
      from == null &&
      to == null &&
      showVoided &&
      category == null;

  TransactionQuery copyWith({
    String? text,
    Set<TransactionKind>? kinds,
    String? Function()? accountId,
    DateTime? Function()? from,
    DateTime? Function()? to,
    bool? showVoided,
    String? Function()? category,
  }) => TransactionQuery(
    text: text ?? this.text,
    kinds: kinds ?? this.kinds,
    accountId: accountId != null ? accountId() : this.accountId,
    from: from != null ? from() : this.from,
    to: to != null ? to() : this.to,
    showVoided: showVoided ?? this.showVoided,
    category: category != null ? category() : this.category,
  );

  static String _norm(String s) => Digits.normalize(s).replaceAll('ي', 'ی').replaceAll('ك', 'ک').toLowerCase().trim();

  bool matches(LedgerTransaction t, Map<String, Account> accounts) {
    if (!showVoided && t.isVoided) return false;
    if (kinds.isNotEmpty && !kinds.contains(t.kind)) return false;
    if (accountId != null && !t.postings.any((p) => p.accountId == accountId)) return false;
    if (category != null &&
        !t.postings.any((p) {
          final a = accounts[p.accountId];
          return a != null && !a.type.isBalanceSheet && !a.isSystem && a.name == category;
        })) {
      return false;
    }
    if (from != null && t.occurredAt.isBefore(from!)) return false;
    if (to != null) {
      final end = DateTime(to!.year, to!.month, to!.day).add(const Duration(days: 1));
      if (!t.occurredAt.isBefore(end)) return false;
    }
    final q = _norm(text);
    if (q.isEmpty) return true;
    final haystack = [
      t.note,
      for (final p in t.postings) accounts[p.accountId]?.name ?? '',
      for (final p in t.postings) (p.amount.minor.abs()).toString(),
    ].map(_norm).join(' ');
    return q.split(RegExp(r'\s+')).every(haystack.contains);
  }

  List<LedgerTransaction> apply(Iterable<LedgerTransaction> txns, Map<String, Account> accounts) => [
    for (final t in txns)
      if (matches(t, accounts)) t,
  ];
}
