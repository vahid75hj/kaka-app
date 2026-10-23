import '../assets/assets.dart';
import '../fx/exchange_rate.dart';
import '../ledger/account.dart';
import '../ledger/ledger_service.dart';
import '../ledger/ledger_transaction.dart';
import '../money/currency.dart';
import '../money/money.dart';

class NetWorth {
  const NetWorth({required this.total, required this.unconverted, this.oldestRate});

  /// Everything convertible, in the base currency.
  final Money total;

  /// Amounts with no known rate, per currency (shown separately).
  final List<Money> unconverted;

  /// Date of the oldest rate used, for a "rates from …" label.
  final DateTime? oldestRate;

  static NetWorth of(List<AccountBalance> balances, List<AssetHolding> assets, CurrencyConverter fx) {
    var total = 0;
    final missing = <Currency, int>{};
    DateTime? oldest;
    void add(Money m) {
      final converted = fx.toBase(m);
      if (converted == null) {
        missing.update(m.currency, (v) => v + m.minor, ifAbsent: () => m.minor);
        return;
      }
      total += converted.minor;
      if (m.currency != fx.base) {
        final d = fx.rateFor(m.currency)!.date;
        if (oldest == null || d.isBefore(oldest!)) oldest = d;
      }
    }

    for (final b in balances.where((b) => b.account.type.isBalanceSheet && !b.account.archived)) {
      add(b.balance);
    }
    for (final h in assets) {
      final v = h.value;
      if (v != null) add(v);
    }
    return NetWorth(
      total: Money(total, fx.base),
      unconverted: [
        for (final e in missing.entries)
          if (e.value != 0) Money(e.value, e.key),
      ],
      oldestRate: oldest,
    );
  }
}

class CategoryTotal {
  const CategoryTotal(this.name, this.amount);
  final String name;
  final Money amount;
}

/// Income and expense per category for [from]..[to) in the base currency.
class MonthlyReport {
  const MonthlyReport({required this.base, required this.income, required this.expense, required this.skipped});
  final Currency base;
  final List<CategoryTotal> income;
  final List<CategoryTotal> expense;

  /// Postings whose currency had no rate.
  final int skipped;

  Money get totalIncome => _sum(income);
  Money get totalExpense => _sum(expense);
  Money _sum(List<CategoryTotal> l) => Money(l.fold(0, (s, c) => s + c.amount.minor), base);

  static MonthlyReport build(
    List<LedgerTransaction> txns,
    Map<String, Account> accounts,
    CurrencyConverter fx, {
    required DateTime from,
    required DateTime to,
  }) {
    final inc = <String, int>{}, exp = <String, int>{};
    var skipped = 0;
    for (final t in txns) {
      if (t.isVoided || t.occurredAt.isBefore(from) || !t.occurredAt.isBefore(to)) continue;
      for (final p in t.postings) {
        final a = accounts[p.accountId];
        if (a == null || (a.type != AccountType.income && a.type != AccountType.expense)) continue;
        final m = fx.toBase(p.amount, on: t.occurredAt) ?? fx.toBase(p.amount);
        if (m == null) {
          skipped++;
          continue;
        }
        if (a.type == AccountType.expense) {
          exp.update(a.name, (v) => v + m.minor, ifAbsent: () => m.minor);
        } else {
          inc.update(a.name, (v) => v - m.minor, ifAbsent: () => -m.minor);
        }
      }
    }
    List<CategoryTotal> sorted(Map<String, int> m) =>
        [for (final e in m.entries) CategoryTotal(e.key, Money(e.value, fx.base))]
          ..sort((a, b) => b.amount.minor.compareTo(a.amount.minor));
    return MonthlyReport(base: fx.base, income: sorted(inc), expense: sorted(exp), skipped: skipped);
  }
}
