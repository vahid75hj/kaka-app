import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaka_domain/kaka_domain.dart';
import 'package:kaka_prices/kaka_prices.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/providers.dart';
import '../../core/l10n_x.dart';
import '../../theme/kaka_colors.dart';
import 'price_parser_help_screen.dart';

/// Enable / import / export pluggable price sources. All off by default except manual.
class PriceSourcesScreen extends ConsumerStatefulWidget {
  const PriceSourcesScreen({super.key});

  @override
  ConsumerState<PriceSourcesScreen> createState() => _PriceSourcesScreenState();
}

class _PriceSourcesScreenState extends ConsumerState<PriceSourcesScreen> {
  Future<void> _setEnabled(String id, bool on, Set<String> current) async {
    final next = {...current};
    if (on) {
      next.add(id);
    } else {
      next.remove(id);
    }
    await ref.read(priceSourceEnabledStoreProvider).save(next);
  }

  Future<void> _export(PriceSource s) async {
    final json = PriceCatalog.exportSource(s);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${s.id}.price-source.json');
    await file.writeAsString(json);
    await SharePlus.instance.share(ShareParams(files: [XFile(file.path)], subject: s.id));
  }

  Future<void> _import() async {
    final l = context.l10n;
    final picked = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: const ['json']);
    if (picked.isEmpty) return;
    try {
      final text = await picked.first.xFile.readAsString();
      final cat = PriceCatalog.parse(text);
      if (cat.sources.isEmpty) throw const FormatException('no sources');
      for (final s in cat.sources) {
        if (s.kind == PriceSourceKind.manual) continue;
        final payload = PriceCatalog.exportSource(s);
        await ref.read(userPriceSourceStoreProvider).save(s.id, payload);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.priceImportOk)));
      }
    } on Object catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${l.priceImportFail}: $e')));
      }
    }
  }

  Future<void> _deleteUser(String id) async {
    await ref.read(userPriceSourceStoreProvider).delete(id);
    final enabled = {...(ref.read(priceSourceEnabledProvider).value ?? {})}..remove(id);
    await ref.read(priceSourceEnabledStoreProvider).save(enabled);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = KakaColors.of(context);
    final fa = ref.watch(settingsProvider).isPersian;
    final catalog = ref.watch(priceCatalogProvider).value;
    final enabled = ref.watch(priceSourceEnabledProvider).value ?? {};
    final sources = [
      for (final s in catalog?.sources ?? const <PriceSource>[])
        if (s.kind != PriceSourceKind.manual) s,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l.priceSources),
        actions: [
          IconButton(
            tooltip: l.priceParserHelpTitle,
            onPressed: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const PriceParserHelpScreen())),
            icon: const Icon(Icons.help_outline),
          ),
          IconButton(tooltip: l.priceImport, onPressed: _import, icon: const Icon(Icons.file_download_outlined)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(l.priceSourcesHint, style: TextStyle(color: c.textMuted)),
          ),
          if (catalog == null) const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator())),
          for (final s in sources)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(s.name(fa)),
                      subtitle: Text(
                        [
                          s.kind.name,
                          if (s.regionNote.isNotEmpty) s.regionNote,
                          if (!s.builtin) l.priceUserSource,
                        ].join(' · '),
                        style: TextStyle(color: c.textMuted, fontSize: 12),
                      ),
                      value: enabled.contains(s.id),
                      onChanged: (v) => _setEnabled(s.id, v, enabled),
                    ),
                    if (s.notes.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(s.notes, style: TextStyle(color: c.textMuted, fontSize: 12)),
                      ),
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () => _export(s),
                          icon: const Icon(Icons.ios_share, size: 18),
                          label: Text(l.priceExport),
                        ),
                        if (!s.builtin)
                          TextButton.icon(
                            onPressed: () => _deleteUser(s.id),
                            icon: const Icon(Icons.delete_outline, size: 18),
                            label: Text(l.delete),
                          ),
                        TextButton(
                          onPressed: () => _editBindingHints(s),
                          child: Text(l.priceBind),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const PriceParserHelpScreen())),
            icon: const Icon(Icons.menu_book_outlined),
            label: Text(l.priceParserHelpTitle),
          ),
        ],
      ),
    );
  }

  Future<void> _editBindingHints(PriceSource s) async {
    final instruments = (ref.read(instrumentsProvider).value ?? const <Instrument>[]).where((i) => !i.archived).toList();
    if (!mounted) return;
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(builder: (_) => _BindInstrumentsScreen(source: s, instruments: instruments)),
    );
  }
}

class _BindInstrumentsScreen extends ConsumerStatefulWidget {
  const _BindInstrumentsScreen({required this.source, required this.instruments});
  final PriceSource source;
  final List<Instrument> instruments;

  @override
  ConsumerState<_BindInstrumentsScreen> createState() => _BindInstrumentsScreenState();
}

class _BindInstrumentsScreenState extends ConsumerState<_BindInstrumentsScreen> {
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final fa = ref.watch(settingsProvider).isPersian;
    final bindings = ref.watch(priceBindingsProvider).value ?? const <PriceBinding>[];
    final forSource = [for (final b in bindings) if (b.sourceId == widget.source.id) b];

    return Scaffold(
      appBar: AppBar(title: Text('${l.priceBind} · ${widget.source.name(fa)}')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        children: [
          Text(l.priceBindHint, style: TextStyle(color: KakaColors.of(context).textMuted)),
          const SizedBox(height: 12),
          for (final i in widget.instruments)
            Builder(
              builder: (context) {
                final existing = forSource.where((b) => b.instrumentId == i.id).firstOrNull;
                final suggested = PriceRefreshService.suggestSymbol(widget.source, i) ?? '';
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(i.name(fa)),
                  subtitle: Text(existing?.symbol ?? (suggested.isEmpty ? '—' : '${l.priceSuggested}: $suggested')),
                  trailing: TextButton(
                    onPressed: () => _bind(i, existing, suggested),
                    child: Text(existing == null ? l.priceBind : l.edit),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Future<void> _bind(Instrument i, PriceBinding? existing, String suggested) async {
    final l = context.l10n;
    final ctrl = TextEditingController(text: existing?.symbol ?? suggested);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.priceBind),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: ctrl,
              decoration: InputDecoration(labelText: l.priceSourceSymbol),
            ),
          ],
        ),
        actions: [
          if (existing != null)
            TextButton(
              onPressed: () async {
                await ref.read(priceBindingStoreProvider).delete(existing.id);
                if (ctx.mounted) Navigator.pop(ctx, false);
              },
              child: Text(l.delete),
            ),
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.save)),
        ],
      ),
    );
    if (ok != true) return;
    final sym = ctrl.text.trim();
    if (sym.isEmpty) return;
    await ref.read(priceBindingStoreProvider).upsert(
      id: existing?.id ?? Ids.next(),
      instrumentId: i.id,
      sourceId: widget.source.id,
      symbol: sym,
      priority: existing?.priority ?? 100,
    );
  }
}
