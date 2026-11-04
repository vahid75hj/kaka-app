import 'package:drift/drift.dart';
import 'package:kaka_domain/kaka_domain.dart';

import 'database.dart';

class DriftExchangeRateRepository implements ExchangeRateRepository {
  DriftExchangeRateRepository(this._db);
  final KakaDatabase _db;

  @override
  Stream<List<ExchangeRate>> watchAll() => _q().watch().map((r) => r.map(_toDomain).toList());
  @override
  Future<List<ExchangeRate>> getAll() async => (await _q().get()).map(_toDomain).toList();
  @override
  Future<void> upsert(ExchangeRate r) => _db
      .into(_db.fxRates)
      .insertOnConflictUpdate(
        FxRatesCompanion.insert(
          id: r.id,
          currency: r.currency.code,
          base: r.base.code,
          rateDate: r.date,
          rate: r.rate.toString(),
        ),
      );
  @override
  Future<void> delete(String id) => (_db.delete(_db.fxRates)..where((r) => r.id.equals(id))).go();

  SimpleSelectStatement<$FxRatesTable, FxRateRow> _q() =>
      _db.select(_db.fxRates)..orderBy([(r) => OrderingTerm.desc(r.rateDate)]);

  static ExchangeRate _toDomain(FxRateRow r) => ExchangeRate(
    id: r.id,
    currency: Currency.byCode(r.currency),
    base: Currency.byCode(r.base),
    date: r.rateDate,
    rate: Decimal.parse(r.rate),
  );
}

class DriftPortfolioRepository implements PortfolioRepository {
  DriftPortfolioRepository(this._db);
  final KakaDatabase _db;

  static Instrument _inst(InstrumentRow r) => Instrument(
    id: r.id,
    assetClass: AssetClass.values.asNameMap()[r.assetClass] ?? AssetClass.other,
    nameFa: r.nameFa,
    nameEn: r.nameEn,
    unitFa: r.unitFa,
    unitEn: r.unitEn,
    qtyScale: r.qtyScale,
    symbol: r.symbol,
    quoteCurrency: r.quoteCurrency == null ? null : Currency.byCode(r.quoteCurrency!),
    costMethod: CostMethod.values.asNameMap()[r.costMethod] ?? CostMethod.average,
    catalogId: r.catalogId,
    archived: r.archived,
  );

  @override
  Stream<List<Instrument>> watchInstruments() => _db.select(_db.instruments).watch().map((r) => r.map(_inst).toList());
  @override
  Future<List<Instrument>> instruments() async => (await _db.select(_db.instruments).get()).map(_inst).toList();
  @override
  Future<void> upsertInstrument(Instrument i) => _db
      .into(_db.instruments)
      .insertOnConflictUpdate(
        InstrumentsCompanion.insert(
          id: i.id,
          assetClass: i.assetClass.name,
          nameFa: i.nameFa,
          nameEn: i.nameEn,
          unitFa: i.unitFa,
          unitEn: i.unitEn,
          qtyScale: i.qtyScale,
          symbol: Value(i.symbol),
          quoteCurrency: Value(i.quoteCurrency?.code),
          costMethod: Value(i.costMethod.name),
          catalogId: Value(i.catalogId),
          archived: Value(i.archived),
        ),
      );

  @override
  Stream<List<AssetPlatform>> watchPlatforms() => _db
      .select(_db.platforms)
      .watch()
      .map(
        (rows) => [
          for (final r in rows)
            AssetPlatform(
              id: r.id,
              name: r.name,
              kind: PlatformKind.values.asNameMap()[r.kind] ?? PlatformKind.other,
              archived: r.archived,
            ),
        ],
      );
  @override
  Future<void> upsertPlatform(AssetPlatform p) => _db
      .into(_db.platforms)
      .insertOnConflictUpdate(
        PlatformsCompanion.insert(id: p.id, name: p.name, kind: p.kind.name, archived: Value(p.archived)),
      );

  static PortfolioEvent _event(PortfolioEventRow r) => PortfolioEvent(
    id: r.id,
    instrumentId: r.instrumentId,
    platformId: r.platformId,
    kind: EventKind.values.byName(r.kind),
    at: r.at,
    currency: Currency.byCode(r.currency),
    qty: r.qty,
    gross: r.gross,
    fee: r.fee,
    costMode: CostMode.values.asNameMap()[r.costMode] ?? CostMode.unknown,
    cost: r.cost,
    splitNum: r.splitNum,
    splitDen: r.splitDen,
    groupId: r.groupId,
    cashAccountId: r.cashAccountId,
    txnId: r.txnId,
    txnSig: r.txnSig,
    source: r.source,
    note: r.note,
    voidedAt: r.voidedAt,
    createdAt: r.createdAt,
  );

  SimpleSelectStatement<$PortfolioEventsTable, PortfolioEventRow> _events() =>
      _db.select(_db.portfolioEvents)..orderBy([(e) => OrderingTerm.asc(e.at), (e) => OrderingTerm.asc(e.id)]);

  @override
  Stream<List<PortfolioEvent>> watchEvents() => _events().watch().map((r) => r.map(_event).toList());
  @override
  Future<List<PortfolioEvent>> events() async => (await _events().get()).map(_event).toList();
  @override
  Future<void> upsertEvent(PortfolioEvent e) => _db
      .into(_db.portfolioEvents)
      .insertOnConflictUpdate(
        PortfolioEventsCompanion.insert(
          id: e.id,
          instrumentId: e.instrumentId,
          platformId: Value(e.platformId),
          kind: e.kind.name,
          at: e.at,
          currency: e.currency.code,
          qty: Value(e.qty),
          gross: Value(e.gross),
          fee: Value(e.fee),
          costMode: Value(e.costMode.name),
          cost: Value(e.cost),
          splitNum: Value(e.splitNum),
          splitDen: Value(e.splitDen),
          groupId: Value(e.groupId),
          cashAccountId: Value(e.cashAccountId),
          txnId: Value(e.txnId),
          txnSig: Value(e.txnSig),
          source: Value(e.source),
          note: Value(e.note),
          voidedAt: Value(e.voidedAt),
          createdAt: Value(e.createdAt),
        ),
      );

  @override
  Stream<List<PriceQuote>> watchPrices() =>
      (_db.select(_db.priceQuotes)..orderBy([(p) => OrderingTerm.desc(p.asOf)])).watch().map(
        (rows) => [
          for (final r in rows)
            PriceQuote(
              id: r.id,
              instrumentId: r.instrumentId,
              price: Money(r.priceMinor, Currency.byCode(r.currency)),
              asOf: r.asOf,
              source: r.source,
            ),
        ],
      );
  @override
  Future<void> upsertPrice(PriceQuote p) => _db
      .into(_db.priceQuotes)
      .insertOnConflictUpdate(
        PriceQuotesCompanion.insert(
          id: p.id,
          instrumentId: p.instrumentId,
          priceMinor: p.price.minor,
          currency: p.price.currency.code,
          asOf: p.asOf,
          source: Value(p.source),
        ),
      );
  @override
  Future<void> deletePrice(String id) => (_db.delete(_db.priceQuotes)..where((p) => p.id.equals(id))).go();

  @override
  Stream<List<ValuationSnapshot>> watchSnapshots() =>
      (_db.select(_db.valuationSnapshots)..orderBy([(s) => OrderingTerm.asc(s.at)])).watch().map(
        (rows) => [
          for (final r in rows)
            ValuationSnapshot(
              id: r.id,
              at: r.at,
              base: Currency.byCode(r.base),
              netWorth: r.netWorth,
              assetsValue: r.assetsValue,
              unrealized: r.unrealized,
            ),
        ],
      );
  @override
  Future<void> upsertSnapshot(ValuationSnapshot s) => _db
      .into(_db.valuationSnapshots)
      .insertOnConflictUpdate(
        ValuationSnapshotsCompanion.insert(
          id: s.id,
          at: s.at,
          base: s.base.code,
          netWorth: s.netWorth,
          assetsValue: s.assetsValue,
          unrealized: s.unrealized,
        ),
      );
}

class DriftCustomParserStore {
  DriftCustomParserStore(this._db);
  final KakaDatabase _db;

  Stream<List<(String id, String json)>> watchAll() =>
      _db.select(_db.customParsers).watch().map((rows) => [for (final r in rows) (r.id, r.json)]);
  Future<List<(String id, String json)>> getAll() async => [
    for (final r in await _db.select(_db.customParsers).get()) (r.id, r.json),
  ];
  Future<void> save(String id, String json) => _db
      .into(_db.customParsers)
      .insertOnConflictUpdate(CustomParsersCompanion.insert(id: id, json: json, createdAt: DateTime.now()));
  Future<void> delete(String id) => (_db.delete(_db.customParsers)..where((r) => r.id.equals(id))).go();
}
