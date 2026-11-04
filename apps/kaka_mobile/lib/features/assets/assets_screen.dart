import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaka_domain/kaka_domain.dart';

import '../../app/providers.dart';
import '../../core/l10n_x.dart';
import '../../core/widgets.dart';
import '../../theme/kaka_colors.dart';
import 'asset_ui.dart';
import 'event_form_screen.dart';
import 'holding_screen.dart';
import 'instrument_form_screen.dart';
import 'prices_screen.dart';

/// Portfolio overview: total value, gain, and holdings grouped by class.
class AssetsScreen extends ConsumerWidget {
  const AssetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = KakaColors.of(context);
    final f = ref.watch(formatProvider);
    final settings = ref.watch(settingsProvider);
    final fa = settings.isPersian;
    final hide = settings.hideAmounts;
    final fx = ref.watch(converterProvider);
    final views = ref.watch(holdingViewsProvider);
    final platforms = {for (final p in ref.watch(platformsProvider).value ?? const <AssetPlatform>[]) p.id: p};
    final (total, unconverted) = PortfolioValuation.total(views, fx);
    var unrealized = 0;
    var unrealizedCost = 0;
    for (final v in views) {
      final u = v.unrealized(fx);
      final cost = fx.toBase(v.cost);
      if (u != null && cost != null) {
        unrealized += u.minor;
        unrealizedCost += cost.minor;
      }
    }
    final stale = views.where((v) => v.isStale || v.price == null).length;
    final byClass = <AssetClass, List<HoldingView>>{};
    for (final v in views) {
      byClass.putIfAbsent(v.instrument.assetClass, () => []).add(v);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l.assets),
        actions: [
          IconButton(
            tooltip: hide ? l.showAmounts : l.hideAmounts,
            icon: Icon(hide ? Icons.visibility_off_outlined : Icons.visibility_outlined),
            onPressed: () => ref.read(settingsProvider.notifier).update((s) => s.copyWith(hideAmounts: !hide)),
          ),
          IconButton(
            tooltip: l.unitPrices,
            icon: const Icon(Icons.price_change_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const PricesScreen())),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAssetActions(context, ref),
        icon: const Icon(Icons.add_rounded),
        label: Text(l.addAssetAction),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
        children: [
          KCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.assetsValue, style: TextStyle(color: c.textMuted)),
                const SizedBox(height: 6),
                AmountText(moneyOrHidden(f, total, hide: hide), style: const TextStyle(fontSize: 26)),
                for (final m in unconverted)
                  Text(
                    '+ ${moneyOrHidden(f, m, hide: hide)} (${l.noRate})',
                    style: TextStyle(color: c.textMuted),
                  ),
                if (unrealizedCost != 0) ...[
                  const SizedBox(height: 6),
                  Text(
                    '${l.unrealizedGain}: ${moneyOrHidden(f, Money(unrealized, fx.base), signed: true, hide: hide)}'
                    '  ${percentText(f, unrealized, unrealizedCost)}',
                    style: TextStyle(color: unrealized >= 0 ? c.positive : c.negative),
                  ),
                ],
                if (stale > 0)
                  TextButton.icon(
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    icon: const Icon(Icons.schedule, size: 18),
                    label: Text(l.pricesNeedUpdate(f.digits('$stale'))),
                    onPressed: () =>
                        Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const PricesScreen())),
                  ),
              ],
            ),
          ),
          if (views.isEmpty) ...[
            const SizedBox(height: 24),
            Text(l.noHoldingsYet, style: TextStyle(color: c.textMuted)),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: () => openEventForm(context, EventKind.opening),
              child: Text(l.evOpeningAction),
            ),
            const SizedBox(height: 8),
            OutlinedButton(onPressed: () => openEventForm(context, EventKind.buy), child: Text(l.buy)),
          ],
          for (final e in byClass.entries) ...[
            SectionHeader(className(l, e.key)),
            for (final v in e.value) _HoldingTile(view: v, platform: platforms[v.state.platformId], fa: fa, hide: hide),
          ],
        ],
      ),
    );
  }
}

class _HoldingTile extends ConsumerWidget {
  const _HoldingTile({required this.view, required this.platform, required this.fa, required this.hide});
  final HoldingView view;
  final AssetPlatform? platform;
  final bool fa;
  final bool hide;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = KakaColors.of(context);
    final f = ref.watch(formatProvider);
    final i = view.instrument;
    final gain = view.unrealizedNative;
    final sub = [
      qtyText(f, i, view.state.qty, fa),
      if (platform != null) platform!.name,
      if (view.price == null) l.noPrice else if (view.isStale) l.priceOld(f.date(view.price!.asOf)),
    ].join(' · ');
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(classIcon(i.assetClass)),
      title: Text(i.name(fa)),
      subtitle: Text(sub),
      onTap: () =>
          Navigator.push(context, MaterialPageRoute<void>(builder: (_) => HoldingScreen(holdingKey: view.state.key))),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AmountText(moneyOrHidden(f, view.bestValue, hide: hide)),
          if (view.marketValue == null)
            Text(l.atCost, style: TextStyle(fontSize: 12, color: c.textMuted))
          else if (gain != null)
            Text(
              percentText(f, gain.minor, view.state.cost),
              style: TextStyle(fontSize: 12, color: gain.minor >= 0 ? c.positive : c.negative),
            ),
        ],
      ),
    );
  }
}

/// Bottom sheet with every way to add something to the portfolio.
Future<void> showAssetActions(BuildContext context, WidgetRef ref, {String? instrumentId, String? platformId}) {
  final l = context.l10n;
  Widget item(IconData icon, String label, VoidCallback onTap) => ListTile(
    leading: Icon(icon),
    title: Text(label),
    onTap: () {
      Navigator.pop(context);
      onTap();
    },
  );
  void form(EventKind k) => openEventForm(context, k, instrumentId: instrumentId, platformId: platformId);
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            item(Icons.add_shopping_cart, l.buy, () => form(EventKind.buy)),
            item(Icons.sell_outlined, l.sell, () => form(EventKind.sell)),
            item(Icons.inventory_2_outlined, l.evOpeningAction, () => form(EventKind.opening)),
            item(Icons.swap_horiz, l.swapAction, () => openSwapForm(context, instrumentId: instrumentId)),
            item(Icons.payments_outlined, l.evIncome, () => form(EventKind.income)),
            item(Icons.card_giftcard, l.evGiftIn, () => form(EventKind.giftIn)),
            item(Icons.redeem, l.evGiftOut, () => form(EventKind.giftOut)),
            item(Icons.call_split, l.evSplit, () => form(EventKind.split)),
            item(Icons.tune, l.adjustAction, () => form(EventKind.adjustIn)),
            item(
              Icons.add_box_outlined,
              l.newAsset,
              () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const InstrumentFormScreen())),
            ),
          ],
        ),
      ),
    ),
  );
}
