import 'package:kaka_domain/kaka_domain.dart';
import 'package:test/test.dart';

class _MemDrafts implements DraftRepository {
  final items = <String, Draft>{};
  @override
  Future<bool> existsWithDedupKey(String key) async => items.values.any((d) => d.dedupKey == key);
  @override
  Future<Draft?> findById(String id) async => items[id];
  @override
  Future<void> upsert(Draft d) async => items[d.id] = d;
  @override
  Stream<List<Draft>> watchPending() =>
      Stream.value(items.values.where((d) => d.status == DraftStatus.pending).toList());
}

class _MemRules implements RecurringRepository {
  final items = <String, RecurringRule>{};
  @override
  Future<void> delete(String id) async => items.remove(id);
  @override
  Future<List<RecurringRule>> getAll() async => items.values.toList();
  @override
  Future<void> upsert(RecurringRule r) async => items[r.id] = r;
  @override
  Stream<List<RecurringRule>> watchAll() => Stream.value(items.values.toList());
}

RecurringRule _rule({RecurrenceEvery every = RecurrenceEvery.monthly, DateTime? start, DateTime? lastDone}) =>
    RecurringRule(
      id: 'rent',
      isExpense: true,
      accountId: 'card',
      category: 'اجاره',
      amount: const Money(150000000, Currency.irr),
      every: every,
      start: start ?? DateTime(2026, 1, 31, 9),
      lastDone: lastDone,
    );

void main() {
  test('monthly keeps the day, clamped, without drifting after short months', () {
    final r = _rule();
    expect(
      [for (var k = 0; k < 4; k++) Recurrence.occurrence(r, k, gregorianAddMonths)],
      [DateTime(2026, 1, 31, 9), DateTime(2026, 2, 28, 9), DateTime(2026, 3, 31, 9), DateTime(2026, 4, 30, 9)],
    );
    expect(gregorianAddMonths(DateTime(2026, 11, 15), 3), DateTime(2027, 2, 15));
  });

  test('due: after lastDone up to now, capped to the latest, paused = none', () {
    final now = DateTime(2026, 4, 30, 10);
    expect(Recurrence.due(_rule(), now, gregorianAddMonths), hasLength(4));
    expect(Recurrence.due(_rule(lastDone: DateTime(2026, 3, 31, 9)), now, gregorianAddMonths), [
      DateTime(2026, 4, 30, 9),
    ]);
    expect(Recurrence.due(_rule(lastDone: DateTime(2026, 4, 30, 9)), now, gregorianAddMonths), isEmpty);
    final weekly = _rule(every: RecurrenceEvery.weekly, start: DateTime(2026, 1, 1));
    final d = Recurrence.due(weekly, DateTime(2026, 12, 31), gregorianAddMonths);
    expect(d, hasLength(6));
    expect(d.last, DateTime(2026, 12, 31));
    expect(Recurrence.due(_rule().copyWith(active: false), now, gregorianAddMonths), isEmpty);
    expect(Recurrence.next(_rule(lastDone: DateTime(2026, 2, 28, 9)), gregorianAddMonths), DateTime(2026, 3, 31, 9));
  });

  test('service queues each occurrence once and advances lastDone', () async {
    final rules = _MemRules(), drafts = _MemDrafts();
    var now = DateTime(2026, 3, 1);
    final service = RecurringService(rules, DraftService(drafts), addMonths: gregorianAddMonths, clock: () => now);
    await rules.upsert(_rule());
    expect(await service.run(), 2); // Jan 31, Feb 28
    expect(await service.run(), 0);
    final queued = drafts.items.values.toList()..sort((a, b) => a.occurredAt!.compareTo(b.occurredAt!));
    expect(queued.map((d) => (d.source, d.occurredAt, d.category, d.isExpense, d.accountId)), [
      (DraftSource.recurring, DateTime(2026, 1, 31, 9), 'اجاره', true, 'card'),
      (DraftSource.recurring, DateTime(2026, 2, 28, 9), 'اجاره', true, 'card'),
    ]);
    expect(rules.items['rent']!.lastDone, DateTime(2026, 2, 28, 9));
    now = DateTime(2026, 4, 1);
    expect(await service.run(), 1);

    // Transfers carry the destination.
    await rules.upsert(
      RecurringRule(
        id: 'save',
        isExpense: false,
        accountId: 'card',
        toAccountId: 'savings',
        amount: const Money(1, Currency.irr),
        every: RecurrenceEvery.monthly,
        start: DateTime(2026, 4, 1),
      ),
    );
    expect(await service.run(), 1);
    expect(drafts.items.values.where((d) => d.isTransfer).single.toAccountId, 'savings');
  });
}
