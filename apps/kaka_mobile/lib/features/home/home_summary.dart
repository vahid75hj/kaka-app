import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaka_domain/kaka_domain.dart';

import '../../app/providers.dart';

/// Totals for the home screen. No exchange rates yet (MVP-2), so other
/// currencies are totalled separately instead of converted.
class HomeSummary {
  const HomeSummary({
    required this.netWorth,
    required this.otherCurrencies,
    required this.monthIncome,
    required this.monthExpense,
    required this.accounts,
  });

  final Money netWorth;
  final List<Money> otherCurrencies;
  final Money monthIncome;
  final Money monthExpense;
  final List<AccountBalance> accounts;
}

final homeSummaryProvider = Provider<HomeSummary>((ref) {
  final settings = ref.watch(settingsProvider);
  final base = settings.baseUnit.currency;
  final balances = ref.watch(balancesProvider).value ?? const <AccountBalance>[];
  final txns = ref.watch(transactionsProvider).value ?? const <LedgerTransaction>[];
  final monthStart = ref.watch(formatProvider).startOfMonth(DateTime.now());

  final visible = balances.where((b) => b.account.type.isBalanceSheet && !b.account.archived).toList();
  final totals = <Currency, int>{};
  for (final b in visible) {
    totals.update(b.account.currency, (v) => v + b.balance.minor, ifAbsent: () => b.balance.minor);
  }

  final types = {for (final b in balances) b.account.id: b.account.type};
  var income = 0, expense = 0;
  for (final t in txns.where((t) => !t.isVoided && !t.occurredAt.isBefore(monthStart))) {
    for (final p in t.postings.where((p) => p.amount.currency == base)) {
      switch (types[p.accountId]) {
        case AccountType.income:
          income -= p.amount.minor;
        case AccountType.expense:
          expense += p.amount.minor;
        default:
      }
    }
  }

  return HomeSummary(
    netWorth: Money(totals.remove(base) ?? 0, base),
    otherCurrencies: [for (final e in totals.entries) Money(e.value, e.key)],
    monthIncome: Money(income, base),
    monthExpense: Money(expense, base),
    accounts: visible,
  );
});
