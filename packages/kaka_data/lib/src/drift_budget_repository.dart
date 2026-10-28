import 'package:kaka_domain/kaka_domain.dart';

import 'database.dart';

class DriftBudgetRepository implements BudgetRepository {
  DriftBudgetRepository(this._db);
  final KakaDatabase _db;

  @override
  Stream<List<Budget>> watchAll() => _db.select(_db.budgets).watch().map((r) => r.map(_toDomain).toList());

  @override
  Future<List<Budget>> getAll() async => (await _db.select(_db.budgets).get()).map(_toDomain).toList();

  @override
  Future<void> upsert(Budget b) => _db
      .into(_db.budgets)
      .insertOnConflictUpdate(
        BudgetsCompanion.insert(
          id: b.id,
          category: b.category,
          limitMinor: b.limit.minor,
          currency: b.limit.currency.code,
        ),
      );

  @override
  Future<void> delete(String id) => (_db.delete(_db.budgets)..where((b) => b.id.equals(id))).go();

  /// Keeps budgets attached when a category is renamed (or merged into an existing name).
  Future<void> renameCategory(String from, String to) async {
    final old = await (_db.select(_db.budgets)..where((b) => b.category.equals(from))).getSingleOrNull();
    if (old == null || from == to) return;
    await _db.transaction(() async {
      await delete(old.id);
      final clash = await (_db.select(_db.budgets)..where((b) => b.category.equals(to))).getSingleOrNull();
      if (clash == null) {
        await upsert(
          Budget(id: Budget.idFor(to), category: to, limit: Money(old.limitMinor, Currency.byCode(old.currency))),
        );
      }
    });
  }

  static Budget _toDomain(BudgetRow r) =>
      Budget(id: r.id, category: r.category, limit: Money(r.limitMinor, Currency.byCode(r.currency)));
}
