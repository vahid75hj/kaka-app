/// Hides card / account / IBAN numbers before anything is sent to an AI provider.
abstract final class Masking {
  // 8+ digits, optionally grouped by spaces/dashes, optionally an IR IBAN prefix.
  static final _long = RegExp(r'(?:IR\s?)?\d(?:[\s\-]?\d){7,}', caseSensitive: false);

  /// `6037 9912 3456 7890` → `••••7890`; amounts with thousands separators are untouched.
  static String text(String s) => s.replaceAllMapped(_long, (m) {
    final digits = m[0]!.replaceAll(RegExp(r'\D'), '');
    return '••••${digits.substring(digits.length - 4)}';
  });

  /// Deep-masks every string in a JSON-like value.
  static Object? json(Object? v) => switch (v) {
    String s => text(s),
    Map m => {for (final e in m.entries) e.key: json(e.value)},
    List l => [for (final x in l) json(x)],
    _ => v,
  };
}
