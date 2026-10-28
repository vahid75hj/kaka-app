import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kaka_domain/kaka_domain.dart';

import '../../app/providers.dart';
import '../../app/router.dart';
import '../budgets/budgets_screen.dart';
import '../../core/l10n_x.dart';
import '../../core/widgets.dart';
import '../../theme/kaka_colors.dart';
import '../accounts/account_card.dart';
import '../transactions/transaction_tile.dart';
import '../backup/backup_actions.dart';
import 'home_summary.dart';

/// "Later" on the backup reminder hides it until the app restarts.
class _Snooze extends Notifier<bool> {
  @override
  bool build() => false;
  void snooze() => state = true;
}

/// Steps of the home checklist: (done, which step).
enum GettingStartedStep { account, transaction, sms, backup }

final gettingStartedProvider = Provider<Map<GettingStartedStep, bool>>((ref) {
  final s = ref.watch(settingsProvider);
  final accounts = ref.watch(accountsProvider).value ?? const [];
  final txns = ref.watch(transactionsProvider).value ?? const [];
  return {
    GettingStartedStep.account: accounts.any((a) => !a.isSystem && a.type.isBalanceSheet),
    GettingStartedStep.transaction: txns.any((t) => t.kind != TransactionKind.opening && !t.isVoided),
    GettingStartedStep.sms: s.smsAutoRead || (ref.watch(smsLinksProvider).value ?? const []).isNotEmpty,
    GettingStartedStep.backup: s.lastBackupAt != null,
  };
});

final _backupSnoozedProvider = NotifierProvider<_Snooze, bool>(_Snooze.new);

/// Earliest thing worth backing up: the first non-system account.
final backupDueProvider = Provider<bool>((ref) {
  final s = ref.watch(settingsProvider);
  final first = (ref.watch(accountsProvider).value ?? const [])
      .where((a) => !a.isSystem)
      .map((a) => a.createdAt)
      .fold<DateTime?>(null, (m, d) => m == null || d.isBefore(m) ? d : m);
  return s.backupDue(DateTime.now(), firstActivity: first);
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = KakaColors.of(context);
    final f = ref.watch(formatProvider);
    final summary = ref.watch(homeSummaryProvider);
    final recent = ref.watch(transactionViewsProvider((opening: l.opening, asset: l.goldAndCoins))).take(5).toList();
    final budgets = ref.watch(budgetStatusesProvider);
    final now = DateTime.now();
    final pending = ref.watch(pendingDraftsProvider).value?.length ?? 0;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: c.accentSoft,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: c.accent.withValues(alpha: 0.35), width: 1.4),
                  ),
                  child: Text(
                    l.appName.characters.first,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: c.accentText),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(l.appName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                ),
                IconButton(
                  tooltip: l.queueTitle,
                  onPressed: () => context.push(Routes.queue),
                  icon: Badge(
                    isLabelVisible: pending > 0,
                    label: Text(f.digits('$pending')),
                    child: const Icon(Icons.inbox_outlined),
                  ),
                ),
                _OfflinePill(color: c),
              ],
            ),
            if (pending > 0)
              Padding(
                padding: const EdgeInsets.only(top: 14),
                child: KCard(
                  onTap: () => context.push(Routes.queue),
                  child: Row(
                    children: [
                      Icon(Icons.help_outline_rounded, color: c.accentText),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          f.digits(l.queueBanner(pending)),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded),
                    ],
                  ),
                ),
              ),
            const _GettingStarted(),
            if (ref.watch(backupDueProvider) && !ref.watch(_backupSnoozedProvider))
              Padding(
                padding: const EdgeInsets.only(top: 14),
                child: KCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.shield_outlined, color: c.accentText),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(l.backupDueTitle, style: const TextStyle(fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(l.backupDueBody, style: TextStyle(color: c.textMuted, fontSize: 12.5, height: 1.5)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => ref.read(_backupSnoozedProvider.notifier).snooze(),
                            child: Text(l.later),
                          ),
                          FilledButton.tonal(onPressed: () => exportBackup(context, ref), child: Text(l.backupNow)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 18),
            _Hero(summary: summary),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _MonthStat(
                    label: l.income,
                    value: f.money(summary.monthIncome),
                    color: c.positive,
                    icon: Icons.south_west_rounded,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MonthStat(
                    label: l.expense,
                    value: f.money(summary.monthExpense),
                    color: c.negative,
                    icon: Icons.north_east_rounded,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text('${l.thisMonth} · ${f.monthTitle(now)}', style: TextStyle(color: c.textFaint, fontSize: 12)),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.bar_chart_rounded, size: 18),
                  label: Text(l.monthlyReport),
                  onPressed: () => context.push(Routes.report),
                ),
                ActionChip(
                  avatar: const Icon(Icons.pie_chart_outline_rounded, size: 18),
                  label: Text(l.budgets),
                  onPressed: () => context.push(Routes.budgets),
                ),
                ActionChip(
                  avatar: const Icon(Icons.diamond_outlined, size: 18),
                  label: Text(l.assets),
                  onPressed: () => context.push(Routes.assets),
                ),
                ActionChip(
                  avatar: const Icon(Icons.currency_exchange_rounded, size: 18),
                  label: Text(l.exchangeRates),
                  onPressed: () => context.push(Routes.rates),
                ),
                ActionChip(
                  avatar: const Icon(Icons.auto_awesome_outlined, size: 18),
                  label: Text(l.chat),
                  onPressed: () => context.push(Routes.chat),
                ),
              ],
            ),
            if (budgets.isNotEmpty) ...[
              SectionHeader(l.budgets, action: l.seeAll, onAction: () => context.push(Routes.budgets)),
              KCard(
                child: Column(
                  children: [
                    for (var i = 0; i < budgets.length && i < 3; i++) ...[
                      if (i > 0) const SizedBox(height: 12),
                      BudgetBar(budgets[i], compact: true),
                    ],
                  ],
                ),
              ),
            ],
            SectionHeader(l.accounts, action: l.seeAll, onAction: () => context.go(Routes.accounts)),
            SizedBox(
              height: 112,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: summary.accounts.length + 1,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (_, i) => i == summary.accounts.length
                    ? _AddAccountCard(onTap: () => context.push(Routes.newAccount))
                    : AccountCard(summary.accounts[i], width: 170),
              ),
            ),
            SectionHeader(l.recent, action: l.seeAll, onAction: () => context.go(Routes.transactions)),
            if (recent.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    Text(
                      l.noTransactions,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: c.textMuted),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () => context.push(Routes.addTransaction),
                      icon: const Icon(Icons.add_rounded),
                      label: Text(l.addFirstTransaction),
                    ),
                  ],
                ),
              )
            else
              KCard(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Column(
                  children: [
                    for (var i = 0; i < recent.length; i++) ...[if (i > 0) const Divider(), TransactionTile(recent[i])],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// First-run checklist; disappears when everything is done or the user hides it.
class _GettingStarted extends ConsumerWidget {
  const _GettingStarted();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = KakaColors.of(context);
    final f = ref.watch(formatProvider);
    final steps = ref.watch(gettingStartedProvider);
    if (ref.watch(settingsProvider.select((s) => s.hideGettingStarted)) || steps.values.every((d) => d)) {
      return const SizedBox.shrink();
    }
    final done = steps.values.where((d) => d).length;
    (String, VoidCallback) info(GettingStartedStep s) => switch (s) {
      GettingStartedStep.account => (l.gsAccount, () => context.push(Routes.newAccount)),
      GettingStartedStep.transaction => (l.gsTransaction, () => context.push(Routes.addTransaction)),
      GettingStartedStep.sms => (l.gsSms, () => context.push(Routes.settings)),
      GettingStartedStep.backup => (l.gsBackup, () => exportBackup(context, ref)),
    };
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: KCard(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(l.gettingStarted, style: const TextStyle(fontWeight: FontWeight.w800)),
                ),
                Text(
                  f.digits(l.stepsDone('$done', '${steps.length}')),
                  style: TextStyle(color: c.textMuted, fontSize: 12),
                ),
                TextButton(
                  onPressed: () =>
                      ref.read(settingsProvider.notifier).update((s) => s.copyWith(hideGettingStarted: true)),
                  child: Text(l.hide),
                ),
              ],
            ),
            LinearProgressIndicator(value: done / steps.length, minHeight: 4, borderRadius: BorderRadius.circular(2)),
            const SizedBox(height: 4),
            for (final e in steps.entries)
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                leading: Icon(
                  e.value ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                  color: e.value ? c.positive : c.textFaint,
                ),
                title: Text(
                  info(e.key).$1,
                  style: TextStyle(
                    color: e.value ? c.textMuted : null,
                    decoration: e.value ? TextDecoration.lineThrough : null,
                  ),
                ),
                trailing: e.value ? null : const Icon(Icons.chevron_right_rounded),
                onTap: e.value ? null : info(e.key).$2,
              ),
          ],
        ),
      ),
    );
  }
}

class _OfflinePill extends StatelessWidget {
  const _OfflinePill({required this.color});
  final KakaColors color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      border: Border.all(color: color.line),
      borderRadius: BorderRadius.circular(20),
      color: color.card,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color.positive, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Icon(Icons.lock_outline_rounded, size: 13, color: color.textMuted),
      ],
    ),
  );
}

class _Hero extends ConsumerWidget {
  const _Hero({required this.summary});
  final HomeSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = KakaColors.of(context);
    final f = ref.watch(formatProvider);
    final l = context.l10n;
    const fg = Color(0xFFF5F5F5);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A2A)),
        gradient: RadialGradient(
          center: AlignmentDirectional.topStart.resolve(Directionality.of(context)),
          radius: 1.3,
          colors: [c.accent.withValues(alpha: 0.18), const Color(0xFF151515)],
        ),
        color: const Color(0xFF151515),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.netWorth, style: const TextStyle(color: Color(0xFF9A9A9A), fontSize: 13)),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                AmountText(
                  f.number(summary.netWorth),
                  color: summary.netWorth.isNegative ? c.negative : fg,
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, letterSpacing: -1),
                ),
                const SizedBox(width: 6),
                Text(
                  f.symbol(summary.netWorth.currency),
                  style: const TextStyle(color: Color(0xFF9A9A9A), fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          if (summary.ratesFrom != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                f.digits(
                  DateTime.now().difference(summary.ratesFrom!).inDays > 7
                      ? context.l10n.ratesStale(f.date(summary.ratesFrom!))
                      : context.l10n.ratesAsOf(f.date(summary.ratesFrom!)),
                ),
                style: const TextStyle(color: Color(0xFF9A9A9A), fontSize: 12),
              ),
            ),
          if (summary.otherCurrencies.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(context.l10n.noRateFor, style: const TextStyle(color: Color(0xFF9A9A9A), fontSize: 12)),
            const SizedBox(height: 4),
            const Divider(color: Color(0x14FFFFFF)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 16,
              runSpacing: 6,
              children: [
                for (final m in summary.otherCurrencies)
                  AmountText(f.money(m), color: fg, style: const TextStyle(fontSize: 13)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _MonthStat extends StatelessWidget {
  const _MonthStat({required this.label, required this.value, required this.color, required this.icon});
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) => KCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 5),
            Text(label, style: TextStyle(fontSize: 12, color: KakaColors.of(context).textMuted)),
          ],
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: AmountText(value, style: const TextStyle(fontSize: 17)),
        ),
      ],
    ),
  );
}

class _AddAccountCard extends StatelessWidget {
  const _AddAccountCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 80,
    child: KCard(
      onTap: onTap,
      child: Center(child: Icon(Icons.add_rounded, color: KakaColors.of(context).accentText)),
    ),
  );
}
