import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kaka_domain/kaka_domain.dart';
import 'package:kaka_mobile/features/import/import_screen.dart';
import 'package:kaka_mobile/features/import/xlsx_reader.dart';

void main() {
  test('xlsx: shared strings, numbers, gaps, serial dates → same pipeline as CSV', () {
    final rows = XlsxReader.read(File('test/fixtures/statement.xlsx').readAsBytesSync());
    expect(rows.first, ['تاریخ', 'شرح', 'برداشت', 'واریز']);
    expect(rows[2][3], '150000000');
    expect(rows.last, ['', '', '', '', '', 'far cell']);
    final r = CsvImport.read(
      rows,
      CsvMapping.detect(rows.first),
      DisplayUnit.of(Currency.irr),
      jalali: jalaliToGregorian,
    );
    expect(
      [for (final x in r.rows) (x.date.year, x.date.month, x.date.day, x.minor)],
      [(2026, 10, 23, -2000000), (2026, 10, 24, 150000000)],
    );
    expect(r.badLines, [4]);
  });

  test('garbage bytes throw instead of returning junk', () {
    expect(() => XlsxReader.read(File('test/xlsx_reader_test.dart').readAsBytesSync()), throwsA(anything));
  });
}
