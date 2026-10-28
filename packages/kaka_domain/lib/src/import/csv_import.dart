import 'package:meta/meta.dart';

import '../format/digits.dart';
import '../ledger/account.dart';
import '../ledger/ledger_transaction.dart';
import '../money/amount_parser.dart';
import '../money/display_unit.dart';

/// Converts a Jalali (Shamsi) date to Gregorian; the app passes shamsi_date.
typedef JalaliToGregorian = DateTime Function(int year, int month, int day);

/// RFC 4180-ish reader: quotes, doubled quotes, CR/LF, BOM, and `,` `;` or tab
/// as delimiter (whichever appears most in the first line outside quotes).
abstract final class CsvReader {
  static List<List<String>> parse(String text) {
    if (text.startsWith('\ufeff')) text = text.substring(1);
    final delimiter = _guessDelimiter(text);
    final rows = <List<String>>[];
    var row = <String>[];
    final cell = StringBuffer();
    var quoted = false;
    for (var i = 0; i < text.length; i++) {
      final ch = text[i];
      if (quoted) {
        if (ch == '"') {
          if (i + 1 < text.length && text[i + 1] == '"') {
            cell.write('"');
            i++;
          } else {
            quoted = false;
          }
        } else {
          cell.write(ch);
        }
      } else if (ch == '"' && cell.isEmpty) {
        quoted = true;
      } else if (ch == delimiter) {
        row.add(cell.toString());
        cell.clear();
      } else if (ch == '\n' || ch == '\r') {
        if (ch == '\r' && i + 1 < text.length && text[i + 1] == '\n') i++;
        row.add(cell.toString());
        cell.clear();
        if (row.any((c) => c.trim().isNotEmpty)) rows.add(row);
        row = <String>[];
      } else {
        cell.write(ch);
      }
    }
    row.add(cell.toString());
    if (row.any((c) => c.trim().isNotEmpty)) rows.add(row);
    return rows;
  }

  static String _guessDelimiter(String text) {
    final counts = {',': 0, ';': 0, '\t': 0};
    var quoted = false;
    for (var i = 0; i < text.length; i++) {
      final ch = text[i];
      if (ch == '"') quoted = !quoted;
      if (!quoted && (ch == '\n' || ch == '\r')) break;
      if (!quoted && counts.containsKey(ch)) counts[ch] = counts[ch]! + 1;
    }
    return counts.entries.reduce((a, b) => b.value > a.value ? b : a).key;
  }
}

enum CsvField {
  date,
  amount,
  debit,
  credit,
  note,
  category,

  /// Kaka's own export: only `expense` / `income` rows are imported.
  kind,

  /// Kaka's own export: `yes` rows were voided and are skipped.
  voided,
}

/// Which column holds what. Either `amount` (signed: negative = money out) or
/// `debit` / `credit` (money out / money in) must be set, plus `date`.
@immutable
class CsvMapping {
  const CsvMapping(this.columns);
  final Map<CsvField, int> columns;

  bool get isValid =>
      columns.containsKey(CsvField.date) &&
      (columns.containsKey(CsvField.amount) ||
          columns.containsKey(CsvField.debit) ||
          columns.containsKey(CsvField.credit));

  CsvMapping withField(CsvField f, int? column) => CsvMapping(
    {...columns}
      ..removeWhere((k, _) => k == f)
      ..addAll({f: ?column}),
  );

  static const _synonyms = {
    CsvField.date: ['date', 'تاریخ', 'time', 'زمان', 'تاریخ تراکنش', 'transaction date'],
    CsvField.amount: ['amount', 'مبلغ', 'مبلغ (ریال)', 'مبلغ تراکنش', 'value', 'sum'],
    CsvField.debit: ['debit', 'برداشت', 'بدهکار', 'withdrawal', 'out', 'خروجی'],
    CsvField.credit: ['credit', 'واریز', 'بستانکار', 'deposit', 'in', 'ورودی'],
    CsvField.note: ['note', 'description', 'شرح', 'توضیحات', 'توضیح', 'memo', 'details', 'یادداشت'],
    CsvField.category: ['category', 'دسته', 'دسته‌بندی', 'counterpart'],
    CsvField.kind: ['kind'],
    CsvField.voided: ['voided'],
  };

  /// Guesses columns from header names (English or Persian). Exact matches
  /// win over "contains" matches; each column is used once.
  static CsvMapping detect(List<String> header) {
    final norm = [for (final h in header) h.trim().toLowerCase().replaceAll('\u200c', ' ')];
    final out = <CsvField, int>{};
    for (final exact in [true, false]) {
      for (final f in CsvField.values) {
        if (out.containsKey(f)) continue;
        for (var i = 0; i < norm.length; i++) {
          if (out.containsValue(i) || norm[i].isEmpty) continue;
          final hit = _synonyms[f]!.any((s) {
            final n = s.replaceAll('\u200c', ' ');
            return exact ? norm[i] == n : n.length > 2 && norm[i].contains(n);
          });
          if (hit) {
            out[f] = i;
            break;
          }
        }
      }
    }
    return CsvMapping(out);
  }
}

/// One parsed line: positive [minor] = money in, negative = money out.
@immutable
class ImportRow {
  const ImportRow({required this.line, required this.date, required this.minor, this.note = '', this.category});
  final int line;
  final DateTime date;
  final int minor;
  final String note;
  final String? category;
}

class CsvReadResult {
  const CsvReadResult(this.rows, this.badLines, {this.skipped = 0});
  final List<ImportRow> rows;

  /// Transfers, exchanges, opening balances… from a Kaka export (not income/expense).
  final int skipped;

  /// 1-based line numbers that had no usable date or amount.
  final List<int> badLines;
}

abstract final class CsvImport {
  /// Reads data rows (after the header) with [mapping]; amounts are in [unit]
  /// (e.g. toman for a rial account). Zero amounts are skipped silently.
  static CsvReadResult read(
    List<List<String>> table,
    CsvMapping mapping,
    DisplayUnit unit, {
    required JalaliToGregorian jalali,
    bool hasHeader = true,
  }) {
    final rows = <ImportRow>[], bad = <int>[];
    var skipped = 0;
    String cell(List<String> r, CsvField f) {
      final i = mapping.columns[f];
      return i == null || i >= r.length ? '' : r[i].trim();
    }

    for (var n = hasHeader ? 1 : 0; n < table.length; n++) {
      final r = table[n];
      if (mapping.columns.containsKey(CsvField.kind) && !const {'expense', 'income'}.contains(cell(r, CsvField.kind)) ||
          cell(r, CsvField.voided) == 'yes') {
        skipped++;
        continue;
      }
      final date = parseDate(cell(r, CsvField.date), jalali: jalali);
      int? minor;
      if (mapping.columns.containsKey(CsvField.amount)) {
        minor = _amount(cell(r, CsvField.amount), unit);
      } else {
        final out = _amount(cell(r, CsvField.debit), unit, emptyIsZero: true);
        final inn = _amount(cell(r, CsvField.credit), unit, emptyIsZero: true);
        minor = out == null || inn == null ? null : inn.abs() - out.abs();
      }
      if (date == null || minor == null) {
        bad.add(n + 1);
        continue;
      }
      if (minor == 0) continue;
      final category = cell(r, CsvField.category);
      rows.add(
        ImportRow(
          line: n + 1,
          date: date,
          minor: minor,
          note: cell(r, CsvField.note),
          category: category.isEmpty ? null : category,
        ),
      );
    }
    return CsvReadResult(rows, bad, skipped: skipped);
  }

  /// Drops rows that already exist on [accountId]: same calendar day and same
  /// signed amount, counted (two identical coffees stay two if only one exists).
  static List<ImportRow> withoutDuplicates(
    List<ImportRow> rows,
    Iterable<LedgerTransaction> existing,
    String accountId,
  ) {
    String key(DateTime d, int minor) => '${d.year}-${d.month}-${d.day}|$minor';
    final have = <String, int>{};
    for (final t in existing) {
      if (t.isVoided) continue;
      for (final p in t.postings.where((p) => p.accountId == accountId)) {
        final k = key(t.occurredAt.toLocal(), p.amount.minor);
        have[k] = (have[k] ?? 0) + 1;
      }
    }
    final out = <ImportRow>[];
    for (final r in rows) {
      final k = key(r.date, r.minor);
      final n = have[k] ?? 0;
      if (n > 0) {
        have[k] = n - 1;
      } else {
        out.add(r);
      }
    }
    return out;
  }

  static int? _amount(String raw, DisplayUnit unit, {bool emptyIsZero = false}) {
    var s = Digits.normalize(raw).replaceAll(RegExp(r'[\s\u200e\u200f]'), '');
    if (s.isEmpty) return emptyIsZero ? 0 : null;
    var negative = false;
    // "(1,000)", "-1,000", "1,000-" and the Unicode minus all mean money out.
    s = s.replaceAll('−', '-');
    if (s.startsWith('(') && s.endsWith(')')) {
      negative = true;
      s = s.substring(1, s.length - 1);
    }
    if (s.startsWith('-')) {
      negative = !negative;
      s = s.substring(1);
    } else if (s.endsWith('-')) {
      negative = !negative;
      s = s.substring(0, s.length - 1);
    } else if (s.startsWith('+')) {
      s = s.substring(1);
    }
    try {
      final m = AmountParser.parse(s, unit).minor;
      return negative ? -m : m;
    } catch (_) {
      return null;
    }
  }

  static final _ymd = RegExp(r'^(\d{4})[-/.](\d{1,2})[-/.](\d{1,2})(?:[T\s,_-]+(\d{1,2}):(\d{2})(?::(\d{2}))?)?');
  static final _dmy = RegExp(r'^(\d{1,2})[-/.](\d{1,2})[-/.](\d{4})(?:[T\s,_-]+(\d{1,2}):(\d{2})(?::(\d{2}))?)?');

  /// `2026-10-23`, `2026/10/23 14:05`, ISO with offset, `23/10/2026`, and
  /// Jalali `1405/08/01` (any year below 1700 is Shamsi). Persian digits OK.
  static DateTime? parseDate(String raw, {required JalaliToGregorian jalali}) {
    final s = Digits.normalize(raw.trim());
    if (s.isEmpty) return null;
    // Excel serial day (days since 1899-12-30), as .xlsx stores dates; fraction = time.
    final serial = RegExp(r'^(\d{5})(\.\d+)?$').firstMatch(s);
    if (serial != null) {
      final days = int.parse(serial[1]!);
      if (days < 20000 || days > 80000) return null;
      final frac = double.parse('0${serial[2] ?? ''}');
      final minutes = (frac * 24 * 60).round();
      final d = DateTime(1899, 12, 30 + days);
      return frac == 0
          ? DateTime(d.year, d.month, d.day, 12)
          : DateTime(d.year, d.month, d.day, minutes ~/ 60, minutes % 60);
    }
    if (RegExp(r'^\d{4}-\d{2}-\d{2}T').hasMatch(s)) {
      final iso = DateTime.tryParse(s);
      if (iso != null) return iso.toLocal();
    }
    int y, m, d;
    int hh = 12, mm = 0;
    var match = _ymd.firstMatch(s);
    if (match != null) {
      y = int.parse(match[1]!);
      m = int.parse(match[2]!);
      d = int.parse(match[3]!);
    } else {
      match = _dmy.firstMatch(s);
      if (match == null) return null;
      d = int.parse(match[1]!);
      m = int.parse(match[2]!);
      y = int.parse(match[3]!);
    }
    if (match[4] != null) {
      hh = int.parse(match[4]!);
      mm = int.parse(match[5]!);
    }
    if (m < 1 || m > 12 || d < 1 || d > 31 || hh > 23 || mm > 59) return null;
    if (y < 1700) {
      if (d > (m <= 6 ? 31 : 30)) return null;
      try {
        final g = jalali(y, m, d);
        return DateTime(g.year, g.month, g.day, hh, mm);
      } catch (_) {
        return null;
      }
    }
    final g = DateTime(y, m, d, hh, mm);
    return g.month == m && g.day == d ? g : null; // rejects 2026-02-30
  }
}

/// Category account kinds an import row needs.
AccountType importKind(ImportRow r) => r.minor < 0 ? AccountType.expense : AccountType.income;
