import 'package:meta/meta.dart';

import '../money/money.dart';

/// Where a draft came from. Drafts never touch the ledger until the user confirms.
enum DraftSource { sms, share, ai, manual, recurring }

enum DraftStatus { pending, confirmed, discarded }

/// A suggested transaction waiting in the question queue.
@immutable
class Draft {
  const Draft({
    required this.id,
    required this.source,
    required this.isExpense,
    required this.amount,
    required this.createdAt,
    this.occurredAt,
    this.rawText = '',
    this.note = '',
    this.bankId,
    this.accountRef,
    this.dedupKey,
    this.status = DraftStatus.pending,
    this.accountId,
    this.balance,
    this.sender,
    this.confidence,
    this.toAccountId,
    this.category,
  });

  final String id;
  final DraftSource source;

  /// `true` money left an account, `false` money arrived.
  final bool isExpense;
  final Money amount;
  final DateTime createdAt;
  final DateTime? occurredAt;

  /// Original text (SMS / shared text), kept so the user can see what was parsed.
  final String rawText;
  final String note;
  final String? bankId;

  /// Account number fragment printed in the SMS (e.g. `06009`).
  final String? accountRef;

  /// Kaka account suggested by an SMS link; the user can change it.
  final String? accountId;

  /// Balance the bank reported after this transaction.
  final Money? balance;
  final String? sender;

  /// Parser confidence 0..1 (`null` for non-SMS drafts).
  final double? confidence;

  /// Set for a suggested transfer: money moves from [accountId] to this account.
  final String? toAccountId;

  /// Suggested category name (AI drafts); the user can change it.
  final String? category;

  bool get isTransfer => toAccountId != null;

  /// Same purchase seen twice (SMS + share) collapses to one draft.
  final String? dedupKey;
  final DraftStatus status;

  Draft withStatus(DraftStatus s) => Draft(
    id: id,
    source: source,
    isExpense: isExpense,
    amount: amount,
    createdAt: createdAt,
    occurredAt: occurredAt,
    rawText: rawText,
    note: note,
    bankId: bankId,
    accountRef: accountRef,
    dedupKey: dedupKey,
    status: s,
    accountId: accountId,
    balance: balance,
    sender: sender,
    confidence: confidence,
    toAccountId: toAccountId,
    category: category,
  );
}

abstract interface class DraftRepository {
  /// Pending drafts, newest first.
  Stream<List<Draft>> watchPending();
  Future<Draft?> findById(String id);
  Future<bool> existsWithDedupKey(String key);
  Future<void> upsert(Draft draft);
}

/// Use cases of the question queue.
class DraftService {
  DraftService(this._repo);
  final DraftRepository _repo;

  Stream<List<Draft>> watchPending() => _repo.watchPending();

  /// Adds [draft] unless an identical one (same dedup key) is already known.
  /// Returns `false` for a duplicate.
  Future<bool> enqueue(Draft draft) async {
    final key = draft.dedupKey;
    if (key != null && await _repo.existsWithDedupKey(key)) return false;
    await _repo.upsert(draft);
    return true;
  }

  Future<void> confirm(String id) => _set(id, DraftStatus.confirmed);
  Future<void> discard(String id) => _set(id, DraftStatus.discarded);

  Future<void> _set(String id, DraftStatus s) async {
    final d = await _repo.findById(id);
    if (d != null) await _repo.upsert(d.withStatus(s));
  }
}
