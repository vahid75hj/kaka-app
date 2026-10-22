import '../money/display_unit.dart';
import '../money/money.dart';
import 'digits.dart';

/// Renders [Money] in a display unit with locale-aware digits and separators.
///
/// Rounding is half-away-from-zero and only ever happens here, on display.
class MoneyFormatter {
  const MoneyFormatter({
    required this.digits,
    required this.decimals,
    this.groupSeparator = ',',
    this.decimalSeparator = '.',
  });

  /// Persian conventions: Persian digits, `٬` grouping, `٫` decimal point.
  const MoneyFormatter.persian({required this.decimals})
    : digits = DigitSystem.persian,
      groupSeparator = '٬',
      decimalSeparator = '٫';

  final DigitSystem digits;
  final int decimals;
  final String groupSeparator;
  final String decimalSeparator;

  /// Formats [m] as a number in [unit] (no symbol).
  String number(Money m, DisplayUnit unit, {bool signed = false}) {
    assert(m.currency == unit.currency, 'money and unit currencies differ');
    // Value in display unit = minor / 10^(scale + factor); keep `decimals` digits.
    final shift = unit.currency.storageScale + unit.factorPow10 - decimals;
    var v = m.minor.abs();
    if (shift > 0) {
      final p = _pow10(shift);
      v = (v + p ~/ 2) ~/ p;
    } else if (shift < 0) {
      v *= _pow10(-shift);
    }
    final raw = v.toString().padLeft(decimals + 1, '0');
    final whole = raw.substring(0, raw.length - decimals);
    final frac = raw.substring(raw.length - decimals);
    final grouped = whole.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => groupSeparator);
    final sign = m.isNegative && v != 0 ? '-' : (signed && v != 0 ? '+' : '');
    final out = '$sign$grouped${decimals > 0 ? '$decimalSeparator$frac' : ''}';
    return Digits.render(out, digits);
  }

  /// Formats with the unit's symbol: `1,234.50 $` style, `۱۲۳ تومان` in Persian.
  String format(Money m, DisplayUnit unit, {required bool persian, bool signed = false}) {
    final symbol = persian ? unit.symbolFa : unit.symbolEn;
    return '${number(m, unit, signed: signed)} $symbol';
  }

  static int _pow10(int n) {
    var r = 1;
    for (var i = 0; i < n; i++) {
      r *= 10;
    }
    return r;
  }
}
