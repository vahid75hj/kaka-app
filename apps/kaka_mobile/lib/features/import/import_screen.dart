import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaka_domain/kaka_domain.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../app/providers.dart';
import '../../core/l10n_x.dart';
import '../../core/widgets.dart';
import '../../theme/kaka_colors.dart';

DateTime jalaliToGregorian(int y, int m, int d) {
  final j = Jalali(y, m, d);
  if (d > j.monthLength) throw ArgumentError('day');
  return j.toDateTime();
}

/// Reads a CSV (bank statement, spreadsheet, or Kaka's own export) into one
/// account. Nothing is written until the user taps import; undo voids it all.
class ImportScreen extends ConsumerStatefulWidget {
  const ImportScreen({super.key, this.initialText});

  /// For tests: skip the file picker.
  final String? initialText;

  @override
  ConsumerState<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends ConsumerState<ImportScreen> {
  List<List<String>>? _table;
  String? _fileName;
  String? _error;
  CsvMapping _mapping = const CsvMapping({});
  String? _accountId;
  bool _toman = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialText != null) _load(widget.initialText!, 'test.csv');
  }

  void _load(String text, String name) {
    final table = CsvReader.parse(text);
    setState(() {
      _fileName = name;
      if (table.length < 2) {
        _table = null;
        _error = context.l10n.importEmpty;
        return;
      }
      _error = null;
      _table = table;
      _mapping = CsvMapping.detect(table.first);
    });
  }

  Future<void> _pick() async {
    final picked = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: const ['csv', 'txt', 'tsv']);
    if (picked.isEmpty || !mounted) return;
    final bytes = await picked.first.xFile.readAsBytes();
    if (!mounted) return;
    try {
      _load(utf8.decode(bytes), picked.first.name);
    } on FormatException {
      setState(() => _error = context.l10n.importNotUtf8);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = KakaColors.of(context);
    final f = ref.watch(formatProvider);
    final accounts = [
      for (final a in ref.watch(accountsProvider).value ?? const <Account>[])
        if (a.type.isBalanceSheet && !a.isSystem && !a.archived) a,
    ];
    final account = accounts.where((a) => a.id == _accountId).firstOrNull ?? accounts.firstOrNull;
    final table = _table;

    CsvReadResult? result;
    List<ImportRow> fresh = const [];
    if (table != null && account != null && _mapping.isValid) {
      final unit = _toman && account.currency == Currency.irr ? DisplayUnit.irt : DisplayUnit.of(account.currency);
      result = CsvImport.read(table, _mapping, unit, jalali: jalaliToGregorian);
      fresh = CsvImport.withoutDuplicates(
        result.rows,
        ref.watch(transactionsProvider).value ?? const <LedgerTransaction>[],
        account.id,
      );
    }

    Widget fieldPicker(CsvField field, String label) => DropdownButtonFormField<int?>(
      key: ValueKey('map-${field.name}-${_mapping.columns[field]}'),
      initialValue: _mapping.columns[field],
      isExpanded: true,
      decoration: InputDecoration(labelText: label, isDense: true),
      items: [
        DropdownMenuItem(value: null, child: Text(l.importNone)),
        for (var i = 0; i < table!.first.length; i++)
          DropdownMenuItem(
            value: i,
            child: Text(table.first[i].isEmpty ? '#${i + 1}' : table.first[i], overflow: TextOverflow.ellipsis),
          ),
      ],
      onChanged: (v) => setState(() => _mapping = _mapping.withField(field, v)),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l.importCsv)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        children: [
          Text(l.importHint, style: TextStyle(color: c.textMuted, height: 1.6)),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _busy ? null : _pick,
            icon: const Icon(Icons.upload_file_rounded),
            label: Text(_fileName ?? l.importChooseFile),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(_error!, style: TextStyle(color: c.negative)),
            ),
          if (table != null) ...[
            const SizedBox(height: 16),
            if (accounts.isEmpty)
              Text(l.importNeedAccount, style: TextStyle(color: c.negative))
            else
              DropdownButtonFormField<String>(
                initialValue: account!.id,
                isExpanded: true,
                decoration: InputDecoration(labelText: l.importInto),
                items: [for (final a in accounts) DropdownMenuItem(value: a.id, child: Text(a.name))],
                onChanged: (v) => setState(() => _accountId = v),
              ),
            if (account?.currency == Currency.irr)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l.importAmountsInToman),
                subtitle: Text(l.importAmountsInTomanHint, style: TextStyle(color: c.textMuted, fontSize: 12)),
                value: _toman,
                onChanged: (v) => setState(() => _toman = v),
              ),
            SectionHeader(l.importColumns),
            fieldPicker(CsvField.date, l.date),
            const SizedBox(height: 8),
            fieldPicker(CsvField.amount, l.importSignedAmount),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: fieldPicker(CsvField.debit, l.importDebit)),
                const SizedBox(width: 8),
                Expanded(child: fieldPicker(CsvField.credit, l.importCredit)),
              ],
            ),
            const SizedBox(height: 8),
            fieldPicker(CsvField.note, l.note),
            const SizedBox(height: 8),
            fieldPicker(CsvField.category, l.category),
            if (!_mapping.isValid)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(l.importMappingHint, style: TextStyle(color: c.negative)),
              ),
            if (result != null) ...[
              SectionHeader(l.importPreview),
              Text(
                l.importSummary(f.digits('${fresh.length}'), f.digits('${result.rows.length - fresh.length}')),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              if (result.badLines.isNotEmpty || result.skipped > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    [
                      if (result.badLines.isNotEmpty)
                        l.importBadLines(
                          f.digits(result.badLines.take(8).join('، ')),
                          f.digits('${result.badLines.length}'),
                        ),
                      if (result.skipped > 0) l.importSkippedKinds(f.digits('${result.skipped}')),
                    ].join('\n'),
                    style: TextStyle(color: c.textMuted, fontSize: 12, height: 1.6),
                  ),
                ),
              const SizedBox(height: 8),
              KCard(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Column(
                  children: [
                    for (final r in fresh.take(5))
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          r.note.isEmpty ? (r.category ?? l.importFallbackCategory) : r.note,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(f.date(r.date)),
                        trailing: AmountText(
                          f.money(Money(r.minor, account!.currency), signed: true),
                          style: TextStyle(color: r.minor < 0 ? c.negative : c.positive),
                        ),
                      ),
                    if (fresh.length > 5)
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          l.importMore(f.digits('${fresh.length - 5}')),
                          style: TextStyle(color: c.textMuted),
                        ),
                      ),
                    if (fresh.isEmpty) Padding(padding: const EdgeInsets.all(12), child: Text(l.importNothingNew)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _busy || fresh.isEmpty ? null : () => _import(account!, fresh),
                icon: const Icon(Icons.download_done_rounded),
                label: Text(l.importNow(f.digits('${fresh.length}'))),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Future<void> _import(Account account, List<ImportRow> rows) async {
    final l = context.l10n;
    final f = ref.read(formatProvider);
    final ledger = ref.read(ledgerProvider);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      final ids = await ledger.importRows(account, rows, fallbackCategory: l.importFallbackCategory);
      messenger.showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 8),
          content: Text(l.importDone(f.digits('${ids.length}'))),
          action: SnackBarAction(
            label: l.undo,
            onPressed: () async {
              for (final id in ids) {
                await ledger.voidById(id);
              }
            },
          ),
        ),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) setState(() => _error = context.domainError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}
