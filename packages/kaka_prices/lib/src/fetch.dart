import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kaka_domain/kaka_domain.dart';

import 'catalog.dart';
import 'extract.dart';
import 'money_from_decimal.dart';

/// Result of reading one price from a source. Never invents a number.
class FetchedPrice {
  const FetchedPrice({required this.amount, required this.asOf, this.raw});
  final Money amount;
  final DateTime asOf;
  final String? raw;
}

class PriceFetchException implements Exception {
  const PriceFetchException(this.message);
  final String message;
  @override
  String toString() => 'PriceFetchException: $message';
}

/// Fetches and extracts prices for HTTP JSON / CSV sources.
/// HTML sources are extracted via [extractFromHtml] after the app loads a page.
class PriceFetcher {
  PriceFetcher({http.Client? client, this.userAgent = 'KakaPrice/0.8 (+https://github.com/vahid75hj/kaka-app)'})
    : _http = client ?? http.Client(),
      _ownsClient = client == null;

  final http.Client _http;
  final bool _ownsClient;
  final String userAgent;

  void close() {
    if (_ownsClient) _http.close();
  }

  Future<FetchedPrice> fetchHttp(PriceSource source, {required String symbol, DateTime? now}) async {
    if (source.kind == PriceSourceKind.manual) {
      throw const PriceFetchException('manual source has no fetch');
    }
    if (source.kind == PriceSourceKind.httpHtml) {
      throw const PriceFetchException('html sources need an in-app browser; use extractFromHtml');
    }
    final url = source.resolveUrl(sym: symbol, quote: source.quoteCurrency.toLowerCase());
    final headers = <String, String>{'User-Agent': userAgent, 'Accept': 'application/json,text/csv,*/*', ...source.headers};
    final res = await _http.get(Uri.parse(url), headers: headers);
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw PriceFetchException('HTTP ${res.statusCode} from ${source.id}');
    }
    final body = utf8.decode(res.bodyBytes);
    return parseHttpBody(source, body: body, symbol: symbol, now: now);
  }

  /// Pure parse (for tests and for HTML after WebView).
  FetchedPrice parseHttpBody(PriceSource source, {required String body, required String symbol, DateTime? now}) {
    final clock = now ?? DateTime.now();
    final currency = Currency.byCode(source.quoteCurrency);
    String? raw;
    DateTime? asOf;

    switch (source.kind) {
      case PriceSourceKind.httpJson:
        final decoded = jsonDecode(body);
        final path = source.resolveExtract(symbol, quote: source.quoteCurrency.toLowerCase());
        final value = jsonPath(decoded, path);
        if (value == null) throw PriceFetchException('extract missed for ${source.id}');
        raw = '$value';
        if (source.asOfExtract.isNotEmpty) {
          asOf = parseAsOf(jsonPath(decoded, source.asOfExtract));
        }
      case PriceSourceKind.httpCsv:
        raw = csvCell(body, source.extract, sym: symbol);
        if (raw == null || raw.isEmpty) throw PriceFetchException('csv extract missed for ${source.id}');
      case PriceSourceKind.httpHtml:
        return extractFromHtml(source, html: body, symbol: symbol, now: clock);
      case PriceSourceKind.manual:
        throw const PriceFetchException('manual source has no fetch');
    }

    final money = moneyFromDecimal(raw, currency, scaleHint: source.scaleHint);
    if (money.isNegative || money.isZero) throw const PriceFetchException('non-positive price');
    final day = asOf ?? DateTime(clock.year, clock.month, clock.day);
    return FetchedPrice(amount: money, asOf: day, raw: raw);
  }

  FetchedPrice extractFromHtml(PriceSource source, {required String html, required String symbol, DateTime? now}) {
    final clock = now ?? DateTime.now();
    final currency = Currency.byCode(source.quoteCurrency);
    String? raw;
    DateTime? asOf;

    if (source.regex.isNotEmpty) {
      final got = regexExtract(html, source.resolveRegex(symbol));
      raw = got.price;
      asOf = parseAsOf(got.asOf);
    }
    if ((raw == null || raw.isEmpty) && source.cssSelector.isNotEmpty) {
      raw = cssSelect(html, source.resolveCss(symbol), attribute: source.attr);
    }
    if (raw == null || raw.isEmpty) throw PriceFetchException('html extract missed for ${source.id}');
    final money = moneyFromDecimal(raw, currency, scaleHint: source.scaleHint);
    if (money.isNegative || money.isZero) throw const PriceFetchException('non-positive price');
    final day = asOf ?? DateTime(clock.year, clock.month, clock.day);
    return FetchedPrice(amount: money, asOf: day, raw: raw);
  }
}
