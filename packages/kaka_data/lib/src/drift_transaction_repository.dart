import 'package:drift/drift.dart';
import 'package:kaka_domain/kaka_domain.dart';

import 'database.dart';

class DriftTransactionRepository implements TransactionRepository {
  DriftTransactionRepository(this._db);
  final KakaDatabase _db;

  @override
  Future<void> insert(LedgerTransaction t) => _db.transaction(() async {
    await _db
        .into(_db.transactions)
        .insert(
          TransactionsCompanion.insert(id: t.id, kind: t.kind.name, occurredAt: t.occurredAt, note: Value(t.note)),
        );
    await _db.batch(
      (b) => b.insertAll(_db.postings, [
        for (final p in t.postings)
          PostingsCompanion.insert(
            id: p.id,
            txnId: t.id,
            accountId: p.accountId,
            amountMinor: p.amount.minor,
            currency: p.amount.currency.code,
          ),
      ]),
    );
  });

  @override
  Future<void> markVoided(String id, DateTime at) =>
      (_db.update(_db.transactions)..where((t) => t.id.equals(id))).write(TransactionsCompanion(voidedAt: Value(at)));

  @override
  Stream<List<LedgerTransaction>> watchRecent({int limit = 200}) {
    final txns = _db.select(_db.transactions)
      ..orderBy([(t) => OrderingTerm.desc(t.occurredAt), (t) => OrderingTerm.desc(t.id)])
      ..limit(limit);
    return txns.watch().asyncMap((rows) async {
      if (rows.isEmpty) return const <LedgerTransaction>[];
      final postings = await (_db.select(_db.postings)..where((p) => p.txnId.isIn(rows.map((r) => r.id)))).get();
      final byTxn = <String, List<Posting>>{};
      for (final p in postings) {
        byTxn
            .putIfAbsent(p.txnId, () => [])
            .add(Posting(id: p.id, accountId: p.accountId, amount: Money(p.amountMinor, Currency.byCode(p.currency))));
      }
      return [
        for (final r in rows)
          LedgerTransaction(
            id: r.id,
            kind: TransactionKind.values.byName(r.kind),
            occurredAt: r.occurredAt,
            note: r.note,
            voidedAt: r.voidedAt,
            postings: byTxn[r.id] ?? const [],
          ),
      ];
    });
  }

  @override
  Stream<Map<String, int>> watchPostedSums() {
    final sum = _db.postings.amountMinor.sum();
    final q =
        _db.selectOnly(_db.postings).join([
            innerJoin(_db.transactions, _db.transactions.id.equalsExp(_db.postings.txnId), useColumns: false),
          ])
          ..addColumns([_db.postings.accountId, sum])
          ..where(_db.transactions.voidedAt.isNull())
          ..groupBy([_db.postings.accountId]);
    return q.watch().map((rows) => {for (final r in rows) r.read(_db.postings.accountId)!: r.read(sum) ?? 0});
  }
}
