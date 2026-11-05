import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:kaka_domain/kaka_domain.dart';
import 'package:kaka_prices/kaka_prices.dart';
import 'package:test/test.dart';

void main() {
  final catalog = PriceCatalog.parseStrict(File('assets/price_sources.v1.json').readAsStringSync());
  final btc = InstrumentCatalog.entries.firstWhere((e) => e.id == 'btc').toInstrument('btc1');

  test('HTTP failure writes no quote; yesterday as_of is kept from body', () async {
    final saved = <PriceQuote>[];
    // First: success with frankfurter fixture date 2026-11-04
    final okClient = _SeqClient([
      http.Response(File('test/fixtures/frankfurter.json').readAsStringSync(), 200),
      http.Response('nope', 503),
    ]);
    final fetcher = PriceFetcher(client: okClient);
    final service = PriceRefreshService(
      catalog: catalog,
      fetcher: fetcher,
      isSourceEnabled: (id) => id == 'frankfurter_fx',
    );
    final bindings = [
      const PriceBinding(id: 'b1', instrumentId: 'btc1', sourceId: 'frankfurter_fx', symbol: 'EUR'),
    ];
    final first = await service.refresh(
      instruments: [btc],
      bindings: bindings,
      save: (q) async => saved.add(q),
      now: DateTime(2026, 11, 5),
    );
    expect(first.single.ok, isTrue);
    expect(saved.single.asOf, DateTime(2026, 11, 4));

    final before = List<PriceQuote>.from(saved);
    final second = await service.refresh(
      instruments: [btc],
      bindings: bindings,
      save: (q) async => saved.add(q),
      now: DateTime(2026, 11, 5),
    );
    expect(second.single.ok, isFalse);
    expect(saved, before); // nothing new on error
  });
}

class _SeqClient extends http.BaseClient {
  _SeqClient(this.responses);
  final List<http.Response> responses;
  var i = 0;
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final r = responses[i < responses.length ? i++ : responses.length - 1];
    return http.StreamedResponse(Stream.value(r.bodyBytes), r.statusCode);
  }
}
