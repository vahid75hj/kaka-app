import 'dart:convert';

enum ParserStatus { verified, needsSamples, community, local }

/// One SMS layout. [pattern] is a regex with named groups:
/// `amount` (required), `balance`, `last4`, `date`, `time`, `direction`.
class SmsTemplate {
  const SmsTemplate({
    required this.id,
    required this.pattern,
    this.debitWords = const [],
    this.creditWords = const [],
    this.unit = 'IRR',
  });

  final String id;
  final String pattern;

  /// Words that mark money leaving / arriving, matched against `direction`
  /// (or the whole text when the template has no `direction` group).
  final List<String> debitWords;
  final List<String> creditWords;

  /// Currency (or display unit) amounts are written in; Iranian banks use rial.
  final String unit;

  factory SmsTemplate.fromJson(Map<String, Object?> j) => SmsTemplate(
    id: j['id'] as String,
    pattern: j['regex'] as String,
    debitWords: [...?(j['debit_words'] as List?)?.cast<String>()],
    creditWords: [...?(j['credit_words'] as List?)?.cast<String>()],
    unit: (j['unit'] as String?) ?? 'IRR',
  );
}

class SmsTest {
  const SmsTest(this.input, this.expect);
  final String input;
  final Map<String, Object?> expect;
}

class BankParser {
  const BankParser({
    required this.bankId,
    required this.nameEn,
    required this.nameFa,
    required this.senders,
    required this.status,
    required this.templates,
    this.tests = const [],
  });

  final String bankId;
  final String nameEn;
  final String nameFa;
  final List<String> senders;
  final ParserStatus status;
  final List<SmsTemplate> templates;
  final List<SmsTest> tests;

  /// Only verified/local parsers run by default; others wait for real samples.
  bool get enabledByDefault => status == ParserStatus.verified || status == ParserStatus.local;

  factory BankParser.fromJson(Map<String, Object?> j) {
    final name = j['name'] as Map<String, Object?>;
    return BankParser(
      bankId: j['bank_id'] as String,
      nameEn: name['en'] as String,
      nameFa: name['fa'] as String,
      senders: [...?(j['senders'] as List?)?.cast<String>()],
      status: switch (j['status']) {
        'verified' => ParserStatus.verified,
        'community' => ParserStatus.community,
        'local' => ParserStatus.local,
        _ => ParserStatus.needsSamples,
      },
      templates: [
        for (final t in (j['templates'] as List? ?? const [])) SmsTemplate.fromJson(t as Map<String, Object?>),
      ],
      tests: [
        for (final t in (j['tests'] as List? ?? const []))
          SmsTest((t as Map)['input'] as String, (t['expect'] as Map).cast<String, Object?>()),
      ],
    );
  }
}

class ParserCatalog {
  const ParserCatalog({required this.schemaVersion, required this.catalogVersion, required this.banks});

  static const supportedSchema = 1;

  final int schemaVersion;
  final String catalogVersion;
  final List<BankParser> banks;

  factory ParserCatalog.parse(String source) {
    final j = jsonDecode(source) as Map<String, Object?>;
    final schema = j['schema_version'] as int;
    if (schema != supportedSchema) throw FormatException('Unsupported sms parser schema $schema');
    return ParserCatalog(
      schemaVersion: schema,
      catalogVersion: j['catalog_version'] as String,
      banks: [for (final b in j['banks'] as List) BankParser.fromJson(b as Map<String, Object?>)],
    );
  }
}
