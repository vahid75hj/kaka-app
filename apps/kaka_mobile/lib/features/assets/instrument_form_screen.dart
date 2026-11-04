import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaka_domain/kaka_domain.dart';

import '../../app/providers.dart';
import '../../core/l10n_x.dart';
import '../../core/widgets.dart';
import '../../theme/kaka_colors.dart';
import 'asset_ui.dart';

/// Create an asset from the starter list or from scratch, or edit one.
/// Pops with the saved [Instrument].
class InstrumentFormScreen extends ConsumerStatefulWidget {
  const InstrumentFormScreen({super.key, this.existing});
  final Instrument? existing;

  @override
  ConsumerState<InstrumentFormScreen> createState() => _InstrumentFormScreenState();
}

class _InstrumentFormScreenState extends ConsumerState<InstrumentFormScreen> {
  late final _nameFa = TextEditingController(text: widget.existing?.nameFa ?? '');
  late final _nameEn = TextEditingController(text: widget.existing?.nameEn ?? '');
  late final _unitFa = TextEditingController(text: widget.existing?.unitFa ?? '');
  late final _unitEn = TextEditingController(text: widget.existing?.unitEn ?? '');
  late final _symbol = TextEditingController(text: widget.existing?.symbol ?? '');
  late AssetClass _class = widget.existing?.assetClass ?? AssetClass.other;
  late int _scale = widget.existing?.qtyScale ?? 0;
  late Currency? _quote = widget.existing?.quoteCurrency;
  late CostMethod _method = widget.existing?.costMethod ?? CostMethod.average;
  String? _catalogId;
  String? _error;

  @override
  void dispose() {
    for (final c in [_nameFa, _nameEn, _unitFa, _unitEn, _symbol]) {
      c.dispose();
    }
    super.dispose();
  }

  void _fromCatalog(CatalogEntry e) => setState(() {
    _nameFa.text = e.nameFa;
    _nameEn.text = e.nameEn;
    _unitFa.text = e.unitFa;
    _unitEn.text = e.unitEn;
    _symbol.text = e.symbol;
    _class = e.assetClass;
    _scale = e.qtyScale;
    _quote = e.quote;
    _catalogId = e.id;
  });

  Future<void> _save() async {
    final ex = widget.existing;
    final i = Instrument(
      id: ex?.id ?? Ids.next(),
      assetClass: _class,
      nameFa: _nameFa.text.trim(),
      nameEn: _nameEn.text.trim(),
      unitFa: _unitFa.text.trim(),
      unitEn: _unitEn.text.trim(),
      qtyScale: ex?.qtyScale ?? _scale,
      symbol: _symbol.text.trim(),
      quoteCurrency: _quote,
      costMethod: _method,
      archived: ex?.archived ?? false,
      catalogId: ex?.catalogId ?? _catalogId,
    );
    try {
      await ref.read(portfolioServiceProvider).saveInstrument(i);
      // Changing the cost method changes past gains: re-post affected sales.
      if (ex != null && ex.costMethod != _method) await ref.read(portfolioServiceProvider).reconcile();
      if (mounted) Navigator.pop(context, i);
    } on DomainException catch (e) {
      setState(() => _error = portfolioError(context.l10n, e.code));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = KakaColors.of(context);
    final f = ref.watch(formatProvider);
    final fa = ref.watch(settingsProvider).isPersian;
    final editing = widget.existing != null;
    final catalog = [...InstrumentCatalog.entries]
      ..sort((a, b) => ((a.region == 'IR') == fa ? 0 : 1).compareTo((b.region == 'IR') == fa ? 0 : 1));
    return Scaffold(
      appBar: AppBar(title: Text(editing ? l.editAsset : l.newAsset)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
        children: [
          if (!editing) ...[
            SectionHeader(l.pickFromList),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final e in catalog)
                  ChoiceChip(
                    label: Text(fa ? e.nameFa : e.nameEn),
                    selected: _catalogId == e.id,
                    onSelected: (_) => _fromCatalog(e),
                  ),
              ],
            ),
            SectionHeader(l.orCustom),
          ],
          DropdownButtonFormField<AssetClass>(
            initialValue: _class,
            decoration: InputDecoration(labelText: l.assetClass),
            items: [
              for (final a in AssetClass.values)
                DropdownMenuItem(
                  value: a,
                  child: Row(children: [Icon(classIcon(a), size: 18), const SizedBox(width: 8), Text(className(l, a))]),
                ),
            ],
            onChanged: (v) => setState(() => _class = v!),
          ),
          TextField(
            controller: _nameFa,
            decoration: InputDecoration(labelText: l.nameFa),
          ),
          TextField(
            controller: _nameEn,
            decoration: InputDecoration(labelText: l.nameEn),
          ),
          TextField(
            controller: _symbol,
            decoration: InputDecoration(labelText: l.symbolOptional),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _unitFa,
                  decoration: InputDecoration(labelText: l.unitFa),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _unitEn,
                  decoration: InputDecoration(labelText: l.unitEn),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(l.qtyDecimals(f.digits('$_scale')), style: TextStyle(color: editing ? c.textFaint : null)),
          Slider(
            value: _scale.toDouble(),
            max: 12,
            divisions: 12,
            label: f.digits('$_scale'),
            onChanged: editing ? null : (v) => setState(() => _scale = v.round()),
          ),
          Text(editing ? l.decimalsLocked : l.decimalsHint, style: TextStyle(color: c.textMuted, fontSize: 12)),
          DropdownButtonFormField<Currency?>(
            initialValue: _quote,
            decoration: InputDecoration(labelText: l.priceCurrency),
            items: [
              DropdownMenuItem(value: null, child: Text(l.baseCurrency)),
              for (final cur in Currency.builtIn) DropdownMenuItem(value: cur, child: Text(f.symbol(cur))),
            ],
            onChanged: (v) => setState(() => _quote = v),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l.fifoTitle),
            subtitle: Text(l.fifoHint),
            value: _method == CostMethod.fifo,
            onChanged: (v) => setState(() => _method = v ? CostMethod.fifo : CostMethod.average),
          ),
          if (_error != null) Text(_error!, style: TextStyle(color: c.negative)),
          const SizedBox(height: 12),
          FilledButton(onPressed: _save, child: Text(l.save)),
          if (editing)
            TextButton(
              onPressed: () async {
                final ex = widget.existing!;
                await ref.read(portfolioServiceProvider).saveInstrument(ex.copyWith(archived: !ex.archived));
                if (context.mounted) Navigator.pop(context);
              },
              child: Text(widget.existing!.archived ? l.unarchive : l.archive),
            ),
        ],
      ),
    );
  }
}
