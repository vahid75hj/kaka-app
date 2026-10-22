import 'package:kaka_domain/kaka_domain.dart';
import 'package:test/test.dart';

void main() {
  group('Money', () {
    test('adds and subtracts in minor units', () {
      final a = const Money(1050, Currency.usd);
      final b = const Money(275, Currency.usd);
      expect((a + b).minor, 1325);
      expect((a - b).minor, 775);
      expect((-a).minor, -1050);
    });

    test('refuses to mix currencies', () {
      expect(() => const Money(1, Currency.usd) + const Money(1, Currency.eur), throwsArgumentError);
    });
  });

  group('AmountParser', () {
    test('parses dollars with cents', () {
      expect(AmountParser.parse('12.34', DisplayUnit.byCode('USD')), const Money(1234, Currency.usd));
      expect(AmountParser.parse('12', DisplayUnit.byCode('USD')), const Money(1200, Currency.usd));
    });

    test('toman input is stored as rial', () {
      expect(AmountParser.parse('۱۲٬۵۰۰', DisplayUnit.irt), const Money(125000, Currency.irr));
      expect(AmountParser.parse('12.5', DisplayUnit.irt), const Money(125, Currency.irr));
    });

    test('accepts Arabic digits and separators', () {
      expect(AmountParser.parse('١,٢٣٤', DisplayUnit.byCode('IRR')), const Money(1234, Currency.irr));
    });

    test('rejects garbage and over-precise amounts', () {
      expect(() => AmountParser.parse('abc', DisplayUnit.irt), throwsA(isA<DomainException>()));
      expect(() => AmountParser.parse('1.005', DisplayUnit.byCode('USD')), throwsA(isA<DomainException>()));
      expect(() => AmountParser.parse('1.25', DisplayUnit.irt), throwsA(isA<DomainException>()));
    });
  });

  group('MoneyFormatter', () {
    const latin0 = MoneyFormatter(digits: DigitSystem.latin, decimals: 0);

    test('shows rial as toman by dividing by ten', () {
      expect(latin0.number(const Money(1234560, Currency.irr), DisplayUnit.irt), '123,456');
    });

    test('rounds half away from zero only on display', () {
      expect(latin0.number(const Money(15, Currency.irr), DisplayUnit.irt), '2');
      expect(latin0.number(const Money(-15, Currency.irr), DisplayUnit.irt), '-2');
      expect(latin0.number(const Money(14, Currency.irr), DisplayUnit.irt), '1');
    });

    test('pads decimals', () {
      const f = MoneyFormatter(digits: DigitSystem.latin, decimals: 2);
      expect(f.number(const Money(123456789, Currency.usd), DisplayUnit.byCode('USD')), '1,234,567.89');
      expect(f.number(const Money(5, Currency.usd), DisplayUnit.byCode('USD')), '0.05');
      expect(f.number(const Money(1234, Currency.irr), DisplayUnit.irt), '123.40');
    });

    test('renders Persian digits and separators', () {
      const f = MoneyFormatter.persian(decimals: 2);
      expect(
        f.format(const Money(123456789, Currency.usd), DisplayUnit.byCode('USD'), persian: true),
        '۱٬۲۳۴٬۵۶۷٫۸۹ دلار',
      );
    });

    test('parse and format round-trip', () {
      const f = MoneyFormatter(digits: DigitSystem.latin, decimals: 1);
      final m = AmountParser.parse('98,765.4', DisplayUnit.irt);
      expect(f.number(m, DisplayUnit.irt), '98,765.4');
    });
  });
}
