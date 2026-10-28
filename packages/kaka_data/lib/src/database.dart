import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart';

import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Accounts,
    Transactions,
    Postings,
    Settings,
    Drafts,
    SmsLinks,
    FxRates,
    AssetTypes,
    AssetMovements,
    AssetPrices,
    CustomParsers,
  ],
)
class KakaDatabase extends _$KakaDatabase {
  KakaDatabase(super.executor);

  /// Opens (or creates) the encrypted ledger at [file] with [key].
  ///
  /// The key comes from the Android Keystore via the app layer; this package
  /// never sees where it is stored.
  factory KakaDatabase.open(File file, {required String key}) =>
      KakaDatabase(NativeDatabase(file, setup: (db) => _unlock(db, key)));

  static void _unlock(Database db, String key) {
    if (db.select('PRAGMA cipher;').isEmpty) {
      throw StateError('SQLite was built without SQLite3MultipleCiphers; refusing to store data unencrypted.');
    }
    db.execute("PRAGMA key = '${key.replaceAll("'", "''")}';");
    db.execute('PRAGMA foreign_keys = ON;');
  }

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await customStatement('CREATE INDEX postings_account ON postings(account_id)');
      await customStatement('CREATE INDEX transactions_occurred ON transactions(occurred_at DESC)');
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) await m.createTable(drafts);
      if (from == 2) {
        await m.addColumn(drafts, drafts.accountId);
        await m.addColumn(drafts, drafts.balanceMinor);
        await m.addColumn(drafts, drafts.sender);
        await m.addColumn(drafts, drafts.confidence);
      }
      if (from < 3) await m.createTable(smsLinks);
      if (from < 4) {
        for (final TableInfo<Table, dynamic> t in [fxRates, assetTypes, assetMovements, assetPrices, customParsers]) {
          await m.createTable(t);
        }
      }
      // Tables created above already have the v5 column.
      // v5 columns. Tables created by an earlier step already have them, so add only when missing.
      if (from < 5) {
        await _addIfMissing(m, assetMovements, assetMovements.transactionId);
        await _addIfMissing(m, drafts, drafts.toAccountId);
        await _addIfMissing(m, drafts, drafts.category);
        await _addIfMissing(m, accounts, accounts.icon);
      }
    },
  );

  Future<void> _addIfMissing(Migrator m, TableInfo<Table, dynamic> table, GeneratedColumn<Object> column) async {
    final cols = await customSelect('PRAGMA table_info("${table.actualTableName}")').get();
    if (cols.any((r) => r.read<String>('name') == column.name)) return;
    await m.addColumn(table, column);
  }
}
