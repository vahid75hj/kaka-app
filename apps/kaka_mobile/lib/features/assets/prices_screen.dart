import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaka_domain/kaka_domain.dart';

import '../../app/providers.dart';
import '../../core/date_picker.dart';
import '../../core/l10n_x.dart';
import '../../core/money_input.dart';
import '../../theme/kaka_colors.dart';
import 'asset_ui.dart';

/// All assets with their last price; tap one to enter today's price.
/// Prices are only ever typed by the user (no made-up numbers).
class PricesScreen extends ConsumerWidget {
  const PricesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = KakaColors.of(context);
    final f = ref.watch(formatProvider);
    final fa = ref.watch(settingsProvider).isPersian;
    final latest = PortfolioValuation.latestPrices(ref.watch(priceQuotesProvider).value ?? const []);
    final held = {for (final v in ref.watch(holdingViewsProvider)) v.instrument.id};
    final instruments =
        (ref.watch(instrumentsProvider).value ?? const <Instrument>[]).where((i) => !i.archived).toList()
          ..sort((a, b) => (held.contains(b.id) ? 1 : 0).compareTo(held.contains(a.id) ? 1 : 0));
    return Scaffold(
      appBar: AppBar(title: Text(l.unitPrices)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(l.pricesManualHint, style: TextStyle(color: c.textMuted)),
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
                    p == null ? l.noPrice : '${f.money(p.price)} / ${i.unit(fa)} · ${f.date(p.asOf)}',
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
            DropdownButtonFormField<Currency>(
              initialValue: currency,
              decoration: InputDecoration(labelText: l.currency),
              items: [for (final cur in Currency.builtIn) DropdownMenuItem(value: cur, child: Text(f.symbol(cur)))],
              onChanged: (v) => setState(() => currency = v!),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
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
  ctrl.dispose();
}
