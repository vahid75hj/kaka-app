import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaka_domain/kaka_domain.dart';

import '../../app/providers.dart';
import '../../core/date_picker.dart';
import '../../core/l10n_x.dart';
import '../../core/money_input.dart';
import '../../core/widgets.dart';
import '../../theme/kaka_colors.dart';
import 'asset_ui.dart';
import 'instrument_form_screen.dart';

Future<void> openEventForm(BuildContext context, EventKind kind, {String? instrumentId, String? platformId}) =>
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => EventFormScreen(kind: kind, instrumentId: instrumentId, platformId: platformId),
      ),
    );

Future<void> openSwapForm(BuildContext context, {String? instrumentId}) =>
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => SwapFormScreen(giveInstrumentId: instrumentId)));

/// Dropdown of assets with a "new asset" shortcut.
class InstrumentPicker extends ConsumerWidget {
  const InstrumentPicker({super.key, required this.value, required this.onChanged, this.label});
  final Instrument? value;
  final ValueChanged<Instrument> onChanged;
  final String? label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final fa = ref.watch(settingsProvider).isPersian;
    final all = (ref.watch(instrumentsProvider).value ?? const <Instrument>[]).where((i) => !i.archived).toList();
    final current = all.where((i) => i.id == value?.id).firstOrNull;
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<Instrument>(
            key: ValueKey(current?.id),
            initialValue: current,
            isExpanded: true,
            decoration: InputDecoration(labelText: label ?? l.asset),
            hint: Text(l.pickAsset),
            items: [for (final i in all) DropdownMenuItem(value: i, child: Text(i.name(fa)))],
            onChanged: (i) => onChanged(i!),
          ),
        ),
        IconButton(
          tooltip: l.newAsset,
          icon: const Icon(Icons.add_box_outlined),
          onPressed: () async {
            final created = await Navigator.push<Instrument>(
              context,
              MaterialPageRoute(builder: (_) => const InstrumentFormScreen()),
            );
            if (created != null) onChanged(created);
          },
        ),
      ],
    );
  }
}

/// One form for buy, sell, already-owned, gift, income, split and adjustment.
class EventFormScreen extends ConsumerStatefulWidget {
  const EventFormScreen({super.key, required this.kind, this.instrumentId, this.platformId});
  final EventKind kind;
  final String? instrumentId;
  final String? platformId;

  @override
  ConsumerState<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends ConsumerState<EventFormScreen> {
  late EventKind _kind = widget.kind;
  Instrument? _instrument;
  Currency? _currency;
  Account? _cash;
  late String? _platformId = widget.platformId;
  DateTime _date = DateTime.now();
  CostMode _costMode = CostMode.custom;
  bool _inKind = false;
  final _qty = TextEditingController();
  final _total = TextEditingController();
  final _fee = TextEditingController();
  final _num = TextEditingController(text: '2');
  final _den = TextEditingController(text: '1');
  final _note = TextEditingController();
  String? _error;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final all = ref.read(instrumentsProvider).value ?? const <Instrument>[];
    _instrument = all.where((i) => i.id == widget.instrumentId).firstOrNull;
    if (_instrument != null) _currency = _defaultCurrency(_instrument!);
  }

  @override
  void dispose() {
    for (final c in [_qty, _total, _fee, _num, _den, _note]) {
      c.dispose();
    }
    super.dispose();
  }

  /// The currency an existing holding of [i] keeps its cost in, else the base.
  Currency _defaultCurrency(Instrument i) {
    final held = ref
        .read(costBasisProvider)
        .holdings
        .values
        .where((h) => h.instrument.id == i.id && h.platformId == _platformId && h.qty > 0);
    return held.firstOrNull?.currency ?? ref.read(settingsProvider).baseUnit.currency;
  }

  Currency get _cur => _cash?.currency ?? _currency ?? ref.read(settingsProvider).baseUnit.currency;

  bool get _usesCash => _kind == EventKind.buy || _kind == EventKind.sell || (_kind == EventKind.income && !_inKind);
  bool get _hasQty => _kind != EventKind.split && !(_kind == EventKind.income && !_inKind);
  bool get _hasCostMode => _kind == EventKind.opening || _kind == EventKind.giftIn || _kind == EventKind.adjustIn;

  int? _parseQty() {
    if (!_hasQty) return 0;
    try {
      final q = Qty.parse(_qty.text, _instrument!.qtyScale);
      return q > 0 ? q : null;
    } on FormatException {
      return null;
    }
  }

  int? _parseMoney(TextEditingController c) {
    if (c.text.trim().isEmpty) return null;
    try {
      return parseUserMoney(ref.read(formatProvider), c.text, _cur).minor;
    } on Object {
      return -1;
    }
  }

  /// Value of [qty] at the latest price, in the event currency when convertible.
  int? _todayValue(int qty) {
    final p = PortfolioValuation.latestPrices(ref.read(priceQuotesProvider).value ?? const [])[_instrument!.id];
    if (p == null) return null;
    final v = roundHalfEven(
      BigInt.from(p.price.minor) * BigInt.from(qty),
      BigInt.from(10).pow(_instrument!.qtyScale),
    ).toInt();
    final money = Money(v, p.price.currency);
    if (money.currency == _cur) return v;
    final fx = ref.read(converterProvider);
    if (_cur == fx.base) return fx.toBase(money)?.minor;
    return null;
  }

  /// Builds the event without saving; throws a l10n-ready message.
  PortfolioEvent _draft() {
    final l = context.l10n;
    final i = _instrument;
    if (i == null) throw l.pickAsset;
    final qty = _parseQty();
    if (qty == null) throw l.errAmount;
    final total = _parseMoney(_total);
    final fee = _parseMoney(_fee) ?? 0;
    if (total == -1 || fee == -1) throw l.errAmount;
    int? cost;
    var mode = CostMode.paid;
    if (_hasCostMode) {
      mode = _costMode;
      if (mode == CostMode.custom) {
        if (total == null) throw l.errAmount;
        cost = total;
      } else if (mode == CostMode.fairValue) {
        cost = _todayValue(qty);
        if (cost == null) throw l.errNoPriceForValue;
      }
    }
    if (_kind == EventKind.income && _inKind) {
      cost = total ?? _todayValue(qty);
      mode = CostMode.fairValue;
    }
    if (_kind == EventKind.income && !_inKind && (total ?? 0) <= 0) throw l.errAmount;
    if (_cash != null && (total ?? 0) <= 0) throw l.errTotalRequired;
    final n = int.tryParse(_num.text.trim()), d = int.tryParse(_den.text.trim());
    if (_kind == EventKind.split && ((n ?? 0) <= 0 || (d ?? 0) <= 0)) throw l.errAmount;
    return PortfolioEvent(
      id: 'draft',
      instrumentId: i.id,
      platformId: _platformId,
      kind: _kind,
      at: _date,
      currency: _cur,
      qty: qty,
      gross: _usesCash ? total : null,
      fee: fee,
      costMode: mode,
      cost: cost,
      splitNum: _kind == EventKind.split ? n : null,
      splitDen: _kind == EventKind.split ? d : null,
    );
  }

  Future<void> _save() async {
    final l = context.l10n;
    final PortfolioEvent e;
    try {
      e = _draft();
    } on String catch (msg) {
      setState(() => _error = msg);
      return;
    }
    setState(() => _busy = true);
    try {
      await ref
          .read(portfolioServiceProvider)
          .record(
            instrumentId: e.instrumentId,
            kind: e.kind,
            currency: e.currency,
            qty: e.qty,
            gross: e.gross,
            fee: e.fee,
            costMode: e.costMode,
            cost: e.cost,
            splitNum: e.splitNum,
            splitDen: e.splitDen,
            platformId: e.platformId,
            cash: _usesCash ? _cash : null,
            at: e.at,
            note: _note.text,
          );
      if (mounted) Navigator.pop(context);
    } on DomainException catch (err) {
      setState(() {
        _busy = false;
        _error = portfolioError(l, err.code);
      });
    }
  }

  /// What saving would do: new average, gain of this sale, or why it can't be saved.
  String? _preview() {
    final l = context.l10n;
    final f = ref.read(formatProvider);
    final fa = ref.read(settingsProvider).isPersian;
    final PortfolioEvent e;
    try {
      e = _draft();
    } on String {
      return null;
    }
    final instruments = ref.read(instrumentsProvider).value ?? const <Instrument>[];
    final events = ref.read(portfolioEventsProvider).value ?? const <PortfolioEvent>[];
    final r = CostBasis.compute(instruments, [...events, e]);
    if (r.errors[e.id] == 'portfolio.oversell') {
      final held = ref.read(costBasisProvider).holdings[holdingKey(e.instrumentId, e.platformId, e.currency)]?.qty ?? 0;
      return l.errSellMoreThanHeld(qtyText(f, _instrument!, held, fa));
    }
    if (r.errors.isNotEmpty) return l.errBreaksLater;
    final h = r.holdings[holdingKey(e.instrumentId, e.platformId, e.currency)];
    final fx = r.effects[e.id];
    final parts = <String>[];
    if (h != null && h.averageCost != null) {
      parts.add('${l.averageCost}: ${f.money(Money(h.averageCost!, e.currency))}');
    }
    if (e.kind == EventKind.sell && fx?.proceeds != null) {
      parts.add('${l.realizedGain}: ${f.money(Money(fx!.gain, e.currency), signed: true)}');
    }
    if (h != null) parts.add('${l.quantity}: ${qtyText(f, _instrument!, h.qty, fa)}');
    return parts.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = KakaColors.of(context);
    final f = ref.watch(formatProvider);
    final fa = ref.watch(settingsProvider).isPersian;
    ref.watch(costBasisProvider);
    final cashAccounts = (ref.watch(accountsProvider).value ?? const <Account>[])
        .where((a) => a.type.isBalanceSheet && !a.isSystem && !a.archived)
        .toList();
    final platforms = (ref.watch(platformsProvider).value ?? const <AssetPlatform>[])
        .where((p) => !p.archived)
        .toList();
    final i = _instrument;
    final preview = i == null ? null : _preview();
    final totalLabel = switch (_kind) {
      EventKind.buy => l.totalPaidInclFees,
      EventKind.sell => l.totalReceivedNet,
      EventKind.income => _inKind ? l.fairValueOptional : l.amount,
      _ => l.costAmount,
    };

    return Scaffold(
      appBar: AppBar(title: Text(kindName(l, _kind))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        children: [
          if (_kind == EventKind.adjustIn || _kind == EventKind.adjustOut)
            SegmentedButton<EventKind>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(value: EventKind.adjustIn, label: Text(l.evAdjustIn)),
                ButtonSegment(value: EventKind.adjustOut, label: Text(l.evAdjustOut)),
              ],
              selected: {_kind},
              onSelectionChanged: (v) => setState(() => _kind = v.first),
            ),
          if (_kind == EventKind.buy || _kind == EventKind.sell)
            SegmentedButton<EventKind>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(value: EventKind.buy, label: Text(l.buy)),
                ButtonSegment(value: EventKind.sell, label: Text(l.sell)),
              ],
              selected: {_kind},
              onSelectionChanged: (v) => setState(() => _kind = v.first),
            ),
          InstrumentPicker(
            value: i,
            onChanged: (v) => setState(() {
              _instrument = v;
              _currency = _defaultCurrency(v);
            }),
          ),
          if (platforms.isNotEmpty)
            DropdownButtonFormField<String?>(
              initialValue: _platformId,
              isExpanded: true,
              decoration: InputDecoration(labelText: l.platform),
              items: [
                DropdownMenuItem(value: null, child: Text(l.noPlatform)),
                for (final p in platforms) DropdownMenuItem(value: p.id, child: Text(p.name)),
              ],
              onChanged: (v) => setState(() => _platformId = v),
            ),
          if (_kind == EventKind.income)
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l.incomeInKind),
              subtitle: Text(l.incomeInKindHint),
              value: _inKind,
              onChanged: (v) => setState(() => _inKind = v),
            ),
          if (_hasQty && i != null)
            TextField(
              controller: _qty,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: l.quantity,
                suffixText: i.unit(fa),
                helperText: i.qtyScale == 0 ? null : l.upToDecimals(f.digits('${i.qtyScale}')),
              ),
            ),
          if (_kind == EventKind.split)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _num,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(labelText: l.splitNew),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(12), child: Text(':')),
                Expanded(
                  child: TextField(
                    controller: _den,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(labelText: l.splitOld),
                  ),
                ),
              ],
            ),
          if (_usesCash)
            DropdownButtonFormField<Account?>(
              initialValue: _cash,
              isExpanded: true,
              decoration: InputDecoration(labelText: _kind == EventKind.buy ? l.payFrom : l.receiveInto),
              items: [
                DropdownMenuItem(value: null, child: Text(l.noCashAccount)),
                for (final a in cashAccounts)
                  DropdownMenuItem(value: a, child: Text('${a.name} (${f.symbol(a.currency)})')),
              ],
              onChanged: (a) => setState(() => _cash = a),
            ),
          if (_hasCostMode) ...[
            const SizedBox(height: 12),
            Text(l.costQuestion, style: const TextStyle(fontWeight: FontWeight.w600)),
            RadioGroup<CostMode>(
              groupValue: _costMode,
              onChanged: (v) => setState(() => _costMode = v!),
              child: Column(
                children: [
                  RadioListTile(contentPadding: EdgeInsets.zero, value: CostMode.custom, title: Text(l.costKnown)),
                  RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    value: CostMode.fairValue,
                    title: Text(l.costTodayValue),
                  ),
                  RadioListTile(contentPadding: EdgeInsets.zero, value: CostMode.unknown, title: Text(l.costUnknown)),
                ],
              ),
            ),
          ],
          if (_kind != EventKind.split &&
              _kind != EventKind.giftOut &&
              _kind != EventKind.adjustOut &&
              (!_hasCostMode || _costMode == CostMode.custom))
            TextField(
              controller: _total,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: _usesCash && _cash == null && _kind != EventKind.income
                    ? '$totalLabel (${l.optional})'
                    : totalLabel,
                suffixText: f.symbol(_cur),
              ),
            ),
          if (_cash == null && i != null && _kind != EventKind.split)
            DropdownButtonFormField<Currency>(
              initialValue: _cur,
              decoration: InputDecoration(labelText: l.currency),
              items: [for (final cur in Currency.builtIn) DropdownMenuItem(value: cur, child: Text(f.symbol(cur)))],
              onChanged: (v) => setState(() => _currency = v),
            ),
          if (_kind == EventKind.buy || _kind == EventKind.sell)
            TextField(
              controller: _fee,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l.feeOptional,
                helperText: _kind == EventKind.buy ? l.feeIncludedBuy : l.feeIncludedSell,
                suffixText: f.symbol(_cur),
              ),
            ),
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
          if (preview != null && preview.isNotEmpty)
            KCard(
              child: Text(preview, style: TextStyle(color: c.textMuted)),
            ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(_error!, style: TextStyle(color: c.negative)),
            ),
          const SizedBox(height: 12),
          FilledButton(onPressed: _busy ? null : _save, child: Text(l.save)),
        ],
      ),
    );
  }
}

/// Asset-for-asset exchange, e.g. paying for a coin with gold.
class SwapFormScreen extends ConsumerStatefulWidget {
  const SwapFormScreen({super.key, this.giveInstrumentId});
  final String? giveInstrumentId;

  @override
  ConsumerState<SwapFormScreen> createState() => _SwapFormScreenState();
}

class _SwapFormScreenState extends ConsumerState<SwapFormScreen> {
  Instrument? _give;
  Instrument? _get;
  final _giveQty = TextEditingController();
  final _getQty = TextEditingController();
  final _value = TextEditingController();
  final _note = TextEditingController();
  Currency? _currency;
  DateTime _date = DateTime.now();
  String? _error;

  @override
  void initState() {
    super.initState();
    _give = (ref.read(instrumentsProvider).value ?? const <Instrument>[])
        .where((i) => i.id == widget.giveInstrumentId)
        .firstOrNull;
  }

  @override
  void dispose() {
    for (final c in [_giveQty, _getQty, _value, _note]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final l = context.l10n;
    final f = ref.read(formatProvider);
    final cur = _currency ?? _giveCurrency() ?? ref.read(settingsProvider).baseUnit.currency;
    try {
      if (_give == null || _get == null) throw const FormatException();
      final gq = Qty.parse(_giveQty.text, _give!.qtyScale);
      final rq = Qty.parse(_getQty.text, _get!.qtyScale);
      final value = parseUserMoney(f, _value.text, cur);
      await ref
          .read(portfolioServiceProvider)
          .swap(
            giveInstrumentId: _give!.id,
            giveQty: gq,
            getInstrumentId: _get!.id,
            getQty: rq,
            fairValue: value,
            at: _date,
            note: _note.text,
          );
      if (mounted) Navigator.pop(context);
    } on DomainException catch (e) {
      setState(() => _error = portfolioError(l, e.code));
    } on Object {
      setState(() => _error = l.errAmount);
    }
  }

  Currency? _giveCurrency() => _give == null
      ? null
      : ref
            .read(costBasisProvider)
            .holdings
            .values
            .where((h) => h.instrument.id == _give!.id && h.platformId == null && h.qty > 0)
            .firstOrNull
            ?.currency;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = KakaColors.of(context);
    final f = ref.watch(formatProvider);
    final fa = ref.watch(settingsProvider).isPersian;
    final cur = _currency ?? _giveCurrency() ?? ref.watch(settingsProvider).baseUnit.currency;
    return Scaffold(
      appBar: AppBar(title: Text(l.swapAction)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        children: [
          Text(l.swapHint, style: TextStyle(color: c.textMuted)),
          InstrumentPicker(label: l.swapGive, value: _give, onChanged: (v) => setState(() => _give = v)),
          if (_give != null)
            TextField(
              controller: _giveQty,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: l.quantity, suffixText: _give!.unit(fa)),
            ),
          InstrumentPicker(label: l.swapGet, value: _get, onChanged: (v) => setState(() => _get = v)),
          if (_get != null)
            TextField(
              controller: _getQty,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: l.quantity, suffixText: _get!.unit(fa)),
            ),
          TextField(
            controller: _value,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: l.swapValue, helperText: l.swapValueHint, suffixText: f.symbol(cur)),
          ),
          DropdownButtonFormField<Currency>(
            initialValue: cur,
            decoration: InputDecoration(labelText: l.currency),
            items: [for (final x in Currency.builtIn) DropdownMenuItem(value: x, child: Text(f.symbol(x)))],
            onChanged: (v) => setState(() => _currency = v),
          ),
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
