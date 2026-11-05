import 'dart:convert';

import 'package:meta/meta.dart';

/// How a [PriceSource] obtains a number. Only data-driven extractors — never code.
enum PriceSourceKind { httpJson, httpCsv, httpHtml, manual }

/// One pluggable price source from the catalog (or a user import).
@immutable
class PriceSource {
  const PriceSource({
    required this.id,
    required this.kind,
    required this.nameEn,
    required this.nameFa,
    required this.classes,
    this.url = '',
    this.extract = '',
    this.asOfExtract = '',
    this.quoteCurrency = 'USD',
    this.scaleHint,
    this.regionNote = '',
    this.rateLimitS = 60,
    this.enabledByDefault = false,
    this.symbolHints = const {},
    this.cssSelector = '',
    this.regex = '',
    this.attr = '',
    this.headers = const {},
    this.builtin = true,
    this.notes = '',
  });

  final String id;
  final PriceSourceKind kind;
  final String nameEn;
  final String nameFa;

  /// Asset classes this source is meant for (`crypto`, `metal`, `fx`, …).
  final List<String> classes;

  /// URL template. Placeholders: `{sym}`, `{quote}`, `{id}` (CoinGecko id).
  final String url;

  /// JSONPath-lite / CSV column / unused for HTML when [cssSelector]/[regex] set.
  final String extract;

  /// Optional JSONPath-lite for the source's own as-of date (ISO `YYYY-MM-DD`).
  final String asOfExtract;

  final String quoteCurrency;
  final int? scaleHint;
  final String regionNote;
  final int rateLimitS;
  final bool enabledByDefault;

  /// Suggested catalog/instrument symbol → source symbol (e.g. BTC → bitcoin).
  final Map<String, String> symbolHints;

  /// HTML: CSS selector (subset). Optional when [regex] is set.
  final String cssSelector;

  /// HTML: regex with a named group `price` (and optional `as_of`).
  final String regex;

  /// HTML: read this attribute of the matched node instead of text (`data-price`).
  final String attr;

  final Map<String, String> headers;
  final bool builtin;
  final String notes;

  bool get isHtml => kind == PriceSourceKind.httpHtml;
  bool get isHttp => kind == PriceSourceKind.httpJson || kind == PriceSourceKind.httpCsv || kind == PriceSourceKind.httpHtml;

  String name(bool fa) => fa ? nameFa : nameEn;

  String resolveUrl({required String sym, String? quote, String? id}) {
    var u = url;
    u = u.replaceAll('{sym}', sym);
    u = u.replaceAll('{quote}', quote ?? quoteCurrency);
    u = u.replaceAll('{id}', id ?? sym);
    return u;
  }

  String resolveExtract(String sym, {String? quote}) {
    var e = extract;
    e = e.replaceAll('{sym}', sym);
    e = e.replaceAll('{quote}', quote ?? quoteCurrency);
    return e;
  }

  String resolveCss(String sym) => cssSelector.replaceAll('{sym}', sym);

  String resolveRegex(String sym) => regex.replaceAll('{sym}', RegExp.escape(sym));

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': switch (kind) {
      PriceSourceKind.httpJson => 'http_json',
      PriceSourceKind.httpCsv => 'http_csv',
      PriceSourceKind.httpHtml => 'http_html',
      PriceSourceKind.manual => 'manual',
    },
    'name': {'en': nameEn, 'fa': nameFa},
    'classes': classes,
    if (url.isNotEmpty) 'url': url,
    if (extract.isNotEmpty) 'extract': extract,
    if (asOfExtract.isNotEmpty) 'as_of_extract': asOfExtract,
    'quote_currency': quoteCurrency,
    if (scaleHint != null) 'scale_hint': scaleHint,
    if (regionNote.isNotEmpty) 'region_note': regionNote,
    'rate_limit_s': rateLimitS,
    'enabled_by_default': enabledByDefault,
    if (symbolHints.isNotEmpty) 'symbol_hints': symbolHints,
    if (cssSelector.isNotEmpty) 'css': cssSelector,
    if (regex.isNotEmpty) 'regex': regex,
    if (attr.isNotEmpty) 'attr': attr,
    if (headers.isNotEmpty) 'headers': headers,
    if (notes.isNotEmpty) 'notes': notes,
    if (!builtin) 'builtin': false,
  };

  factory PriceSource.fromJson(Map<String, Object?> j, {bool builtin = false}) {
    final kindStr = j['kind'] as String? ?? '';
    final kind = switch (kindStr) {
      'http_json' => PriceSourceKind.httpJson,
      'http_csv' => PriceSourceKind.httpCsv,
      'http_html' || 'html' => PriceSourceKind.httpHtml,
      'manual' => PriceSourceKind.manual,
      _ => throw FormatException('Unknown price source kind: $kindStr'),
    };
    final name = (j['name'] as Map?)?.cast<String, Object?>() ?? const {};
    final hintsRaw = j['symbol_hints'];
    final hints = <String, String>{
      if (hintsRaw is Map)
        for (final e in hintsRaw.entries) '${e.key}': '${e.value}',
    };
    final headersRaw = j['headers'];
    final headers = <String, String>{
      if (headersRaw is Map)
        for (final e in headersRaw.entries) '${e.key}': '${e.value}',
    };
    return PriceSource(
      id: j['id'] as String,
      kind: kind,
      nameEn: (name['en'] as String?) ?? (j['id'] as String),
      nameFa: (name['fa'] as String?) ?? (name['en'] as String?) ?? (j['id'] as String),
      classes: [...?(j['classes'] as List?)?.map((e) => '$e')],
      url: (j['url'] as String?) ?? '',
      extract: (j['extract'] as String?) ?? '',
      asOfExtract: (j['as_of_extract'] as String?) ?? '',
      quoteCurrency: (j['quote_currency'] as String?) ?? 'USD',
      scaleHint: j['scale_hint'] as int?,
      regionNote: (j['region_note'] as String?) ?? '',
      rateLimitS: (j['rate_limit_s'] as int?) ?? 60,
      enabledByDefault: (j['enabled_by_default'] as bool?) ?? false,
      symbolHints: hints,
      cssSelector: (j['css'] as String?) ?? '',
      regex: (j['regex'] as String?) ?? '',
      attr: (j['attr'] as String?) ?? '',
      headers: headers,
      builtin: (j['builtin'] as bool?) ?? builtin,
      notes: (j['notes'] as String?) ?? '',
    );
  }
}

/// Binding of one instrument to a source symbol (and optional priority).
@immutable
class PriceBinding {
  const PriceBinding({
    required this.id,
    required this.instrumentId,
    required this.sourceId,
    required this.symbol,
    this.priority = 100,
    this.enabled = true,
  });

  final String id;
  final String instrumentId;
  final String sourceId;

  /// Symbol / id as the source expects it (`BTC`, `bitcoin`, `geram18`, …).
  final String symbol;
  final int priority;
  final bool enabled;

  Map<String, Object?> toJson() => {
    'id': id,
    'instrument_id': instrumentId,
    'source_id': sourceId,
    'symbol': symbol,
    'priority': priority,
    'enabled': enabled,
  };

  factory PriceBinding.fromJson(Map<String, Object?> j) => PriceBinding(
    id: j['id'] as String,
    instrumentId: j['instrument_id'] as String,
    sourceId: j['source_id'] as String,
    symbol: j['symbol'] as String,
    priority: (j['priority'] as int?) ?? 100,
    enabled: (j['enabled'] as bool?) ?? true,
  );
}

/// Catalog of price sources (bundled + optional user imports).
@immutable
class PriceCatalog {
  const PriceCatalog({
    required this.schemaVersion,
    required this.catalogVersion,
    required this.sources,
    this.note = '',
  });

  static const supportedSchema = 1;

  final int schemaVersion;
  final String catalogVersion;
  final List<PriceSource> sources;
  final String note;

  PriceSource? byId(String id) {
    for (final s in sources) {
      if (s.id == id) return s;
    }
    return null;
  }

  /// User / imported sources override bundled ones with the same id.
  PriceCatalog mergeUser(List<PriceSource> user) {
    final byId = {for (final s in sources) s.id: s};
    for (final u in user) {
      byId[u.id] = u;
    }
    return PriceCatalog(
      schemaVersion: schemaVersion,
      catalogVersion: catalogVersion,
      sources: byId.values.toList(),
      note: note,
    );
  }

  Map<String, Object?> toJson() => {
    'schema_version': schemaVersion,
    'catalog_version': catalogVersion,
    if (note.isNotEmpty) 'note': note,
    'sources': [for (final s in sources) s.toJson()],
  };

  /// Export one source as a shareable file (enough for someone else to import).
  static String exportSource(PriceSource s) => const JsonEncoder.withIndent('  ').convert({
    'schema_version': supportedSchema,
    'catalog_version': 'user-export',
    'sources': [s.copyAsUser().toJson()],
  });

  static String exportSources(Iterable<PriceSource> list) => const JsonEncoder.withIndent('  ').convert({
    'schema_version': supportedSchema,
    'catalog_version': 'user-export',
    'sources': [for (final s in list) s.copyAsUser().toJson()],
  });

  factory PriceCatalog.parse(String source, {bool builtin = false}) {
    final decoded = jsonDecode(source);
    if (decoded is! Map) throw const FormatException('Price catalog must be a JSON object');
    return PriceCatalog.fromJson(decoded.cast<String, Object?>(), builtin: builtin);
  }

  factory PriceCatalog.fromJson(Map<String, Object?> j, {bool builtin = false}) {
    final schema = j['schema_version'];
    if (schema is! int) throw const FormatException('Missing schema_version');
    if (schema != supportedSchema) {
      throw FormatException('Unsupported price catalog schema $schema');
    }
    final raw = j['sources'];
    if (raw is! List) throw const FormatException('Missing sources[]');
    final sources = <PriceSource>[];
    for (final item in raw) {
      if (item is! Map) throw const FormatException('Each source must be an object');
      try {
        sources.add(PriceSource.fromJson(item.cast<String, Object?>(), builtin: builtin));
      } on FormatException catch (e) {
        // Unknown kinds are skipped on import so a newer file cannot crash an older app.
        if (e.message.startsWith('Unknown price source kind:')) continue;
        rethrow;
      }
    }
    return PriceCatalog(
      schemaVersion: schema,
      catalogVersion: (j['catalog_version'] as String?) ?? 'unknown',
      sources: sources,
      note: (j['note'] as String?) ?? '',
    );
  }

  /// Validates without accepting unknown kinds (strict, for the bundled file).
  static PriceCatalog parseStrict(String source, {bool builtin = true}) {
    final decoded = jsonDecode(source);
    if (decoded is! Map) throw const FormatException('Price catalog must be a JSON object');
    final j = decoded.cast<String, Object?>();
    final schema = j['schema_version'];
    if (schema != supportedSchema) throw FormatException('Unsupported price catalog schema $schema');
    final raw = j['sources'];
    if (raw is! List || raw.isEmpty) throw const FormatException('sources[] required');
    final sources = <PriceSource>[
      for (final item in raw)
        if (item is Map) PriceSource.fromJson(item.cast<String, Object?>(), builtin: builtin),
    ];
    for (final s in sources) {
      if (s.id.isEmpty) throw const FormatException('source id required');
      if (s.kind != PriceSourceKind.manual && s.url.isEmpty) {
        throw FormatException('source ${s.id}: url required');
      }
      if (s.kind == PriceSourceKind.httpJson && s.extract.isEmpty) {
        throw FormatException('source ${s.id}: extract required');
      }
      if (s.kind == PriceSourceKind.httpHtml && s.cssSelector.isEmpty && s.regex.isEmpty) {
        throw FormatException('source ${s.id}: css or regex required');
      }
    }
    return PriceCatalog(
      schemaVersion: schema as int,
      catalogVersion: (j['catalog_version'] as String?) ?? 'unknown',
      sources: sources,
      note: (j['note'] as String?) ?? '',
    );
  }
}

extension on PriceSource {
  PriceSource copyAsUser() => PriceSource(
    id: id,
    kind: kind,
    nameEn: nameEn,
    nameFa: nameFa,
    classes: classes,
    url: url,
    extract: extract,
    asOfExtract: asOfExtract,
    quoteCurrency: quoteCurrency,
    scaleHint: scaleHint,
    regionNote: regionNote,
    rateLimitS: rateLimitS,
    enabledByDefault: false,
    symbolHints: symbolHints,
    cssSelector: cssSelector,
    regex: regex,
    attr: attr,
    headers: headers,
    builtin: false,
    notes: notes,
  );
}
