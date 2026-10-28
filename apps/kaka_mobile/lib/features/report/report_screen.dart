import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaka_domain/kaka_domain.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/providers.dart';
import '../../core/l10n_x.dart';
import '../../core/widgets.dart';
import '../../theme/kaka_colors.dart';

/// Income / expense by category for one month (Jalali or Gregorian), in the base currency.
class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  late DateTime _month = ref.read(formatProvider).startOfMonth(DateTime.now());

  Future<void> _exportCsv(List<LedgerTransaction> txns, Map<String, Account> accounts, DateTime end) async {
    final inMonth = txns.where((t) => !t.occurredAt.isBefore(_month) && t.occurredAt.isBefore(end));
    final file = File('${(await getTemporaryDirectory()).path}/kaka-${_month.toIso8601String().substring(0, 7)}.csv');
    await file.writeAsString(TransactionCsv.build(inMonth, accounts), flush: true);
    await SharePlus.instance.share(ShareParams(files: [XFile(file.path, mimeType: 'text/csv')]));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = KakaColors.of(context);
    final f = ref.watch(formatProvider);
    final fa = ref.watch(settingsProvider).isPersian;
    final end = f.addMonths(_month, 1);
    final txns = ref.watch(transactionsProvider).value ?? const <LedgerTransaction>[];
    final accounts = {for (final a in ref.watch(accountsProvider).value ?? const <Account>[]) a.id: a};
    final report = MonthlyReport.build(txns, accounts, ref.watch(converterProvider), from: _month, to: end);
    final net = report.totalIncome - report.totalExpense;

    final limits = {
      for (final b in ref.watch(budgetsProvider).value ?? const <Budget>[])
        if (b.limit.currency == report.base) b.category: b.limit,
    };

    Widget bars(List<CategoryTotal> items, Color color, {bool budgets = false}) {
      if (items.isEmpty) return Text(l.noTransactions, style: TextStyle(color: c.textMuted));
      final max = items.first.amount.minor.abs().clamp(1, 1 << 62);
      return Column(
        children: [
          for (final i in items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(i.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerEnd,
                          child: AmountText(
                            budgets && limits[i.name] != null
                                ? l.budgetSpentOf(f.number(i.amount), f.money(limits[i.name]!))
                                : f.money(i.amount),
                            style: TextStyle(
                              fontSize: 13,
                              color: budgets && limits[i.name] != null && i.amount.minor > limits[i.name]!.minor
                                  ? c.negative
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: i.amount.minor / max,
                      minHeight: 10,
                      color: color,
                      backgroundColor: c.line,
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l.monthlyReport),
        actions: [
          IconButton(
            tooltip: l.exportCsv,
            icon: const Icon(Icons.ios_share_rounded),
            onPressed: () => _exportCsv(txns, accounts, end),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
        children: [
          Row(
            children: [
              IconButton(
                tooltip: l.previousMonth,
                icon: Icon(fa ? Icons.chevron_right_rounded : Icons.chevron_left_rounded),
                onPressed: () => setState(() => _month = f.addMonths(_month, -1)),
              ),
              Expanded(
                child: Text(
                  f.monthTitle(_month),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ),
              IconButton(
                tooltip: l.nextMonth,
                icon: Icon(fa ? Icons.chevron_left_rounded : Icons.chevron_right_rounded),
                onPressed: () => setState(() => _month = f.addMonths(_month, 1)),
              ),
            ],
          ),
          KCard(
            child: Row(
              children: [
                Expanded(child: _Stat(l.income, f.money(report.totalIncome), c.positive)),
                Expanded(child: _Stat(l.expense, f.money(report.totalExpense), c.negative)),
                Expanded(child: _Stat(l.net, f.money(net, signed: true), c.text)),
              ],
            ),
          ),
          if (report.skipped > 0)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(l.reportSkipped, style: TextStyle(color: c.negative, fontSize: 12)),
            ),
          SectionHeader(l.expense),
          bars(report.expense, c.negative, budgets: true),
          SectionHeader(l.income),
          bars(report.income, c.positive),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value, this.color);
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(label, style: TextStyle(color: KakaColors.of(context).textMuted, fontSize: 12)),
      const SizedBox(height: 4),
      FittedBox(child: AmountText(value, color: color)),
    ],
  );
}
