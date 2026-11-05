import 'dart:io';

import 'package:kaka_prices/kaka_prices.dart';
import 'package:test/test.dart';

void main() {
  final bundled = File('assets/price_sources.v1.json').readAsStringSync();

  test('bundled catalog validates', () {
    final c = PriceCatalog.parseStrict(bundled, builtin: true);
    expect(c.sources.length, greaterThanOrEqualTo(5));
    expect(c.sources.every((s) => s.id != 'manual' ? s.enabledByDefault == false : true), isTrue);
    expect(c.byId('coingecko_simple')?.kind, PriceSourceKind.httpJson);
    expect(c.byId('tgju_html_metals')?.kind, PriceSourceKind.httpHtml);
    expect(c.byId('manual')?.kind, PriceSourceKind.manual);
  });

  test('bad catalog is rejected', () {
    expect(() => PriceCatalog.parseStrict('{"schema_version":99,"sources":[]}'), throwsFormatException);
    expect(
      () => PriceCatalog.parseStrict('{"schema_version":1,"catalog_version":"x","sources":[{"id":"x","kind":"http_json","name":{"en":"x","fa":"x"},"classes":[]}]}'),
      throwsFormatException,
    );
  });

  test('import skips unknown kinds and round-trips export', () {
    final exported = PriceCatalog.exportSource(
      PriceCatalog.parseStrict(bundled).byId('coingecko_simple')!,
    );
    final imported = PriceCatalog.parse(exported);
    expect(imported.sources.single.id, 'coingecko_simple');
    expect(imported.sources.single.builtin, isFalse);

    final mixed = '''
    {"schema_version":1,"catalog_version":"x","sources":[
      {"id":"ok","kind":"http_json","name":{"en":"ok","fa":"ok"},"classes":["crypto"],"url":"https://example.com/{sym}","extract":"\$.x"},
      {"id":"future","kind":"quantum_oracle","name":{"en":"x","fa":"x"},"classes":[]}
    ]}''';
    final parsed = PriceCatalog.parse(mixed);
    expect(parsed.sources.map((s) => s.id), ['ok']);
  });
}
