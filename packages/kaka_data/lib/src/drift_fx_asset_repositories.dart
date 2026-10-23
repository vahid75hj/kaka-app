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

class DriftAssetRepository implements AssetRepository {
  DriftAssetRepository(this._db);
  final KakaDatabase _db;

  /// Built-in types are inserted lazily so prices/movements can reference them.
  Future<void> ensureBuiltIns() async {
    for (final t in AssetType.builtIn) {
      await _db
          .into(_db.assetTypes)
          .insert(
            AssetTypesCompanion.insert(id: t.id, nameFa: t.nameFa, nameEn: t.nameEn, unit: t.unit.name),
            mode: InsertMode.insertOrIgnore,
          );
    }
  }

  @override
  Stream<List<AssetType>> watchTypes() => _db
      .select(_db.assetTypes)
      .watch()
      .map(
        (rows) => [
          for (final r in rows)
            AssetType(
              id: r.id,
              nameFa: r.nameFa,
              nameEn: r.nameEn,
              unit: AssetUnit.values.byName(r.unit),
              archived: r.archived,
            ),
        ],
      );

  @override
  Future<void> upsertType(AssetType t) => _db
      .into(_db.assetTypes)
      .insertOnConflictUpdate(
        AssetTypesCompanion.insert(
          id: t.id,
          nameFa: t.nameFa,
          nameEn: t.nameEn,
          unit: t.unit.name,
          archived: Value(t.archived),
        ),
      );

  @override
  Stream<List<AssetMovement>> watchMovements() =>
      (_db.select(_db.assetMovements)..orderBy([(m) => OrderingTerm.desc(m.movedAt)])).watch().map(
        (rows) => [
          for (final r in rows)
            AssetMovement(
              id: r.id,
              assetTypeId: r.assetTypeId,
              quantityMilli: r.quantityMilli,
              date: r.movedAt,
              total: r.totalMinor == null ? null : Money(r.totalMinor!, Currency.byCode(r.totalCurrency!)),
              note: r.note,
              voidedAt: r.voidedAt,
            ),
        ],
      );

  @override
  Future<void> insertMovement(AssetMovement m) => _db
      .into(_db.assetMovements)
      .insert(
        AssetMovementsCompanion.insert(
          id: m.id,
          assetTypeId: m.assetTypeId,
          quantityMilli: m.quantityMilli,
          movedAt: m.date,
          totalMinor: Value(m.total?.minor),
          totalCurrency: Value(m.total?.currency.code),
          note: Value(m.note),
        ),
      );

  @override
  Future<void> voidMovement(String id, DateTime at) => (_db.update(
    _db.assetMovements,
  )..where((m) => m.id.equals(id))).write(AssetMovementsCompanion(voidedAt: Value(at)));

  @override
  Stream<List<AssetPrice>> watchPrices() => _db
      .select(_db.assetPrices)
      .watch()
      .map(
        (rows) => [
          for (final r in rows)
            AssetPrice(
              id: r.id,
              assetTypeId: r.assetTypeId,
              date: r.priceDate,
              price: Money(r.priceMinor, Currency.byCode(r.currency)),
            ),
        ],
      );

  @override
  Future<void> upsertPrice(AssetPrice p) => _db
      .into(_db.assetPrices)
      .insertOnConflictUpdate(
        AssetPricesCompanion.insert(
          id: p.id,
          assetTypeId: p.assetTypeId,
          priceDate: p.date,
          priceMinor: p.price.minor,
          currency: p.price.currency.code,
        ),
      );
}

/// Local "learned" SMS templates, stored as one catalog bank entry (JSON) each.
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
