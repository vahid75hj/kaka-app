import 'package:drift/drift.dart';
import 'package:kaka_domain/kaka_domain.dart';

import 'database.dart';

class DriftRecurringRepository implements RecurringRepository {
  DriftRecurringRepository(this._db);
  final KakaDatabase _db;

  @override
  Stream<List<RecurringRule>> watchAll() =>
      _db.select(_db.recurringRules).watch().map((r) => r.map(_toDomain).toList());

  @override
  Future<List<RecurringRule>> getAll() async => (await _db.select(_db.recurringRules).get()).map(_toDomain).toList();

  @override
  Future<void> upsert(RecurringRule r) => _db
      .into(_db.recurringRules)
      .insertOnConflictUpdate(
        RecurringRulesCompanion.insert(
          id: r.id,
          isExpense: r.isExpense,
          accountId: r.accountId,
          toAccountId: Value(r.toAccountId),
          category: Value(r.category),
          amountMinor: r.amount.minor,
          currency: r.amount.currency.code,
          note: Value(r.note),
          every: r.every.name,
          start: r.start,
          lastDone: Value(r.lastDone),
          active: Value(r.active),
        ),
      );

  @override
  Future<void> delete(String id) => (_db.delete(_db.recurringRules)..where((r) => r.id.equals(id))).go();

  /// Keeps rules attached when a category of that kind is renamed.
  Future<void> renameCategory(String from, String to, {required bool isExpense}) {
    final q = _db.update(_db.recurringRules)
      ..where((r) => r.category.equals(from) & r.isExpense.equals(isExpense) & r.toAccountId.isNull());
    return q.write(RecurringRulesCompanion(category: Value(to)));
  }

  static RecurringRule _toDomain(RecurringRuleRow r) => RecurringRule(
    id: r.id,
    isExpense: r.isExpense,
    accountId: r.accountId,
    toAccountId: r.toAccountId,
    category: r.category,
    amount: Money(r.amountMinor, Currency.byCode(r.currency)),
    note: r.note,
    every: RecurrenceEvery.values.asNameMap()[r.every] ?? RecurrenceEvery.monthly,
    start: r.start,
    lastDone: r.lastDone,
    active: r.active,
  );
}
