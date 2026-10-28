import 'dart:io';

import 'package:kaka_data/kaka_data.dart';
import 'package:kaka_domain/kaka_domain.dart';
import 'package:test/test.dart';

void main() {
  test('v2 database (Kaka 0.2.0) upgrades to v3 keeping drafts', () async {
    final dir = Directory.systemTemp.createTempSync('kaka_mig');
    addTearDown(() => dir.deleteSync(recursive: true));
    final file = File('${dir.path}/l.db');

    // Build a v2-shaped file: current schema minus the v3 additions.
    var db = KakaDatabase.open(file, key: 'k');
    await db.customStatement('DROP TABLE sms_links');
    await db.customStatement('DROP TABLE drafts');
    await db.customStatement(
      'CREATE TABLE drafts (id TEXT NOT NULL, source TEXT NOT NULL, status TEXT NOT NULL, '
      'is_expense INTEGER NOT NULL, amount_minor INTEGER NOT NULL, currency TEXT NOT NULL, '
      "created_at INTEGER NOT NULL, occurred_at INTEGER NULL, raw_text TEXT NOT NULL DEFAULT '', "
      "note TEXT NOT NULL DEFAULT '', bank_id TEXT NULL, last4 TEXT NULL, dedup_key TEXT NULL, PRIMARY KEY (id))",
    );
    await db.customStatement(
      "INSERT INTO drafts (id, source, status, is_expense, amount_minor, currency, created_at) "
      "VALUES ('old', 'share', 'pending', 1, 5000, 'IRR', 1760000000)",
    );
    await db.customStatement('PRAGMA user_version = 2');
    await db.close();

    db = KakaDatabase.open(file, key: 'k');
    addTearDown(db.close);
    final repo = DriftDraftRepository(db);
    expect((await repo.findById('old'))?.amount.minor, 5000);
    await repo.upsert(
      Draft(
        id: 'new',
        source: DraftSource.sms,
        isExpense: true,
        amount: const Money(1, Currency.irr),
        createdAt: DateTime(2026),
        accountId: 'a',
        balance: const Money(9, Currency.irr),
        sender: 's',
        confidence: 0.7,
      ),
    );
    final n = await repo.findById('new');
    expect((n!.accountId, n.balance?.minor, n.confidence), ('a', 9, 0.7));
    await DriftSmsLinkRepository(db).upsert(const SmsLink(id: 'l', sender: '700717'));
    expect(await DriftSmsLinkRepository(db).getAll(), hasLength(1));
  });

  test('v3 database (Kaka 0.3.0) upgrades to v4: rates, assets, custom parsers', () async {
    final dir = Directory.systemTemp.createTempSync('kaka_mig4');
    addTearDown(() => dir.deleteSync(recursive: true));
    final file = File('${dir.path}/l.db');
    var db = KakaDatabase.open(file, key: 'k');
    await DriftSmsLinkRepository(db).upsert(const SmsLink(id: 'keep', sender: '700717'));
    for (final t in ['fx_rates', 'asset_movements', 'asset_prices', 'asset_types', 'custom_parsers']) {
      await db.customStatement('DROP TABLE $t');
    }
    // A real v3 file has no v5 columns either.
    await db.customStatement('ALTER TABLE drafts DROP COLUMN to_account_id');
    await db.customStatement('ALTER TABLE drafts DROP COLUMN category');
    await db.customStatement('ALTER TABLE accounts DROP COLUMN icon');
    await db.customStatement('PRAGMA user_version = 3');
    await db.close();

    db = KakaDatabase.open(file, key: 'k');
    addTearDown(db.close);
    expect(await DriftSmsLinkRepository(db).getAll(), hasLength(1));
    final fx = DriftExchangeRateRepository(db);
    await fx.upsert(
      ExchangeRate(
        id: 'r',
        currency: Currency.usd,
        base: Currency.irr,
        date: DateTime(2026, 10),
        rate: Decimal.parse('1050000.5'),
      ),
    );
    expect((await fx.getAll()).single.rate.toString(), '1050000.5');
    final assets = DriftAssetRepository(db);
    await assets.ensureBuiltIns();
    await assets.insertMovement(
      AssetMovement(id: 'm', assetTypeId: 'coin_emami', quantityMilli: 2000, date: DateTime(2026)),
    );
    await assets.upsertPrice(
      AssetPrice(id: 'p', assetTypeId: 'coin_emami', date: DateTime(2026), price: const Money(900000000, Currency.irr)),
    );
    final h = AssetMath.holdings(
      await assets.watchTypes().first,
      await assets.watchMovements().first,
      await assets.watchPrices().first,
    );
    expect(h.single.value, const Money(1800000000, Currency.irr));
    await DriftCustomParserStore(db).save('local.x', '{}');
    expect(await DriftCustomParserStore(db).getAll(), hasLength(1));

    // Backups include the new tables.
    final snap = await LedgerSnapshot(db).export();
    expect((snap['tables'] as Map).keys, containsAll(['fx_rates', 'asset_movements', 'custom_parsers']));
  });

  test('v4 database (Kaka 0.4.0) upgrades to v5: asset movement transaction_id, transfer drafts', () async {
    final dir = Directory.systemTemp.createTempSync('kaka_mig5');
    addTearDown(() => dir.deleteSync(recursive: true));
    final file = File('${dir.path}/l.db');
    var db = KakaDatabase.open(file, key: 'k');
    await DriftAssetRepository(db).ensureBuiltIns();
    await db.customStatement('ALTER TABLE asset_movements DROP COLUMN transaction_id');
    await db.customStatement('ALTER TABLE drafts DROP COLUMN to_account_id');
    await db.customStatement('ALTER TABLE drafts DROP COLUMN category');
    await db.customStatement('ALTER TABLE accounts DROP COLUMN icon');
    await db.customStatement(
      "INSERT INTO asset_movements (id, asset_type_id, quantity_milli, moved_at, note) VALUES ('old', 'gold18', 1500, 0, '')",
    );
    await db.customStatement('PRAGMA user_version = 4');
    await db.close();

    db = KakaDatabase.open(file, key: 'k');
    addTearDown(db.close);
    final assets = DriftAssetRepository(db);
    await assets.insertMovement(
      AssetMovement(id: 'new', assetTypeId: 'gold18', quantityMilli: 500, date: DateTime(2026), transactionId: 't1'),
    );
    final all = {for (final m in await assets.watchMovements().first) m.id: m};
    expect(all['old']!.quantityMilli, 1500);
    expect(all['old']!.transactionId, isNull);
    expect(all['new']!.transactionId, 't1');
    final drafts = DriftDraftRepository(db);
    await drafts.upsert(
      Draft(
        id: 'd',
        source: DraftSource.ai,
        isExpense: true,
        amount: const Money(5, Currency.irr),
        createdAt: DateTime(2026),
        accountId: 'a',
        toAccountId: 'b',
        category: 'x',
      ),
    );
    final d = (await drafts.findById('d'))!;
    expect((d.isTransfer, d.toAccountId, d.category), (true, 'b', 'x'));
    final accounts = DriftAccountRepository(db);
    await accounts.upsert(
      Account(
        id: 'c',
        name: 'غذا',
        type: AccountType.expense,
        currency: Currency.irr,
        createdAt: DateTime(2026),
        icon: 'food',
      ),
    );
    expect((await accounts.findById('c'))!.icon, 'food');
  });
}
