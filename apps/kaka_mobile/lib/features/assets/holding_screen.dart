import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaka_domain/kaka_domain.dart';

import '../../app/providers.dart';
import '../../core/l10n_x.dart';
import '../../core/widgets.dart';
import '../../theme/kaka_colors.dart';
import 'asset_ui.dart';
import 'assets_screen.dart';
import 'event_form_screen.dart';
import 'instrument_form_screen.dart';
import 'prices_screen.dart';

/// One holding: quantity, average cost, value, gains, and its events.
class HoldingScreen extends ConsumerWidget {
  const HoldingScreen({super.key, required this.holdingKey});
  final String holdingKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = KakaColors.of(context);
    final f = ref.watch(formatProvider);
    final fa = ref.watch(settingsProvider).isPersian;
    final hide = ref.watch(settingsProvider).hideAmounts;
    final result = ref.watch(costBasisProvider);
    final h = result.holdings[holdingKey];
    if (h == null) return Scaffold(appBar: AppBar());
    final prices = ref.watch(priceQuotesProvider).value ?? const <PriceQuote>[];
    final view = HoldingView(
      h,
      PortfolioValuation.latestPrices(prices)[h.instrument.id],
      staleAfter: staleAfterFor(h.instrument.assetClass),
      now: DateTime.now(),
    );
    final i = h.instrument;
    final platform = (ref.watch(platformsProvider).value ?? const <AssetPlatform>[])
        .where((p) => p.id == h.platformId)
        .firstOrNull;
    final events = (ref.watch(portfolioEventsProvider).value ?? const <PortfolioEvent>[])
        .where((e) => holdingKey == holdingKeyOf(e))
        .toList()
        .reversed
        .toList();
    String m(Money x, {bool signed = false}) => moneyOrHidden(f, x, signed: signed, hide: hide);
    Widget row(String k, String v, {Color? color}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(k, style: TextStyle(color: c.textMuted)),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: AmountText(v, color: color),
            ),
          ),
        ],
      ),
    );
    final gain = view.unrealizedNative;

    return Scaffold(
      appBar: AppBar(
        title: Text(i.name(fa)),
        actions: [
          IconButton(
            tooltip: l.editAsset,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute<void>(builder: (_) => InstrumentFormScreen(existing: i))),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAssetActions(context, ref, instrumentId: i.id, platformId: h.platformId),
        child: const Icon(Icons.add_rounded),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
        children: [
          KCard(
            child: Column(
              children: [
                row(l.quantity, qtyText(f, i, h.qty, fa)),
                if (platform != null) row(l.platform, platform.name),
                row(l.costBasis, h.costUnknown ? '${m(view.cost)} (${l.partlyUnknown})' : m(view.cost)),
                if (view.averageCost != null) row(l.averageCost, '${m(view.averageCost!)} / ${i.unit(fa)}'),
                row(l.marketValue, view.marketValue == null ? l.noPrice : m(view.marketValue!)),
                if (view.price != null)
                  row(
                    l.lastPrice,
                    '${m(view.price!.price)} · ${f.date(view.price!.asOf)}${view.isStale ? ' · ${l.old}' : ''}',
                    color: view.isStale ? Colors.orange : null,
                  ),
                if (gain != null)
                  row(
                    l.unrealizedGain,
                    '${m(gain, signed: true)}  ${percentText(f, gain.minor, h.cost)}',
                    color: gain.minor >= 0 ? c.positive : c.negative,
                  ),
                row(
                  l.realizedGain,
                  '${m(Money(h.realized, h.currency), signed: true)}${h.realizedIncomplete ? ' (${l.partlyUnknown})' : ''}',
                ),
                if (h.income != 0) row(l.investmentIncome, m(Money(h.income, h.currency))),
                if (h.fees != 0) row(l.feesPaid, m(Money(h.fees, h.currency))),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              FilledButton.tonal(
                onPressed: () => openEventForm(context, EventKind.buy, instrumentId: i.id, platformId: h.platformId),
                child: Text(l.buy),
              ),
              FilledButton.tonal(
                onPressed: h.qty == 0
                    ? null
                    : () => openEventForm(context, EventKind.sell, instrumentId: i.id, platformId: h.platformId),
                child: Text(l.sell),
              ),
              OutlinedButton(onPressed: () => showSetPriceDialog(context, ref, i), child: Text(l.setPrice)),
            ],
          ),
          SectionHeader(l.assetHistory),
          for (final e in events) EventTile(event: e, instrument: i),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(l.longPressToVoid, style: TextStyle(color: c.textFaint, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

String holdingKeyOf(PortfolioEvent e) => holdingKey(e.instrumentId, e.platformId, e.currency);

class EventTile extends ConsumerWidget {
  const EventTile({super.key, required this.event, required this.instrument});
  final PortfolioEvent event;
  final Instrument instrument;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final f = ref.watch(formatProvider);
    final fa = ref.watch(settingsProvider).isPersian;
    final hide = ref.watch(settingsProvider).hideAmounts;
    final e = event;
    final fx = ref.watch(costBasisProvider).effects[e.id];
    final accounts = {for (final a in ref.watch(accountsProvider).value ?? const <Account>[]) a.id: a};
    final amount = e.gross ?? e.cost;
    final parts = [
      f.date(e.at),
      if (e.isVoided) l.voided,
      if (e.cashAccountId != null) accounts[e.cashAccountId]?.name ?? '',
      if (e.kind == EventKind.sell && fx != null && fx.proceeds != null)
        '${l.realizedGain}: ${moneyOrHidden(f, Money(fx.gain, e.currency), signed: true, hide: hide)}',
      if (e.costMode == CostMode.unknown && e.kind.addsQuantity) l.costUnknown,
      if (e.note.isNotEmpty) e.note,
    ];
    final qty = e.kind == EventKind.split
        ? f.digits('${e.splitNum}:${e.splitDen}')
        : (e.qty == 0 ? '' : qtyText(f, instrument, e.qty, fa));
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onLongPress: e.isVoided ? null : () => confirmVoidEvent(context, ref, e),
      leading: Icon(
        e.kind.addsQuantity || (e.kind == EventKind.income && e.qty > 0)
            ? Icons.add_circle_outline
            : e.kind.removesQuantity
            ? Icons.remove_circle_outline
            : Icons.circle_outlined,
      ),
      title: Text(
        [kindName(l, e.kind), if (qty.isNotEmpty) qty].join(' · '),
        style: TextStyle(decoration: e.isVoided ? TextDecoration.lineThrough : null),
      ),
      subtitle: Text(parts.where((p) => p.isNotEmpty).join(' · ')),
      trailing: amount == null ? null : AmountText(moneyOrHidden(f, Money(amount, e.currency), hide: hide)),
    );
  }
}

Future<void> confirmVoidEvent(BuildContext context, WidgetRef ref, PortfolioEvent e) async {
  final l = context.l10n;
  final ok = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(l.voidTitle),
      content: Text(l.assetVoidBody),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l.cancel)),
        TextButton(onPressed: () => Navigator.pop(c, true), child: Text(l.voidAction)),
      ],
    ),
  );
  if (ok != true) return;
  try {
    await ref.read(portfolioServiceProvider).voidEvent(e);
  } on DomainException catch (err) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(portfolioError(l, err.code))));
    }
  }
}
