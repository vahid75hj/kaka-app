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
    Instruments,
    Platforms,
    PortfolioEvents,
    PriceQuotes,
    ValuationSnapshots,
    CustomParsers,
    Budgets,
    RecurringRules,
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

  /// Unencrypted, RAM-only database (desktop tools reading a decrypted backup; tests).
  factory KakaDatabase.inMemory() =>
      KakaDatabase(NativeDatabase.memory(setup: (db) => db.execute('PRAGMA foreign_keys = ON;')));

  static void _unlock(Database db, String key) {
    if (db.select('PRAGMA cipher;').isEmpty) {
      throw StateError('SQLite was built without SQLite3MultipleCiphers; refusing to store data unencrypted.');
    }
    db.execute("PRAGMA key = '${key.replaceAll("'", "''")}';");
    db.execute('PRAGMA foreign_keys = ON;');
  }

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await customStatement('CREATE INDEX postings_account ON postings(account_id)');
      await customStatement('CREATE INDEX transactions_occurred ON transactions(occurred_at DESC)');
      await customStatement('CREATE INDEX portfolio_events_inst ON portfolio_events(instrument_id, at)');
    },
    // Kaka was never released with real data before v6, so old ledgers are
    // not migrated: the app offers to move them aside and start fresh.
    onUpgrade: (m, from, to) async => throw LedgerTooOldException(from),
  );
}

/// The ledger file predates schema 6 (pre-portfolio test builds).
class LedgerTooOldException implements Exception {
  const LedgerTooOldException(this.version);
  final int version;
  @override
  String toString() => 'LedgerTooOldException: ledger schema v$version is older than v6 and is not migrated';
}
