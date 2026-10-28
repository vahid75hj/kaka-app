import 'dart:async';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import 'model_catalog.dart';

class ModelDownloadException implements Exception {
  const ModelDownloadException(this.code, [this.detail]);

  /// `checksum_mismatch`, `size_mismatch`, `all_sources_failed`, `cancelled`, `no_checksum`.
  final String code;
  final String? detail;
  @override
  String toString() => 'ModelDownloadException($code${detail == null ? '' : ': $detail'})';
}

/// Downloads a catalog model into [dir] as `<id>.<format>`, verifying sha256.
///
/// - Tries the primary URL, then mirrors.
/// - Resumes a previous `.part` file with an HTTP Range request when the server allows it.
/// - Never keeps an unverified file: on a checksum mismatch the partial file is deleted.
class ModelDownloader {
  ModelDownloader({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;
  var _cancelled = false;

  void cancel() => _cancelled = true;

  Future<File> download(CatalogModel model, Directory dir, {void Function(int received, int total)? onProgress}) async {
    final expected = model.sha256?.toLowerCase();
    if (expected == null || expected.length != 64) throw const ModelDownloadException('no_checksum');
    final target = File('${dir.path}/${model.id}.${model.format}');
    if (await target.exists() && await target.length() == model.sizeBytes) {
      if (await _sha256(target) == expected) return target;
      await target.delete();
    }
    final part = File('${target.path}.part');
    final errors = <String>[];
    for (final url in model.urls) {
      if (_cancelled) throw const ModelDownloadException('cancelled');
      try {
        await _fetch(Uri.parse(url), part, model.sizeBytes, onProgress);
      } on ModelDownloadException {
        rethrow;
      } catch (e) {
        errors.add('$url: $e');
        continue; // next mirror; the .part file is kept for resuming
      }
      final got = await part.length();
      if (model.sizeBytes > 0 && got != model.sizeBytes) {
        await part.delete();
        throw ModelDownloadException('size_mismatch', '$got != ${model.sizeBytes}');
      }
      if (await _sha256(part) != expected) {
        await part.delete();
        throw const ModelDownloadException('checksum_mismatch');
      }
      return part.rename(target.path);
    }
    throw ModelDownloadException('all_sources_failed', errors.join('\n'));
  }

  Future<void> _fetch(Uri url, File part, int total, void Function(int, int)? onProgress) async {
    var have = await part.exists() ? await part.length() : 0;
    if (total > 0 && have > total) {
      await part.delete();
      have = 0;
    }
    final req = http.Request('GET', url);
    if (have > 0) req.headers['Range'] = 'bytes=$have-';
    final res = await _client.send(req);
    if (res.statusCode == 416 && have == total) return; // already complete
    final resumed = res.statusCode == 206;
    if (res.statusCode != 200 && !resumed) {
      await res.stream.drain<void>();
      throw HttpException('HTTP ${res.statusCode}', uri: url);
    }
    if (!resumed) have = 0; // server ignored Range: start over
    final sink = part.openWrite(mode: resumed ? FileMode.append : FileMode.write);
    try {
      var received = have;
      await for (final chunk in res.stream) {
        if (_cancelled) throw const ModelDownloadException('cancelled');
        sink.add(chunk);
        received += chunk.length;
        onProgress?.call(received, total);
      }
    } finally {
      await sink.close();
    }
  }

  static Future<String> _sha256(File f) async => (await sha256.bind(f.openRead()).first).toString();
}
