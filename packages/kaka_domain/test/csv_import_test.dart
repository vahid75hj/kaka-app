import 'dart:async';

import 'package:kaka_domain/kaka_domain.dart';
import 'package:test/test.dart';

class _MemAccounts implements AccountRepository {
  final _items = <String, Account>{};
  final _ctrl = StreamController<List<Account>>.broadcast();
  @override
  Future<Account?> findById(String id) async => _items[id];
  @override
  Future<List<Account>> getAll() async => _items.values.toList();
  @override
  Future<void> upsert(Account a) async => _ctrl.add((_items[a.id] = a, _items.values.toList()).$2);
  @override
  Stream<List<Account>> watchAll() => _ctrl.stream;
}

class _MemTxns implements TransactionRepository {
  final items = <LedgerTransaction>[];
  @override
  Future<void> insert(LedgerTransaction t) async => items.add(t);
  @override
  Future<void> markVoided(String id, DateTime at) async {}
  @override
  Stream<List<LedgerTransaction>> watchRecent({int limit = 200}) => Stream.value(items);
  @override
  Stream<Map<String, int>> watchPostedSums() {
    final sums = <String, int>{};
    for (final t in items.where((t) => !t.isVoided)) {
      for (final p in t.postings) {
        sums.update(p.accountId, (v) => v + p.amount.minor, ifAbsent: () => p.amount.minor);
      }
    }
    return Stream.value(sums);
  }
}

// 1 Aban 1405 = 23 Oct 2026; enough for the tests (the app passes shamsi_date).
DateTime _jalali(int y, int m, int d) {
  if (y == 1405 && m == 8) return DateTime(2026, 10, 22 + d);
  throw ArgumentError('not in fake table');
}

void main() {
  test('reader: BOM, quotes, doubled quotes, CRLF, semicolon and tab delimiters, blank lines', () {
    expect(CsvReader.parse('\ufeffa,b\r\n"x, y","say ""hi"""\r\n\r\n1,2'), [
      ['a', 'b'],
      ['x, y', 'say "hi"'],
      ['1', '2'],
    ]);
    expect(CsvReader.parse('a;b\n1,5;2'), [
      ['a', 'b'],
      ['1,5', '2'],
    ]);
    expect(CsvReader.parse('a\tb\n"multi\nline"\tz'), [
      ['a', 'b'],
      ['multi\nline', 'z'],
    ]);
  });

  test('mapping detects Persian and English headers; exact beats contains', () {
    final fa = CsvMapping.detect(['ردیف', 'تاریخ', 'شرح', 'برداشت', 'واریز', 'مانده']);
    expect(fa.columns, {CsvField.date: 1, CsvField.note: 2, CsvField.debit: 3, CsvField.credit: 4});
    expect(fa.isValid, isTrue);
    final kaka = CsvMapping.detect(TransactionCsv.header);
    expect(kaka.columns[CsvField.date], 0);
    expect(kaka.columns[CsvField.amount], 4);
    expect(kaka.columns[CsvField.note], 6);
    expect(kaka.columns[CsvField.category], 3);
    expect(CsvMapping.detect(['x', 'y']).isValid, isFalse);
    final export = CsvImport.read(
      CsvReader.parse(
        '${TransactionCsv.header.join(',')}\n2026-10-01T10:00:00.000,expense,کارت,غذا,-12.5,USD,,,'
        '1\n2026-10-01T11:00:00.000,transfer,کارت,نقد,-5,USD,,,2\n2026-10-01T12:00:00.000,expense,کارت,غذا,-1,USD,,yes,3',
      ),
      kaka,
      DisplayUnit.of(Currency.usd),
      jalali: _jalali,
    );
    expect((export.rows.single.minor, export.rows.single.category, export.skipped), (-1250, 'غذا', 2));
    expect(fa.withField(CsvField.note, null).columns.containsKey(CsvField.note), isFalse);
  });

  test('dates: ISO, slashes, d/m/y, Jalali with Persian digits, invalid days rejected', () {
    DateTime? p(String s) => CsvImport.parseDate(s, jalali: _jalali);
    expect(p('2026-10-23'), DateTime(2026, 10, 23, 12));
    expect(p('2026/10/23 14:05'), DateTime(2026, 10, 23, 14, 5));
    expect(p('23/10/2026'), DateTime(2026, 10, 23, 12));
    expect(p('۱۴۰۵/۰۸/۰۱'), DateTime(2026, 10, 23, 12));
    expect(p('1405/8/2-09:30'), DateTime(2026, 10, 24, 9, 30));
    expect(p('2026-02-30'), isNull);
    expect(p('1405/07/31'), isNull);
    expect(p('yesterday'), isNull);
    expect(p('46318'), DateTime(2026, 10, 23, 12)); // Excel serial
    expect(p('46318.5'), DateTime(2026, 10, 23, 12));
    expect(p('46318.75'), DateTime(2026, 10, 23, 18));
    expect(p('12345'), isNull);
    expect(p('2026-10-23T10:00:00Z'), DateTime.utc(2026, 10, 23, 10).toLocal());
  });

  test('rows: signed amounts in toman, debit/credit columns, trailing minus, bad lines reported', () {
    final signed = CsvImport.read(
      CsvReader.parse(
        'date,amount,note,category\n2026-10-01,-120000,ناهار,غذا\n2026-10-02,"5,000,000",حقوق,\n'
        '2026-10-03,(1500),پارکینگ,\nbad,1,,\n2026-10-04,0,zero,\n2026-10-05,۲۵۰۰-,تاکسی,',
      ),
      CsvMapping.detect(['date', 'amount', 'note', 'category']),
      DisplayUnit.irt,
      jalali: _jalali,
    );
    expect(
      [for (final r in signed.rows) (r.minor, r.note, r.category)],
      [(-1200000, 'ناهار', 'غذا'), (50000000, 'حقوق', null), (-15000, 'پارکینگ', null), (-25000, 'تاکسی', null)],
    );
    expect(signed.badLines, [5]);

    final bank = CsvImport.read(
      CsvReader.parse(
        'تاریخ,شرح,برداشت,واریز\n۱۴۰۵/۰۸/۰۱,خرید,۲۰۰٬۰۰۰,\n1405/08/02,واریز حقوق,,1000\n1405/08/03,x,abc,',
      ),
      CsvMapping.detect(['تاریخ', 'شرح', 'برداشت', 'واریز']),
      DisplayUnit.of(Currency.irr),
      jalali: _jalali,
    );
    expect([for (final r in bank.rows) (r.date.day, r.minor)], [(23, -200000), (24, 1000)]);
    expect(bank.badLines, [4]);
  });

  test('import: categories created per kind, fallback used, duplicates counted, ids returned', () async {
    final accounts = _MemAccounts(), txns = _MemTxns();
    final ledger = LedgerService(accounts, txns);
    final card = await ledger.createAccount(name: 'کارت', type: AccountType.asset, currency: Currency.irr);
    final rows = [
      ImportRow(line: 2, date: DateTime(2026, 10, 1, 9), minor: -500, note: 'قهوه'),
      ImportRow(line: 3, date: DateTime(2026, 10, 1, 17), minor: -500, note: 'قهوه'),
      ImportRow(line: 4, date: DateTime(2026, 10, 2), minor: 9000, category: 'حقوق'),
    ];
    final ids = await ledger.importRows(card, rows, fallbackCategory: 'وارد شده');
    expect(ids, hasLength(3));
    final names = {for (final a in await accounts.getAll()) '${a.type.name}:${a.name}'};
    expect(names, containsAll(['expense:وارد شده', 'income:حقوق']));
    expect(names.where((n) => n.endsWith('وارد شده')), hasLength(1));

    // Re-importing the same file plus one new coffee: only the new row is left.
    final again = [...rows, ImportRow(line: 5, date: DateTime(2026, 10, 1, 20), minor: -500)];
    final fresh = CsvImport.withoutDuplicates(again, txns.items, card.id);
    expect(fresh.map((r) => r.line), [5]);

    final usd = await ledger.ensureCategory('غذا', AccountType.expense, Currency.irr);
    expect(() => ledger.importRows(usd, rows, fallbackCategory: 'x'), throwsA(isA<DomainException>()));
  });
}
