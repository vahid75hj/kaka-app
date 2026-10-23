import 'package:kaka_sms/kaka_sms.dart';
import 'package:test/test.dart';

void main() {
  test('learns the Melli layout from two real samples', () {
    final r = TemplateLearner.learn(
      [
        'بانك ملي ايران\nانتقالي:37,416,819-\nحساب:06009\nمانده:2,950,788\n0712-15:10',
        'بانك ملي ايران\nانتقالي:2,000,000-\nحساب:06009\nمانده:950,788\n0713-12:14',
        'بانك ملي ايران\nواريز:5,000,000+\nحساب:06009\nمانده:5,950,788\n0714-09:01',
      ],
      nameFa: 'ملی من',
      nameEn: 'My Melli',
      receivedAt: DateTime(2026, 10, 23),
    );
    expect(r.error, isNull);
    expect(r.previews.map((p) => p!.amount.minor), [37416819, 2000000, 5000000]);
    expect(r.previews.map((p) => p!.direction), [SmsDirection.debit, SmsDirection.debit, SmsDirection.credit]);
    expect(r.previews.map((p) => p!.balance?.minor), [2950788, 950788, 5950788]);
    expect(r.previews.first!.account, '06009');
    expect(r.previews.first!.occurredAt, DateTime(2026, 10, 4, 15, 10));

    // The learned bank is used by the parser ahead of bundled templates.
    final parser = SmsParser(
      const ParserCatalog(schemaVersion: 1, catalogVersion: 't', banks: []).withLocal([r.bank!]),
      useHeuristics: false,
    );
    final again = parser.parse('بانك ملي ايران\nانتقالي:123,000-\nحساب:06009\nمانده:1,000\n0715-10:00');
    expect(again?.amount.minor, 123000);
    expect(again?.bankId, r.bank!.bankId);

    // Round-trips through JSON (stored as a local catalog entry).
    final restored = BankParser.fromJson(r.bank!.toJson());
    expect(restored.templates.single.pattern, r.bank!.templates.single.pattern);
  });

  test('words that differ become the direction', () {
    final r = TemplateLearner.learn(
      [
        'Bank X\nبرداشت 120,000 ریال\nمانده 1,000,000',
        'Bank X\nواریز 50,000 ریال\nمانده 1,050,000',
        'Bank X\nبرداشت 7,500 ریال\nمانده 1,042,500',
      ],
      nameFa: 'ایکس',
      nameEn: 'X',
    );
    expect(r.error, isNull);
    expect(r.previews.map((p) => p!.isDebit), [true, false, true]);
  });

  test('different layouts are rejected', () {
    final r = TemplateLearner.learn(['a 1,000 b', 'a 1,000 b c 9'], nameFa: 'a', nameEn: 'a');
    expect(r.error, 'layout_mismatch');
  });

  test('a single sample is not enough', () {
    expect(TemplateLearner.learn(['x 1,000-'], nameFa: 'a', nameEn: 'a').error, 'need_samples');
  });
}
