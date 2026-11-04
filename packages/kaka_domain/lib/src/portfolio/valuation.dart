import '../fx/exchange_rate.dart';
import '../money/currency.dart';
import '../money/money.dart';
import 'cost_basis.dart';
import 'event.dart';
import 'instrument.dart';

/// A holding with its latest price applied.
class HoldingView {
  HoldingView(this.state, this.price, {required this.staleAfter, required this.now});
  final HoldingState state;
  final PriceQuote? price;
  final Duration staleAfter;
  final DateTime now;

  Instrument get instrument => state.instrument;
  Money get cost => Money(state.cost, state.currency);
  Money? get averageCost => state.averageCost == null ? null : Money(state.averageCost!, state.currency);
  Money get realized => Money(state.realized, state.currency);
  Money get income => Money(state.income, state.currency);

  bool get isStale => price != null && now.difference(price!.asOf) > staleAfter;

  /// Quantity × unit price in the price's currency, or null without a price.
  Money? get marketValue {
    final p = price;
    if (p == null) return null;
    final v = roundHalfEven(
      BigInt.from(p.price.minor) * BigInt.from(state.qty),
      BigInt.from(10).pow(instrument.qtyScale),
    );
    return Money(v.toInt(), p.price.currency);
  }

  /// Market value, falling back to cost when there is no price.
  Money get bestValue => marketValue ?? cost;

  /// Market value − cost in [fx]'s base currency; null when either can't be converted
  /// or the cost is (partly) unknown.
  Money? unrealized(CurrencyConverter fx) {
    final mv = marketValue;
    if (mv == null || state.costUnknown) return null;
    final a = fx.toBase(mv), b = fx.toBase(cost);
    if (a == null || b == null) return null;
    return a - b;
  }

  /// Same, in the holding's own currency when the price is in it.
  Money? get unrealizedNative {
    final mv = marketValue;
    if (mv == null || state.costUnknown || mv.currency != state.currency) return null;
    return mv - cost;
  }
}

/// Default days after which a price is shown as old, per class.
Duration staleAfterFor(AssetClass c) => switch (c) {
  AssetClass.crypto => const Duration(days: 1),
  AssetClass.metal || AssetClass.coin || AssetClass.stock || AssetClass.fund => const Duration(days: 3),
  AssetClass.bond => const Duration(days: 7),
  _ => const Duration(days: 90),
};

abstract final class PortfolioValuation {
  /// Latest quote per instrument (newest date; manual wins a tie).
  static Map<String, PriceQuote> latestPrices(List<PriceQuote> prices) {
    final out = <String, PriceQuote>{};
    for (final p in prices) {
      final cur = out[p.instrumentId];
      if (cur == null || p.asOf.isAfter(cur.asOf) || (p.asOf == cur.asOf && p.source == 'manual')) {
        out[p.instrumentId] = p;
      }
    }
    return out;
  }

  static List<HoldingView> views(
    CostBasisResult r,
    List<PriceQuote> prices, {
    DateTime? now,
    bool includeEmpty = false,
  }) {
    final latest = latestPrices(prices);
    final t = now ?? DateTime.now();
    return [
      for (final h in r.holdings.values)
        if (includeEmpty || h.qty != 0)
          HoldingView(h, latest[h.instrument.id], staleAfter: staleAfterFor(h.instrument.assetClass), now: t),
    ];
  }

  /// Total in base currency; values without a rate are returned per currency.
  static (Money total, List<Money> unconverted) total(Iterable<HoldingView> views, CurrencyConverter fx) {
    var sum = 0;
    final missing = <Currency, int>{};
    for (final v in views) {
      final m = v.bestValue;
      final b = fx.toBase(m);
      if (b == null) {
        missing.update(m.currency, (x) => x + m.minor, ifAbsent: () => m.minor);
      } else {
        sum += b.minor;
      }
    }
    return (Money(sum, fx.base), [for (final e in missing.entries) Money(e.value, e.key)]);
  }
}
