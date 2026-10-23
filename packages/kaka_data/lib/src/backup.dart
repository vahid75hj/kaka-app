import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';
import 'package:drift/drift.dart';

import 'database.dart';

class BackupException implements Exception {
  const BackupException(this.code);

  /// `backup.not_kaka`, `backup.wrong_password`, `backup.unsupported`, `backup.corrupt`.
  final String code;
  @override
  String toString() => 'BackupException($code)';
}

/// Argon2id cost. The defaults follow OWASP's minimum (19 MiB, t=2, p=1).
class KdfParams {
  const KdfParams({this.memoryKiB = 19456, this.iterations = 2, this.parallelism = 1});
  final int memoryKiB;
  final int iterations;
  final int parallelism;
}

/// `.kaka` file: `KAKA-BACKUP\n` + JSON header line + XChaCha20-Poly1305
/// ciphertext (‖ 16-byte MAC) of a gzipped JSON snapshot. The header (KDF
/// params, salt, nonce) is authenticated as AAD, so it cannot be tampered with.
abstract final class BackupCodec {
  static const _magic = 'KAKA-BACKUP\n';
  static const formatVersion = 1;
  static final _cipher = Xchacha20.poly1305Aead();

  static Future<Uint8List> encrypt(
    Map<String, Object?> snapshot,
    String password, {
    KdfParams kdf = const KdfParams(),
  }) async {
    final salt = SecretKeyData.random(length: 16).bytes;
    final nonce = _cipher.newNonce();
    final header = utf8.encode(
      jsonEncode({
        'v': formatVersion,
        'kdf': {
          'alg': 'argon2id',
          'm': kdf.memoryKiB,
          't': kdf.iterations,
          'p': kdf.parallelism,
          'salt': base64.encode(salt),
        },
        'aead': 'xchacha20-poly1305',
        'nonce': base64.encode(nonce),
      }),
    );
    final key = await _derive(password, salt, kdf);
    final plain = gzip.encode(utf8.encode(jsonEncode(snapshot)));
    final box = await _cipher.encrypt(plain, secretKey: key, nonce: nonce, aad: header);
    return Uint8List.fromList([...utf8.encode(_magic), ...header, 10, ...box.cipherText, ...box.mac.bytes]);
  }

  static Future<Map<String, Object?>> decrypt(Uint8List file, String password) async {
    final magic = utf8.encode(_magic);
    if (file.length < magic.length || !_startsWith(file, magic)) throw const BackupException('backup.not_kaka');
    final headerEnd = file.indexOf(10, magic.length);
    if (headerEnd < 0) throw const BackupException('backup.corrupt');
    final headerBytes = file.sublist(magic.length, headerEnd);
    final Map<String, Object?> header;
    try {
      header = jsonDecode(utf8.decode(headerBytes)) as Map<String, Object?>;
    } on FormatException {
      throw const BackupException('backup.corrupt');
    }
    if (header['v'] != formatVersion) throw const BackupException('backup.unsupported');
    final k = header['kdf'] as Map<String, Object?>;
    final kdf = KdfParams(memoryKiB: k['m'] as int, iterations: k['t'] as int, parallelism: k['p'] as int);
    if (kdf.memoryKiB > 1 << 20 || kdf.iterations > 20) throw const BackupException('backup.unsupported');
    final body = file.sublist(headerEnd + 1);
    if (body.length < 16) throw const BackupException('backup.corrupt');
    final key = await _derive(password, base64.decode(k['salt'] as String), kdf);
    try {
      final plain = await _cipher.decrypt(
        SecretBox(
          body.sublist(0, body.length - 16),
          nonce: base64.decode(header['nonce'] as String),
          mac: Mac(body.sublist(body.length - 16)),
        ),
        secretKey: key,
        aad: headerBytes,
      );
      return jsonDecode(utf8.decode(gzip.decode(plain))) as Map<String, Object?>;
    } on SecretBoxAuthenticationError {
      throw const BackupException('backup.wrong_password');
    }
  }

  static Future<SecretKey> _derive(String password, List<int> salt, KdfParams p) => Argon2id(
    memory: p.memoryKiB,
    iterations: p.iterations,
    parallelism: p.parallelism,
    hashLength: 32,
  ).deriveKey(secretKey: SecretKey(utf8.encode(password)), nonce: salt);

  static bool _startsWith(List<int> a, List<int> prefix) {
    for (var i = 0; i < prefix.length; i++) {
      if (a[i] != prefix[i]) return false;
    }
    return true;
  }
}

/// Dumps / restores every ledger table as plain rows.
class LedgerSnapshot {
  LedgerSnapshot(this._db);
  final KakaDatabase _db;

  // Parents before children so foreign keys hold while inserting.
  static const _order = ['accounts', 'transactions', 'postings', 'settings', 'drafts', 'sms_links'];

  Future<Map<String, Object?>> export({DateTime? now}) async => {
    'format': 'kaka.snapshot',
    'schema': _db.schemaVersion,
    'exported_at': (now ?? DateTime.now()).toUtc().toIso8601String(),
    'tables': {
      for (final t in _order) t: [for (final r in await _db.customSelect('SELECT * FROM "$t"').get()) r.data],
    },
  };

  /// Replaces everything with [snapshot] atomically; on any error nothing changes.
  Future<void> restore(Map<String, Object?> snapshot) async {
    if (snapshot['format'] != 'kaka.snapshot') throw const BackupException('backup.corrupt');
    final schema = snapshot['schema'] as int? ?? 0;
    if (schema > _db.schemaVersion) throw const BackupException('backup.unsupported');
    final tables = (snapshot['tables'] as Map).cast<String, Object?>();
    final columns = {for (final t in _db.allTables) t.actualTableName: t.$columns.map((c) => c.name).toSet()};
    await _db.transaction(() async {
      for (final t in _order.reversed) {
        await _db.customStatement('DELETE FROM "$t"');
      }
      for (final t in _order) {
        // Older backups lack newer tables/columns; missing ones simply stay empty/null.
        for (final raw in (tables[t] as List? ?? const [])) {
          final row = (raw as Map).cast<String, Object?>();
          final known = columns[t]!;
          if (!row.keys.every(known.contains)) throw const BackupException('backup.corrupt');
          final keys = row.keys.toList();
          await _db.customInsert(
            'INSERT INTO "$t" (${keys.map((k) => '"$k"').join(',')}) VALUES (${List.filled(keys.length, '?').join(',')})',
            variables: [for (final k in keys) Variable(row[k])],
          );
        }
      }
    });
  }
}
