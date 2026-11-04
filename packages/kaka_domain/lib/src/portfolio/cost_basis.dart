import '../money/currency.dart';
import 'event.dart';
import 'instrument.dart';

/// Holdings are keyed by instrument, platform and cost currency.
String holdingKey(String instrumentId, String? platformId, Currency currency) =>
    '$instrumentId|${platformId ?? ''}|${currency.code}';

class Lot {
  Lot(this.openedAt, this.qty, this.cost, this.unknownQty);
  final DateTime openedAt;
  int qty;
  int cost;

  /// Part of [qty] whose cost is unknown (counted as zero cost).
  int unknownQty;
}

/// Derived state of one holding after replaying its events.
class HoldingState {
  HoldingState(this.instrument, this.platformId, this.currency);
  final Instrument instrument;
  final String? platformId;
  final Currency currency;
  final List<Lot> lots = [];

  /// Realized gain (proceeds − cost removed) in minor units of [currency].
  int realized = 0;

  /// Dividends, coupons, staking etc. in minor units of [currency].
  int income = 0;
  int fees = 0;

  /// A sale consumed quantity of unknown cost, or had no proceeds: [realized] is partial.
  bool realizedIncomplete = false;
  DateTime? lastEventAt;

  String get key => holdingKey(instrument.id, platformId, currency);
  int get qty => lots.fold<int>(0, (s, l) => s + l.qty);
  int get cost => lots.fold<int>(0, (s, l) => s + l.cost);
  int get unknownQty => lots.fold<int>(0, (s, l) => s + l.unknownQty);
  bool get costUnknown => unknownQty > 0;

  /// Average cost of one whole unit, as an exact fraction (num, den); null when empty.
  (BigInt, BigInt)? get averageFraction {
    if (qty == 0) return null;
    return (BigInt.from(cost) * BigInt.from(10).pow(instrument.qtyScale), BigInt.from(qty));
  }

  /// Average cost of one whole unit, rounded half-even to minor units.
  int? get averageCost {
    final f = averageFraction;
    return f == null ? null : roundHalfEven(f.$1, f.$2).toInt();
  }
}

/// What one event did, for the ledger and history.
class EventEffect {
  EventEffect(this.event, this.key);
  final PortfolioEvent event;
  final String key;
  int costIn = 0;
  int costOut = 0;
  int? proceeds;
  int gain = 0;
  int incomeAmount = 0;
  bool incomplete = false;
}

class CostBasisResult {
  CostBasisResult(this.holdings, this.effects, this.errors);
  final Map<String, HoldingState> holdings;
  final Map<String, EventEffect> effects;

  /// Event id → error code (e.g. `portfolio.oversell`). Such events are skipped.
  final Map<String, String> errors;
}

BigInt roundHalfEven(BigInt num, BigInt den) {
  if (den.isNegative) return roundHalfEven(-num, -den);
  final neg = num.isNegative;
  final n = num.abs();
  var q = n ~/ den;
  final r = n - q * den;
  final twice = r * BigInt.two;
  if (twice > den || (twice == den && q.isOdd)) q += BigInt.one;
  return neg ? -q : q;
}

int _ratio(int value, int part, int whole) =>
    part == whole ? value : roundHalfEven(BigInt.from(value) * BigInt.from(part), BigInt.from(whole)).toInt();

/// Replays events into holdings with weighted-average (default) or FIFO cost.
///
/// Pure and deterministic: events are ordered by time, then outgoing legs of a
/// transfer before incoming ones, then id (UUIDv7, i.e. creation order).
abstract final class CostBasis {
  static CostBasisResult compute(List<Instrument> instruments, List<PortfolioEvent> events) {
    final byId = {for (final i in instruments) i.id: i};
    final holdings = <String, HoldingState>{};
    final effects = <String, EventEffect>{};
    final errors = <String, String>{};
    final transferred = <String, (int cost, int unknownQty, List<Lot> lots)>{};

    final ordered = events.where((e) => !e.isVoided && byId.containsKey(e.instrumentId)).toList()
      ..sort((a, b) {
        final t = a.at.compareTo(b.at);
        if (t != 0) return t;
        final o = _order(a.kind).compareTo(_order(b.kind));
        return o != 0 ? o : a.id.compareTo(b.id);
      });

    for (final e in ordered) {
      final inst = byId[e.instrumentId]!;
      final key = holdingKey(e.instrumentId, e.platformId, e.currency);
      final h = holdings.putIfAbsent(key, () => HoldingState(inst, e.platformId, e.currency));
      final fx = EventEffect(e, key);
      final fifo = inst.costMethod == CostMethod.fifo;

      void addLot(int qty, int cost, int unknown) {
        if (qty <= 0) return;
        if (!fifo && h.lots.isNotEmpty) {
          final l = h.lots.single;
          l
            ..qty += qty
            ..cost += cost
            ..unknownQty += unknown;
        } else {
          h.lots.add(Lot(e.at, qty, cost, unknown));
        }
        fx.costIn += cost;
      }

      /// Removes [qty]; returns removed lots (for transfers).
      List<Lot>? remove(int qty) {
        if (qty <= 0 || qty > h.qty) return null;
        final out = <Lot>[];
        var left = qty;
        while (left > 0) {
          final l = h.lots.first;
          final take = left < l.qty ? left : l.qty;
          final c = _ratio(l.cost, take, l.qty);
          final u = _ratio(l.unknownQty, take, l.qty);
          out.add(Lot(l.openedAt, take, c, u));
          l
            ..qty -= take
            ..cost -= c
            ..unknownQty -= u;
          if (l.qty == 0) h.lots.removeAt(0);
          left -= take;
        }
        fx.costOut = out.fold<int>(0, (s, l) => s + l.cost);
        if (out.any((l) => l.unknownQty > 0)) fx.incomplete = true;
        return out;
      }

      switch (e.kind) {
        case EventKind.buy:
          if (e.qty <= 0 || (e.gross ?? 0) < 0) {
            errors[e.id] = 'portfolio.bad_event';
            continue;
          }
          addLot(e.qty, e.gross ?? 0, e.gross == null ? e.qty : 0);
          h.fees += e.fee;
        case EventKind.opening || EventKind.giftIn || EventKind.adjustIn:
          final unknown = e.costMode == CostMode.unknown || e.cost == null;
          addLot(e.qty, unknown ? 0 : e.cost!, unknown ? e.qty : 0);
        case EventKind.transferIn:
          final moved = e.groupId == null ? null : transferred.remove(e.groupId);
          if (moved == null) {
            final unknown = e.cost == null;
            addLot(e.qty, e.cost ?? 0, unknown ? e.qty : 0);
          } else if (fifo) {
            // Lot dates travel with the quantity; a network fee in kind shrinks the last lots.
            var shrink = moved.$3.fold<int>(0, (s, l) => s + l.qty) - e.qty;
            for (final l in moved.$3.reversed) {
              final cut = shrink < l.qty ? shrink : l.qty;
              l.qty -= cut;
              shrink -= cut;
            }
            for (final l in moved.$3.where((l) => l.qty > 0)) {
              h.lots.add(l);
            }
            // Cost of quantity lost in a fee stays on the remaining lots.
            final kept = moved.$3.where((l) => l.qty > 0).toList();
            final lostCost = moved.$1 - kept.fold<int>(0, (s, l) => s + l.cost);
            if (kept.isNotEmpty) kept.last.cost += lostCost;
            h.lots.sort((a, b) => a.openedAt.compareTo(b.openedAt));
            fx.costIn = moved.$1;
          } else {
            addLot(e.qty, moved.$1, moved.$2 > e.qty ? e.qty : moved.$2);
          }
        case EventKind.sell || EventKind.giftOut || EventKind.transferOut || EventKind.adjustOut:
          final out = remove(e.qty);
          if (out == null) {
            errors[e.id] = 'portfolio.oversell';
            continue;
          }
          if (e.kind == EventKind.sell) {
            h.fees += e.fee;
            if (e.gross == null) {
              fx.incomplete = true;
              h.realizedIncomplete = true;
            } else {
              fx.proceeds = e.gross;
              fx.gain = e.gross! - fx.costOut;
              h.realized += fx.gain;
              if (fx.incomplete) h.realizedIncomplete = true;
            }
          }
          if (e.kind == EventKind.transferOut && e.groupId != null) {
            transferred[e.groupId!] = (fx.costOut, out.fold<int>(0, (s, l) => s + l.unknownQty), out);
          }
        case EventKind.income:
          if (e.qty > 0) {
            // Staking / airdrop: income at fair value, which becomes the cost.
            final value = e.cost ?? e.gross;
            addLot(e.qty, value ?? 0, value == null ? e.qty : 0);
            fx.incomeAmount = value ?? 0;
          } else {
            fx.incomeAmount = e.gross ?? 0;
          }
          h.income += fx.incomeAmount;
        case EventKind.split:
          final n = e.splitNum ?? 0, d = e.splitDen ?? 0;
          if (n <= 0 || d <= 0) {
            errors[e.id] = 'portfolio.bad_event';
            continue;
          }
          for (final l in h.lots) {
            final q = (BigInt.from(l.qty) * BigInt.from(n) ~/ BigInt.from(d)).toInt();
            l.unknownQty = l.qty == 0 ? 0 : _ratio(l.unknownQty, q, l.qty).clamp(0, q).toInt();
            l.qty = q;
          }
          h.lots.removeWhere((l) => l.qty == 0 && l.cost == 0);
      }
      h.lastEventAt = e.at;
      effects[e.id] = fx;
    }
    return CostBasisResult(holdings, effects, errors);
  }

  static int _order(EventKind k) => switch (k) {
    EventKind.transferOut => 0,
    EventKind.transferIn => 2,
    _ => 1,
  };
}
