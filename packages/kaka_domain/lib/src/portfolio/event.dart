import 'instrument.dart';
import 'package:meta/meta.dart';

import '../money/currency.dart';
import '../money/money.dart';

/// What happened to a holding. Quantities in events are always positive;
/// the kind gives the direction.
enum EventKind {
  /// Bought with money (cash account optional). Cost = [PortfolioEvent.gross], fees included.
  buy,

  /// Sold for money. Proceeds = gross, net of fees.
  sell,

  /// Already owned before using Kaka. Cost per [CostMode].
  opening,

  /// Received as a gift or inheritance. Cost per [CostMode] (usually fair value).
  giftIn,

  /// Given away. Cost leaves without a gain or loss.
  giftOut,

  /// Dividend, coupon, rent, interest (money, no quantity) or staking/airdrop
  /// (quantity, valued at fair value as income).
  income,

  /// Moved between platforms; cost and lot dates travel with it.
  transferOut,
  transferIn,

  /// Quantity × num/den, total cost unchanged (split, bonus shares).
  split,

  /// Correction of a lost/found quantity.
  adjustIn,
  adjustOut,
}

/// How the cost of an incoming quantity is known.
enum CostMode { paid, fairValue, custom, unknown }

extension EventKindX on EventKind {
  bool get addsQuantity => switch (this) {
    EventKind.buy || EventKind.opening || EventKind.giftIn || EventKind.transferIn || EventKind.adjustIn => true,
    _ => false,
  };
  bool get removesQuantity => switch (this) {
    EventKind.sell || EventKind.giftOut || EventKind.transferOut || EventKind.adjustOut => true,
    _ => false,
  };
}

/// Append-only source of truth for holdings. Fixed by voiding, never edited
/// (except the ledger link, which Kaka keeps in sync).
@immutable
class PortfolioEvent {
  const PortfolioEvent({
    required this.id,
    required this.instrumentId,
    required this.kind,
    required this.at,
    required this.currency,
    this.platformId,
    this.qty = 0,
    this.gross,
    this.fee = 0,
    this.costMode = CostMode.paid,
    this.cost,
    this.splitNum,
    this.splitDen,
    this.groupId,
    this.cashAccountId,
    this.txnId,
    this.txnSig,
    this.source = 'manual',
    this.note = '',
    this.voidedAt,
    this.createdAt,
  });

  final String id;
  final String instrumentId;
  final String? platformId;
  final EventKind kind;
  final DateTime at;

  /// Currency of [gross]/[cost]/[fee]: the holding's cost currency.
  final Currency currency;
  final int qty;

  /// Paid (buy) / received (sell, cash income), minor units of [currency].
  final int? gross;

  /// Informational: already inside [gross] (capitalised on buys, netted on sells).
  final int fee;
  final CostMode costMode;

  /// Cost of an incoming non-buy quantity (fair value or custom); null = unknown.
  final int? cost;
  final int? splitNum;
  final int? splitDen;

  /// Links the legs of a transfer or swap.
  final String? groupId;
  final String? cashAccountId;
  final String? txnId;

  /// Signature of the postings [txnId] holds, to detect when it must be re-posted.
  final String? txnSig;
  final String source;
  final String note;
  final DateTime? voidedAt;
  final DateTime? createdAt;

  bool get isVoided => voidedAt != null;
  Money? get grossMoney => gross == null ? null : Money(gross!, currency);

  PortfolioEvent copyWith({String? Function()? txnId, String? Function()? txnSig, DateTime? Function()? voidedAt}) =>
      PortfolioEvent(
        id: id,
        instrumentId: instrumentId,
        platformId: platformId,
        kind: kind,
        at: at,
        currency: currency,
        qty: qty,
        gross: gross,
        fee: fee,
        costMode: costMode,
        cost: cost,
        splitNum: splitNum,
        splitDen: splitDen,
        groupId: groupId,
        cashAccountId: cashAccountId,
        txnId: txnId != null ? txnId() : this.txnId,
        txnSig: txnSig != null ? txnSig() : this.txnSig,
        source: source,
        note: note,
        voidedAt: voidedAt != null ? voidedAt() : this.voidedAt,
        createdAt: createdAt,
      );
}

/// Price of one whole unit of an instrument.
@immutable
class PriceQuote {
  const PriceQuote({
    required this.id,
    required this.instrumentId,
    required this.price,
    required this.asOf,
    this.source = 'manual',
  });
  final String id;
  final String instrumentId;
  final Money price;
  final DateTime asOf;
  final String source;
}

/// One point of the net-worth history, logged when prices change.
@immutable
class ValuationSnapshot {
  const ValuationSnapshot({
    required this.id,
    required this.at,
    required this.base,
    required this.netWorth,
    required this.assetsValue,
    required this.unrealized,
  });
  final String id;
  final DateTime at;
  final Currency base;
  final int netWorth;
  final int assetsValue;
  final int unrealized;
}

abstract interface class PortfolioRepository {
  Stream<List<Instrument>> watchInstruments();
  Future<List<Instrument>> instruments();
  Future<void> upsertInstrument(Instrument i);

  Stream<List<AssetPlatform>> watchPlatforms();
  Future<void> upsertPlatform(AssetPlatform p);

  /// All events, voided included, oldest first.
  Stream<List<PortfolioEvent>> watchEvents();
  Future<List<PortfolioEvent>> events();
  Future<void> upsertEvent(PortfolioEvent e);

  Stream<List<PriceQuote>> watchPrices();
  Future<void> upsertPrice(PriceQuote p);
  Future<void> deletePrice(String id);

  Stream<List<ValuationSnapshot>> watchSnapshots();
  Future<void> upsertSnapshot(ValuationSnapshot s);
}
