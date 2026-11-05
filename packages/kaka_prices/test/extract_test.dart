import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:kaka_domain/kaka_domain.dart';
import 'package:kaka_prices/kaka_prices.dart';
import 'package:test/test.dart';

void main() {
  final fetcher = PriceFetcher();
  final catalog = PriceCatalog.parseStrict(File('assets/price_sources.v1.json').readAsStringSync());

  test('CoinGecko-shaped JSON extract', () {
    final src = catalog.byId('coingecko_simple')!;
    final body = File('test/fixtures/coingecko_simple.json').readAsStringSync();
    final got = fetcher.parseHttpBody(src, body: body, symbol: 'bitcoin', now: DateTime(2026, 11, 5));
    expect(got.amount.currency, Currency.usd);
    expect(got.amount.minor, 8026600);
    expect(got.asOf, DateTime(2026, 11, 5));
  });

  test('Nobitex-shaped JSON extract', () {
    final src = catalog.byId('nobitex_public')!;
    final body = File('test/fixtures/nobitex_stats.json').readAsStringSync();
    final got = fetcher.parseHttpBody(src, body: body, symbol: 'btc', now: DateTime(2026, 11, 5));
    expect(got.amount.currency, Currency.irr);
    expect(got.amount.minor, 111950000000);
  });

  test('Frankfurter as_of stays on source date, not now', () {
    final src = catalog.byId('frankfurter_fx')!;
    final body = File('test/fixtures/frankfurter.json').readAsStringSync();
    final got = fetcher.parseHttpBody(src, body: body, symbol: 'EUR', now: DateTime(2026, 11, 5));
    expect(got.asOf, DateTime(2026, 11, 4));
    expect(got.amount.minor, 88);
  });

  test('HTML css + regex extract on fixture', () {
    final html = File('test/fixtures/price_card.html').readAsStringSync();
    final example = catalog.byId('example_html_price_card')!;
    final a = fetcher.extractFromHtml(example, html: html, symbol: 'x', now: DateTime(2026, 11, 5));
    expect(a.amount.minor, 123456);

    final tgju = catalog.byId('tgju_html_metals')!;
    final b = fetcher.extractFromHtml(tgju, html: html, symbol: 'geram18', now: DateTime(2026, 11, 5));
    expect(b.amount.currency, Currency.irr);
    expect(b.amount.minor, 260621000);
  });

  test('HTTP error does not produce a quote', () async {
    final f = PriceFetcher(client: _FakeClient(500, 'nope'));
    final src = catalog.byId('coingecko_simple')!;
    await expectLater(f.fetchHttp(src, symbol: 'bitcoin'), throwsA(isA<PriceFetchException>()));
  });

  test('formula multiply/divide with cycle detection', () {
    expect(evalFormula('a * b', (n) => n == 'a' ? 2 : 3), 6);
    expect(evalFormula('10 / b', (n) => 2), 5);
    expect(
      () => evalFormula('a * c', (n) {
        if (n == 'a') {
          return evalFormula('a', (_) => 1, stack: {'a'})!;
        }
        return 1;
      }),
      throwsFormatException,
    );
  });
}

class _FakeClient extends http.BaseClient {
  _FakeClient(this.code, this.body);
  final int code;
  final String body;
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    return http.StreamedResponse(Stream.value(body.codeUnits), code);
  }
}
