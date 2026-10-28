import 'package:drift/drift.dart';
import 'package:kaka_domain/kaka_domain.dart';

import 'database.dart';

class DriftDraftRepository implements DraftRepository {
  DriftDraftRepository(this._db);
  final KakaDatabase _db;

  @override
  Stream<List<Draft>> watchPending() =>
      (_db.select(_db.drafts)
            ..where((d) => d.status.equals(DraftStatus.pending.name))
            ..orderBy([(d) => OrderingTerm.desc(d.createdAt)]))
          .watch()
          .map((rows) => rows.map(_toDomain).toList());

  @override
  Future<Draft?> findById(String id) async {
    final r = await (_db.select(_db.drafts)..where((d) => d.id.equals(id))).getSingleOrNull();
    return r == null ? null : _toDomain(r);
  }

  @override
  Future<bool> existsWithDedupKey(String key) async =>
      (await (_db.select(_db.drafts)..where((d) => d.dedupKey.equals(key))).get()).isNotEmpty;

  @override
  Future<void> upsert(Draft d) => _db
      .into(_db.drafts)
      .insertOnConflictUpdate(
        DraftsCompanion.insert(
          id: d.id,
          source: d.source.name,
          status: d.status.name,
          isExpense: d.isExpense,
          amountMinor: d.amount.minor,
          currency: d.amount.currency.code,
          createdAt: d.createdAt,
          occurredAt: Value(d.occurredAt),
          rawText: Value(d.rawText),
          note: Value(d.note),
          bankId: Value(d.bankId),
          last4: Value(d.accountRef),
          dedupKey: Value(d.dedupKey),
          accountId: Value(d.accountId),
          balanceMinor: Value(d.balance?.minor),
          sender: Value(d.sender),
          confidence: Value(d.confidence),
          toAccountId: Value(d.toAccountId),
          category: Value(d.category),
        ),
      );

  static Draft _toDomain(DraftRow r) => Draft(
    id: r.id,
    source: DraftSource.values.byName(r.source),
    status: DraftStatus.values.byName(r.status),
    isExpense: r.isExpense,
    amount: Money(r.amountMinor, Currency.byCode(r.currency)),
    createdAt: r.createdAt,
    occurredAt: r.occurredAt,
    rawText: r.rawText,
    note: r.note,
    bankId: r.bankId,
    accountRef: r.last4,
    dedupKey: r.dedupKey,
    accountId: r.accountId,
    balance: r.balanceMinor == null ? null : Money(r.balanceMinor!, Currency.byCode(r.currency)),
    sender: r.sender,
    confidence: r.confidence,
    toAccountId: r.toAccountId,
    category: r.category,
  );
}
