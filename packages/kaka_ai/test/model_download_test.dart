import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:kaka_ai/kaka_ai.dart';
import 'package:test/test.dart';

void main() {
  final body = Uint8List.fromList(List.generate(300000, (i) => (i * 7) % 256));
  final digest = sha256.convert(body).toString();
  late HttpServer server;
  late Directory dir;
  final ranges = <String?>[];

  setUp(() async {
    dir = Directory.systemTemp.createTempSync('kaka_dl');
    ranges.clear();
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((req) async {
      final path = req.uri.path;
      ranges.add(req.headers.value('range'));
      if (path == '/down') {
        req.response.statusCode = 503;
        return req.response.close();
      }
      final range = req.headers.value('range');
      if (range != null && path == '/ok') {
        final start = int.parse(RegExp(r'bytes=(\d+)-').firstMatch(range)![1]!);
        req.response.statusCode = 206;
        req.response.add(body.sublist(start));
      } else {
        req.response.add(path == '/evil' ? (Uint8List.fromList(body)..[5] ^= 1) : body);
      }
      await req.response.close();
    });
  });
  tearDown(() async {
    await server.close(force: true);
    dir.deleteSync(recursive: true);
  });

  CatalogModel model(List<String> paths, {String? sha}) => CatalogModel.fromJson({
    'id': 'm',
    'version': 1,
    'name': {'en': 'M', 'fa': 'M'},
    'runtime': 'litert-lm',
    'format': 'litertlm',
    'size_bytes': body.length,
    'sha256': sha ?? digest,
    'downloads': [
      for (final (i, p) in paths.indexed)
        {'kind': i == 0 ? 'primary' : 'mirror', 'url': 'http://127.0.0.1:${server.port}$p'},
    ],
  });

  test('falls back to a mirror and verifies sha256', () async {
    final f = await ModelDownloader().download(model(['/down', '/ok']), dir);
    expect(f.path, endsWith('m.litertlm'));
    expect(sha256.convert(f.readAsBytesSync()).toString(), digest);
  });

  test('resumes a partial download with Range', () async {
    File('${dir.path}/m.litertlm.part').writeAsBytesSync(body.sublist(0, 100000));
    var last = 0;
    final f = await ModelDownloader().download(model(['/ok']), dir, onProgress: (r, _) => last = r);
    expect(ranges.single, 'bytes=100000-');
    expect(last, body.length);
    expect(f.lengthSync(), body.length);
  });

  test('a corrupted file is rejected and not kept', () async {
    await expectLater(
      ModelDownloader().download(model(['/evil']), dir),
      throwsA(isA<ModelDownloadException>().having((e) => e.code, 'code', 'checksum_mismatch')),
    );
    expect(dir.listSync(), isEmpty);
  });

  test('refuses models without a checksum; reports when every source fails', () async {
    await expectLater(
      ModelDownloader().download(model(['/ok'], sha: ''), dir),
      throwsA(isA<ModelDownloadException>().having((e) => e.code, 'code', 'no_checksum')),
    );
    await expectLater(
      ModelDownloader().download(model(['/down']), dir),
      throwsA(isA<ModelDownloadException>().having((e) => e.code, 'code', 'all_sources_failed')),
    );
  });

  test('bundled catalog parses; fit check covers RAM, Android version, ABI and disk', () {
    final catalog = ModelCatalog.parse(File('../../model_catalog/catalog.v1.json').readAsStringSync());
    expect(catalog.models, hasLength(3));
    for (final m in catalog.models) {
      expect(m.sha256, matches(RegExp(r'^[0-9a-f]{64}$')));
      expect(m.urls.first, startsWith('https://huggingface.co/'));
      expect(m.sizeBytes, greaterThan(100 * 1024 * 1024));
    }
    final small = catalog.models.firstWhere((m) => m.id == 'qwen3-0.6b-int4');
    const phone = DeviceProfile(ramMb: 4096, androidSdk: 33, abis: ['arm64-v8a'], freeBytes: 8 << 30);
    expect(ModelFit.check(small, phone), isEmpty);
    expect(
      ModelFit.check(
        small,
        const DeviceProfile(ramMb: 2048, androidSdk: 28, abis: ['armeabi-v7a'], freeBytes: 1 << 20),
      ),
      [FitProblem.ram, FitProblem.androidVersion, FitProblem.abi, FitProblem.disk],
    );
    expect(catalog.fittingDevice(phone).map((m) => m.id), ['qwen3-0.6b-mixed-int4', 'qwen3-0.6b-int4']);
    expect(catalog.models.map((m) => m.license).toSet(), {'Apache-2.0'});
  });
}
