import 'package:meta/meta.dart';

import '../failures.dart';
import '../money/currency.dart';

/// Broad kind of asset. Only drives icons, defaults and grouping; the cost
/// and ledger logic is the same for every class.
enum AssetClass { metal, coin, crypto, stock, fund, bond, realEstate, vehicle, collectible, other }

enum CostMethod { average, fifo }

/// Anything the user can hold a quantity of: a gram of gold, a coin, a
/// token, a share, a flat. Quantities are integers with [qtyScale] decimals.
@immutable
class Instrument {
  const Instrument({
    required this.id,
    required this.assetClass,
    required this.nameFa,
    required this.nameEn,
    required this.unitFa,
    required this.unitEn,
    required this.qtyScale,
    this.symbol = '',
    this.quoteCurrency,
    this.costMethod = CostMethod.average,
    this.archived = false,
    this.catalogId,
  });

  final String id;
  final AssetClass assetClass;
  final String nameFa;
  final String nameEn;
  final String unitFa;
  final String unitEn;

  /// Decimals kept for quantities (0..12): 8 for most tokens, 3 for grams, 0 for shares.
  final int qtyScale;
  final String symbol;

  /// Currency its unit price is usually entered in (null = base currency).
  final Currency? quoteCurrency;
  final CostMethod costMethod;
  final bool archived;

  /// Catalog entry it was created from, if any.
  final String? catalogId;

  String name(bool fa) => fa ? (nameFa.isEmpty ? nameEn : nameFa) : (nameEn.isEmpty ? nameFa : nameEn);
  String unit(bool fa) => fa ? (unitFa.isEmpty ? unitEn : unitFa) : (unitEn.isEmpty ? unitFa : unitEn);

  Instrument copyWith({
    String? nameFa,
    String? nameEn,
    String? unitFa,
    String? unitEn,
    String? symbol,
    AssetClass? assetClass,
    Currency? Function()? quoteCurrency,
    CostMethod? costMethod,
    bool? archived,
  }) => Instrument(
    id: id,
    assetClass: assetClass ?? this.assetClass,
    nameFa: nameFa ?? this.nameFa,
    nameEn: nameEn ?? this.nameEn,
    unitFa: unitFa ?? this.unitFa,
    unitEn: unitEn ?? this.unitEn,
    qtyScale: qtyScale,
    symbol: symbol ?? this.symbol,
    quoteCurrency: quoteCurrency != null ? quoteCurrency() : this.quoteCurrency,
    costMethod: costMethod ?? this.costMethod,
    archived: archived ?? this.archived,
    catalogId: catalogId,
  );

  static void validate(Instrument i) {
    if (i.nameFa.trim().isEmpty && i.nameEn.trim().isEmpty) throw const DomainException('instrument.name_required');
    if (i.qtyScale < 0 || i.qtyScale > 12) throw const DomainException('instrument.bad_scale');
  }
}

/// Where something is kept: an exchange, a broker, a wallet, a safe, a person.
enum PlatformKind { exchange, broker, wallet, app, bank, home, person, other }

@immutable
class AssetPlatform {
  const AssetPlatform({required this.id, required this.name, required this.kind, this.archived = false});
  final String id;
  final String name;
  final PlatformKind kind;
  final bool archived;
}

/// Exact quantities: integers with a per-instrument number of decimals.
abstract final class Qty {
  /// Parses "2.5", "۲٫۵", "0,001" (thousands separators dropped) into minor units.
  static int parse(String raw, int scale) {
    final latin = raw
        .trim()
        .split('')
        .map((c) {
          final i = '۰۱۲۳۴۵۶۷۸۹'.indexOf(c);
          final j = '٠١٢٣٤٥٦٧٨٩'.indexOf(c);
          return i >= 0 ? '$i' : (j >= 0 ? '$j' : c);
        })
        .join()
        .replaceAll('٫', '.')
        .replaceAll(RegExp(r'[,٬\s\u200e\u200f]'), '');
    final m = RegExp(r'^(\d+)(?:\.(\d*))?$').firstMatch(latin);
    if (m == null) throw const FormatException('quantity');
    final frac = m[2] ?? '';
    if (frac.length > scale) throw const FormatException('quantity.too_precise');
    final whole =
        BigInt.parse(m[1]!) * BigInt.from(10).pow(scale) +
        BigInt.parse(frac.padRight(scale, '0').isEmpty ? '0' : frac.padRight(scale, '0'));
    if (whole > BigInt.from(0x7FFFFFFFFFFFFFFF)) throw const FormatException('quantity.too_large');
    return whole.toInt();
  }

  /// Plain decimal string without trailing zeros: 2500 @3 → "2.5".
  static String format(int minor, int scale) {
    final neg = minor < 0;
    final s = minor.abs().toString().padLeft(scale + 1, '0');
    final whole = s.substring(0, s.length - scale);
    final frac = scale == 0 ? '' : s.substring(s.length - scale).replaceFirst(RegExp(r'0+$'), '');
    return '${neg ? '-' : ''}$whole${frac.isEmpty ? '' : '.$frac'}';
  }
}
