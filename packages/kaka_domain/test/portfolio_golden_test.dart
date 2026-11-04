import 'package:kaka_domain/kaka_domain.dart';
import 'package:test/test.dart';

// Worked examples from docs/portfolio-design.md §3, plus ledger and edge cases.

class _Accounts implements AccountRepository {
  final items = <String, Account>{};
  @override
  Future<Account?> findById(String id) async => items[id];
  @override
  Future<List<Account>> getAll() async => items.values.toList();
  @override
  Future<void> upsert(Account a) async => items[a.id] = a;
  @override
  Stream<List<Account>> watchAll() => Stream.value(items.values.toList());
}

class _Txns implements TransactionRepository {
  final items = <LedgerTransaction>[];
  @override
  Future<void> insert(LedgerTransaction t) async => items.add(t);
  @override
  Future<void> markVoided(String id, DateTime at) async {
    final i = items.indexWhere((t) => t.id == id);
    final t = items[i];
    items[i] = LedgerTransaction(
      id: t.id,
      kind: t.kind,
      occurredAt: t.occurredAt,
      note: t.note,
      postings: t.postings,
      voidedAt: at,
    );
  }

  @override
  Stream<List<LedgerTransaction>> watchRecent({int limit = 200}) => Stream.value(items);
  @override
  Stream<Map<String, int>> watchPostedSums() {
    final m = <String, int>{};
    for (final t in items.where((t) => !t.isVoided)) {
      for (final p in t.postings) {
        m.update(p.accountId, (v) => v + p.amount.minor, ifAbsent: () => p.amount.minor);
      }
    }
    return Stream.value(m);
  }
}

class _Repo implements PortfolioRepository {
  final inst = <String, Instrument>{};
  final ev = <String, PortfolioEvent>{};
  final prices = <String, PriceQuote>{};
  @override
  Future<List<PortfolioEvent>> events() async => ev.values.toList();
  @override
  Future<List<Instrument>> instruments() async => inst.values.toList();
  @override
  Future<void> upsertEvent(PortfolioEvent e) async => ev[e.id] = e;
  @override
  Future<void> upsertInstrument(Instrument i) async => inst[i.id] = i;
  @override
  Future<void> upsertPlatform(AssetPlatform p) async {}
  @override
  Future<void> upsertPrice(PriceQuote p) async => prices[p.id] = p;
  @override
  Future<void> deletePrice(String id) async => prices.remove(id);
  @override
  Future<void> upsertSnapshot(ValuationSnapshot s) async {}
  @override
  Stream<List<PortfolioEvent>> watchEvents() => Stream.value(ev.values.toList());
  @override
  Stream<List<Instrument>> watchInstruments() => Stream.value(inst.values.toList());
  @override
  Stream<List<AssetPlatform>> watchPlatforms() => const Stream.empty();
  @override
  Stream<List<PriceQuote>> watchPrices() => Stream.value(prices.values.toList());
  @override
  Stream<List<ValuationSnapshot>> watchSnapshots() => const Stream.empty();
}

const irr = Currency.irr;
const usd = Currency.usd;

Instrument coin({CostMethod m = CostMethod.average}) => Instrument(
  id: 'coin',
  assetClass: AssetClass.coin,
  nameFa: 'سکه',
  nameEn: 'Coin',
  unitFa: 'عدد',
  unitEn: 'coin',
  qtyScale: 0,
  costMethod: m,
);

PortfolioEvent ev(
  String id,
  EventKind k,
  int qty, {
  int? gross,
  int fee = 0,
  Currency c = irr,
  int day = 1,
  String inst = 'coin',
  String? platform,
  String? group,
  int? cost,
  CostMode mode = CostMode.paid,
  int? num,
  int? den,
}) => PortfolioEvent(
  id: id,
  instrumentId: inst,
  kind: k,
  at: DateTime(2026, 1, day),
  currency: c,
  qty: qty,
  gross: gross,
  fee: fee,
  platformId: platform,
  groupId: group,
  cost: cost,
  costMode: mode,
  splitNum: num,
  splitDen: den,
);

List<PortfolioEvent> example1() => [
  ev('a1', EventKind.buy, 2, gross: 1602000000, fee: 2000000, day: 1),
  ev('a2', EventKind.buy, 1, gross: 950000000, day: 2),
  ev('a3', EventKind.sell, 2, gross: 1996000000, fee: 4000000, day: 3),
];

void main() {
  group('example 1: weighted average', () {
    test('average, realized and unrealized match the doc', () {
      final r = CostBasis.compute([coin()], example1());
      final h = r.holdings.values.single;
      expect(r.effects['a2']!.costIn, 950000000);
      expect(r.effects['a3']!.costOut, 1701333333);
      expect(h.qty, 1);
      expect(h.cost, 850666667);
      expect(h.averageCost, 850666667);
      expect(h.realized, 294666667);
      expect(h.fees, 6000000);
      final v = PortfolioValuation.views(r, [
        PriceQuote(id: 'p', instrumentId: 'coin', price: const Money(1050000000, irr), asOf: DateTime(2026, 1, 3)),
      ], now: DateTime(2026, 1, 3)).single;
      expect(v.unrealizedNative!.minor, 199333333);
    });

    test('average after two buys is exact (not rounded until shown)', () {
      final r = CostBasis.compute([coin()], example1().take(2).toList());
      final h = r.holdings.values.single;
      expect(h.cost, 2552000000);
      expect(h.averageFraction, (BigInt.from(2552000000), BigInt.from(3)));
      expect(h.averageCost, 850666667);
    });
  });

  test('example 2: FIFO gives the same total gain', () {
    final r = CostBasis.compute([coin(m: CostMethod.fifo)], example1());
    final h = r.holdings.values.single;
    expect(h.realized, 394000000);
    expect(h.cost, 950000000);
    final unrealized = 1050000000 - h.cost;
    expect(unrealized, 100000000);
    final avg = CostBasis.compute([coin()], example1()).holdings.values.single;
    expect(h.realized + unrealized, avg.realized + (1050000000 - avg.cost));
    expect(h.realized + unrealized, 494000000);
  });

  test('example 3: crypto fee in kind and network transfer keep cost', () {
    const btc = Instrument(
      id: 'btc',
      assetClass: AssetClass.crypto,
      nameFa: 'بیت‌کوین',
      nameEn: 'Bitcoin',
      unitFa: 'BTC',
      unitEn: 'BTC',
      qtyScale: 8,
    );
    final r = CostBasis.compute(
      [btc],
      [
        // 0.01 BTC bought for 650 USD, 0.00001 BTC fee taken in kind → 0.00999 net.
        ev('b1', EventKind.buy, 999000, gross: 65000, c: usd, inst: 'btc', platform: 'ex'),
        ev('t1', EventKind.transferOut, 999000, c: usd, inst: 'btc', platform: 'ex', group: 'g', day: 2),
        ev('t2', EventKind.transferIn, 997000, c: usd, inst: 'btc', platform: 'wallet', group: 'g', day: 2),
      ],
    );
    final ex = r.holdings[holdingKey('btc', 'ex', usd)]!;
    final w = r.holdings[holdingKey('btc', 'wallet', usd)]!;
    expect(ex.qty, 0);
    expect(w.qty, 997000);
    expect(w.cost, 65000);
    expect(Qty.format(w.qty, 8), '0.00997');
    // 650 / 0.00997 = 65,195.59 USD per BTC
    expect(w.averageCost, 6519559);
  });

  test('example 4: split, dividend, sale with fee and tax', () {
    const stock = Instrument(
      id: 's',
      assetClass: AssetClass.stock,
      nameFa: 'سهم',
      nameEn: 'Stock',
      unitFa: 'سهم',
      unitEn: 'shares',
      qtyScale: 0,
    );
    final r = CostBasis.compute(
      [stock],
      [
        ev('s1', EventKind.buy, 1000, gross: 6000022, fee: 22, c: usd, inst: 's'),
        ev('s2', EventKind.split, 0, num: 2, den: 1, c: usd, inst: 's', day: 2),
        ev('s3', EventKind.income, 0, gross: 100000, c: usd, inst: 's', day: 3),
        ev('s4', EventKind.sell, 2000, gross: 6964974, fee: 35026, c: usd, inst: 's', day: 4),
      ],
    );
    final h = r.holdings.values.single;
    expect(r.effects['s2'] != null, isTrue);
    expect(h.qty, 0);
    expect(h.income, 100000);
    expect(h.realized, 964952);
  });

  group('edge cases', () {
    test('selling more than held is an error; voiding the buy is refused later', () {
      final r = CostBasis.compute(
        [coin()],
        [ev('x', EventKind.buy, 1, gross: 10), ev('y', EventKind.sell, 2, gross: 30)],
      );
      expect(r.errors['y'], 'portfolio.oversell');
    });

    test('back-dated buy before a sale is ordered by date', () {
      final r = CostBasis.compute(
        [coin()],
        [ev('s', EventKind.sell, 1, gross: 300, day: 5), ev('b', EventKind.buy, 1, gross: 100, day: 1)],
      );
      expect(r.errors, isEmpty);
      expect(r.holdings.values.single.realized, 200);
    });

    test('unknown cost marks the gain incomplete', () {
      final r = CostBasis.compute(
        [coin()],
        [ev('o', EventKind.opening, 2, mode: CostMode.unknown), ev('s', EventKind.sell, 1, gross: 500, day: 2)],
      );
      final h = r.holdings.values.single;
      expect(h.costUnknown, isTrue);
      expect(h.realizedIncomplete, isTrue);
      expect(r.effects['s']!.incomplete, isTrue);
    });

    test('cost is conserved across many partial sales (no lost rial)', () {
      final events = <PortfolioEvent>[ev('b', EventKind.buy, 7, gross: 1000)];
      for (var i = 0; i < 7; i++) {
        events.add(ev('s$i', EventKind.sell, 1, gross: 200, day: 2 + i));
      }
      final r = CostBasis.compute([coin()], events);
      final removed = r.effects.values.fold(0, (s, e) => s + e.costOut);
      expect(removed, 1000);
      expect(r.holdings.values.single.cost, 0);
      expect(r.holdings.values.single.realized, 7 * 200 - 1000);
    });

    test('staking at fair value is income and becomes cost', () {
      final r = CostBasis.compute([coin()], [ev('i', EventKind.income, 3, cost: 900)]);
      final h = r.holdings.values.single;
      expect(h.income, 900);
      expect(h.cost, 900);
    });

    test('quantity parsing is exact with Persian digits', () {
      expect(Qty.parse('۰٫۰۰۹۹۹', 8), 999000);
      expect(Qty.parse('2.5', 3), 2500);
      expect(() => Qty.parse('0.123', 2), throwsFormatException);
      expect(Qty.format(2500, 3), '2.5');
      expect(Qty.format(5, 0), '5');
    });
  });

  group('service and ledger', () {
    late _Accounts accounts;
    late _Txns txns;
    late _Repo repo;
    late LedgerService ledger;
    late PortfolioService svc;
    late Account bank;

    setUp(() async {
      accounts = _Accounts();
      txns = _Txns();
      repo = _Repo();
      ledger = LedgerService(accounts, txns);
      svc = PortfolioService(repo, ledger, accounts);
      await svc.saveInstrument(coin());
      bank = await ledger.createAccount(
        name: 'bank',
        type: AccountType.asset,
        currency: irr,
        openingBalance: const Money(5000000000, irr),
      );
    });

    Future<int> balance(String name) async {
      final all = await ledger.watchBalances().first;
      return all.where((b) => b.account.name == name).fold<int>(0, (s, b) => s + b.balance.minor);
    }

    Future<void> runExample1() async {
      await svc.record(
        instrumentId: 'coin',
        kind: EventKind.buy,
        currency: irr,
        qty: 2,
        gross: 1602000000,
        fee: 2000000,
        cash: bank,
        at: DateTime(2026, 1, 1),
      );
      await svc.record(
        instrumentId: 'coin',
        kind: EventKind.buy,
        currency: irr,
        qty: 1,
        gross: 950000000,
        cash: bank,
        at: DateTime(2026, 1, 2),
      );
      await svc.record(
        instrumentId: 'coin',
        kind: EventKind.sell,
        currency: irr,
        qty: 2,
        gross: 1996000000,
        cash: bank,
        at: DateTime(2026, 1, 3),
      );
    }

    test('trades move cash, holdings carry cost, gain goes to income', () async {
      await runExample1();
      expect(await balance('bank'), 5000000000 - 1602000000 - 950000000 + 1996000000);
      expect(await balance(PortfolioAccounts.holdings('coin', irr)), 850666667);
      expect(await balance(PortfolioAccounts.realizedGain(irr)), 294666667);
    });

    test('net worth counts holdings at market value, not twice', () async {
      await runExample1();
      final res = await svc.compute();
      final views = PortfolioValuation.views(res, [
        PriceQuote(id: 'p', instrumentId: 'coin', price: const Money(1050000000, irr), asOf: DateTime(2026, 1, 3)),
      ]);
      final nw = NetWorth.of(await ledger.watchBalances().first, [
        for (final v in views) v.bestValue,
      ], CurrencyConverter(irr, const []));
      expect(nw.total.minor, (5000000000 - 1602000000 - 950000000 + 1996000000) + 1050000000);
    });

    test('back-dated buy re-posts the later sale (old one voided, not deleted)', () async {
      await runExample1();
      final before = txns.items.length;
      await svc.record(
        instrumentId: 'coin',
        kind: EventKind.buy,
        currency: irr,
        qty: 1,
        gross: 700000000,
        cash: bank,
        at: DateTime(2025, 12, 1),
      );
      // new buy + re-posted sale; the old sale transaction is voided
      expect(txns.items.length, before + 2);
      expect(txns.items.where((t) => t.isVoided).length, 1);
      final res = await svc.compute();
      final cost = res.holdings.values.single.cost;
      expect(await balance(PortfolioAccounts.holdings('coin', irr)), cost);
    });

    test('voiding the buy a later sale needs is refused; voiding the sale works', () async {
      await runExample1();
      final events = await repo.events();
      final firstBuy = events.firstWhere((e) => e.gross == 1602000000);
      await expectLater(svc.voidEvent(firstBuy), throwsA(isA<DomainException>()));
      final sale = events.firstWhere((e) => e.kind == EventKind.sell);
      await svc.voidEvent(sale);
      expect(await balance(PortfolioAccounts.realizedGain(irr)), 0);
      expect(await balance('bank'), 5000000000 - 1602000000 - 950000000);
      expect(await balance(PortfolioAccounts.holdings('coin', irr)), 2552000000);
    });

    test('oversell is rejected before anything is stored', () async {
      await expectLater(
        svc.record(instrumentId: 'coin', kind: EventKind.sell, currency: irr, qty: 1, gross: 5),
        throwsA(isA<DomainException>().having((e) => e.code, 'code', 'portfolio.oversell')),
      );
      expect(await repo.events(), isEmpty);
    });

    test('swap realizes the given asset at fair value; new cost = fair value', () async {
      const gold = Instrument(
        id: 'gold',
        assetClass: AssetClass.metal,
        nameFa: 'طلا',
        nameEn: 'Gold',
        unitFa: 'گرم',
        unitEn: 'g',
        qtyScale: 3,
      );
      await svc.saveInstrument(gold);
      await svc.record(
        instrumentId: 'gold',
        kind: EventKind.opening,
        currency: irr,
        qty: 10000,
        costMode: CostMode.custom,
        cost: 400,
      );
      await svc.swap(
        giveInstrumentId: 'gold',
        giveQty: 5000,
        getInstrumentId: 'coin',
        getQty: 1,
        fairValue: const Money(300, irr),
      );
      final res = await svc.compute();
      final g = res.holdings[holdingKey('gold', null, irr)]!;
      final c = res.holdings[holdingKey('coin', null, irr)]!;
      expect(g.realized, 100);
      expect(g.cost, 200);
      expect(c.cost, 300);
      expect(await balance(PortfolioAccounts.realizedGain(irr)), 100);
    });

    test('cash account must match the event currency', () async {
      await expectLater(
        svc.record(instrumentId: 'coin', kind: EventKind.buy, currency: usd, qty: 1, gross: 5, cash: bank),
        throwsA(isA<DomainException>()),
      );
    });
  });
}
