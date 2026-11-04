import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaka_domain/kaka_domain.dart';

import '../../app/providers.dart';
import '../../core/date_picker.dart';
import '../../core/l10n_x.dart';
import '../../theme/kaka_colors.dart';
import 'asset_ui.dart';
import 'event_form_screen.dart';
import 'platforms_screen.dart';

Future<void> openTransferForm(BuildContext context, {String? instrumentId, String? fromPlatformId}) => Navigator.push(
  context,
  MaterialPageRoute<void>(
    builder: (_) => TransferFormScreen(instrumentId: instrumentId, fromPlatformId: fromPlatformId),
  ),
);

/// Moves a quantity between places; cost and purchase dates move with it.
class TransferFormScreen extends ConsumerStatefulWidget {
  const TransferFormScreen({super.key, this.instrumentId, this.fromPlatformId});
  final String? instrumentId;
  final String? fromPlatformId;

  @override
  ConsumerState<TransferFormScreen> createState() => _TransferFormScreenState();
}

class _TransferFormScreenState extends ConsumerState<TransferFormScreen> {
  Instrument? _instrument;
  late String? _from = widget.fromPlatformId;
  String? _to;
  final _qty = TextEditingController();
  final _fee = TextEditingController();
  final _note = TextEditingController();
  DateTime _date = DateTime.now();
  String? _error;

  @override
  void initState() {
    super.initState();
    _instrument = (ref.read(instrumentsProvider).value ?? const <Instrument>[])
        .where((i) => i.id == widget.instrumentId)
        .firstOrNull;
  }

  @override
  void dispose() {
    for (final c in [_qty, _fee, _note]) {
      c.dispose();
    }
    super.dispose();
  }

  HoldingState? get _source => _instrument == null
      ? null
      : ref
            .read(costBasisProvider)
            .holdings
            .values
            .where((h) => h.instrument.id == _instrument!.id && h.platformId == _from && h.qty > 0)
            .firstOrNull;

  Future<void> _save() async {
    final l = context.l10n;
    final src = _source;
    if (_instrument == null || src == null) {
      setState(() => _error = l.errNothingToTransfer);
      return;
    }
    try {
      final q = Qty.parse(_qty.text, _instrument!.qtyScale);
      final fee = _fee.text.trim().isEmpty ? 0 : Qty.parse(_fee.text, _instrument!.qtyScale);
      await ref
          .read(portfolioServiceProvider)
          .transfer(
            instrumentId: _instrument!.id,
            currency: src.currency,
            qty: q,
            fromPlatformId: _from,
            toPlatformId: _to,
            feeQty: fee,
            at: _date,
            note: _note.text,
          );
      if (mounted) Navigator.pop(context);
    } on DomainException catch (e) {
      setState(() => _error = portfolioError(l, e.code));
    } on FormatException {
      setState(() => _error = l.errAmount);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = KakaColors.of(context);
    final f = ref.watch(formatProvider);
    final fa = ref.watch(settingsProvider).isPersian;
    ref.watch(costBasisProvider);
    final platforms = (ref.watch(platformsProvider).value ?? const <AssetPlatform>[])
        .where((p) => !p.archived)
        .toList();
    final src = _source;
    List<DropdownMenuItem<String?>> items() => [
      DropdownMenuItem(value: null, child: Text(l.noPlatform)),
      for (final p in platforms) DropdownMenuItem(value: p.id, child: Text(p.name)),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l.transferAction)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        children: [
          if (platforms.isEmpty) ...[
            Text(l.platformsHint, style: TextStyle(color: c.textMuted)),
            TextButton(onPressed: () => editPlatform(context, ref), child: Text(l.newPlatform)),
          ],
          InstrumentPicker(value: _instrument, onChanged: (v) => setState(() => _instrument = v)),
          DropdownButtonFormField<String?>(
            initialValue: _from,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: l.transferFrom,
              helperText: src == null || _instrument == null ? null : qtyText(f, _instrument!, src.qty, fa),
            ),
            items: items(),
            onChanged: (v) => setState(() => _from = v),
          ),
          DropdownButtonFormField<String?>(
            initialValue: _to,
            isExpanded: true,
            decoration: InputDecoration(labelText: l.transferTo),
            items: items(),
            onChanged: (v) => setState(() => _to = v),
          ),
          if (_instrument != null) ...[
            TextField(
              controller: _qty,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: l.quantitySent, suffixText: _instrument!.unit(fa)),
            ),
            TextField(
              controller: _fee,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l.networkFeeQty,
                helperText: l.networkFeeHint,
                suffixText: _instrument!.unit(fa),
              ),
            ),
          ],
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.event_outlined),
            title: Text(f.date(_date)),
            onTap: () async {
              final d = await pickDate(context, f, initial: _date);
              if (d != null) setState(() => _date = d);
            },
          ),
          TextField(
            controller: _note,
            decoration: InputDecoration(labelText: l.note),
          ),
          if (_error != null) Text(_error!, style: TextStyle(color: c.negative)),
          const SizedBox(height: 12),
          FilledButton(onPressed: _save, child: Text(l.save)),
        ],
      ),
    );
  }
}
