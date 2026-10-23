import 'package:kaka_domain/kaka_domain.dart';

/// Text clean-up shared by templates and the heuristic parser.
abstract final class SmsText {
  static final _invisible = RegExp('[\u200b\u200e\u200f\u202a-\u202e\u2066-\u2069\ufeff]');
  static final _spaces = RegExp(r'[ \t\u00a0\u200c]+');

  /// Latin digits, Persian ی/ک, no bidi/invisible marks, no `*` decoration,
  /// collapsed spaces and trimmed lines (line breaks are kept: they carry meaning).
  static String normalize(String text) {
    final s = Digits.normalize(text)
        .replaceAll('ي', 'ی')
        .replaceAll('ى', 'ی')
        .replaceAll('ك', 'ک')
        .replaceAll('ۀ', 'ه')
        .replaceAll('٬', ',')
        .replaceAll('،', ',')
        .replaceAll('\r', '')
        .replaceAll(_invisible, '')
        .replaceAll('*', ' ')
        .replaceAll(_spaces, ' ');
    return s.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).join('\n');
  }

  /// Digits only (for comparing account numbers written with dashes / dots).
  static String digitsOnly(String s) => Digits.normalize(s).replaceAll(RegExp(r'\D'), '');

  /// Normalized SMS sender address: `+98 700-717` and `98700717` compare equal.
  static String sender(String s) {
    var d = Digits.normalize(s).trim().toLowerCase().replaceAll(RegExp(r'[\s\-()]'), '');
    if (RegExp(r'^\+?\d+$').hasMatch(d)) {
      d = d.replaceFirst('+', '');
      if (d.startsWith('0098')) d = d.substring(4);
      if (d.startsWith('98') && d.length > 6) d = d.substring(2);
    }
    return d;
  }
}
