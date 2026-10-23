import 'package:drift/drift.dart';
import 'package:kaka_domain/kaka_domain.dart';

import 'database.dart';

class DriftSmsLinkRepository implements SmsLinkRepository {
  DriftSmsLinkRepository(this._db);
  final KakaDatabase _db;

  @override
  Stream<List<SmsLink>> watchAll() => _db.select(_db.smsLinks).watch().map((r) => r.map(_toDomain).toList());

  @override
  Future<List<SmsLink>> getAll() async => (await _db.select(_db.smsLinks).get()).map(_toDomain).toList();

  @override
  Future<void> upsert(SmsLink l) => _db
      .into(_db.smsLinks)
      .insertOnConflictUpdate(
        SmsLinksCompanion.insert(
          id: l.id,
          sender: Value(l.sender),
          accountId: Value(l.accountId),
          accountNumber: Value(l.accountNumber),
        ),
      );

  @override
  Future<void> delete(String id) => (_db.delete(_db.smsLinks)..where((l) => l.id.equals(id))).go();

  static SmsLink _toDomain(SmsLinkRow r) =>
      SmsLink(id: r.id, sender: r.sender, accountId: r.accountId, accountNumber: r.accountNumber);
}
