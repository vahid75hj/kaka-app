import 'package:meta/meta.dart';

import '../money/money.dart';

enum AssetUnit { gram, coin }

/// Gold, coins and similar holdings. Quantities are integers in
/// thousandths (milli-gram / milli-coin) so 2.5 g is 2500.
@immutable
class AssetType {
  const AssetType({
    required this.id,
    required this.nameFa,
    required this.nameEn,
    required this.unit,
    this.archived = false,
  });
  final String id;
  final String nameFa;
  final String nameEn;
  final AssetUnit unit;
  final bool archived;

  static const builtIn = [
    AssetType(id: 'gold18', nameFa: 'طلای ۱۸ عیار (گرم)', nameEn: 'Gold 18k (gram)', unit: AssetUnit.gram),
    AssetType(id: 'gold24', nameFa: 'طلای ۲۴ عیار (گرم)', nameEn: 'Gold 24k (gram)', unit: AssetUnit.gram),
    AssetType(id: 'coin_emami', nameFa: 'سکه امامی', nameEn: 'Emami coin', unit: AssetUnit.coin),
    AssetType(id: 'coin_bahar', nameFa: 'سکه بهار آزادی', nameEn: 'Bahar Azadi coin', unit: AssetUnit.coin),
    AssetType(id: 'coin_half', nameFa: 'نیم‌سکه', nameEn: 'Half coin', unit: AssetUnit.coin),
    AssetType(id: 'coin_quarter', nameFa: 'ربع‌سکه', nameEn: 'Quarter coin', unit: AssetUnit.coin),
    AssetType(id: 'coin_gram', nameFa: 'سکه گرمی', nameEn: 'Gerami coin', unit: AssetUnit.coin),
  ];
}

/// A buy (+) or sell (−) of [quantityMilli]; [total] is what was paid/received (optional).
@immutable
class AssetMovement {
  const AssetMovement({
    required this.id,
    required this.assetTypeId,
    required this.quantityMilli,
    required this.date,
    this.total,
    this.note = '',
    this.voidedAt,
  });
  final String id;
  final String assetTypeId;
  final int quantityMilli;
  final DateTime date;
  final Money? total;
  final String note;
  final DateTime? voidedAt;
}

/// Price of one unit (gram or coin) on a day.
@immutable
class AssetPrice {
  const AssetPrice({required this.id, required this.assetTypeId, required this.date, required this.price});
  final String id;
  final String assetTypeId;
  final DateTime date;
  final Money price;
}

abstract interface class AssetRepository {
  Stream<List<AssetType>> watchTypes();
  Future<void> upsertType(AssetType t);
  Stream<List<AssetMovement>> watchMovements();
  Future<void> insertMovement(AssetMovement m);
  Future<void> voidMovement(String id, DateTime at);
  Stream<List<AssetPrice>> watchPrices();
  Future<void> upsertPrice(AssetPrice p);
}

class AssetHolding {
  const AssetHolding(this.type, this.quantityMilli, this.price);
  final AssetType type;
  final int quantityMilli;

  /// Latest known unit price, or `null`.
  final AssetPrice? price;

  /// Quantity × unit price, rounded to minor units.
  Money? get value {
    final p = price?.price;
    if (p == null) return null;
    final v = BigInt.from(p.minor) * BigInt.from(quantityMilli);
    return Money(((v + BigInt.from(500)) ~/ BigInt.from(1000)).toInt(), p.currency);
  }
}

abstract final class AssetMath {
  static List<AssetHolding> holdings(
    List<AssetType> types,
    List<AssetMovement> movements,
    List<AssetPrice> prices, {
    bool includeEmpty = false,
  }) {
    final qty = <String, int>{};
    for (final m in movements.where((m) => m.voidedAt == null)) {
      qty.update(m.assetTypeId, (v) => v + m.quantityMilli, ifAbsent: () => m.quantityMilli);
    }
    final latest = <String, AssetPrice>{};
    for (final p in prices) {
      final cur = latest[p.assetTypeId];
      if (cur == null || p.date.isAfter(cur.date)) latest[p.assetTypeId] = p;
    }
    return [
      for (final t in types)
        if (includeEmpty || (qty[t.id] ?? 0) != 0) AssetHolding(t, qty[t.id] ?? 0, latest[t.id]),
    ];
  }

  /// Parses "2.5" / "۲٫۵" into thousandths.
  static int parseQuantity(String raw) {
    final s = raw.replaceAll('٫', '.').replaceAll(RegExp(r'[,٬\s]'), '');
    final latin = s.split('').map((c) {
      final i = '۰۱۲۳۴۵۶۷۸۹'.indexOf(c);
      final j = '٠١٢٣٤٥٦٧٨٩'.indexOf(c);
      return i >= 0 ? '$i' : (j >= 0 ? '$j' : c);
    }).join();
    final m = RegExp(r'^(\d+)(?:\.(\d{1,3}))?$').firstMatch(latin);
    if (m == null) throw const FormatException('quantity');
    return int.parse(m[1]!) * 1000 + int.parse((m[2] ?? '').padRight(3, '0'));
  }

  static String formatQuantity(int milli) {
    final whole = milli.abs() ~/ 1000;
    final frac = (milli.abs() % 1000).toString().padLeft(3, '0').replaceFirst(RegExp(r'0+$'), '');
    return '${milli < 0 ? '-' : ''}$whole${frac.isEmpty ? '' : '.$frac'}';
  }
}
