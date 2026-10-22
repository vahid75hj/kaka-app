import 'package:kaka_domain/kaka_domain.dart';

import 'tool_catalog.dart';

/// A draft produced by a write tool, waiting for the user's approval.
class TransactionDraft {
  const TransactionDraft(this.arguments);
  final Map<String, Object?> arguments;
}

/// Executes Kaka tools against the domain. Read tools return JSON-ready maps;
/// write tools only produce drafts handed to [onDraft].
class ToolRunner {
  ToolRunner({required this.accounts, required this.transactions, required this.ledger, required this.onDraft});

  final AccountRepository accounts;
  final TransactionRepository transactions;
  final LedgerService ledger;
  final Future<void> Function(TransactionDraft draft) onDraft;

  Future<Map<String, Object?>> call(String name, Map<String, Object?> args) async {
    if (!kakaTools.any((t) => t.name == name)) return _error('unknown_tool', name);
    try {
      return switch (name) {
        'list_accounts' => await _listAccounts(),
        'get_balance' => await _getBalance(args['account_id'] as String?),
        'list_transactions' => await _listTransactions(args),
        'summarize_spending' => await _summarize(args),
        'add_transaction' => await _addDraft(args),
        _ => _error('unknown_tool', name),
      };
    } on DomainException catch (e) {
      return _error(e.code, e.message);
    } on FormatException catch (e) {
      return _error('bad_arguments', e.message);
    }
  }

  static Map<String, Object?> money(Money m) => {
    'amount_minor': m.minor,
    'currency': m.currency.code,
    'scale': m.currency.storageScale,
    'formatted': MoneyFormatter(
      digits: DigitSystem.latin,
      decimals: m.currency.storageScale,
    ).format(m, DisplayUnit.of(m.currency), persian: false),
  };

  Future<List<Account>> _visible() async => (await accounts.getAll()).where((a) => !a.isSystem).toList();

  Future<Map<String, Object?>> _listAccounts() async => {
    'accounts': [
      for (final a in await _visible())
        {'id': a.id, 'name': a.name, 'type': a.type.name, 'currency': a.currency.code, 'archived': a.archived},
    ],
  };

  Future<Map<String, Object?>> _getBalance(String? id) async {
    final balances = (await ledger.watchBalances().first).where(
      (b) => b.account.type.isBalanceSheet && (id == null || b.account.id == id),
    );
    return {
      'balances': [
        for (final b in balances) {'account_id': b.account.id, 'name': b.account.name, 'balance': money(b.balance)},
      ],
    };
  }

  Future<Map<String, Object?>> _listTransactions(Map<String, Object?> args) async {
    final from = _date(args['from']);
    final to = _date(args['to'])?.add(const Duration(days: 1));
    final accountId = args['account_id'] as String?;
    final query = (args['query'] as String?)?.toLowerCase();
    final limit = (args['limit'] as int?) ?? 50;
    final byId = {for (final a in await accounts.getAll()) a.id: a};
    final out = <Map<String, Object?>>[];
    for (final t in await transactions.watchRecent(limit: 1000).first) {
      if (t.isVoided) continue;
      if (from != null && t.occurredAt.isBefore(from)) continue;
      if (to != null && !t.occurredAt.isBefore(to)) continue;
      if (accountId != null && !t.postings.any((p) => p.accountId == accountId)) continue;
      final names = t.postings.map((p) => byId[p.accountId]?.name ?? '').join(' ');
      if (query != null && !'${t.note} $names'.toLowerCase().contains(query)) continue;
      out.add({
        'id': t.id,
        'kind': t.kind.name,
        'date': t.occurredAt.toUtc().toIso8601String(),
        'note': t.note,
        'postings': [
          for (final p in t.postings)
            {'account': byId[p.accountId]?.name, 'account_id': p.accountId, 'amount': money(p.amount)},
        ],
      });
      if (out.length >= limit) break;
    }
    return {'transactions': out};
  }

  Future<Map<String, Object?>> _summarize(Map<String, Object?> args) async {
    final from = _date(args['from']) ?? (throw const FormatException('from is required'));
    final to = (_date(args['to']) ?? (throw const FormatException('to is required'))).add(const Duration(days: 1));
    final byId = {for (final a in await accounts.getAll()) a.id: a};
    final totals = <String, Map<String, int>>{};
    for (final t in await transactions.watchRecent(limit: 100000).first) {
      if (t.isVoided || t.occurredAt.isBefore(from) || !t.occurredAt.isBefore(to)) continue;
      for (final p in t.postings) {
        final a = byId[p.accountId];
        if (a?.type != AccountType.expense) continue;
        totals
            .putIfAbsent(p.amount.currency.code, () => {})
            .update(a!.name, (v) => v + p.amount.minor, ifAbsent: () => p.amount.minor);
      }
    }
    return {
      'by_currency': {
        for (final e in totals.entries)
          e.key: {for (final c in e.value.entries) c.key: money(Money(c.value, Currency.byCode(e.key)))},
      },
    };
  }

  Future<Map<String, Object?>> _addDraft(Map<String, Object?> args) async {
    final account = await accounts.findById(args['account_id'] as String? ?? '');
    if (account == null) return _error('unknown_account', args['account_id'] as String?);
    // Validate the amount now so the model gets immediate feedback.
    AmountParser.parse(args['amount'] as String? ?? '', DisplayUnit.of(account.currency));
    await onDraft(TransactionDraft(Map.of(args)));
    return {'status': 'pending_user_approval'};
  }

  static DateTime? _date(Object? v) => v == null ? null : DateTime.parse(v as String);

  static Map<String, Object?> _error(String code, [String? detail]) => {
    'error': {'code': code, 'detail': ?detail},
  };
}
