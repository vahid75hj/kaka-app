import 'dart:convert';

import 'ai_provider.dart';

class ModelDownload {
  const ModelDownload(this.url, this.kind);
  final String url;
  final String kind;
}

/// One entry of `model_catalog/catalog.v1.json`. Adding a model is a JSON
/// change; a new *format* needs one new [LocalModelRuntime] adapter.
class CatalogModel implements ModelManifest {
  const CatalogModel({
    required this.id,
    required this.version,
    required this.nameEn,
    required this.nameFa,
    required this.runtime,
    required this.format,
    required this.sizeBytes,
    required this.minRamMb,
    required this.capabilities,
    required this.downloads,
    required this.sha256,
    required this.tier,
  });

  @override
  final String id;
  final int version;
  final String nameEn;
  final String nameFa;
  @override
  final String runtime;
  @override
  final String format;
  final int sizeBytes;
  final int minRamMb;
  final List<String> capabilities;
  final List<ModelDownload> downloads;
  final String? sha256;
  final String tier;

  factory CatalogModel.fromJson(Map<String, Object?> j) {
    final name = j['name'] as Map<String, Object?>;
    return CatalogModel(
      id: j['id'] as String,
      version: j['version'] as int,
      nameEn: name['en'] as String,
      nameFa: name['fa'] as String,
      runtime: j['runtime'] as String,
      format: j['format'] as String,
      sizeBytes: (j['size_bytes'] as int?) ?? 0,
      minRamMb: (j['min_ram_mb'] as int?) ?? 0,
      capabilities: [...?(j['capabilities'] as List?)?.cast<String>()],
      downloads: [
        for (final d in (j['downloads'] as List? ?? const []))
          ModelDownload((d as Map)['url'] as String, d['kind'] as String? ?? 'primary'),
      ],
      sha256: j['sha256'] as String?,
      tier: (j['tier'] as String?) ?? 'custom',
    );
  }
}

class ModelCatalog {
  const ModelCatalog(this.catalogVersion, this.models);

  static const supportedSchema = 1;
  final String catalogVersion;
  final List<CatalogModel> models;

  factory ModelCatalog.parse(String source) {
    final j = jsonDecode(source) as Map<String, Object?>;
    if (j['schema_version'] != supportedSchema) {
      throw FormatException('Unsupported catalog schema ${j['schema_version']}');
    }
    return ModelCatalog(j['catalog_version'] as String, [
      for (final m in j['models'] as List) CatalogModel.fromJson(m as Map<String, Object?>),
    ]);
  }

  /// Bundled catalog merged with a remote/custom one: newer `version` wins per id.
  ModelCatalog merge(ModelCatalog other) {
    final byId = {for (final m in models) m.id: m};
    for (final m in other.models) {
      final current = byId[m.id];
      if (current == null || m.version > current.version) byId[m.id] = m;
    }
    return ModelCatalog(other.catalogVersion, byId.values.toList());
  }

  /// Models a device with [ramMb] can run, best tier first.
  List<CatalogModel> fitting(int ramMb) =>
      models.where((m) => m.minRamMb <= ramMb).toList()..sort((a, b) => b.minRamMb.compareTo(a.minRamMb));
}
