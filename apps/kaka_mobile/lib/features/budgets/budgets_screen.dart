import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaka_domain/kaka_domain.dart';

import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/router.dart';
import '../../core/category_icons.dart';
import '../../core/l10n_x.dart';
import '../../core/money_input.dart';
import '../../core/widgets.dart';
import '../../theme/kaka_colors.dart';
import '../categories/categories_screen.dart';

/// This month's budget statuses in the user's calendar, most used first.
final budgetStatusesProvider = Provider<List<BudgetStatus>>((ref) {
  final budgets = ref.watch(budgetsProvider).value ?? const <Budget>[];
  if (budgets.isEmpty) return const [];
  final f = ref.watch(formatProvider);
  final now = DateTime.now();
  final from = f.startOfMonth(now), to = f.addMonths(from, 1);
  final txns = ref.watch(transactionsProvider).value ?? const <LedgerTransaction>[];
  final accounts = {for (final a in ref.watch(accountsProvider).value ?? const <Account>[]) a.id: a};
  final report = MonthlyReport.build(txns, accounts, ref.watch(converterProvider), from: from, to: to);
  return BudgetMath.of(budgets, report, from: from, to: to, now: now);
});

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final f = ref.watch(formatProvider);
    final statuses = ref.watch(budgetStatusesProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.budgets)),
      floatingActionButton: statuses.isEmpty
          ? null
          : FloatingActionButton(
              tooltip: l.addBudget,
              onPressed: () => editBudget(context, ref),
              child: const Icon(Icons.add_rounded),
            ),
      body: statuses.isEmpty
          ? EmptyState(
              icon: Icons.pie_chart_outline_rounded,
              message: l.noBudgets,
              action: l.addBudget,
              onAction: () => editBudget(context, ref),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(f.monthTitle(DateTime.now()), style: const TextStyle(fontWeight: FontWeight.w800)),
                ),
                for (final s in statuses)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: KCard(
                      onTap: () => context.push(
                        Routes.filteredTransactions,
                        extra: TransactionQuery(
                          category: s.budget.category,
                          kinds: const {TransactionKind.expense},
                          showVoided: false,
                          from: f.startOfMonth(DateTime.now()),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(child: BudgetBar(s)),
                          IconButton(
                            tooltip: l.editBudget,
                            icon: const Icon(Icons.edit_outlined, size: 20),
                            onPressed: () => editBudget(context, ref, existing: s.budget),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

/// Category name, "spent of limit" and a bar coloured by [BudgetState].
class BudgetBar extends ConsumerWidget {
  const BudgetBar(this.status, {super.key, this.compact = false});
  final BudgetStatus status;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = KakaColors.of(context);
    final f = ref.watch(formatProvider);
    final s = status;
    final color = switch (s.state) {
      BudgetState.over => c.negative,
      BudgetState.ahead => Colors.orange.shade700,
      BudgetState.ok => c.positive,
    };
    final remaining = s.remaining;
    final note = s.spent == null
        ? l.budgetCurrencyChanged
        : switch (s.state) {
            BudgetState.over => l.budgetOver(f.money(Money(-remaining!.minor, remaining.currency))),
            BudgetState.ahead => l.budgetAhead(f.money(remaining!)),
            BudgetState.ok => l.budgetLeft(f.money(remaining!)),
          };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(
              CategoryIcons.of(null, name: s.budget.category, type: AccountType.expense),
              size: 18,
              color: c.textMuted,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                s.budget.category,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              flex: 2,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerEnd,
                child: AmountText(
                  s.spent == null
                      ? f.money(s.budget.limit)
                      : l.budgetSpentOf(f.number(s.spent!), f.money(s.budget.limit)),
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: s.ratio.clamp(0.0, 1.0),
            minHeight: compact ? 8 : 10,
            color: color,
            backgroundColor: c.line,
          ),
        ),
        if (!compact || s.state != BudgetState.ok) ...[
          const SizedBox(height: 4),
          Text(note, style: TextStyle(fontSize: 12, color: s.state == BudgetState.ok ? c.textMuted : color)),
        ],
      ],
    );
  }
}

Future<void> editBudget(BuildContext context, WidgetRef ref, {Budget? existing}) async {
  final l = context.l10n;
  final f = ref.read(formatProvider);
  final base = ref.read(settingsProvider).baseUnit.currency;
  final taken = {for (final b in ref.read(budgetsProvider).value ?? const <Budget>[]) b.category};
  final categories = [
    for (final e in CategoryEntry.group(ref.read(accountsProvider).value ?? const <Account>[], AccountType.expense))
      if (!e.archived && (e.name == existing?.category || !taken.contains(e.name))) e.name,
  ];
  if (existing != null && !categories.contains(existing.category)) categories.insert(0, existing.category);
  if (categories.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.allCategoriesBudgeted)));
    return;
  }
  var category = existing?.category ?? categories.first;
  final amount = TextEditingController(
    text: existing != null && existing.limit.currency == base
        ? f.number(existing.limit).replaceAll(RegExp('[,٬]'), '')
        : '',
  );
  String? error;
  await showDialog<void>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (dialogContext, setState) => AlertDialog(
        title: Text(existing == null ? l.addBudget : l.editBudget),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              initialValue: category,
              isExpanded: true,
              decoration: InputDecoration(labelText: l.category),
              items: [for (final n in categories) DropdownMenuItem(value: n, child: Text(n))],
              onChanged: existing != null ? null : (v) => setState(() => category = v ?? category),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amount,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: l.monthlyLimit, suffixText: f.symbol(base), errorText: error),
            ),
          ],
        ),
        actions: [
          if (existing != null)
            TextButton(
              onPressed: () async {
                await ref.read(budgetRepositoryProvider).delete(existing.id);
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              },
              child: Text(l.delete),
            ),
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(l.cancel)),
          FilledButton(
            onPressed: () async {
              Money limit;
              try {
                limit = parseUserMoney(f, amount.text, base);
              } catch (_) {
                setState(() => error = l.errAmount);
                return;
              }
              if (limit.minor <= 0) {
                setState(() => error = l.errAmount);
                return;
              }
              await ref
                  .read(budgetRepositoryProvider)
                  .upsert(Budget(id: Budget.idFor(category), category: category, limit: limit));
              if (dialogContext.mounted) Navigator.pop(dialogContext);
            },
            child: Text(l.save),
          ),
        ],
      ),
    ),
  );
  amount.dispose();
}
