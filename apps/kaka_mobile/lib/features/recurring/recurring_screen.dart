import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kaka_domain/kaka_domain.dart';

import '../../app/providers.dart';
import '../../app/router.dart';
import '../../core/app_format.dart';
import '../../core/l10n_x.dart';
import '../../core/widgets.dart';
import '../../theme/kaka_colors.dart';

class RecurringScreen extends ConsumerWidget {
  const RecurringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = KakaColors.of(context);
    final f = ref.watch(formatProvider);
    final add = monthAdderFor(f.settings.calendar);
    final rules = [...ref.watch(recurringRulesProvider).value ?? const <RecurringRule>[]]
      ..sort((a, b) => Recurrence.next(a, add).compareTo(Recurrence.next(b, add)));
    final accounts = {for (final a in ref.watch(accountsProvider).value ?? const <Account>[]) a.id: a};
    return Scaffold(
      appBar: AppBar(title: Text(l.recurring)),
      body: rules.isEmpty
          ? EmptyState(
              icon: Icons.repeat_rounded,
              message: l.noRecurring,
              action: l.addTransaction,
              onAction: () => context.push(Routes.addTransaction),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
              itemCount: rules.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final r = rules[i];
                final from = accounts[r.accountId]?.name ?? '?';
                final title = r.isTransfer
                    ? '$from → ${accounts[r.toAccountId]?.name ?? '?'}'
                    : '${r.category ?? l.catOther} · $from';
                final every = r.every == RecurrenceEvery.weekly ? l.repeatWeekly : l.repeatMonthly;
                return KCard(
                  padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 2),
                            AmountText(
                              f.money(r.amount, signed: !r.isTransfer && !r.isExpense),
                              style: TextStyle(
                                color: r.isTransfer ? c.text : (r.isExpense ? c.negative : c.positive),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$every · ${r.active ? l.recurringNext(f.date(Recurrence.next(r, add))) : l.recurringPaused}',
                              style: TextStyle(color: c.textMuted, fontSize: 12),
                            ),
                            if (r.note.isNotEmpty)
                              Text(
                                r.note,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: c.textFaint, fontSize: 12),
                              ),
                          ],
                        ),
                      ),
                      Switch(
                        value: r.active,
                        onChanged: (on) => ref.read(recurringRepositoryProvider).upsert(_resumed(r, on)),
                      ),
                      IconButton(
                        tooltip: l.delete,
                        icon: const Icon(Icons.delete_outline_rounded),
                        onPressed: () async {
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (d) => AlertDialog(
                              content: Text(l.recurringDeleteConfirm),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(d, false), child: Text(l.cancel)),
                                FilledButton(onPressed: () => Navigator.pop(d, true), child: Text(l.delete)),
                              ],
                            ),
                          );
                          if (ok ?? false) await ref.read(recurringRepositoryProvider).delete(r.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  /// Resuming skips what was missed while paused instead of flooding the queue.
  static RecurringRule _resumed(RecurringRule r, bool on) =>
      on && !r.active ? r.copyWith(active: true, lastDone: DateTime.now()) : r.copyWith(active: on);
}
