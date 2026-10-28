import 'package:meta/meta.dart';

import '../money/money.dart';
import 'net_worth.dart';

/// Monthly spending limit for one expense category (by name, like categories
/// themselves), in the base currency.
@immutable
class Budget {
  const Budget({required this.id, required this.category, required this.limit});
  final String id;
  final String category;
  final Money limit;

  /// One budget per category name.
  static String idFor(String category) => 'budget:$category';
}

abstract interface class BudgetRepository {
  Stream<List<Budget>> watchAll();
  Future<List<Budget>> getAll();
  Future<void> upsert(Budget budget);
  Future<void> delete(String id);
}

enum BudgetState { ok, ahead, over }

class BudgetStatus {
  const BudgetStatus(this.budget, this.spent, this.state);
  final Budget budget;

  /// `null` when the budget's currency differs from the report's base (base changed since).
  final Money? spent;
  final BudgetState state;

  double get ratio => spent == null || budget.limit.minor <= 0 ? 0 : spent!.minor / budget.limit.minor;
  Money? get remaining => spent == null ? null : budget.limit - spent!;
}

abstract final class BudgetMath {
  /// Statuses for [report] covering [from]..[to), judged at [now]:
  /// `over` past the limit, `ahead` when spending runs ≥10 points ahead of the
  /// share of the month already gone (and above half the limit), else `ok`.
  /// Sorted by how much of the limit is used.
  static List<BudgetStatus> of(
    List<Budget> budgets,
    MonthlyReport report, {
    required DateTime from,
    required DateTime to,
    required DateTime now,
  }) {
    final spentBy = {for (final c in report.expense) c.name: c.amount};
    final span = to.difference(from).inSeconds;
    final elapsed = span <= 0 ? 1.0 : (now.difference(from).inSeconds / span).clamp(0.0, 1.0);
    final out = <BudgetStatus>[];
    for (final b in budgets) {
      if (b.limit.currency != report.base) {
        out.add(BudgetStatus(b, null, BudgetState.ok));
        continue;
      }
      final spent = spentBy[b.category] ?? Money.zero(report.base);
      final ratio = b.limit.minor <= 0 ? 0.0 : spent.minor / b.limit.minor;
      final state = spent.minor > b.limit.minor
          ? BudgetState.over
          : (ratio >= 0.5 && ratio >= elapsed + 0.1 ? BudgetState.ahead : BudgetState.ok);
      out.add(BudgetStatus(b, spent, state));
    }
    out.sort((a, b) => b.ratio.compareTo(a.ratio));
    return out;
  }
}
