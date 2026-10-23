import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/router.dart';
import '../../core/l10n_x.dart';
import '../../core/widgets.dart';
import '../../theme/kaka_colors.dart';
import '../accounts/account_card.dart';
import '../transactions/transaction_tile.dart';
import 'home_summary.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = KakaColors.of(context);
    final f = ref.watch(formatProvider);
    final summary = ref.watch(homeSummaryProvider);
    final recent = ref.watch(transactionViewsProvider(l.opening)).take(5).toList();
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
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  l.noTransactions,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: c.textMuted),
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
