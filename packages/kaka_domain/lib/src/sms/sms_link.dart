import 'package:meta/meta.dart';

/// Ties a bank SMS sender and/or an account number to a Kaka account.
///
/// - sender + number → that account
/// - sender only     → the sender is processed; its default account is [accountId] (may be null)
/// - number only     → matches that number from any linked sender
@immutable
class SmsLink {
  const SmsLink({required this.id, this.sender, this.accountId, this.accountNumber});
  final String id;

  /// Normalized sender address (see `SmsText.sender`).
  final String? sender;
  final String? accountId;
  final String? accountNumber;
}

abstract interface class SmsLinkRepository {
  Stream<List<SmsLink>> watchAll();
  Future<List<SmsLink>> getAll();
  Future<void> upsert(SmsLink link);
  Future<void> delete(String id);
}
