import 'dart:io';

import 'package:kaka_data/kaka_data.dart';
import 'package:kaka_domain/kaka_domain.dart';
import 'package:test/test.dart';

void main() {
  test('a pre-v6 ledger is refused (not migrated) so the app can offer a fresh start', () async {
    final dir = Directory.systemTemp.createTempSync('kaka_old');
    addTearDown(() => dir.deleteSync(recursive: true));
    final file = File('${dir.path}/l.db');
    var db = KakaDatabase.open(file, key: 'k');
    await db.customSelect('SELECT 1').get();
    await db.customStatement('PRAGMA user_version = 5');
    await db.close();

    db = KakaDatabase.open(file, key: 'k');
    await expectLater(db.customSelect('SELECT 1').get(), throwsA(isA<LedgerTooOldException>()));
    await db.close();
    expect(file.existsSync(), isTrue, reason: 'never deleted');
  });

  test('portfolio tables round-trip through the repository and backups', () async {
    final db = KakaDatabase.inMemory();
    addTearDown(db.close);
    final repo = DriftPortfolioRepository(db);
    final i = InstrumentCatalog.entries.firstWhere((e) => e.id == 'btc').toInstrument('btc1');
    await repo.upsertInstrument(i);
    await repo.upsertPlatform(const AssetPlatform(id: 'p', name: 'Exchange', kind: PlatformKind.exchange));
    final e = PortfolioEvent(
      id: 'e1',
      instrumentId: 'btc1',
      platformId: 'p',
      kind: EventKind.buy,
      at: DateTime(2026, 1, 2),
      currency: Currency.usd,
      qty: 999000,
      gross: 65000,
      fee: 65,
      costMode: CostMode.paid,
    );
    await repo.upsertEvent(e);
    await repo.upsertEvent(e.copyWith(txnId: () => 't', txnSig: () => 's'));
    await repo.upsertPrice(
      PriceQuote(id: 'q', instrumentId: 'btc1', price: const Money(7000000, Currency.usd), asOf: DateTime(2026)),
    );
    final back = (await repo.events()).single;
    expect((back.qty, back.gross, back.txnId, back.platformId, back.kind), (999000, 65000, 't', 'p', EventKind.buy));
    expect((await repo.instruments()).single.qtyScale, 8);
    expect((await repo.watchPrices().first).single.price.minor, 7000000);

    final snap = await LedgerSnapshot(db).export();
    final fresh = KakaDatabase.inMemory();
    addTearDown(fresh.close);
    await LedgerSnapshot(fresh).restore(snap);
    expect((await DriftPortfolioRepository(fresh).events()).single.gross, 65000);
    await expectLater(
      LedgerSnapshot(fresh).restore({...snap, 'schema': 5}),
      throwsA(isA<BackupException>().having((b) => b.code, 'code', 'backup.too_old')),
    );
  });

  test('v6 ledger upgrades to v7 and keeps prices', () async {
    final dir = Directory.systemTemp.createTempSync('kaka_v6');
    addTearDown(() => dir.deleteSync(recursive: true));
    final file = File('${dir.path}/l.db');

    var db = KakaDatabase.open(file, key: 'k');
    await db.customSelect('SELECT 1').get();
    final repo = DriftPortfolioRepository(db);
    final i = InstrumentCatalog.entries.firstWhere((e) => e.id == 'btc').toInstrument('btc1');
    await repo.upsertInstrument(i);
    await repo.upsertPrice(
      PriceQuote(id: 'q', instrumentId: 'btc1', price: const Money(7000000, Currency.usd), asOf: DateTime(2026)),
    );
    await db.close();

    // Simulate a v6 file: drop v7 tables and set user_version=6.
    db = KakaDatabase.open(file, key: 'k');
    await db.customStatement('DROP TABLE IF EXISTS price_bindings');
    await db.customStatement('DROP TABLE IF EXISTS user_price_sources');
    await db.customStatement('PRAGMA user_version = 6');
    await db.close();

    db = KakaDatabase.open(file, key: 'k');
    addTearDown(db.close);
    expect(db.schemaVersion, 7);
    await db.customSelect('SELECT 1').get();
    final prices = await DriftPortfolioRepository(db).watchPrices().first;
    expect(prices.single.price.minor, 7000000);
    final tables = await db.customSelect("SELECT name FROM sqlite_master WHERE name='price_bindings'").get();
    expect(tables, isNotEmpty);
  });
}
