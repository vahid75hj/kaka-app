import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kaka_domain/kaka_domain.dart';

import '../../app/providers.dart';
import '../../app/router.dart';
import '../../core/l10n_x.dart';
import '../../core/widgets.dart';
import '../../theme/kaka_colors.dart';
import 'share_ingest.dart';

/// The question queue: drafts from SMS / share / AI waiting for a yes or no.
class QueueScreen extends ConsumerWidget {
  const QueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final drafts = ref.watch(pendingDraftsProvider).value ?? const <Draft>[];
    return Scaffold(
      appBar: AppBar(
        title: Text(l.queueTitle),
        actions: [
          IconButton(
            tooltip: l.pasteSms,
            icon: const Icon(Icons.content_paste_go_rounded),
            onPressed: () => showPasteSmsDialog(context, ref),
          ),
        ],
      ),
      body: drafts.isEmpty
          ? EmptyState(
              icon: Icons.inbox_outlined,
              message: l.queueEmpty,
              action: l.pasteSms,
              onAction: () => showPasteSmsDialog(context, ref),
              secondary: ref.watch(settingsProvider).smsAutoRead
                  ? null
                  : TextButton(onPressed: () => context.push(Routes.settings), child: Text(l.smsAutoRead)),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: drafts.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _DraftCard(drafts[i]),
            ),
    );
  }
}

Future<void> showPasteSmsDialog(BuildContext context, WidgetRef ref) async {
  final l = context.l10n;
  final controller = TextEditingController();
  final clip = await Clipboard.getData(Clipboard.kTextPlain);
  if (clip?.text != null) controller.text = clip!.text!;
  if (!context.mounted) return;
  final text = await showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l.pasteSms),
      content: TextField(
        controller: controller,
        maxLines: 6,
        minLines: 3,
        decoration: InputDecoration(hintText: l.pasteSmsHint),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(l.cancel)),
        FilledButton(onPressed: () => Navigator.pop(dialogContext, controller.text), child: Text(l.read)),
      ],
    ),
  );
  controller.dispose();
  if (text == null || text.trim().isEmpty || !context.mounted) return;
  final result = await ref.read(shareIngestProvider).ingest(text, source: DraftSource.manual);
  if (context.mounted) showIngestResult(context, result);
}

void showIngestResult(BuildContext context, IngestResult r) {
  final l = context.l10n;
  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
    SnackBar(
      content: Text(switch (r) {
        IngestResult.added => l.ingestAdded,
        IngestResult.duplicate => l.ingestDuplicate,
        IngestResult.unreadable || IngestResult.ignoredSender => l.ingestUnreadable,
      }),
    ),
  );
}

class _DraftCard extends ConsumerWidget {
  const _DraftCard(this.draft);
  final Draft draft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = KakaColors.of(context);
    final f = ref.watch(formatProvider);
    final signed = draft.isExpense ? -draft.amount : draft.amount;
    final accounts = ref.watch(accountsProvider).value ?? const <Account>[];
    final account = accounts.where((a) => a.id == draft.accountId).firstOrNull;
    final toAccount = accounts.where((a) => a.id == draft.toAccountId).firstOrNull;
    // Optional sanity check: the bank's reported balance vs. Kaka's balance after this draft.
    String? mismatch;
    final bank = draft.balance;
    if (account != null && bank != null && bank.currency == account.currency) {
      final current = (ref.watch(balancesProvider).value ?? const <AccountBalance>[])
          .where((b) => b.account.id == account.id)
          .firstOrNull
          ?.balance;
      if (current != null) {
        final after = current + signed;
        if (after != bank) mismatch = l.balanceMismatch(f.money(bank), f.money(after));
      }
    }
    return KCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                draft.isTransfer
                    ? Icons.swap_horiz_rounded
                    : (draft.isExpense ? Icons.north_east_rounded : Icons.south_west_rounded),
                color: c.accentText,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  [
                    draft.isTransfer ? l.transfer : (draft.isExpense ? l.expense : l.income),
                    if (draft.category != null && draft.category!.isNotEmpty) draft.category!,
                    if (draft.note.isNotEmpty) draft.note,
                    if (draft.accountRef != null) f.digits(_shortRef(draft.accountRef!)),
                  ].join(' · '),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              AmountText(
                f.money(draft.isTransfer ? draft.amount : signed, signed: !draft.isExpense && !draft.isTransfer),
                color: draft.isTransfer ? c.textMuted : (draft.isExpense ? c.text : c.positive),
              ),
            ],
          ),
          if (draft.rawText.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              draft.rawText,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: c.textMuted, fontSize: 12.5, height: 1.5),
            ),
          ],
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              if (account != null)
                _Tag(
                  icon: Icons.account_balance_wallet_outlined,
                  text: toAccount == null ? account.name : '${account.name} → ${toAccount.name}',
                ),
              if (draft.source == DraftSource.ai) _Tag(icon: Icons.auto_awesome_outlined, text: l.fromAi),
              if (account == null && draft.source == DraftSource.sms)
                _Tag(icon: Icons.help_outline, text: l.smsNoAccount),
              if (draft.confidence != null)
                _Tag(
                  icon: draft.confidence! >= 0.8 ? Icons.verified_outlined : Icons.info_outline,
                  text: f.digits(l.confidence((draft.confidence! * 100).round())),
                  warn: draft.confidence! < 0.6,
                ),
              _Tag(icon: Icons.schedule, text: f.date(draft.occurredAt ?? draft.createdAt)),
            ],
          ),
          if (mismatch != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(mismatch, style: TextStyle(color: c.negative, fontSize: 12, height: 1.5)),
            ),
          const SizedBox(height: 10),
          Row(
            children: [
              TextButton(onPressed: () => ref.read(draftServiceProvider).discard(draft.id), child: Text(l.discard)),
              const Spacer(),
              OutlinedButton(
                onPressed: () => context.push(Routes.confirmDraft(draft.id)),
                child: Text(l.editAndConfirm),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _shortRef(String ref) => ref.length > 6 ? '…${ref.substring(ref.length - 5)}' : ref;

class _Tag extends StatelessWidget {
  const _Tag({required this.icon, required this.text, this.warn = false});
  final IconData icon;
  final String text;
  final bool warn;

  @override
  Widget build(BuildContext context) {
    final c = KakaColors.of(context);
    final color = warn ? c.negative : c.textMuted;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: color, fontSize: 11.5)),
      ],
    );
  }
}
