import 'package:kaka_domain/kaka_domain.dart';

/// Parses a decimal price string into [Money] using the currency's storage scale.
/// Accepts grouped digits (`1,234.56` or `1.234.567` European) only when unambiguous;
/// prefers `.` as decimal when both appear, else last separator is decimal.
Money moneyFromDecimal(String raw, Currency currency, {int? scaleHint}) {
  var s = Digits.normalize(raw.trim()).replaceAll(RegExp(r'\s'), '').replaceAll('٬', ',').replaceAll('،', ',').replaceAll('٫', '.');
  if (s.startsWith('+')) s = s.substring(1);
  // Strip currency symbols / letters.
  s = s.replaceAll(RegExp(r'[^\d,.\-]'), '');
  if (s.isEmpty || s == '-' || s == '.' || s == ',') {
    throw const FormatException('empty price');
  }
  final neg = s.startsWith('-');
  if (neg) s = s.substring(1);

  if (s.contains(',') && s.contains('.')) {
    // The rightmost separator is the decimal mark; the other is grouping.
    if (s.lastIndexOf(',') > s.lastIndexOf('.')) {
      s = s.replaceAll('.', '').replaceAll(',', '.');
    } else {
      s = s.replaceAll(',', '');
    }
  } else if (s.contains(',')) {
    // `260,621,000` (grouping) vs `0,99` (decimal). If every group is 3 digits → grouping.
    final parts = s.split(',');
    final grouping = parts.length > 1 && parts.skip(1).every((p) => p.length == 3);
    s = grouping ? parts.join() : parts.join('.');
  }

  if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(s)) {
    throw FormatException('invalid price: $raw');
  }
  final scale = scaleHint ?? currency.storageScale;
  final parts = s.split('.');
  final whole = parts[0];
  final frac = parts.length > 1 ? parts[1] : '';
  if (frac.replaceFirst(RegExp(r'0+$'), '').length > scale + 8) {
    // Allow long floats (CoinGecko) but round/truncate into storage scale.
  }
  final padded = frac.padRight(scale, '0');
  final kept = padded.substring(0, scale.clamp(0, padded.length));
  final digits = whole + (scale == 0 ? '' : kept.padRight(scale, '0').substring(0, scale));
  // Truncate extra fractional digits beyond storage scale (no float rounding).
  final minor = BigInt.parse(digits.isEmpty ? '0' : digits);
  if (minor > BigInt.from(1) << 62) throw const FormatException('price too large');
  return Money(neg ? -minor.toInt() : minor.toInt(), currency);
}

DateTime? parseAsOf(Object? raw) {
  if (raw == null) return null;
  final s = '$raw'.trim();
  if (s.isEmpty) return null;
  // Prefer date-only so timezone does not invent a "tomorrow".
  final day = RegExp(r'^(\d{4})-(\d{2})-(\d{2})').firstMatch(s);
  if (day != null) {
    return DateTime(int.parse(day.group(1)!), int.parse(day.group(2)!), int.parse(day.group(3)!));
  }
  try {
    final dt = DateTime.parse(s);
    return DateTime(dt.year, dt.month, dt.day);
  } on FormatException {
    return null;
  }
}
