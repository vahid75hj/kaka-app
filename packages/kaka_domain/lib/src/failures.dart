/// Thrown when an operation would break a domain invariant.
class DomainException implements Exception {
  const DomainException(this.code, [this.message]);

  /// Stable, machine-readable code (useful for l10n in the UI).
  final String code;
  final String? message;

  @override
  String toString() => 'DomainException($code${message == null ? '' : ': $message'})';
}
