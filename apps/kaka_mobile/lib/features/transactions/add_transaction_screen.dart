import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kaka_data/kaka_data.dart';
import 'package:kaka_domain/kaka_domain.dart';

import '../../app/providers.dart';
import '../../core/date_picker.dart';
import '../../core/l10n_x.dart';
import '../../theme/kaka_colors.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key, this.initialAccountId, this.draftId, this.editTxnId});
  final String? initialAccountId;

  /// Edit = void-and-replace: the form is pre-filled from this transaction and
  /// saving records a corrected copy, then voids the original.
  final String? editTxnId;

  /// When set, the form is pre-filled from this question-queue draft and the
  /// draft is marked confirmed once saved.
  final String? draftId;

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _amount = TextEditingController();
  final _note = TextEditingController();
  final _toAmount = TextEditingController();
  LedgerTransaction? _original;
  var _kind = TransactionKind.expense;
  String? _accountId;
  String? _toAccountId;
  String? _category;
  var _date = DateTime.now();
  var _saving = false;
  String? _error;

  Draft? _draft;

  @override
  void initState() {
    super.initState();
    if (widget.draftId != null) _loadDraft(widget.draftId!);
    if (widget.editTxnId != null) _loadOriginal(widget.editTxnId!);
  }

  Future<void> _loadOriginal(String id) async {
    final txns = await ref.read(transactionRepositoryProvider).watchRecent(limit: 100000).first;
    final t = txns.where((t) => t.id == id).firstOrNull;
    if (t == null || !mounted) return;
    final accounts = {for (final a in await ref.read(accountRepositoryProvider).getAll()) a.id: a};
    final f = ref.read(formatProvider);
    final user = t.postings.where((p) => !(accounts[p.accountId]?.isSystem ?? true)).toList();
    final debit = user.where((p) => p.amount.isPositive).firstOrNull;
    final credit = user.where((p) => p.amount.isNegative).firstOrNull;
    if (debit == null || credit == null) return;
    setState(() {
      _original = t;
      _kind = t.kind == TransactionKind.exchange ? TransactionKind.transfer : t.kind;
      _date = t.occurredAt;
      _note.text = t.note;
      switch (t.kind) {
        case TransactionKind.expense:
          _accountId = credit.accountId;
          _category = accounts[debit.accountId]?.name;
          _amount.text = exactAmountText(debit.amount, f.unitFor(debit.amount.currency));
        case TransactionKind.income:
          _accountId = debit.accountId;
          _category = accounts[credit.accountId]?.name;
          _amount.text = exactAmountText(debit.amount, f.unitFor(debit.amount.currency));
        case TransactionKind.transfer || TransactionKind.exchange:
          _accountId = credit.accountId;
          _toAccountId = debit.accountId;
          _amount.text = exactAmountText(-credit.amount, f.unitFor(credit.amount.currency));
          _toAmount.text = exactAmountText(debit.amount, f.unitFor(debit.amount.currency));
        case TransactionKind.opening || TransactionKind.asset:
          break;
      }
    });
  }

  Future<void> _loadDraft(String id) async {
    final d = await DriftDraftRepository(ref.read(databaseProvider)).findById(id);
    if (d == null || !mounted) return;
    final f = ref.read(formatProvider);
    setState(() {
      _draft = d;
      _kind = d.isTransfer
          ? TransactionKind.transfer
          : (d.isExpense ? TransactionKind.expense : TransactionKind.income);
      if (d.isTransfer) _toAccountId = d.toAccountId;
      if (d.category != null && d.category!.isNotEmpty) _category = d.category;
      _amount.text = exactAmountText(d.amount, f.unitFor(d.amount.currency));
      _date = d.occurredAt ?? d.createdAt;
      _note.text = d.note;
      if (d.accountId != null) _accountId = d.accountId;
    });
  }

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    _toAmount.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await pickDate(context, ref.read(formatProvider), initial: _date);
    if (picked != null) {
      final now = DateTime.now();
      setState(() => _date = DateTime(picked.year, picked.month, picked.day, now.hour, now.minute));
    }
  }

  Future<void> _save(List<Account> wallets) async {
    final l = context.l10n;
    final ledger = ref.read(ledgerProvider);
    final f = ref.read(formatProvider);
    final from = wallets.where((a) => a.id == _accountId).firstOrNull ?? wallets.firstOrNull;
    if (from == null) return setState(() => _error = l.errNoAccount);
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final amount = AmountParser.parse(_amount.text, f.unitFor(from.currency));
      Future<void> record() async {
        switch (_kind) {
          case TransactionKind.expense || TransactionKind.income:
            final type = _kind == TransactionKind.expense ? AccountType.expense : AccountType.income;
            final category = await ledger.ensureCategory(_category ?? l.catOther, type, from.currency);
            if (type == AccountType.expense) {
              await ledger.recordExpense(from: from, category: category, amount: amount, at: _date, note: _note.text);
            } else {
              await ledger.recordIncome(to: from, category: category, amount: amount, at: _date, note: _note.text);
            }
          case TransactionKind.transfer:
            final to = wallets.where((a) => a.id == _toAccountId).firstOrNull;
            if (to == null) throw const DomainException('ledger.same_account');
            if (to.currency == from.currency) {
              await ledger.recordTransfer(from: from, to: to, amount: amount, at: _date, note: _note.text);
            } else {
              final received = AmountParser.parse(_toAmount.text, f.unitFor(to.currency));
              await ledger.recordExchange(
                from: from,
                to: to,
                fromAmount: amount,
                toAmount: received,
                at: _date,
                note: _note.text,
              );
            }
          case TransactionKind.opening || TransactionKind.exchange || TransactionKind.asset:
            break;
        }
      }

      if (_original != null) {
        await ledger.replace(_original!, record);
      } else {
        await record();
      }
      if (_draft != null) await ref.read(draftServiceProvider).confirm(_draft!.id);
      if (mounted) context.pop();
    } catch (e) {
      setState(() {
        _saving = false;
        _error = context.domainError(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = KakaColors.of(context);
    final f = ref.watch(formatProvider);
    final accounts = ref.watch(accountsProvider).value ?? const <Account>[];
    final wallets = accounts.where((a) => a.type.isBalanceSheet && !a.archived).toList();
    _accountId ??= widget.initialAccountId ?? wallets.firstOrNull?.id;
    final from = wallets.where((a) => a.id == _accountId).firstOrNull;
    final to = wallets.where((a) => a.id == _toAccountId).firstOrNull;
    final wantedType = _kind == TransactionKind.income ? AccountType.income : AccountType.expense;
    // Category names are shared across currencies; one account per currency is created on demand.
    final categories = {for (final a in accounts.where((a) => a.type == wantedType && !a.archived)) a.name}.toList();
    if (!categories.contains(_category)) _category = categories.firstOrNull;

    return Scaffold(
      appBar: AppBar(title: Text(_original != null ? l.editTransaction : l.addTransaction)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (_draft != null && _draft!.rawText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: c.accentSoft, borderRadius: BorderRadius.circular(12)),
                child: Text(_draft!.rawText, style: TextStyle(color: c.textMuted, fontSize: 12.5, height: 1.5)),
              ),
            ),
          SegmentedButton<TransactionKind>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(value: TransactionKind.expense, label: Text(l.expense)),
              ButtonSegment(value: TransactionKind.income, label: Text(l.income)),
              ButtonSegment(value: TransactionKind.transfer, label: Text(l.transfer)),
            ],
            selected: {_kind},
            onSelectionChanged: (v) => setState(() => _kind = v.first),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _amount,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            decoration: InputDecoration(labelText: l.amount, suffixText: from == null ? null : f.symbol(from.currency)),
          ),
          const SizedBox(height: 16),
          _AccountPicker(
            label: _kind == TransactionKind.income
                ? l.toAccount
                : (_kind == TransactionKind.transfer ? l.fromAccount : l.account),
            accounts: wallets,
            value: _accountId,
            onChanged: (id) => setState(() => _accountId = id),
          ),
          const SizedBox(height: 16),
          if (_kind == TransactionKind.transfer) ...[
            _AccountPicker(
              label: l.toAccount,
              accounts: wallets.where((a) => a.id != _accountId).toList(),
              value: _toAccountId,
              onChanged: (id) => setState(() => _toAccountId = id),
            ),
            if (to != null && from != null && to.currency != from.currency) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _toAmount,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: l.amountReceived, suffixText: f.symbol(to.currency)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(l.exchangeHint, style: TextStyle(color: c.textFaint, fontSize: 12)),
              ),
            ],
          ] else ...[
            Text(l.category, style: TextStyle(color: c.textMuted, fontSize: 13)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final name in categories)
                  ChoiceChip(
                    label: Text(name),
                    selected: name == _category,
                    onSelected: (_) => setState(() => _category = name),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.event_outlined),
            title: Text(l.date),
            trailing: Text(f.date(_date), style: const TextStyle(fontWeight: FontWeight.w700)),
            onTap: _pickDate,
          ),
          TextField(
            controller: _note,
            decoration: InputDecoration(labelText: l.note),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(_error!, style: TextStyle(color: c.negative)),
            ),
          const SizedBox(height: 24),
          FilledButton(onPressed: _saving ? null : () => _save(wallets), child: Text(l.save)),
        ],
      ),
    );
  }
}

class _AccountPicker extends ConsumerWidget {
  const _AccountPicker({required this.label, required this.accounts, required this.value, required this.onChanged});
  final String label;
  final List<Account> accounts;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final valid = accounts.any((a) => a.id == value) ? value : null;
    return DropdownButtonFormField<String>(
      key: ValueKey('$label-${accounts.length}-$valid'),
      initialValue: valid,
      decoration: InputDecoration(labelText: label),
      items: [for (final a in accounts) DropdownMenuItem(value: a.id, child: Text('${a.name} · ${a.currency.code}'))],
      onChanged: onChanged,
    );
  }
}

/// [m] in [unit] without any display rounding (e.g. 1,234,567 rial → "123456.7" toman).
String exactAmountText(Money m, DisplayUnit unit) {
  final p = unit.currency.storageScale + unit.factorPow10;
  if (p <= 0) return (m.minor.abs() * _pow10(-p)).toString();
  final div = _pow10(p);
  final v = m.minor.abs();
  final frac = (v % div).toString().padLeft(p, '0').replaceFirst(RegExp(r'0+$'), '');
  return frac.isEmpty ? '${v ~/ div}' : '${v ~/ div}.$frac';
}

int _pow10(int n) => n == 0 ? 1 : 10 * _pow10(n - 1);
