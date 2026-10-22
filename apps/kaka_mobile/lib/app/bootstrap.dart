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
