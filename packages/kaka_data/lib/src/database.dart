import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart';

import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Accounts, Transactions, Postings, Settings, Drafts])
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
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await customStatement('CREATE INDEX postings_account ON postings(account_id)');
      await customStatement('CREATE INDEX transactions_occurred ON transactions(occurred_at DESC)');
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) await m.createTable(drafts);
    },
  );
}
