import '../money/currency.dart';
import 'instrument.dart';

/// Starting points offered when adding an asset. Plain data: the user can
/// rename anything, and anything not here is created as a custom asset.
class CatalogEntry {
  const CatalogEntry(
    this.id,
    this.assetClass,
    this.nameEn,
    this.nameFa,
    this.unitEn,
    this.unitFa,
    this.qtyScale, {
    this.symbol = '',
    this.quote,
    this.region,
  });
  final String id;
  final AssetClass assetClass;
  final String nameEn, nameFa, unitEn, unitFa;
  final int qtyScale;
  final String symbol;
  final Currency? quote;

  /// ISO country the entry is local to (null = global). Only used to sort suggestions.
  final String? region;

  Instrument toInstrument(String id) => Instrument(
    id: id,
    assetClass: assetClass,
    nameFa: nameFa,
    nameEn: nameEn,
    unitFa: unitFa,
    unitEn: unitEn,
    qtyScale: qtyScale,
    symbol: symbol,
    quoteCurrency: quote,
    catalogId: this.id,
  );
}

abstract final class InstrumentCatalog {
  static const entries = <CatalogEntry>[
    CatalogEntry('gold_24k_g', AssetClass.metal, 'Gold 24k', 'طلای ۲۴ عیار', 'g', 'گرم', 3),
    CatalogEntry('gold_18k_g', AssetClass.metal, 'Gold 18k', 'طلای ۱۸ عیار', 'g', 'گرم', 3),
    CatalogEntry(
      'gold_oz',
      AssetClass.metal,
      'Gold (troy ounce)',
      'طلا (اونس)',
      'oz',
      'اونس',
      4,
      symbol: 'XAU',
      quote: Currency.usd,
    ),
    CatalogEntry('silver_g', AssetClass.metal, 'Silver', 'نقره', 'g', 'گرم', 3),
    CatalogEntry('btc', AssetClass.crypto, 'Bitcoin', 'بیت‌کوین', 'BTC', 'BTC', 8, symbol: 'BTC', quote: Currency.usd),
    CatalogEntry('eth', AssetClass.crypto, 'Ethereum', 'اتریوم', 'ETH', 'ETH', 8, symbol: 'ETH', quote: Currency.usd),
    CatalogEntry('usdt', AssetClass.crypto, 'Tether', 'تتر', 'USDT', 'USDT', 6, symbol: 'USDT', quote: Currency.usd),
    CatalogEntry(
      'usdc',
      AssetClass.crypto,
      'USD Coin',
      'یو‌اس‌دی کوین',
      'USDC',
      'USDC',
      6,
      symbol: 'USDC',
      quote: Currency.usd,
    ),
    CatalogEntry('dai', AssetClass.crypto, 'Dai', 'دای', 'DAI', 'DAI', 6, symbol: 'DAI', quote: Currency.usd),
    CatalogEntry('stock', AssetClass.stock, 'Stock (enter ticker)', 'سهام (نماد را بنویس)', 'shares', 'سهم', 0),
    CatalogEntry('fund', AssetClass.fund, 'Fund / ETF', 'صندوق / ETF', 'units', 'واحد', 0),
    CatalogEntry('real_estate', AssetClass.realEstate, 'Property', 'ملک', 'unit', 'واحد', 0),
    CatalogEntry('vehicle', AssetClass.vehicle, 'Vehicle', 'خودرو', 'unit', 'دستگاه', 0),
    CatalogEntry('coin_emami', AssetClass.coin, 'Emami gold coin', 'سکه امامی', 'coin', 'عدد', 0, region: 'IR'),
    CatalogEntry('coin_bahar', AssetClass.coin, 'Bahar Azadi coin', 'سکه بهار آزادی', 'coin', 'عدد', 0, region: 'IR'),
    CatalogEntry('coin_half', AssetClass.coin, 'Half coin', 'نیم‌سکه', 'coin', 'عدد', 0, region: 'IR'),
    CatalogEntry('coin_quarter', AssetClass.coin, 'Quarter coin', 'ربع‌سکه', 'coin', 'عدد', 0, region: 'IR'),
    CatalogEntry('coin_gerami', AssetClass.coin, 'Gerami coin', 'سکه گرمی', 'coin', 'عدد', 0, region: 'IR'),
  ];
}
