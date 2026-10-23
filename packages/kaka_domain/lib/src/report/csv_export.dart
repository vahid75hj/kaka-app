import '../ledger/account.dart';
import '../ledger/ledger_transaction.dart';

/// RFC 4180 CSV of transactions (one row per posting on a user account),
/// amounts as exact decimals in the account currency. Opens in Excel/Sheets.
abstract final class TransactionCsv {
  static const header = ['date', 'kind', 'account', 'counterpart', 'amount', 'currency', 'note', 'voided', 'id'];

  static String build(Iterable<LedgerTransaction> txns, Map<String, Account> accounts) {
    final rows = <List<String>>[header];
    for (final t in txns) {
      for (final p in t.postings) {
        final a = accounts[p.accountId];
        if (a == null || !a.type.isBalanceSheet || a.isSystem) continue;
        final other = t.postings
            .where((o) => o.accountId != p.accountId && !(accounts[o.accountId]?.isSystem ?? true))
            .map((o) => accounts[o.accountId]!.name)
            .join(' / ');
        rows.add([
          t.occurredAt.toIso8601String(),
          t.kind.name,
          a.name,
          other,
          _decimal(p.amount.minor, p.amount.currency.storageScale),
          p.amount.currency.code,
          t.note,
          t.isVoided ? 'yes' : '',
          t.id,
        ]);
      }
    }
    // BOM so Excel opens Persian text as UTF-8.
    return '\ufeff${rows.map((r) => r.map(_cell).join(',')).join('\r\n')}\r\n';
  }

  static String _decimal(int minor, int scale) {
    if (scale == 0) return '$minor';
    final s = minor.abs().toString().padLeft(scale + 1, '0');
    return '${minor < 0 ? '-' : ''}${s.substring(0, s.length - scale)}.${s.substring(s.length - scale)}';
  }

  static String _cell(String v) {
    // Neutralize spreadsheet formulas and quote when needed.
    final safe = RegExp(r'^[=+\-@]').hasMatch(v) && double.tryParse(v) == null ? "'$v" : v;
    return RegExp(r'[",\r\n]').hasMatch(safe) ? '"${safe.replaceAll('"', '""')}"' : safe;
  }
}
