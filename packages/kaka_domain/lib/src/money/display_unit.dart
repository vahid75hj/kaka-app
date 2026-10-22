import 'package:meta/meta.dart';

import 'currency.dart';

/// How a stored currency is presented to the user.
///
/// Toman is not a currency in Kaka: everything is stored in rial and
/// toman is a display unit that divides by 10. This keeps SMS imports
/// (usually in rial) unambiguous and makes a future redenomination a
/// one-line change.
@immutable
class DisplayUnit {
  const DisplayUnit({
    required this.code,
    required this.currency,
    required this.factorPow10,
    required this.symbolEn,
    required this.symbolFa,
    required this.nameEn,
    required this.nameFa,
  });

  final String code;
  final Currency currency;

  /// Displayed value = stored value / 10^factorPow10.
  final int factorPow10;
  final String symbolEn;
  final String symbolFa;
  final String nameEn;
  final String nameFa;

  /// The identity unit of a currency.
  factory DisplayUnit.of(Currency c) => DisplayUnit(
    code: c.code,
    currency: c,
    factorPow10: 0,
    symbolEn: c.symbolEn,
    symbolFa: c.symbolFa,
    nameEn: c.nameEn,
    nameFa: c.nameFa,
  );

  static const irt = DisplayUnit(
    code: 'IRT',
    currency: Currency.irr,
    factorPow10: 1,
    symbolEn: 'Toman',
    symbolFa: 'تومان',
    nameEn: 'Toman (display unit of rial)',
    nameFa: 'تومان',
  );

  /// Every unit a user can pick as a base: IRR, IRT, USD, EUR, AED.
  static final List<DisplayUnit> choices = [
    DisplayUnit.of(Currency.irr),
    irt,
    for (final c in Currency.builtIn.skip(1)) DisplayUnit.of(c),
  ];

  static DisplayUnit byCode(String code) => code == irt.code ? irt : DisplayUnit.of(Currency.byCode(code));

  /// Decimal digits the unit naturally has (rial 0, toman 1, dollar 2).
  int get naturalDecimals => currency.storageScale + factorPow10;

  /// Sensible default number of decimals to show.
  int get defaultDisplayDecimals => currency.code == 'IRR' ? 0 : currency.storageScale;

  @override
  bool operator ==(Object other) => other is DisplayUnit && other.code == code;

  @override
  int get hashCode => code.hashCode;
}
