import 'package:meta/meta.dart';

/// A currency the ledger can store amounts in.
///
/// [storageScale] is the number of decimal digits kept in `amount_minor`
/// (ISO 4217 minor unit by default). It is fixed once the ledger is created;
/// how many decimals are *shown* is a separate user setting.
@immutable
class Currency {
  const Currency({
    required this.code,
    required this.storageScale,
    required this.symbolEn,
    required this.symbolFa,
    required this.nameEn,
    required this.nameFa,
  });

  final String code;
  final int storageScale;
  final String symbolEn;
  final String symbolFa;
  final String nameEn;
  final String nameFa;

  static const irr = Currency(
    code: 'IRR',
    storageScale: 0,
    symbolEn: 'IRR',
    symbolFa: 'ریال',
    nameEn: 'Iranian rial',
    nameFa: 'ریال',
  );
  static const usd = Currency(
    code: 'USD',
    storageScale: 2,
    symbolEn: r'$',
    symbolFa: 'دلار',
    nameEn: 'US dollar',
    nameFa: 'دلار آمریکا',
  );
  static const eur = Currency(
    code: 'EUR',
    storageScale: 2,
    symbolEn: '€',
    symbolFa: 'یورو',
    nameEn: 'Euro',
    nameFa: 'یورو',
  );
  static const aed = Currency(
    code: 'AED',
    storageScale: 2,
    symbolEn: 'AED',
    symbolFa: 'درهم',
    nameEn: 'UAE dirham',
    nameFa: 'درهم امارات',
  );

  /// Built-in currencies. Adding one is a single line here.
  static const builtIn = <Currency>[irr, usd, eur, aed];

  static Currency byCode(String code) => builtIn.firstWhere(
    (c) => c.code == code,
    orElse: () => throw ArgumentError.value(code, 'code', 'Unknown currency'),
  );

  @override
  bool operator ==(Object other) => other is Currency && other.code == code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => code;
}
