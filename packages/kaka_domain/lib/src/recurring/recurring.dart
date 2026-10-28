import 'package:meta/meta.dart';

import '../drafts/draft.dart';
import '../ids.dart';
import '../money/money.dart';

enum RecurrenceEvery { weekly, monthly }

/// "Every month on the 1st: rent 15m from Melli card." Due occurrences become
/// question-queue drafts — nothing is recorded without the user confirming.
@immutable
class RecurringRule {
  const RecurringRule({
    required this.id,
    required this.isExpense,
    required this.accountId,
    required this.amount,
    required this.every,
    required this.start,
    this.toAccountId,
    this.category,
    this.note = '',
    this.lastDone,
    this.active = true,
  });

  final String id;

  /// Ignored for transfers ([toAccountId] set).
  final bool isExpense;
  final String accountId;
  final String? toAccountId;
  final String? category;
  final Money amount;
  final String note;
  final RecurrenceEvery every;

  /// First occurrence; later ones keep its weekday / day of month.
  final DateTime start;

  /// Latest occurrence already queued or recorded.
  final DateTime? lastDone;
  final bool active;

  bool get isTransfer => toAccountId != null;

  RecurringRule copyWith({DateTime? lastDone, bool? active}) => RecurringRule(
    id: id,
    isExpense: isExpense,
    accountId: accountId,
    toAccountId: toAccountId,
    category: category,
    amount: amount,
    note: note,
    every: every,
    start: start,
    lastDone: lastDone ?? this.lastDone,
    active: active ?? this.active,
  );
}

abstract interface class RecurringRepository {
  Stream<List<RecurringRule>> watchAll();
  Future<List<RecurringRule>> getAll();
  Future<void> upsert(RecurringRule rule);
  Future<void> delete(String id);
}

/// [n] months after [anchor] keeping its day of month (clamped to the month's
/// length) and time. The app passes a Jalali one for Shamsi users.
typedef MonthAdder = DateTime Function(DateTime anchor, int n);

DateTime gregorianAddMonths(DateTime a, int n) {
  final first = DateTime(a.year, a.month + n);
  final length = DateTime(first.year, first.month + 1, 0).day;
  return DateTime(first.year, first.month, a.day > length ? length : a.day, a.hour, a.minute);
}

abstract final class Recurrence {
  /// The [k]th occurrence (0 = start).
  static DateTime occurrence(RecurringRule r, int k, MonthAdder addMonths) => switch (r.every) {
    RecurrenceEvery.weekly => DateTime(r.start.year, r.start.month, r.start.day + 7 * k, r.start.hour, r.start.minute),
    RecurrenceEvery.monthly => addMonths(r.start, k),
  };

  /// Occurrences after `lastDone` (from `start` when never done) up to [now],
  /// oldest first, at most the latest [cap] (a phone off for a year shouldn't
  /// flood the queue).
  static List<DateTime> due(RecurringRule r, DateTime now, MonthAdder addMonths, {int cap = 6}) {
    if (!r.active) return const [];
    final out = <DateTime>[];
    for (var k = 0; k < 10000; k++) {
      final d = occurrence(r, k, addMonths);
      if (d.isAfter(now)) break;
      if (r.lastDone == null || d.isAfter(r.lastDone!)) out.add(d);
    }
    return out.length > cap ? out.sublist(out.length - cap) : out;
  }

  /// The first occurrence after `lastDone` (or the start), for display.
  static DateTime next(RecurringRule r, MonthAdder addMonths) {
    for (var k = 0; k < 10000; k++) {
      final d = occurrence(r, k, addMonths);
      if (r.lastDone == null || d.isAfter(r.lastDone!)) return d;
    }
    return r.start;
  }
}

class RecurringService {
  RecurringService(this._rules, this._drafts, {required MonthAdder addMonths, DateTime Function()? clock})
    : _addMonths = addMonths,
      _now = clock ?? DateTime.now;
  final RecurringRepository _rules;
  final DraftService _drafts;
  final MonthAdder _addMonths;
  final DateTime Function() _now;

  /// Queues every due occurrence once (dedup key per rule and date) and moves
  /// `lastDone` forward. Returns how many drafts were added.
  Future<int> run() async {
    final now = _now();
    var added = 0;
    for (final r in await _rules.getAll()) {
      final due = Recurrence.due(r, now, _addMonths);
      if (due.isEmpty) continue;
      for (final d in due) {
        final ok = await _drafts.enqueue(
          Draft(
            id: Ids.next(),
            source: DraftSource.recurring,
            isExpense: r.isTransfer || r.isExpense,
            amount: r.amount,
            createdAt: now,
            occurredAt: d,
            note: r.note,
            accountId: r.accountId,
            toAccountId: r.toAccountId,
            category: r.category,
            dedupKey: 'rec:${r.id}:${d.toIso8601String()}',
          ),
        );
        if (ok) added++;
      }
      await _rules.upsert(r.copyWith(lastDone: due.last));
    }
    return added;
  }
}
