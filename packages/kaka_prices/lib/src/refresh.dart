import 'package:kaka_domain/kaka_domain.dart';

import 'catalog.dart';
import 'fetch.dart';

/// One instrument refresh attempt outcome. Failures never invent a quote.
class RefreshOutcome {
  const RefreshOutcome.ok(this.instrumentId, this.sourceId, this.price) : error = null;
  const RefreshOutcome.fail(this.instrumentId, this.sourceId, this.error) : price = null;

  final String instrumentId;
  final String sourceId;
  final PriceQuote? price;
  final String? error;
  bool get ok => price != null;
}

/// Applies enabled bindings in priority order; first success wins per instrument.
class PriceRefreshService {
  PriceRefreshService({
    required this.catalog,
    required this.fetcher,
    required this.isSourceEnabled,
    this.htmlBodyFor,
  });

  final PriceCatalog catalog;
  final PriceFetcher fetcher;
  final bool Function(String sourceId) isSourceEnabled;

  /// For HTML sources the app supplies page HTML after the user opens WebView.
  final Future<String> Function(PriceSource source, String url)? htmlBodyFor;

  Future<List<RefreshOutcome>> refresh({
    required List<Instrument> instruments,
    required List<PriceBinding> bindings,
    required Future<void> Function(PriceQuote quote) save,
    DateTime? now,
    String? onlySourceId,
    String? onlyInstrumentId,
  }) async {
    final byInst = <String, List<PriceBinding>>{};
    for (final b in bindings) {
      if (!b.enabled) continue;
      if (onlyInstrumentId != null && b.instrumentId != onlyInstrumentId) continue;
      if (onlySourceId != null && b.sourceId != onlySourceId) continue;
      if (!isSourceEnabled(b.sourceId)) continue;
      (byInst[b.instrumentId] ??= []).add(b);
    }
    for (final list in byInst.values) {
      list.sort((a, b) => a.priority.compareTo(b.priority));
    }

    final out = <RefreshOutcome>[];
    for (final inst in instruments) {
      final chain = byInst[inst.id];
      if (chain == null || chain.isEmpty) continue;
      var saved = false;
      for (final b in chain) {
        final source = catalog.byId(b.sourceId);
        if (source == null) {
          out.add(RefreshOutcome.fail(inst.id, b.sourceId, 'unknown source'));
          continue;
        }
        try {
          final FetchedPrice fetched;
          if (source.kind == PriceSourceKind.httpHtml) {
            final loader = htmlBodyFor;
            if (loader == null) {
              out.add(RefreshOutcome.fail(inst.id, b.sourceId, 'html loader missing'));
              continue;
            }
            final url = source.resolveUrl(sym: b.symbol, quote: source.quoteCurrency.toLowerCase());
            final html = await loader(source, url);
            fetched = fetcher.extractFromHtml(source, html: html, symbol: b.symbol, now: now);
          } else {
            fetched = await fetcher.fetchHttp(source, symbol: b.symbol, now: now);
          }
          // Quote currency must match what we store; instrument may prefer another —
          // still save what the source returned (user chose the source).
          final day = DateTime(fetched.asOf.year, fetched.asOf.month, fetched.asOf.day);
          final quote = PriceQuote(
            id: '${inst.id}|${fetched.amount.currency.code}|${day.toIso8601String().substring(0, 10)}|${source.id}',
            instrumentId: inst.id,
            price: fetched.amount,
            asOf: day,
            source: source.id,
          );
          await save(quote);
          out.add(RefreshOutcome.ok(inst.id, source.id, quote));
          saved = true;
          break; // first success wins
        } on Object catch (e) {
          out.add(RefreshOutcome.fail(inst.id, b.sourceId, '$e'));
        }
      }
      if (!saved && chain.isNotEmpty) {
        // Keep last valid quote untouched — caller saves nothing on failure.
      }
    }
    return out;
  }

  /// Suggest a binding symbol for an instrument from source hints / instrument.symbol.
  static String? suggestSymbol(PriceSource source, Instrument instrument) {
    final sym = instrument.symbol.trim();
    if (sym.isNotEmpty && source.symbolHints.containsKey(sym)) {
      return source.symbolHints[sym];
    }
    if (sym.isNotEmpty && source.symbolHints.containsKey(sym.toUpperCase())) {
      return source.symbolHints[sym.toUpperCase()];
    }
    final catalogId = instrument.catalogId;
    if (catalogId != null && source.symbolHints.containsKey(catalogId)) {
      return source.symbolHints[catalogId];
    }
    if (sym.isNotEmpty) return sym.toLowerCase();
    return null;
  }
}
