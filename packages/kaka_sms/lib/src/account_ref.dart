import 'sms_text.dart';

/// An account number fragment as banks print it: `06009`, `0320192383104`,
/// `761670007641552001` or the dashed `7616-700-7641552-1`.
abstract final class AccountRef {
  /// Does the fragment [fromSms] refer to the full/linked number [linked]?
  ///
  /// - equal digits, or one is a suffix of the other (≥ 4 digits): `06009` ↔ `...06009`
  /// - dashed forms drop zero padding, so each dash segment (leading zeros
  ///   stripped) must appear in order: `7616-700-7641552-1` ↔ `761670007641552001`
  static bool matches(String fromSms, String linked) {
    final a = SmsText.digitsOnly(fromSms);
    final b = SmsText.digitsOnly(linked);
    if (a.isEmpty || b.isEmpty) return false;
    if (a == b) return true;
    final shorter = a.length <= b.length ? a : b;
    final longer = identical(shorter, a) ? b : a;
    if (shorter.length >= 4 && longer.endsWith(shorter)) return true;
    for (final (dashed, plain) in [(fromSms, b), (linked, a)]) {
      final segments = RegExp(r'\d+').allMatches(dashed).map((m) => m[0]!).toList();
      if (segments.length >= 3 && _inOrder(segments, plain)) return true;
    }
    return false;
  }

  static bool _inOrder(List<String> segments, String plain) {
    var at = 0;
    for (final (i, raw) in segments.indexed) {
      final seg = raw.replaceFirst(RegExp(r'^0+(?=\d)'), '');
      final found = plain.indexOf(seg, at);
      // The first segment must start the number; later ones may sit after padding zeros.
      if (found < 0 || (i == 0 && found != 0)) return false;
      if (i > 0 && plain.substring(at, found).replaceAll('0', '').isNotEmpty) return false;
      at = found + seg.length;
    }
    return plain.substring(at).replaceAll('0', '').isEmpty;
  }
}
