import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaka_domain/kaka_domain.dart';

import '../../app/providers.dart';
import '../../core/date_picker.dart';
import '../../core/l10n_x.dart';
import '../../core/money_input.dart';
import '../../core/widgets.dart';
import '../../theme/kaka_colors.dart';

/// Gold & coins: holdings, buy/sell movements and manual unit prices.
class AssetsScreen extends ConsumerWidget {
  const AssetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = KakaColors.of(context);
    final f = ref.watch(formatProvider);
    final fa = ref.watch(settingsProvider).isPersian;
    final types = (ref.watch(assetTypesProvider).value ?? const <AssetType>[]).where((t) => !t.archived).toList();
    final all = AssetMath.holdings(
      types,
      ref.watch(assetMovementsProvider).value ?? const [],
      ref.watch(assetPricesProvider).value ?? const [],
      includeEmpty: true,
    );
    final held = all.where((h) => h.quantityMilli != 0).toList();
    final fx = ref.watch(converterProvider);
    var total = Money.zero(fx.base);
    for (final h in held) {
      final v = h.value == null ? null : fx.toBase(h.value!);
      if (v != null) total += v;
    }
    String name(AssetType t) => fa ? t.nameFa : t.nameEn;
    String unit(AssetType t) => t.unit == AssetUnit.gram ? l.unitGram : l.unitCoin;

    return Scaffold(
      appBar: AppBar(title: Text(l.assets)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: types.isEmpty ? null : () => _move(context, ref, types),
        icon: const Icon(Icons.add_rounded),
        label: Text(l.buySell),
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
                AmountText(f.money(total), style: const TextStyle(fontSize: 26)),
              ],
            ),
          ),
          SectionHeader(l.holdings),
          if (held.isEmpty) Text(l.noHoldings, style: TextStyle(color: c.textMuted)),
          for (final h in held)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(h.type.unit == AssetUnit.gram ? Icons.diamond_outlined : Icons.toll_outlined),
              title: Text(name(h.type)),
              subtitle: Text(
                '${f.digits(AssetMath.formatQuantity(h.quantityMilli))} ${unit(h.type)}'
                '${h.price == null ? ' · ${l.noPrice}' : ' · ${f.date(h.price!.date)}'}',
              ),
              trailing: h.value == null ? null : AmountText(f.money(h.value!)),
            ),
          SectionHeader(l.unitPrices),
          for (final h in all)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(name(h.type)),
              subtitle: Text(
                h.price == null ? l.noPrice : '${f.money(h.price!.price)} / ${unit(h.type)} · ${f.date(h.price!.date)}',
              ),
              trailing: TextButton(onPressed: () => _price(context, ref, h.type), child: Text(l.setPrice)),
            ),
        ],
      ),
    );
  }
}

Future<void> _price(BuildContext context, WidgetRef ref, AssetType type) async {
  final l = context.l10n;
  final f = ref.read(formatProvider);
  final base = ref.read(settingsProvider).baseUnit.currency;
  final ctrl = TextEditingController();
  var date = DateTime.now();
  String? error;
  await showDialog<void>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (dialogContext, setState) => AlertDialog(
        title: Text(l.setPrice),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: ctrl,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: l.pricePerUnit, suffixText: f.symbol(base), errorText: error),
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
                    .read(assetRepositoryProvider)
                    .upsertPrice(
                      AssetPrice(
                        id: '${type.id}-${day.toIso8601String().substring(0, 10)}',
                        assetTypeId: type.id,
                        date: day,
                        price: parseUserMoney(f, ctrl.text, base),
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
  ctrl.dispose();
}

Future<void> _move(BuildContext context, WidgetRef ref, List<AssetType> types) async {
  final l = context.l10n;
  final f = ref.read(formatProvider);
  final fa = ref.read(settingsProvider).isPersian;
  final base = ref.read(settingsProvider).baseUnit.currency;
  var type = types.first;
  var buy = true;
  var date = DateTime.now();
  final qty = TextEditingController();
  final total = TextEditingController();
  String? error;
  await showDialog<void>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (dialogContext, setState) => AlertDialog(
        title: Text(l.buySell),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SegmentedButton<bool>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(value: true, label: Text(l.buy)),
                  ButtonSegment(value: false, label: Text(l.sell)),
                ],
                selected: {buy},
                onSelectionChanged: (v) => setState(() => buy = v.first),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<AssetType>(
                initialValue: type,
                isExpanded: true,
                items: [for (final t in types) DropdownMenuItem(value: t, child: Text(fa ? t.nameFa : t.nameEn))],
                onChanged: (t) => setState(() => type = t!),
              ),
              TextField(
                controller: qty,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: l.quantity,
                  suffixText: type.unit == AssetUnit.gram ? l.unitGram : l.unitCoin,
                  errorText: error,
                ),
              ),
              TextField(
                controller: total,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: l.totalOptional, suffixText: f.symbol(base)),
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
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(l.cancel)),
          FilledButton(
            onPressed: () async {
              try {
                final q = AssetMath.parseQuantity(qty.text);
                if (q <= 0) throw const FormatException('quantity');
                final paid = total.text.trim().isEmpty ? null : parseUserMoney(f, total.text, base);
                await ref
                    .read(assetRepositoryProvider)
                    .insertMovement(
                      AssetMovement(
                        id: Ids.next(),
                        assetTypeId: type.id,
                        quantityMilli: buy ? q : -q,
                        date: date,
                        total: paid,
                      ),
                    );
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              } on FormatException {
                setState(() => error = l.errAmount);
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
  qty.dispose();
  total.dispose();
}
