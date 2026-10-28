import 'package:drift/drift.dart';
import 'package:kaka_domain/kaka_domain.dart';

import 'database.dart';

class DriftAccountRepository implements AccountRepository {
  DriftAccountRepository(this._db);
  final KakaDatabase _db;

  @override
  Stream<List<Account>> watchAll() => _query().watch().map((rows) => rows.map(_toDomain).toList());

  @override
  Future<List<Account>> getAll() async => (await _query().get()).map(_toDomain).toList();

  @override
  Future<Account?> findById(String id) async {
    final row = await (_db.select(_db.accounts)..where((a) => a.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  @override
  Future<void> upsert(Account a) => _db
      .into(_db.accounts)
      .insertOnConflictUpdate(
        AccountsCompanion.insert(
          id: a.id,
          name: a.name,
          type: a.type.name,
          currency: a.currency.code,
          isSystem: Value(a.isSystem),
          archived: Value(a.archived),
          icon: Value(a.icon),
          createdAt: a.createdAt,
        ),
      );

  SimpleSelectStatement<$AccountsTable, AccountRow> _query() =>
      _db.select(_db.accounts)..orderBy([(a) => OrderingTerm(expression: a.createdAt)]);

  static Account _toDomain(AccountRow r) => Account(
    id: r.id,
    name: r.name,
    type: AccountType.values.byName(r.type),
    currency: Currency.byCode(r.currency),
    createdAt: r.createdAt,
    isSystem: r.isSystem,
    archived: r.archived,
    icon: r.icon,
  );
}
