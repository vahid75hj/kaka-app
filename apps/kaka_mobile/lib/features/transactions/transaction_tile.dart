import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaka_domain/kaka_domain.dart';

import '../../app/providers.dart';
import '../../core/l10n_x.dart';
import '../../core/widgets.dart';
import '../../theme/kaka_colors.dart';
import 'transaction_view.dart';

class TransactionTile extends ConsumerWidget {
  const TransactionTile(this.view, {super.key});
  final TransactionView view;

  IconData get _icon => switch (view.txn.kind) {
    TransactionKind.expense => Icons.north_east_rounded,
    TransactionKind.income => Icons.south_west_rounded,
    TransactionKind.transfer => Icons.swap_horiz_rounded,
    TransactionKind.opening => Icons.flag_outlined,
  };

  Future<void> _confirmVoid(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l.voidTitle),
        content: Text(l.voidBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l.cancel)),
          TextButton(onPressed: () => Navigator.pop(c, true), child: Text(l.voidAction)),
        ],
      ),
    );
    if (ok == true) await ref.read(ledgerProvider).voidTransaction(view.txn);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = KakaColors.of(context);
    final f = ref.watch(formatProvider);
    final voided = view.txn.isVoided;
    final color = voided
        ? c.textFaint
        : switch (view.txn.kind) {
            TransactionKind.expense => c.text,
            TransactionKind.income => c.positive,
            _ => c.textMuted,
          };
    final strike = voided ? TextDecoration.lineThrough : null;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      onLongPress: voided ? null : () => _confirmVoid(context, ref),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: c.line),
        ),
        child: Icon(_icon, size: 20, color: c.accentText),
      ),
      title: Text(
        view.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontWeight: FontWeight.w700, decoration: strike),
      ),
      subtitle: Text(
        '${voided ? '${context.l10n.voided} · ' : ''}${view.subtitle} · ${f.date(view.txn.occurredAt)}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: c.textMuted, fontSize: 12),
      ),
      trailing: AmountText(
        f.money(view.amount, signed: view.txn.kind == TransactionKind.income),
        color: color,
        style: TextStyle(fontSize: 14.5, decoration: strike),
      ),
    );
  }
}

/// Builds tiles for [txns] once accounts are known.
final transactionViewsProvider = Provider.family<List<TransactionView>, String>((ref, openingLabel) {
  final accounts = {for (final a in ref.watch(accountsProvider).value ?? const <Account>[]) a.id: a};
  final txns = ref.watch(transactionsProvider).value ?? const <LedgerTransaction>[];
  if (accounts.isEmpty) return const [];
  return [for (final t in txns) TransactionView.of(t, accounts, openingLabel: openingLabel)];
});
