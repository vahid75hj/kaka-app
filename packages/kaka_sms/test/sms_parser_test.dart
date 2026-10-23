import 'dart:io';

import 'package:kaka_sms/kaka_sms.dart';
import 'package:test/test.dart';

void main() {
  test('bundled catalog loads and nothing unverified runs by default', () {
    final catalog = ParserCatalog.parse(File('assets/sms-parsers.v1.json').readAsStringSync());
    expect(catalog.banks.map((b) => b.bankId), ['melli', 'mellat', 'saderat', 'tejarat', 'pasargad']);
    expect(catalog.banks.every((b) => !b.enabledByDefault), isTrue);
  });

  group('bundled bank templates (unverified)', () {
    final bundled = ParserCatalog.parse(File('assets/sms-parsers.v1.json').readAsStringSync());
    final p = SmsParser(bundled, includeUnverified: true);
    for (final bank in bundled.banks) {
      test('${bank.bankId} has samples', () => expect(bank.tests, isNotEmpty));
      for (final t in bank.tests) {
        test('${bank.bankId}: ${t.input.split('\n').skip(1).first}', () {
          final r = p.parse(t.input);
          expect(r, isNotNull);
          expect(r!.bankId, bank.bankId);
          expect(r.direction.name, t.expect['direction']);
          expect(r.amount.minor, t.expect['amount_minor']);
          expect(r.balance?.minor, t.expect['balance_minor']);
          expect(r.last4, t.expect['last4']);
        });
      }
    }
  });

  // The fixture is a fictional bank used to exercise the engine; every catalog
  // entry's own `tests` are run the same way in CI.
  final catalog = ParserCatalog.parse(File('test/fixtures/example_bank.json').readAsStringSync());
  final parser = SmsParser(catalog, includeUnverified: true);

  for (final bank in catalog.banks) {
    for (final t in bank.tests) {
      test('${bank.bankId}: ${t.input}', () {
        final r = parser.parse(t.input)!;
        expect(r.direction.name, t.expect['direction']);
        expect(r.amount.minor, t.expect['amount_minor']);
        expect(r.balance?.minor, t.expect['balance_minor']);
        expect(r.last4, t.expect['last4']);
      });
    }
  }

  test('unknown text and unknown senders are ignored', () {
    expect(parser.parse('سلام، کد تخفیف شما ۱۲۳۴'), isNull);
    expect(parser.parse(catalog.banks.first.tests.first.input, sender: '+98OTHER'), isNull);
  });

  test('dedup key is stable across digit styles', () {
    final a = parser.parse(catalog.banks.first.tests.first.input)!;
    final b = parser.parse(catalog.banks.first.tests.first.input.replaceAll('۱۲۳۴', '1234'))!;
    expect(a.dedupKey, b.dedupKey);
  });
}
