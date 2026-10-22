import 'dart:convert';

import 'package:kaka_domain/kaka_domain.dart';

import 'database.dart';

/// Persists [AppSettings] as one JSON row inside the encrypted database.
class DriftSettingsStore {
  DriftSettingsStore(this._db);
  final KakaDatabase _db;
  static const _key = 'app_settings';

  Future<AppSettings?> load() async {
    final row = await (_db.select(_db.settings)..where((s) => s.key.equals(_key))).getSingleOrNull();
    return row == null ? null : AppSettings.fromJson(jsonDecode(row.value) as Map<String, Object?>);
  }

  Future<void> save(AppSettings s) =>
      _db.into(_db.settings).insertOnConflictUpdate(SettingRow(key: _key, value: jsonEncode(s.toJson())));
}
