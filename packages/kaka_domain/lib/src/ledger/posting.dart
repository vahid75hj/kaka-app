import 'package:meta/meta.dart';

import '../money/money.dart';

/// One leg of a transaction. Positive = debit, negative = credit.
@immutable
class Posting {
  const Posting({required this.id, required this.accountId, required this.amount});

  final String id;
  final String accountId;
  final Money amount;
}
