import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaka_domain/kaka_domain.dart';

import '../../app/providers.dart';
import '../../core/date_picker.dart';
import '../../core/l10n_x.dart';
import '../../core/money_input.dart';
import '../../core/widgets.dart';

/// Manual exchange rates per date: "1 USD = x base".
class RatesScreen extends ConsumerWidget {
  const RatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final f = ref.watch(formatProvider);
    final base = ref.watch(settingsProvider).baseUnit;
    final rates = (ref.watch(exchangeRatesProvider).value ?? const <ExchangeRate>[])
        .where((r) => r.base == base.currency)
        .toList();
    return Scaffold(
      appBar: AppBar(title: Text(l.exchangeRates)),
      floatingActionButton: FloatingActionButton(
        tooltip: l.addRate,
        onPressed: () => _addRate(context, ref),
        child: const Icon(Icons.add_rounded),
      ),
      body: rates.isEmpty
          ? EmptyState(
              icon: Icons.currency_exchange_rounded,
              message: l.noRates,
              action: l.addRate,
              onAction: () => _addRate(context, ref),
            )
          : ListView(
              padding: const EdgeInsets.only(bottom: 96),
              children: [
                for (final r in rates)
                  ListTile(
                    leading: const Icon(Icons.currency_exchange_rounded),
                    title: Text(
                      '1 ${f.symbol(r.currency)} = ${showUserRate(f, r.rate)} ${f.symbol(base.currency)}',
                      textDirection: TextDirection.ltr,
                    ),
                    subtitle: Text(f.date(r.date)),
                    trailing: IconButton(
                      tooltip: l.delete,
                      icon: const Icon(Icons.delete_outline_rounded),
                      onPressed: () => ref.read(exchangeRateRepositoryProvider).delete(r.id),
                    ),
                  ),
              ],
            ),
    );
  }
}

Future<void> _addRate(BuildContext context, WidgetRef ref) async {
  final l = context.l10n;
  final f = ref.read(formatProvider);
  final base = ref.read(settingsProvider).baseUnit.currency;
  final others = Currency.builtIn.where((x) => x != base).toList();
  var currency = others.first;
  var date = DateTime.now();
  final rate = TextEditingController();
  String? error;
  await showDialog<void>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (dialogContext, setState) => AlertDialog(
        title: Text(l.addRate),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<Currency>(
              initialValue: currency,
              decoration: InputDecoration(labelText: l.currency),
              items: [for (final x in others) DropdownMenuItem(value: x, child: Text('${x.code} · ${f.symbol(x)}'))],
              onChanged: (x) => setState(() => currency = x!),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: rate,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l.rateLabel(f.symbol(currency)),
                suffixText: f.symbol(base),
                errorText: error,
              ),
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
                final day = DateTime(date.year, date.month, date.day);
                await ref
                    .read(exchangeRateRepositoryProvider)
                    .upsert(
                      ExchangeRate(
                        // One rate per currency per day: re-entering replaces it.
                        id: '${currency.code}-${base.code}-${day.toIso8601String().substring(0, 10)}',
                        currency: currency,
                        base: base,
                        date: day,
                        rate: parseUserRate(f, rate.text),
                      ),
                    );
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              } on DomainException {
                setState(() => error = l.errAmount);
              }
            },
            child: Text(l.save),
          ),
        ],
      ),
    ),
  );
  rate.dispose();
}
