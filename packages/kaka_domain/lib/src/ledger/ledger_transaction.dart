import 'package:meta/meta.dart';

import 'posting.dart';

enum TransactionKind { opening, income, expense, transfer, exchange }

/// A balanced set of postings written atomically. Never edited in place:
/// mistakes are fixed by voiding.
@immutable
class LedgerTransaction {
  const LedgerTransaction({
    required this.id,
    required this.kind,
    required this.occurredAt,
    required this.postings,
    this.note = '',
    this.voidedAt,
  });

  final String id;
  final TransactionKind kind;
  final DateTime occurredAt;
  final List<Posting> postings;
  final String note;
  final DateTime? voidedAt;

  bool get isVoided => voidedAt != null;
}
