import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kaka_domain/kaka_domain.dart';

import '../../app/providers.dart';
import '../../core/l10n_x.dart';
import '../../theme/kaka_colors.dart';

/// Create a new account, or rename/archive an existing one ([accountId]).
class AccountFormScreen extends ConsumerStatefulWidget {
  const AccountFormScreen({super.key, this.accountId});
  final String? accountId;

  @override
  ConsumerState<AccountFormScreen> createState() => _AccountFormScreenState();
}

class _AccountFormScreenState extends ConsumerState<AccountFormScreen> {
  final _name = TextEditingController();
  final _opening = TextEditingController();
  var _type = AccountType.asset;
  late Currency _currency = ref.read(settingsProvider).baseUnit.currency;
  Account? _existing;
  String? _error;

  @override
  void initState() {
    super.initState();
    final id = widget.accountId;
    if (id != null) {
      ref.read(accountRepositoryProvider).findById(id).then((a) {
        if (!mounted || a == null) return;
        setState(() {
          _existing = a;
          _name.text = a.name;
          _type = a.type;
          _currency = a.currency;
        });
      });
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _opening.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final ledger = ref.read(ledgerProvider);
    final f = ref.read(formatProvider);
    try {
      if (_existing case final a?) {
        await ledger.renameAccount(a, _name.text);
      } else {
        final opening = _opening.text.trim().isEmpty ? null : AmountParser.parse(_opening.text, f.unitFor(_currency));
        await ledger.createAccount(name: _name.text, type: _type, currency: _currency, openingBalance: opening);
      }
      if (mounted) context.pop();
    } catch (e) {
      setState(() => _error = context.domainError(e));
    }
  }

  Future<void> _toggleArchive() async {
    await ref.read(ledgerProvider).setArchived(_existing!, !_existing!.archived);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final f = ref.watch(formatProvider);
    final fa = ref.watch(settingsProvider).isPersian;
    final editing = widget.accountId != null;
    return Scaffold(
      appBar: AppBar(title: Text(editing ? l.editAccount : l.newAccount)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _name,
            autofocus: !editing,
            decoration: InputDecoration(labelText: l.accountName),
          ),
          const SizedBox(height: 16),
          SegmentedButton<AccountType>(
            segments: [
              ButtonSegment(value: AccountType.asset, label: Text(l.typeAsset)),
              ButtonSegment(value: AccountType.liability, label: Text(l.typeLiability)),
            ],
            selected: {_type},
            onSelectionChanged: editing ? null : (v) => setState(() => _type = v.first),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<Currency>(
            initialValue: _currency,
            decoration: InputDecoration(labelText: l.currency),
            items: [
              for (final cur in Currency.builtIn)
                DropdownMenuItem(
                  value: cur,
                  child: Text('${fa ? f.unitFor(cur).nameFa : f.unitFor(cur).nameEn} (${cur.code})'),
                ),
            ],
            onChanged: editing ? null : (v) => setState(() => _currency = v!),
          ),
          if (!editing) ...[
            const SizedBox(height: 16),
            TextField(
              controller: _opening,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: l.openingBalance, suffixText: f.symbol(_currency)),
            ),
          ],
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(_error!, style: TextStyle(color: KakaColors.of(context).negative)),
            ),
          const SizedBox(height: 24),
          FilledButton(onPressed: _save, child: Text(l.save)),
          if (_existing != null) ...[
            const SizedBox(height: 8),
            TextButton(onPressed: _toggleArchive, child: Text(_existing!.archived ? l.unarchive : l.archive)),
          ],
        ],
      ),
    );
  }
}
