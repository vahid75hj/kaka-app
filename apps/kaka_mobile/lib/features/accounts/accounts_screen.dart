import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kaka_domain/kaka_domain.dart';

import '../../app/providers.dart';
import '../../app/router.dart';
import '../../core/l10n_x.dart';
import '../../core/widgets.dart';
import '../../theme/kaka_colors.dart';
import 'account_card.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = KakaColors.of(context);
    final all = (ref.watch(balancesProvider).value ?? const <AccountBalance>[])
        .where((b) => b.account.type.isBalanceSheet)
        .toList();
    final active = all.where((b) => !b.account.archived).toList();
    final archived = all.where((b) => b.account.archived).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(l.navAccounts),
        actions: [
          IconButton(
            onPressed: () => context.push(Routes.newAccount),
            icon: const Icon(Icons.add_rounded),
            tooltip: l.newAccount,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        children: [
          for (final b in active) Padding(padding: const EdgeInsets.only(bottom: 10), child: AccountCard(b)),
          if (archived.isNotEmpty) ...[
            SectionHeader(l.archived),
            for (final b in archived)
              Opacity(
                opacity: 0.55,
                child: Padding(padding: const EdgeInsets.only(bottom: 10), child: AccountCard(b)),
              ),
          ],
          const SizedBox(height: 8),
          Text(l.archiveHint, style: TextStyle(color: c.textFaint, fontSize: 12)),
        ],
      ),
    );
  }
}
