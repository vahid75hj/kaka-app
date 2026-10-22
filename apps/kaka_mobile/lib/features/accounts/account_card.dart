import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kaka_domain/kaka_domain.dart';

import '../../app/providers.dart';
import '../../app/router.dart';
import '../../core/widgets.dart';
import '../../theme/kaka_colors.dart';

class AccountCard extends ConsumerWidget {
  const AccountCard(this.item, {super.key, this.width});
  final AccountBalance item;
  final double? width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = KakaColors.of(context);
    final f = ref.watch(formatProvider);
    final a = item.account;
    return SizedBox(
      width: width,
      child: KCard(
        onTap: () => context.push(Routes.editAccount(a.id)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  a.type == AccountType.liability ? Icons.credit_card_rounded : Icons.account_balance_wallet_outlined,
                  size: 18,
                  color: c.accentText,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    a.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: AmountText(
                f.money(item.balance),
                color: item.balance.isNegative ? c.negative : c.text,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
