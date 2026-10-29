import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kaka_data/kaka_data.dart';
import 'package:path_provider/path_provider.dart';

/// Opens the encrypted ledger. The random 256-bit key lives in the Android
/// Keystore-backed secure storage and never leaves the device.
Future<KakaDatabase> openLedger() async {
  const storage = FlutterSecureStorage();
  const keyName = 'kaka.db.key.v1';
  var key = await storage.read(key: keyName);
  if (key == null) {
    final rnd = Random.secure();
    key = base64Url.encode(List<int>.generate(32, (_) => rnd.nextInt(256)));
    await storage.write(key: keyName, value: key);
  }
  final dir = await getApplicationSupportDirectory();
  return KakaDatabase.open(File('${dir.path}/kaka.ledger'), key: key);
}

/// Last resort from the startup error screen: moves an unreadable ledger
/// aside (never deletes it) and forgets its key, so Kaka can start fresh.
Future<String?> moveLedgerAside() async {
  final dir = await getApplicationSupportDirectory();
  final f = File('${dir.path}/kaka.ledger');
  String? moved;
  if (f.existsSync()) {
    moved = '${f.path}.unreadable-${DateTime.now().millisecondsSinceEpoch}';
    f.renameSync(moved);
  }
  for (final side in ['-wal', '-shm', '-journal']) {
    final s = File('${f.path}$side');
    if (s.existsSync()) s.deleteSync();
  }
  try {
    await const FlutterSecureStorage().delete(key: 'kaka.db.key.v1');
  } catch (_) {
    try {
      await const FlutterSecureStorage().deleteAll();
    } catch (_) {}
  }
  return moved;
}
