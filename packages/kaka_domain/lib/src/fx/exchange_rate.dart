import 'package:meta/meta.dart';

import '../money/currency.dart';
import '../money/money.dart';
import 'rational.dart';

/// "On [date], 1 [currency] = [rate] [base]" (major units), entered by the user.
@immutable
class ExchangeRate {
  const ExchangeRate({
    required this.id,
    required this.currency,
    required this.base,
    required this.date,
    required this.rate,
  });

  final String id;
  final Currency currency;
  final Currency base;
  final DateTime date;
  final Decimal rate;

  /// [m] (in [currency]) expressed in [base], rounded to base minor units.
  Money convert(Money m) {
    assert(m.currency == currency);
    // base_minor = m_minor / 10^s_from × rate × 10^s_base
    final num = rate.numerator * BigInt.from(10).pow(base.storageScale);
    final den = rate.denominator * BigInt.from(10).pow(currency.storageScale);
    return Money(Decimal.mulDivRound(m.minor, num, den), base);
  }
}

abstract interface class ExchangeRateRepository {
  Stream<List<ExchangeRate>> watchAll();
  Future<List<ExchangeRate>> getAll();
  Future<void> upsert(ExchangeRate rate);
  Future<void> delete(String id);
}

/// Picks the latest rate on or before a date. Missing rates are reported, not guessed.
class CurrencyConverter {
  CurrencyConverter(this.base, Iterable<ExchangeRate> rates)
    : _rates = [
        for (final r in rates)
          if (r.base == base) r,
      ]..sort((a, b) => b.date.compareTo(a.date));

  final Currency base;
  final List<ExchangeRate> _rates;

  ExchangeRate? rateFor(Currency c, {DateTime? on}) {
    for (final r in _rates) {
      if (r.currency == c && (on == null || !r.date.isAfter(on))) return r;
    }
    return null;
  }

  /// `null` when no rate is known for [m]'s currency.
  Money? toBase(Money m, {DateTime? on}) {
    if (m.currency == base) return m;
    return rateFor(m.currency, on: on)?.convert(m);
  }
}
