import '../failures.dart';
import '../format/digits.dart';
import 'display_unit.dart';
import 'money.dart';

/// Parses what the user typed, in a display unit, into exact stored [Money].
///
/// Accepts Latin, Persian and Arabic digits, `,` `٬` `،` as group separators
/// and `.` `٫` as the decimal separator. `12.5` toman → 125 rial.
abstract final class AmountParser {
  static final _shape = RegExp(r'^\d+(\.\d+)?$');

  static Money parse(String input, DisplayUnit unit) {
    var s = Digits.normalize(input.trim()).replaceAll(RegExp(r'[,٬،\s]'), '').replaceAll('٫', '.');
    final negative = s.startsWith('-');
    if (negative) s = s.substring(1);
    if (!_shape.hasMatch(s)) throw const DomainException('amount.invalid');

    final parts = s.split('.');
    final whole = parts[0];
    final frac = parts.length > 1 ? parts[1] : '';
    final storedScale = unit.currency.storageScale;
    // Digits after the point in the display unit, shifted into storage scale.
    final available = unit.factorPow10 + storedScale;
    if (frac.replaceFirst(RegExp(r'0+$'), '').length > available) {
      throw const DomainException('amount.too_precise');
    }
    final digits = whole + frac.padRight(available, '0').substring(0, available);
    final minor = int.parse(digits);
    return Money(negative ? -minor : minor, unit.currency);
  }
}
