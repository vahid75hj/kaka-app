import 'package:meta/meta.dart';

import '../failures.dart';
import '../format/digits.dart';

/// An exact positive decimal (e.g. a rate "1050000" or "0.00095"), never a double.
@immutable
class Decimal {
  const Decimal._(this.numerator, this.denominator);

  final BigInt numerator;
  final BigInt denominator;

  /// Accepts Persian/Latin digits, `,`/`٬` grouping and `.`/`٫` decimal point.
  factory Decimal.parse(String raw) {
    final s = Digits.normalize(raw).replaceAll(RegExp('[,٬\\s]'), '').replaceAll('٫', '.');
    final m = RegExp(r'^(\d*)(?:\.(\d+))?$').firstMatch(s);
    if (s.isEmpty || m == null || (m[1]!.isEmpty && m[2] == null)) throw const DomainException('rate.invalid');
    final frac = m[2] ?? '';
    final n = BigInt.parse('${m[1]!.isEmpty ? '0' : m[1]}$frac');
    if (n == BigInt.zero) throw const DomainException('rate.invalid');
    return Decimal._(n, BigInt.from(10).pow(frac.length));
  }

  /// `value × num / den`, rounded half away from zero.
  static int mulDivRound(int value, BigInt num, BigInt den) {
    final v = BigInt.from(value) * num;
    final neg = v.isNegative;
    final q = (v.abs() + den ~/ BigInt.two) ~/ den;
    return (neg ? -q : q).toInt();
  }

  @override
  String toString() {
    final digits = denominator.toString().length - 1;
    if (digits == 0) return numerator.toString();
    final s = numerator.toString().padLeft(digits + 1, '0');
    final whole = s.substring(0, s.length - digits);
    final frac = s.substring(s.length - digits).replaceFirst(RegExp(r'0+$'), '');
    return frac.isEmpty ? whole : '$whole.$frac';
  }

  @override
  bool operator ==(Object other) => other is Decimal && numerator * other.denominator == other.numerator * denominator;

  @override
  int get hashCode => (numerator / denominator).hashCode;
}
