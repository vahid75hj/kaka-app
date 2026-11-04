import '../failures.dart';
import '../ids.dart';
import '../ledger/account.dart';
import '../ledger/ledger_service.dart';
import '../ledger/ledger_transaction.dart';
import '../ledger/posting.dart';
import '../ledger/repositories.dart';
import '../money/currency.dart';
import '../money/money.dart';
import 'cost_basis.dart';
import 'event.dart';
import 'instrument.dart';

/// System account names used by the portfolio (the app localizes them).
abstract final class PortfolioAccounts {
  static String holdings(String instrumentId, Currency c) => 'Holdings:$instrumentId:${c.code}';
  static String realizedGain(Currency c) => 'Realized gain ${c.code}';
  static String investmentIncome(Currency c) => 'Investment income ${c.code}';
  static String clearing(Currency c) => 'Portfolio ${c.code}';
  static bool isHoldings(Account a) => a.isSystem && a.name.startsWith('Holdings:');
}

/// Use cases for holdings: trades, other events, prices. Every change replays
/// the events and re-posts any ledger transaction whose amounts changed
/// (the old one is voided, never deleted).
class PortfolioService {
  PortfolioService(this._repo, this._ledger, this._accounts, {DateTime Function()? clock, this.label})
    : _now = clock ?? DateTime.now;

  /// Instrument name used in ledger notes (the app passes the user's language).
  final String Function(Instrument)? label;
  final PortfolioRepository _repo;
  final LedgerService _ledger;
  final AccountRepository _accounts;
  final DateTime Function() _now;

  Future<Instrument> saveInstrument(Instrument i) async {
    Instrument.validate(i);
    await _repo.upsertInstrument(i);
    return i;
  }

  Future<AssetPlatform> savePlatform({
    String? id,
    required String name,
    required PlatformKind kind,
    bool archived = false,
  }) async {
    if (name.trim().isEmpty) throw const DomainException('platform.name_required');
    final p = AssetPlatform(id: id ?? Ids.next(), name: name.trim(), kind: kind, archived: archived);
    await _repo.upsertPlatform(p);
    return p;
  }

  /// Records one event (buy, sell, opening, income, split, gift, adjust).
  /// With [cash], money moves in that account; it must be in the event currency.
  Future<PortfolioEvent> record({
    required String instrumentId,
    required EventKind kind,
    required Currency currency,
    int qty = 0,
    int? gross,
    int fee = 0,
    CostMode costMode = CostMode.paid,
    int? cost,
    int? splitNum,
    int? splitDen,
    String? platformId,
    Account? cash,
    DateTime? at,
    String note = '',
    String source = 'manual',
  }) async {
    final e = PortfolioEvent(
      id: Ids.next(),
      instrumentId: instrumentId,
      platformId: platformId,
      kind: kind,
      at: at ?? _now(),
      currency: currency,
      qty: qty,
      gross: gross,
      fee: fee,
      costMode: costMode,
      cost: cost,
      splitNum: splitNum,
      splitDen: splitDen,
      cashAccountId: cash?.id,
      source: source,
      note: note.trim(),
      createdAt: _now(),
    );
    _check(e, cash);
    await _commit([e]);
    return e;
  }

  /// Moves quantity between platforms; [fee] is quantity lost on the way (network fee in kind).
  Future<void> transfer({
    required String instrumentId,
    required Currency currency,
    required int qty,
    String? fromPlatformId,
    String? toPlatformId,
    int feeQty = 0,
    DateTime? at,
    String note = '',
  }) async {
    if (qty <= 0 || feeQty < 0 || feeQty >= qty) throw const DomainException('portfolio.bad_quantity');
    if (fromPlatformId == toPlatformId) throw const DomainException('portfolio.same_platform');
    final group = Ids.next();
    final when = at ?? _now();
    PortfolioEvent leg(EventKind k, String? platform, int q) => PortfolioEvent(
      id: Ids.next(),
      instrumentId: instrumentId,
      platformId: platform,
      kind: k,
      at: when,
      currency: currency,
      qty: q,
      groupId: group,
      note: note.trim(),
      createdAt: _now(),
    );
    await _commit([
      leg(EventKind.transferOut, fromPlatformId, qty),
      leg(EventKind.transferIn, toPlatformId, qty - feeQty),
    ]);
  }

  /// Asset-for-asset exchange (or a peer purchase paid in kind): the given
  /// asset is sold at [fairValue] (gain realized) and the received one costs [fairValue].
  Future<void> swap({
    required String giveInstrumentId,
    required int giveQty,
    String? givePlatformId,
    required String getInstrumentId,
    required int getQty,
    String? getPlatformId,
    required Money fairValue,
    DateTime? at,
    String note = '',
  }) async {
    if (giveQty <= 0 || getQty <= 0) throw const DomainException('portfolio.bad_quantity');
    if (fairValue.isNegative) throw const DomainException('amount.not_positive');
    final group = Ids.next();
    final when = at ?? _now();
    PortfolioEvent leg(EventKind k, String inst, String? platform, int q) => PortfolioEvent(
      id: Ids.next(),
      instrumentId: inst,
      platformId: platform,
      kind: k,
      at: when,
      currency: fairValue.currency,
      qty: q,
      gross: fairValue.minor,
      groupId: group,
      note: note.trim(),
      createdAt: _now(),
    );
    await _commit([
      leg(EventKind.sell, giveInstrumentId, givePlatformId, giveQty),
      leg(EventKind.buy, getInstrumentId, getPlatformId, getQty),
    ]);
  }

  /// Voids [e] and the other legs of its group, with their ledger transactions.
  /// Refused when a later sale would then sell more than was held.
  Future<void> voidEvent(PortfolioEvent e) async {
    final all = await _repo.events();
    final targets = all.where((x) => !x.isVoided && (x.id == e.id || (e.groupId != null && x.groupId == e.groupId)));
    final ids = targets.map((t) => t.id).toSet();
    final after = [for (final x in all) ids.contains(x.id) ? x.copyWith(voidedAt: () => _now()) : x];
    final result = CostBasis.compute(await _repo.instruments(), after);
    if (result.errors.isNotEmpty) throw const DomainException('portfolio.void_breaks_later');
    for (final t in targets) {
      if (t.txnId != null) await _ledger.voidById(t.txnId!);
      await _repo.upsertEvent(t.copyWith(voidedAt: () => _now()));
    }
    await reconcile();
  }

  Future<void> setPrice(String instrumentId, Money price, DateTime day, {String source = 'manual'}) async {
    if (price.isNegative || price.isZero) throw const DomainException('amount.not_positive');
    final d = DateTime(day.year, day.month, day.day);
    await _repo.upsertPrice(
      PriceQuote(
        id: '$instrumentId|${price.currency.code}|${d.toIso8601String().substring(0, 10)}|$source',
        instrumentId: instrumentId,
        price: price,
        asOf: d,
        source: source,
      ),
    );
  }

  Future<CostBasisResult> compute() async => CostBasis.compute(await _repo.instruments(), await _repo.events());

  void _check(PortfolioEvent e, Account? cash) {
    if (cash != null) {
      if (!cash.type.isBalanceSheet || cash.isSystem) throw const DomainException('ledger.not_money_account');
      if (cash.currency != e.currency) throw const DomainException('ledger.currency_mismatch');
      if (e.gross == null || e.gross! <= 0) throw const DomainException('portfolio.total_required');
    }
    if (e.gross != null && e.gross! < 0) throw const DomainException('amount.not_positive');
    if (e.cost != null && e.cost! < 0) throw const DomainException('amount.not_positive');
    switch (e.kind) {
      case EventKind.split:
        if ((e.splitNum ?? 0) <= 0 || (e.splitDen ?? 0) <= 0) throw const DomainException('portfolio.bad_split');
      case EventKind.income:
        if (e.qty < 0 || (e.qty == 0 && (e.gross ?? 0) <= 0)) throw const DomainException('portfolio.bad_quantity');
      default:
        if (e.qty <= 0) throw const DomainException('portfolio.bad_quantity');
    }
    if (cash != null && !(e.kind == EventKind.buy || e.kind == EventKind.sell || e.kind == EventKind.income)) {
      throw const DomainException('portfolio.cash_not_allowed');
    }
  }

  /// Validates by replaying everything with the new events, then stores and re-posts.
  Future<void> _commit(List<PortfolioEvent> added) async {
    final instruments = await _repo.instruments();
    for (final e in added) {
      if (!instruments.any((i) => i.id == e.instrumentId)) throw const DomainException('portfolio.unknown_instrument');
    }
    final result = CostBasis.compute(instruments, [...await _repo.events(), ...added]);
    for (final e in added) {
      final err = result.errors[e.id];
      if (err != null) throw DomainException(err);
    }
    if (result.errors.isNotEmpty) throw const DomainException('portfolio.breaks_later');
    for (final e in added) {
      await _repo.upsertEvent(e);
    }
    await reconcile(result);
  }

  /// Makes every live event's ledger transaction match its computed amounts.
  Future<void> reconcile([CostBasisResult? computed]) async {
    final result = computed ?? await compute();
    final instruments = {for (final i in await _repo.instruments()) i.id: i};
    final events = {for (final e in await _repo.events()) e.id: e};
    for (final fx in result.effects.values) {
      final e = events[fx.event.id];
      if (e == null || e.isVoided) continue;
      final legs = await _legs(fx);
      final sig = legs.isEmpty ? '' : (legs.map((l) => '${l.$1.id}:${l.$2}').toList()..sort()).join(';');
      if (sig == (e.txnSig ?? '') && (sig.isEmpty || e.txnId != null)) continue;
      if (e.txnId != null) await _ledger.voidById(e.txnId!);
      String? txnId;
      if (legs.isNotEmpty) {
        final inst = instruments[e.instrumentId];
        final txn = LedgerTransaction(
          id: Ids.next(),
          kind: TransactionKind.asset,
          occurredAt: e.at,
          note: [if (inst != null) label?.call(inst) ?? inst.name(false), if (e.note.isNotEmpty) e.note].join(' · '),
          postings: [
            for (final l in legs) Posting(id: Ids.next(), accountId: l.$1.id, amount: Money(l.$2, e.currency)),
          ],
        );
        await _ledger.recordBuilt(txn);
        txnId = txn.id;
      }
      await _repo.upsertEvent(e.copyWith(txnId: () => txnId, txnSig: () => sig));
    }
  }

  /// Postings (account, signed amount) for one event. Debits positive.
  Future<List<(Account, int)>> _legs(EventEffect fx) async {
    final e = fx.event;
    final c = e.currency;
    Future<Account> sys(String name, AccountType t) => _ledger.systemAccount(name, t, c);
    final cash = e.cashAccountId == null ? null : await _accounts.findById(e.cashAccountId!);
    final holdings = await sys(PortfolioAccounts.holdings(e.instrumentId, c), AccountType.asset);
    final counter = cash ?? await sys(PortfolioAccounts.clearing(c), AccountType.equity);
    final legs = <(Account, int)>[];
    void add(Account a, int v) {
      if (v == 0) return;
      final i = legs.indexWhere((l) => l.$1.id == a.id);
      if (i >= 0) {
        legs[i] = (a, legs[i].$2 + v);
      } else {
        legs.add((a, v));
      }
    }

    switch (e.kind) {
      case EventKind.buy || EventKind.opening || EventKind.giftIn || EventKind.adjustIn || EventKind.transferIn:
        if (e.kind == EventKind.transferIn) break; // holdings account is per instrument+currency: nothing moves
        add(holdings, fx.costIn);
        add(counter, -fx.costIn);
      case EventKind.sell:
        add(holdings, -fx.costOut);
        if (fx.proceeds == null) {
          add(counter, fx.costOut);
        } else {
          add(counter, fx.proceeds!);
          add(await sys(PortfolioAccounts.realizedGain(c), AccountType.income), -fx.gain);
        }
      case EventKind.giftOut || EventKind.adjustOut:
        add(holdings, -fx.costOut);
        add(await sys(PortfolioAccounts.clearing(c), AccountType.equity), fx.costOut);
      case EventKind.income:
        final income = await sys(PortfolioAccounts.investmentIncome(c), AccountType.income);
        add(e.qty > 0 ? holdings : counter, fx.incomeAmount);
        add(income, -fx.incomeAmount);
      case EventKind.transferOut || EventKind.split:
        break;
    }
    legs.removeWhere((l) => l.$2 == 0);
    return legs.length < 2 ? const [] : legs;
  }
}
