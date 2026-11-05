import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaka_domain/kaka_domain.dart';
import 'package:kaka_prices/kaka_prices.dart';

import '../../app/providers.dart';
import '../../core/date_picker.dart';
import '../../core/l10n_x.dart';
import '../../core/money_input.dart';
import '../../theme/kaka_colors.dart';
import 'asset_ui.dart';
import 'html_price_refresh.dart';
import 'price_sources_screen.dart';

/// All assets with their last price; manual entry always works.
/// Online refresh uses the enabled catalog sources (user-initiated only).
class PricesScreen extends ConsumerStatefulWidget {
  const PricesScreen({super.key});

  @override
  ConsumerState<PricesScreen> createState() => _PricesScreenState();
}

class _PricesScreenState extends ConsumerState<PricesScreen> {
  var _refreshing = false;
  String? _status;

  Future<void> _refreshAll() async {
    final l = context.l10n;
    final catalog = await ref.read(priceCatalogProvider.future);
    final enabled = ref.read(priceSourceEnabledProvider).value ?? {};
    if (enabled.isEmpty) {
      setState(() => _status = l.priceRefreshNoneEnabled);
      return;
    }
    setState(() {
      _refreshing = true;
      _status = null;
    });
    final fetcher = PriceFetcher();
    try {
      final service = PriceRefreshService(
        catalog: catalog,
        fetcher: fetcher,
        isSourceEnabled: enabled.contains,
        htmlBodyFor: (source, url) async {
          final html = await loadHtmlInApp(context, url: url, title: source.name(ref.read(settingsProvider).isPersian));
          if (html == null || html.isEmpty) throw const PriceFetchException('cancelled');
          return html;
        },
      );
      final instruments = (ref.read(instrumentsProvider).value ?? const <Instrument>[]).where((i) => !i.archived).toList();
      final bindings = ref.read(priceBindingsProvider).value ?? const <PriceBinding>[];
      // Auto-suggest bindings for enabled sources when none exist yet.
      await _ensureSuggestedBindings(catalog, enabled, instruments, bindings);
      final List<PriceBinding> freshBindings = await ref.read(priceBindingsProvider.future);
      final portfolio = ref.read(portfolioServiceProvider);
      final outcomes = await service.refresh(
        instruments: instruments,
        bindings: freshBindings,
        save: (q) async {
          await portfolio.setPrice(q.instrumentId, q.price, q.asOf, source: q.source);
        },
      );
      final ok = outcomes.where((o) => o.ok).length;
      final fail = outcomes.length - ok;
      if (mounted) {
        setState(() => _status = l.priceRefreshResult(ok, fail));
      }
    } on Object catch (e) {
      if (mounted) setState(() => _status = '$e');
    } finally {
      fetcher.close();
      if (mounted) setState(() => _refreshing = false);
    }
  }

  Future<void> _ensureSuggestedBindings(
    PriceCatalog catalog,
    Set<String> enabled,
    List<Instrument> instruments,
    List<PriceBinding> existing,
  ) async {
    final store = ref.read(priceBindingStoreProvider);
    for (final sourceId in enabled) {
      final source = catalog.byId(sourceId);
      if (source == null || source.kind == PriceSourceKind.manual) continue;
      for (final i in instruments) {
        if (existing.any((b) => b.instrumentId == i.id && b.sourceId == sourceId)) continue;
        final sym = PriceRefreshService.suggestSymbol(source, i);
        if (sym == null || sym.isEmpty) continue;
        // Only auto-bind when the instrument has a symbol/catalog hint match.
        final hinted = source.symbolHints.containsKey(i.symbol) ||
            source.symbolHints.containsKey(i.symbol.toUpperCase()) ||
            (i.catalogId != null && source.symbolHints.containsKey(i.catalogId));
        if (!hinted) continue;
        await store.upsert(id: Ids.next(), instrumentId: i.id, sourceId: sourceId, symbol: sym, priority: 100);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = KakaColors.of(context);
    final f = ref.watch(formatProvider);
    final fa = ref.watch(settingsProvider).isPersian;
    final latest = PortfolioValuation.latestPrices(ref.watch(priceQuotesProvider).value ?? const []);
    final held = {for (final v in ref.watch(holdingViewsProvider)) v.instrument.id};
    final instruments =
        (ref.watch(instrumentsProvider).value ?? const <Instrument>[]).where((i) => !i.archived).toList()
          ..sort((a, b) => (held.contains(b.id) ? 1 : 0).compareTo(held.contains(a.id) ? 1 : 0));
    final enabledCount = (ref.watch(priceSourceEnabledProvider).value ?? {}).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.unitPrices),
        actions: [
          IconButton(
            tooltip: l.priceSources,
            onPressed: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const PriceSourcesScreen())),
            icon: const Icon(Icons.cloud_outlined),
          ),
          IconButton(
            tooltip: l.priceRefresh,
            onPressed: _refreshing ? null : _refreshAll,
            icon: _refreshing
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(l.pricesManualHint, style: TextStyle(color: c.textMuted)),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.cloud_outlined),
            title: Text(l.priceSources),
            subtitle: Text(l.priceSourcesEnabledCount(enabledCount)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const PriceSourcesScreen())),
          ),
          if (_status != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(_status!, style: TextStyle(color: c.textMuted)),
            ),
          if (instruments.isEmpty) Text(l.noHoldingsYet, style: TextStyle(color: c.textMuted)),
          for (final i in instruments)
            Builder(
              builder: (context) {
                final p = latest[i.id];
                final stale = p != null && DateTime.now().difference(p.asOf) > staleAfterFor(i.assetClass);
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(classIcon(i.assetClass)),
                  title: Text(i.name(fa)),
                  subtitle: Text(
                    p == null
                        ? l.noPrice
                        : '${f.money(p.price)} / ${i.unit(fa)} · ${f.date(p.asOf)}${p.source == 'manual' ? '' : ' · ${p.source}'}',
                    style: TextStyle(color: stale ? Colors.orange : null),
                  ),
                  trailing: TextButton(onPressed: () => showSetPriceDialog(context, ref, i), child: Text(l.setPrice)),
                );
              },
            ),
        ],
      ),
    );
  }
}

Future<void> showSetPriceDialog(BuildContext context, WidgetRef ref, Instrument i) async {
  final l = context.l10n;
  final f = ref.read(formatProvider);
  final fa = ref.read(settingsProvider).isPersian;
  final latest = PortfolioValuation.latestPrices(ref.read(priceQuotesProvider).value ?? const [])[i.id];
  var currency = latest?.price.currency ?? i.quoteCurrency ?? ref.read(settingsProvider).baseUnit.currency;
  final ctrl = TextEditingController();
  var date = DateTime.now();
  String? error;
  await showDialog<void>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (dialogContext, setState) => AlertDialog(
        title: Text('${l.setPrice} · ${i.name(fa)}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: ctrl,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: '${l.pricePerUnit} (1 ${i.unit(fa)})',
                suffixText: f.symbol(currency),
                errorText: error,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<Currency>(
              initialValue: currency,
              decoration: InputDecoration(labelText: l.currency),
              items: [for (final cur in Currency.builtIn) DropdownMenuItem(value: cur, child: Text(f.symbol(cur)))],
              onChanged: (v) => setState(() => currency = v!),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              visualDensity: VisualDensity.compact,
              leading: const Icon(Icons.event_outlined),
              title: Text(f.date(date)),
              onTap: () async {
                final d = await pickDate(dialogContext, f, initial: date);
                if (d != null) setState(() => date = d);
              },
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(l.cancel)),
          FilledButton(
            onPressed: () async {
              try {
                await ref.read(portfolioServiceProvider).setPrice(i.id, parseUserMoney(f, ctrl.text, currency), date);
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              } on Object {
                setState(() => error = l.errAmount);
              }
            },
            child: Text(l.save),
          ),
        ],
      ),
    ),
  );
}
