import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaka_domain/kaka_domain.dart';

import '../../app/providers.dart';
import '../../core/l10n_x.dart';
import '../../core/widgets.dart';
import '../../theme/kaka_colors.dart';
import 'asset_ui.dart';
import 'holding_screen.dart';

IconData platformIcon(PlatformKind k) => switch (k) {
  PlatformKind.exchange => Icons.currency_exchange,
  PlatformKind.broker => Icons.business_center_outlined,
  PlatformKind.wallet => Icons.account_balance_wallet_outlined,
  PlatformKind.app => Icons.phone_android,
  PlatformKind.bank => Icons.account_balance_outlined,
  PlatformKind.home => Icons.lock_outline,
  PlatformKind.person => Icons.person_outline,
  PlatformKind.other => Icons.place_outlined,
};

/// Places assets are kept (exchanges, brokers, wallets, apps, a safe…), defined by the user.
class PlatformsScreen extends ConsumerWidget {
  const PlatformsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = KakaColors.of(context);
    final f = ref.watch(formatProvider);
    final fa = ref.watch(settingsProvider).isPersian;
    final hide = ref.watch(settingsProvider).hideAmounts;
    final platforms = ref.watch(platformsProvider).value ?? const <AssetPlatform>[];
    final views = ref.watch(holdingViewsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.platforms)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => editPlatform(context, ref),
        icon: const Icon(Icons.add_rounded),
        label: Text(l.newPlatform),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(l.platformsHint, style: TextStyle(color: c.textMuted)),
          ),
          for (final p in platforms) ...[
            SectionHeader(
              p.archived ? '${p.name} (${l.archive})' : p.name,
              action: l.edit,
              onAction: () => editPlatform(context, ref, p),
            ),
            for (final v in views.where((v) => v.state.platformId == p.id))
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(classIcon(v.instrument.assetClass)),
                title: Text(v.instrument.name(fa)),
                subtitle: Text(qtyText(f, v.instrument, v.state.qty, fa)),
                trailing: AmountText(moneyOrHidden(f, v.bestValue, hide: hide)),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (_) => HoldingScreen(holdingKey: v.state.key)),
                ),
              ),
            if (!views.any((v) => v.state.platformId == p.id))
              Text(l.nothingHere, style: TextStyle(color: c.textFaint)),
          ],
        ],
      ),
    );
  }
}

Future<void> editPlatform(BuildContext context, WidgetRef ref, [AssetPlatform? existing]) async {
  final l = context.l10n;
  final name = TextEditingController(text: existing?.name ?? '');
  var kind = existing?.kind ?? PlatformKind.exchange;
  var archived = existing?.archived ?? false;
  String? error;
  await showDialog<void>(
    context: context,
    builder: (dc) => StatefulBuilder(
      builder: (dc, setState) => AlertDialog(
        title: Text(existing == null ? l.newPlatform : l.edit),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              autofocus: true,
              decoration: InputDecoration(labelText: l.platformName, errorText: error),
            ),
            DropdownButtonFormField<PlatformKind>(
              initialValue: kind,
              isExpanded: true,
              items: [
                for (final k in PlatformKind.values)
                  DropdownMenuItem(
                    value: k,
                    child: Row(
                      children: [
                        Icon(platformIcon(k), size: 18),
                        const SizedBox(width: 8),
                        Text(platformKindName(l, k)),
                      ],
                    ),
                  ),
              ],
              onChanged: (v) => setState(() => kind = v!),
            ),
            if (existing != null)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l.archive),
                value: archived,
                onChanged: (v) => setState(() => archived = v),
              ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dc), child: Text(l.cancel)),
          FilledButton(
            onPressed: () async {
              try {
                await ref
                    .read(portfolioServiceProvider)
                    .savePlatform(id: existing?.id, name: name.text, kind: kind, archived: archived);
                if (dc.mounted) Navigator.pop(dc);
              } on DomainException {
                setState(() => error = l.errNameRequired);
              }
            },
            child: Text(l.save),
          ),
        ],
      ),
    ),
  );
  name.dispose();
}
