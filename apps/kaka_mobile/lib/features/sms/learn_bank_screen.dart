import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kaka_sms/kaka_sms.dart';

import '../../app/providers.dart';
import '../../core/l10n_x.dart';
import '../../core/widgets.dart';
import '../../theme/kaka_colors.dart';

/// "Teach Kaka a new bank": paste 3–5 SMS of the same bank, preview, save.
class LearnBankScreen extends ConsumerStatefulWidget {
  const LearnBankScreen({super.key});

  @override
  ConsumerState<LearnBankScreen> createState() => _LearnBankScreenState();
}

class _LearnBankScreenState extends ConsumerState<LearnBankScreen> {
  final _name = TextEditingController();
  final _samples = List.generate(5, (_) => TextEditingController());
  LearnResult? _result;
  String? _defaultDirection;

  @override
  void dispose() {
    _name.dispose();
    for (final s in _samples) {
      s.dispose();
    }
    super.dispose();
  }

  void _learn() {
    final samples = [
      for (final s in _samples)
        if (s.text.trim().isNotEmpty) s.text,
    ];
    final name = _name.text.trim().isEmpty ? context.l10n.customBank : _name.text.trim();
    setState(
      () => _result = samples.length < 3
          ? null
          : TemplateLearner.learn(samples, nameFa: name, nameEn: name, defaultDirection: _defaultDirection),
    );
    if (samples.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.learnNeedThree)));
    }
  }

  Future<void> _save() async {
    final bank = _result!.bank!;
    await ref.read(customParserStoreProvider).save(bank.bankId, jsonEncode(bank.toJson()));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.learnSaved)));
      context.pop();
    }
  }

  String _error(String code) {
    final l = context.l10n;
    return switch (code) {
      'layout_mismatch' => l.learnLayoutMismatch,
      'no_amount' => l.learnNoAmount,
      'no_direction' => l.learnNoDirection,
      _ => l.learnFailed,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = KakaColors.of(context);
    final f = ref.watch(formatProvider);
    final local = ref.watch(localBanksProvider).value ?? const <BankParser>[];
    final r = _result;
    return Scaffold(
      appBar: AppBar(title: Text(l.learnBank)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l.learnHint, style: TextStyle(color: c.textMuted, height: 1.6)),
          const SizedBox(height: 12),
          TextField(
            controller: _name,
            decoration: InputDecoration(labelText: l.bankName),
          ),
          for (var i = 0; i < _samples.length; i++)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextField(
                controller: _samples[i],
                minLines: 2,
                maxLines: 6,
                decoration: InputDecoration(labelText: f.digits(l.sampleN(i + 1)), alignLabelWithHint: true),
              ),
            ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String?>(
            initialValue: _defaultDirection,
            decoration: InputDecoration(labelText: l.learnDirection),
            items: [
              DropdownMenuItem(value: null, child: Text(l.learnDirectionAuto)),
              DropdownMenuItem(value: 'debit', child: Text(l.expense)),
              DropdownMenuItem(value: 'credit', child: Text(l.income)),
            ],
            onChanged: (v) => setState(() => _defaultDirection = v),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(onPressed: _learn, icon: const Icon(Icons.auto_fix_high_rounded), label: Text(l.learn)),
          if (r != null) ...[
            SectionHeader(l.preview),
            if (r.error != null) Text(_error(r.error!), style: TextStyle(color: c.negative, height: 1.6)),
            for (final (i, p) in r.previews.indexed)
              KCard(
                child: p == null
                    ? Text(f.digits(l.sampleNotRead(i + 1)), style: TextStyle(color: c.negative))
                    : Text(
                        [
                          '${p.isDebit ? l.expense : l.income}: ${f.money(p.amount)}',
                          if (p.balance != null) '${l.balance}: ${f.money(p.balance!)}',
                          if (p.account != null) '${l.account}: ${f.digits(p.account!)}',
                          if (p.occurredAt != null) '${l.date}: ${f.date(p.occurredAt!)}',
                        ].join('\n'),
                        style: const TextStyle(height: 1.7),
                      ),
              ),
            if (r.ok) ...[const SizedBox(height: 12), FilledButton(onPressed: _save, child: Text(l.learnConfirm))],
          ],
          if (local.isNotEmpty) ...[
            SectionHeader(l.learnedBanks),
            for (final b in local)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.school_outlined),
                title: Text(b.nameFa),
                trailing: IconButton(
                  tooltip: l.delete,
                  icon: const Icon(Icons.delete_outline_rounded),
                  onPressed: () => ref.read(customParserStoreProvider).delete(b.bankId),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
