import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:xml/xml.dart';

/// Minimal .xlsx reader: the first worksheet as rows of strings (shared and
/// inline strings, numbers as written). Dates stay Excel serial numbers;
/// `CsvImport.parseDate` understands those.
abstract final class XlsxReader {
  static List<List<String>> read(Uint8List bytes) {
    final zip = ZipDecoder().decodeBytes(bytes);
    String? text(String name) {
      final f = zip.findFile(name);
      return f == null ? null : utf8.decode(f.content as List<int>);
    }

    final shared = <String>[];
    final ss = text('xl/sharedStrings.xml');
    if (ss != null) {
      for (final si in XmlDocument.parse(ss).findAllElements('si')) {
        shared.add(si.findAllElements('t').map((t) => t.innerText).join());
      }
    }
    final sheetPath = _firstSheet(zip, text) ?? (throw const FormatException('no worksheet'));
    final sheet = XmlDocument.parse(text(sheetPath) ?? (throw const FormatException('no worksheet')));
    final rows = <List<String>>[];
    for (final row in sheet.findAllElements('row')) {
      final cells = <int, String>{};
      var next = 0;
      for (final c in row.findElements('c')) {
        final ref = c.getAttribute('r');
        final col = ref == null ? next : _column(ref);
        next = col + 1;
        final type = c.getAttribute('t');
        final v = c.getElement('v')?.innerText ?? '';
        cells[col] = switch (type) {
          's' => (int.tryParse(v) ?? -1) >= 0 && int.parse(v) < shared.length ? shared[int.parse(v)] : '',
          'inlineStr' => c.findAllElements('t').map((t) => t.innerText).join(),
          'b' => v == '1' ? 'TRUE' : 'FALSE',
          _ => v,
        };
      }
      if (cells.isEmpty || cells.values.every((v) => v.trim().isEmpty)) continue;
      final width = cells.keys.reduce((a, b) => a > b ? a : b) + 1;
      rows.add([for (var i = 0; i < width; i++) cells[i] ?? '']);
    }
    return rows;
  }

  static String? _firstSheet(Archive zip, String? Function(String) text) {
    final wb = text('xl/workbook.xml');
    final rels = text('xl/_rels/workbook.xml.rels');
    if (wb != null && rels != null) {
      final first = XmlDocument.parse(wb).findAllElements('sheet').firstOrNull;
      final id = first?.attributes.where((a) => a.name.local == 'id').firstOrNull?.value;
      for (final r in XmlDocument.parse(rels).findAllElements('Relationship')) {
        if (r.getAttribute('Id') == id) {
          final t = r.getAttribute('Target')!;
          return t.startsWith('/') ? t.substring(1) : 'xl/$t';
        }
      }
    }
    final sheets = zip.files.map((f) => f.name).where((n) => n.startsWith('xl/worksheets/sheet')).toList()..sort();
    return sheets.firstOrNull;
  }

  /// "AB12" → 27.
  static int _column(String ref) {
    var n = 0;
    for (final ch in ref.codeUnits) {
      if (ch < 65 || ch > 90) break;
      n = n * 26 + (ch - 64);
    }
    return n - 1;
  }
}
