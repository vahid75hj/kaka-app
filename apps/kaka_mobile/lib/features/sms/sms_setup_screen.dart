import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kaka_domain/kaka_domain.dart';
import 'package:kaka_sms/kaka_sms.dart';

import '../../app/providers.dart';
import '../../app/router.dart';
import '../../core/l10n_x.dart';
import '../../core/widgets.dart';
import '../../theme/kaka_colors.dart';
import 'sms_auto_reader.dart';

final _insightsProvider = FutureProvider.autoDispose<List<SenderInsight>>((ref) async {
  final parser = await ref.watch(smsParserProvider.future);
  final summaries = await ref
      .read(smsPlatformProvider)
      .senders(since: DateTime.now().subtract(const Duration(days: 180)));
  final insights = summaries.map(parser.classify).toList()
    ..sort((a, b) {
      if (a.looksLikeBank != b.looksLikeBank) return a.looksLikeBank ? -1 : 1;
      return b.summary.count.compareTo(a.summary.count);
    });
  return insights;
});

/// "Which SMS sender is which account": only senders switched on here are read.
class SmsSetupScreen extends ConsumerStatefulWidget {
  const SmsSetupScreen({super.key});

  @override
  ConsumerState<SmsSetupScreen> createState() => _SmsSetupScreenState();
}

class _SmsSetupScreenState extends ConsumerState<SmsSetupScreen> {
  var _showAll = false;
  var _scanning = false;

  static String _senderId(String s) => 'sender:$s';
  static String _numberId(String n) => 'num:${SmsText.digitsOnly(n)}';

  Future<void> _scanNow() async {
    final l = context.l10n;
    setState(() => _scanning = true);
    final added = await ref
        .read(smsAutoReaderProvider)
        .scan(since: DateTime.now().subtract(SmsAutoReader.firstScanWindow));
    if (!mounted) return;
    setState(() => _scanning = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(ref.read(formatProvider).digits(l.smsScanResult(added)))));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = KakaColors.of(context);
    final insights = ref.watch(_insightsProvider);
    final links = ref.watch(smsLinksProvider).value ?? const <SmsLink>[];
    final wallets = (ref.watch(accountsProvider).value ?? const <Account>[])
        .where((a) => a.type.isBalanceSheet && !a.archived && !a.isSystem)
        .toList();
    final repo = ref.read(smsLinkRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.smsSetupTitle),
        actions: [
          IconButton(
            tooltip: l.newAccount,
            icon: const Icon(Icons.add_card_rounded),
            onPressed: () => context.push(Routes.newAccount),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: _scanning || SmsAccountMatcher.linkedSenders(links).isEmpty ? null : _scanNow,
            icon: _scanning
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.manage_search_rounded),
            label: Text(l.smsScanNow),
          ),
        ),
      ),
      body: insights.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l.errGeneric)),
        data: (all) {
          final shown = _showAll ? all : all.where((i) => i.looksLikeBank).toList();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(l.smsSetupHint, style: TextStyle(color: c.textMuted, height: 1.6)),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l.smsShowAllSenders),
                value: _showAll,
                onChanged: (v) => setState(() => _showAll = v),
              ),
              if (shown.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    l.smsNoSenders,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: c.textMuted),
                  ),
                ),
              for (final i in shown) ...[
                _SenderCard(
                  insight: i,
                  wallets: wallets,
                  link: links.where((x) => x.id == _senderId(SmsText.sender(i.summary.sender))).firstOrNull,
                  numberLinks: {for (final a in i.accounts) a: links.where((x) => x.id == _numberId(a)).firstOrNull},
                  onSender: (enabled, accountId) async {
                    final s = SmsText.sender(i.summary.sender);
                    if (!enabled) return repo.delete(_senderId(s));
                    await repo.upsert(SmsLink(id: _senderId(s), sender: s, accountId: accountId));
                  },
                  onNumber: (number, accountId) async {
                    if (accountId == null) return repo.delete(_numberId(number));
                    await repo.upsert(SmsLink(id: _numberId(number), accountNumber: number, accountId: accountId));
                  },
                ),
                const SizedBox(height: 12),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _SenderCard extends ConsumerWidget {
  const _SenderCard({
    required this.insight,
    required this.wallets,
    required this.link,
    required this.numberLinks,
    required this.onSender,
    required this.onNumber,
  });
  final SenderInsight insight;
  final List<Account> wallets;
  final SmsLink? link;
  final Map<String, SmsLink?> numberLinks;
  final Future<void> Function(bool enabled, String? accountId) onSender;
  final Future<void> Function(String number, String? accountId) onNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = KakaColors.of(context);
    final f = ref.watch(formatProvider);
    final fa = ref.watch(settingsProvider).isPersian;
    final enabled = link != null;
    final bankName = insight.bank == null ? null : (fa ? insight.bank!.nameFa : insight.bank!.nameEn);

    List<DropdownMenuItem<String?>> items(String none) => [
      DropdownMenuItem(value: null, child: Text(none)),
      for (final a in wallets) DropdownMenuItem(value: a.id, child: Text('${a.name} · ${a.currency.code}')),
    ];

    return KCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(insight.summary.sender, style: const TextStyle(fontWeight: FontWeight.w800)),
            subtitle: Text(
              [?bankName, f.digits(l.smsMessageCount(insight.summary.count))].join(' · '),
              style: TextStyle(color: c.textMuted, fontSize: 12),
            ),
            value: enabled,
            onChanged: (v) => onSender(v, link?.accountId),
          ),
          if (insight.summary.samples.isNotEmpty)
            Text(
              insight.summary.samples.first,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: c.textFaint, fontSize: 12, height: 1.5),
            ),
          if (enabled) ...[
            const SizedBox(height: 12),
            DropdownButtonFormField<String?>(
              initialValue: wallets.any((a) => a.id == link!.accountId) ? link!.accountId : null,
              decoration: InputDecoration(labelText: l.smsDefaultAccount),
              items: items(l.smsAskEachTime),
              onChanged: (id) => onSender(true, id),
            ),
            for (final e in numberLinks.entries) ...[
              const SizedBox(height: 10),
              DropdownButtonFormField<String?>(
                initialValue: wallets.any((a) => a.id == e.value?.accountId) ? e.value!.accountId : null,
                decoration: InputDecoration(labelText: f.digits(l.smsAccountNumber(e.key))),
                items: items(l.smsUseDefault),
                onChanged: (id) => onNumber(e.key, id),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
