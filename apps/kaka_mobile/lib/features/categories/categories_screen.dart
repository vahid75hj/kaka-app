import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaka_domain/kaka_domain.dart';

import '../../app/providers.dart';
import '../../core/l10n_x.dart';
import '../../theme/kaka_colors.dart';

/// A category as the user sees it: one name, possibly backed by one account per currency.
class CategoryEntry {
  const CategoryEntry(this.name, this.type, {required this.archived, required this.currencies});
  final String name;
  final AccountType type;
  final bool archived;
  final List<Currency> currencies;

  static List<CategoryEntry> group(Iterable<Account> accounts, AccountType type) {
    final byName = <String, List<Account>>{};
    for (final a in accounts.where((a) => a.type == type && !a.isSystem)) {
      byName.putIfAbsent(a.name, () => []).add(a);
    }
    return [
      for (final e in byName.entries)
        CategoryEntry(
          e.key,
          type,
          archived: e.value.every((a) => a.archived),
          currencies: [for (final a in e.value) a.currency],
        ),
    ];
  }
}

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.categories),
          bottom: TabBar(
            tabs: [
              Tab(text: l.expense),
              Tab(text: l.income),
            ],
          ),
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            tooltip: l.addCategory,
            onPressed: () {
              final type = DefaultTabController.of(context).index == 0 ? AccountType.expense : AccountType.income;
              _edit(context, ref, type, null);
            },
            child: const Icon(Icons.add_rounded),
          ),
        ),
        body: const TabBarView(children: [_CategoryList(AccountType.expense), _CategoryList(AccountType.income)]),
      ),
    );
  }
}

Future<void> _edit(BuildContext context, WidgetRef ref, AccountType type, CategoryEntry? existing) async {
  final l = context.l10n;
  final controller = TextEditingController(text: existing?.name ?? '');
  String? error;
  await showDialog<void>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (dialogContext, setState) => AlertDialog(
        title: Text(existing == null ? l.addCategory : l.renameCategory),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: l.categoryName, errorText: error),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(l.cancel)),
          FilledButton(
            onPressed: () async {
              final ledger = ref.read(ledgerProvider);
              try {
                if (existing == null) {
                  await ledger.addCategory(controller.text, type, ref.read(settingsProvider).baseUnit.currency);
                } else {
                  await ledger.renameCategory(type, existing.name, controller.text);
                }
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              } catch (e) {
                setState(() => error = context.mounted ? context.domainError(e) : null);
              }
            },
            child: Text(l.save),
          ),
        ],
      ),
    ),
  );
  controller.dispose();
}

class _CategoryList extends ConsumerWidget {
  const _CategoryList(this.type);
  final AccountType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = KakaColors.of(context);
    final all = CategoryEntry.group(ref.watch(accountsProvider).value ?? const [], type);
    final active = all.where((e) => !e.archived).toList();
    final archived = all.where((e) => e.archived).toList();
    if (all.isEmpty) {
      return Center(
        child: Text(l.noCategories, style: TextStyle(color: c.textMuted)),
      );
    }
    Widget tile(CategoryEntry e) => ListTile(
      leading: Icon(
        type == AccountType.expense ? Icons.sell_outlined : Icons.savings_outlined,
        color: e.archived ? c.textFaint : c.accentText,
      ),
      title: Text(e.name, style: TextStyle(color: e.archived ? c.textFaint : null)),
      subtitle: Text(e.currencies.map((x) => x.code).join(' · '), style: TextStyle(color: c.textMuted, fontSize: 12)),
      onTap: e.archived ? null : () => _edit(context, ref, type, e),
      trailing: IconButton(
        tooltip: e.archived ? l.unarchive : l.archive,
        icon: Icon(e.archived ? Icons.unarchive_outlined : Icons.archive_outlined),
        onPressed: () => ref.read(ledgerProvider).setCategoryArchived(type, e.name, !e.archived),
      ),
    );
    return ListView(
      padding: const EdgeInsets.only(bottom: 96),
      children: [
        for (final e in active) tile(e),
        if (archived.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
            child: Text(
              l.archived,
              style: TextStyle(color: c.textMuted, fontWeight: FontWeight.w700),
            ),
          ),
          for (final e in archived) tile(e),
        ],
      ],
    );
  }
}
