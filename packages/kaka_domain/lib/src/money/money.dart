import 'package:meta/meta.dart';

import 'currency.dart';

/// An exact amount of money: an integer count of minor units of a currency.
///
/// Never a double. `Money(12345, Currency.usd)` is $123.45.
@immutable
class Money implements Comparable<Money> {
  const Money(this.minor, this.currency);

  const Money.zero(this.currency) : minor = 0;

  final int minor;
  final Currency currency;

  bool get isZero => minor == 0;
  bool get isNegative => minor < 0;
  bool get isPositive => minor > 0;

  Money operator +(Money other) => Money(minor + _same(other).minor, currency);
  Money operator -(Money other) => Money(minor - _same(other).minor, currency);
  Money operator -() => Money(-minor, currency);
  Money abs() => isNegative ? -this : this;

  Money _same(Money other) {
    if (other.currency != currency) {
      throw ArgumentError('Currency mismatch: $currency vs ${other.currency}');
    }
    return other;
  }

  @override
  int compareTo(Money other) => minor.compareTo(_same(other).minor);

  @override
  bool operator ==(Object other) => other is Money && other.minor == minor && other.currency == currency;

  @override
  int get hashCode => Object.hash(minor, currency);

  @override
  String toString() => '$minor ${currency.code}/10^${currency.storageScale}';
}
