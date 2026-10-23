import 'package:kaka_domain/kaka_domain.dart';
import 'package:test/test.dart';

Account _acc(String id, AccountType t, Currency c, {bool system = false}) =>
    Account(id: id, name: id, type: t, currency: c, createdAt: DateTime(2026), isSystem: system);

void main() {
  group('Decimal & rates', () {
    test('parses Persian digits and decimals exactly', () {
      expect(Decimal.parse('۱٬۰۵۰٬۰۰۰').toString(), '1050000');
      expect(Decimal.parse('0.00095').toString(), '0.00095');
      expect(() => Decimal.parse('abc'), throwsA(isA<DomainException>()));
      expect(() => Decimal.parse('0'), throwsA(isA<DomainException>()));
    });

    test('converts with storage scales and rounding', () {
      final usd = ExchangeRate(
        id: 'r',
        currency: Currency.usd,
        base: Currency.irr,
        date: DateTime(2026, 10, 1),
        rate: Decimal.parse('1050000'),
      );
      expect(usd.convert(const Money(1250, Currency.usd)), const Money(13125000, Currency.irr)); // $12.50
      final irr = ExchangeRate(
        id: 'r2',
        currency: Currency.irr,
        base: Currency.usd,
        date: DateTime(2026),
        rate: Decimal.parse('0.00000095'),
      );
      expect(irr.convert(const Money(10000000, Currency.irr)), const Money(950, Currency.usd));
    });

    test('converter uses the latest rate on or before the date', () {
      ExchangeRate r(DateTime d, String v) =>
          ExchangeRate(id: '$d', currency: Currency.usd, base: Currency.irr, date: d, rate: Decimal.parse(v));
      final fx = CurrencyConverter(Currency.irr, [r(DateTime(2026, 1, 1), '100'), r(DateTime(2026, 6, 1), '200')]);
      expect(fx.toBase(const Money(100, Currency.usd), on: DateTime(2026, 3, 1))!.minor, 100);
      expect(fx.toBase(const Money(100, Currency.usd))!.minor, 200);
      expect(fx.toBase(const Money(100, Currency.eur)), isNull);
      expect(fx.toBase(const Money(5, Currency.irr))!.minor, 5);
    });
  });

  test('exchange balances per currency through FX accounts', () {
    final rial = _acc('rial', AccountType.asset, Currency.irr);
    final usd = _acc('usd', AccountType.asset, Currency.usd);
    final fxIrr = _acc('FX:IRR', AccountType.equity, Currency.irr, system: true);
    final fxUsd = _acc('FX:USD', AccountType.equity, Currency.usd, system: true);
    final t = TransactionFactory.exchange(
      from: rial,
      to: usd,
      fromAmount: const Money(105000000, Currency.irr),
      toAmount: const Money(10000, Currency.usd),
      fxFrom: fxIrr,
      fxTo: fxUsd,
      at: DateTime(2026),
    );
    LedgerRules.validate(t, {
      for (final a in [rial, usd, fxIrr, fxUsd]) a.id: a,
    });
    expect(t.kind, TransactionKind.exchange);
  });

  group('assets', () {
    test('quantities in thousandths and holdings value', () {
      expect(AssetMath.parseQuantity('۲٫۵'), 2500);
      expect(AssetMath.formatQuantity(2500), '2.5');
      final gold = AssetType.builtIn.first;
      final h = AssetMath.holdings(
        [gold],
        [
          AssetMovement(id: 'a', assetTypeId: gold.id, quantityMilli: 3000, date: DateTime(2026)),
          AssetMovement(id: 'b', assetTypeId: gold.id, quantityMilli: -500, date: DateTime(2026, 2)),
          AssetMovement(
            id: 'c',
            assetTypeId: gold.id,
            quantityMilli: 9000,
            date: DateTime(2026, 3),
            voidedAt: DateTime(2026, 3),
          ),
        ],
        [
          AssetPrice(id: 'p1', assetTypeId: gold.id, date: DateTime(2026), price: const Money(1000, Currency.irr)),
          AssetPrice(id: 'p2', assetTypeId: gold.id, date: DateTime(2026, 5), price: const Money(2000, Currency.irr)),
        ],
      ).single;
      expect(h.quantityMilli, 2500);
      expect(h.value, const Money(5000, Currency.irr));
    });
  });

  test('net worth converts accounts and assets; unknown rates are listed apart', () {
    final fx = CurrencyConverter(Currency.irr, [
      ExchangeRate(
        id: 'u',
        currency: Currency.usd,
        base: Currency.irr,
        date: DateTime(2026),
        rate: Decimal.parse('10'),
      ),
    ]);
    final nw = NetWorth.of(
      [
        AccountBalance(_acc('r', AccountType.asset, Currency.irr), const Money(1000, Currency.irr)),
        AccountBalance(_acc('u', AccountType.asset, Currency.usd), const Money(500, Currency.usd)), // $5
        AccountBalance(_acc('e', AccountType.asset, Currency.eur), const Money(700, Currency.eur)),
        AccountBalance(_acc('food', AccountType.expense, Currency.irr), const Money(99, Currency.irr)),
      ],
      [
        AssetHolding(
          AssetType.builtIn.first,
          1000,
          AssetPrice(id: 'p', assetTypeId: 'gold18', date: DateTime(2026), price: const Money(300, Currency.irr)),
        ),
      ],
      fx,
    );
    expect(nw.total, const Money(1350, Currency.irr));
    expect(nw.unconverted, [const Money(700, Currency.eur)]);
  });

  test('monthly report groups by category in base currency', () {
    final wallet = _acc('w', AccountType.asset, Currency.irr);
    final food = _acc('Food', AccountType.expense, Currency.irr);
    final salary = _acc('Salary', AccountType.income, Currency.irr);
    final accounts = {
      for (final a in [wallet, food, salary]) a.id: a,
    };
    final txns = [
      TransactionFactory.expense(
        from: wallet,
        category: food,
        amount: const Money(300, Currency.irr),
        at: DateTime(2026, 10, 5),
      ),
      TransactionFactory.expense(
        from: wallet,
        category: food,
        amount: const Money(200, Currency.irr),
        at: DateTime(2026, 10, 6),
      ),
      TransactionFactory.income(
        to: wallet,
        category: salary,
        amount: const Money(1000, Currency.irr),
        at: DateTime(2026, 10, 1),
      ),
      TransactionFactory.expense(
        from: wallet,
        category: food,
        amount: const Money(999, Currency.irr),
        at: DateTime(2026, 9, 30),
      ),
    ];
    final r = MonthlyReport.build(
      txns,
      accounts,
      CurrencyConverter(Currency.irr, const []),
      from: DateTime(2026, 10),
      to: DateTime(2026, 11),
    );
    expect(r.totalExpense.minor, 500);
    expect(r.totalIncome.minor, 1000);
    expect(r.expense.single.name, 'Food');
  });

  test('CSV export: exact decimals, quoting and formula neutralization', () {
    final w = _acc('Wallet, main', AccountType.asset, Currency.usd);
    final food = _acc('=cmd', AccountType.expense, Currency.usd);
    final t = TransactionFactory.expense(
      from: w,
      category: food,
      amount: const Money(1250, Currency.usd),
      at: DateTime(2026, 10, 1),
      note: 'say "hi"',
    );
    final csv = TransactionCsv.build([t], {w.id: w, food.id: food});
    final lines = csv.substring(1).trim().split('\r\n');
    expect(lines.first, TransactionCsv.header.join(','));
    expect(lines[1], contains('"Wallet, main"'));
    expect(lines[1], contains(',-12.50,USD,"say ""hi""",'));
  });
}
