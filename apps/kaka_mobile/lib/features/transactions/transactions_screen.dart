import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n_x.dart';
import '../../theme/kaka_colors.dart';
import 'transaction_tile.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final views = ref.watch(transactionViewsProvider(l.opening));
    return Scaffold(
      appBar: AppBar(title: Text(l.navTransactions)),
      body: views.isEmpty
          ? Center(
              child: Text(l.noTransactions, style: TextStyle(color: KakaColors.of(context).textMuted)),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
              itemCount: views.length,
              separatorBuilder: (_, _) => const Divider(),
              itemBuilder: (_, i) => TransactionTile(views[i]),
            ),
    );
  }
}
