/// Digit systems the UI can render numbers in.
enum DigitSystem { latin, persian }

abstract final class Digits {
  static const _persian = '۰۱۲۳۴۵۶۷۸۹';
  static const _arabic = '٠١٢٣٤٥٦٧٨٩';

  /// Converts Latin digits to [system].
  static String render(String s, DigitSystem system) {
    if (system == DigitSystem.latin) return s;
    final b = StringBuffer();
    for (final r in s.runes) {
      b.write(r >= 0x30 && r <= 0x39 ? _persian[r - 0x30] : String.fromCharCode(r));
    }
    return b.toString();
  }

  /// Converts Persian and Arabic-Indic digits to Latin.
  static String normalize(String s) {
    final b = StringBuffer();
    for (final ch in s.split('')) {
      final p = _persian.indexOf(ch);
      final a = _arabic.indexOf(ch);
      b.write(
        p >= 0
            ? '$p'
            : a >= 0
            ? '$a'
            : ch,
      );
    }
    return b.toString();
  }
}
