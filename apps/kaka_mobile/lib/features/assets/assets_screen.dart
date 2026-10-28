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
    final allTypes = ref.watch(assetTypesProvider).value ?? const <AssetType>[];
    final types = allTypes.where((t) => !t.archived).toList();
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
    final movements = ref.watch(assetMovementsProvider).value ?? const <AssetMovement>[];
    String typeName(String id) => allTypes.where((t) => t.id == id).map(name).firstOrNull ?? id;
    // Cash account of a linked movement, read from its ledger transaction.
    final txns = {for (final t in ref.watch(transactionsProvider).value ?? const <LedgerTransaction>[]) t.id: t};
    final accounts = {for (final a in ref.watch(accountsProvider).value ?? const <Account>[]) a.id: a};
    String? accountFor(AssetMovement m) => txns[m.transactionId]?.postings
        .map((p) => accounts[p.accountId])
        .where((a) => a != null && !a.isSystem)
        .firstOrNull
        ?.name;
    String unit(AssetType t) => t.unit == AssetUnit.gram ? l.unitGram : l.unitCoin;

    return Scaffold(
      appBar: AppBar(title: Text(l.assets)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: types.isEmpty ? null : () => _move(context, ref, types, all),
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
          if (movements.isNotEmpty) SectionHeader(l.assetHistory),
          for (final m in movements)
            ListTile(
              contentPadding: EdgeInsets.zero,
              onLongPress: m.voidedAt != null ? null : () => _voidMovement(context, ref, m),
              leading: Icon(m.quantityMilli > 0 ? Icons.add_circle_outline : Icons.remove_circle_outline),
              title: Text(
                '${m.quantityMilli > 0 ? l.buy : l.sell} · ${typeName(m.assetTypeId)} · '
                '${f.digits(AssetMath.formatQuantity(m.quantityMilli.abs()))}',
                style: TextStyle(decoration: m.voidedAt != null ? TextDecoration.lineThrough : null),
              ),
              subtitle: Text(
                '${m.voidedAt != null ? '${l.voided} · ' : ''}${f.date(m.date)}'
                '${m.transactionId != null && accountFor(m) != null ? ' · ${accountFor(m)}' : ''}',
              ),
              trailing: m.total == null ? null : AmountText(f.money(m.total!)),
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

Future<void> _move(BuildContext context, WidgetRef ref, List<AssetType> types, List<AssetHolding> all) async {
  final l = context.l10n;
  final f = ref.read(formatProvider);
  final fa = ref.read(settingsProvider).isPersian;
  final base = ref.read(settingsProvider).baseUnit.currency;
  final cashAccounts = (ref.read(accountsProvider).value ?? const <Account>[])
      .where((a) => a.type.isBalanceSheet && !a.isSystem && !a.archived)
      .toList();
  var type = types.first;
  var buy = true;
  var date = DateTime.now();
  Account? cash;
  final qty = TextEditingController();
  final total = TextEditingController();
  String? qtyError;
  String? totalError;
  int held(AssetType t) => all.where((h) => h.type.id == t.id).firstOrNull?.quantityMilli ?? 0;
  String unit(AssetType t) => t.unit == AssetUnit.gram ? l.unitGram : l.unitCoin;
  await showDialog<void>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (dialogContext, setState) {
        final currency = cash?.currency ?? base;
        // Suggest price × quantity when a price in the same currency is known.
        String? estimate;
        try {
          final p = all.where((h) => h.type.id == type.id).firstOrNull?.price;
          final q = AssetMath.parseQuantity(qty.text);
          if (p != null && p.price.currency == currency && q > 0) {
            estimate = l.estimateFromPrice(f.money(AssetHolding(type, q, p).value!));
          }
        } on FormatException {
          estimate = null;
        }
        return AlertDialog(
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
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(labelText: l.quantity, suffixText: unit(type), errorText: qtyError),
                ),
                DropdownButtonFormField<Account?>(
                  initialValue: cash,
                  isExpanded: true,
                  decoration: InputDecoration(labelText: buy ? l.payFrom : l.receiveInto),
                  items: [
                    DropdownMenuItem(value: null, child: Text(l.noCashAccount)),
                    for (final a in cashAccounts)
                      DropdownMenuItem(value: a, child: Text('${a.name} (${f.symbol(a.currency)})')),
                  ],
                  onChanged: (a) => setState(() => cash = a),
                ),
                TextField(
                  controller: total,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: cash == null ? l.totalOptional : l.amount,
                    suffixText: f.symbol(currency),
                    helperText: estimate,
                    errorText: totalError,
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
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(l.cancel)),
            FilledButton(
              onPressed: () async {
                setState(() => qtyError = totalError = null);
                final int q;
                try {
                  q = AssetMath.parseQuantity(qty.text);
                  if (q <= 0) throw const FormatException('quantity');
                } on FormatException {
                  setState(() => qtyError = l.errAmount);
                  return;
                }
                Money? paid;
                try {
                  paid = total.text.trim().isEmpty ? null : parseUserMoney(f, total.text, currency);
                } on DomainException {
                  setState(() => totalError = l.errAmount);
                  return;
                }
                try {
                  await ref
                      .read(assetTradingProvider)
                      .trade(
                        assetTypeId: type.id,
                        quantityMilli: q,
                        buy: buy,
                        total: paid,
                        cash: cash,
                        heldMilli: held(type),
                        at: date,
                      );
                  if (dialogContext.mounted) Navigator.pop(dialogContext);
                } on DomainException catch (e) {
                  setState(() {
                    switch (e.code) {
                      case 'asset.sell_more_than_held':
                        qtyError = l.errSellMoreThanHeld(
                          '${f.digits(AssetMath.formatQuantity(held(type)))} ${unit(type)}',
                        );
                      case 'asset.total_required':
                        totalError = l.errTotalRequired;
                      default:
                        totalError = l.errAmount;
                    }
                  });
                }
              },
              child: Text(l.save),
            ),
          ],
        );
      },
    ),
  );
  qty.dispose();
  total.dispose();
}

Future<void> _voidMovement(BuildContext context, WidgetRef ref, AssetMovement m) async {
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
  if (ok == true) await ref.read(assetTradingProvider).voidMovement(m);
}
