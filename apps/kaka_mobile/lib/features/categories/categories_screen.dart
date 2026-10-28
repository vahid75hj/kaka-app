import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaka_domain/kaka_domain.dart';

import '../../app/providers.dart';
import '../../core/category_icons.dart';
import '../../core/l10n_x.dart';
import '../../theme/kaka_colors.dart';

/// A category as the user sees it: one name, possibly backed by one account per currency.
class CategoryEntry {
  const CategoryEntry(this.name, this.type, {required this.archived, required this.currencies, this.icon});
  final String? icon;
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
          icon: e.value.map((a) => a.icon).nonNulls.firstOrNull,
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

Future<void> _pickIcon(BuildContext context, WidgetRef ref, CategoryEntry e) async {
  final l = context.l10n;
  final c = KakaColors.of(context);
  final picked = await showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (sheet) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.changeIcon, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final entry in CategoryIcons.all.entries)
                  IconButton.outlined(
                    isSelected: entry.key == e.icon,
                    onPressed: () => Navigator.pop(sheet, entry.key),
                    icon: Icon(entry.value, color: c.accentText),
                  ),
              ],
            ),
            if (e.icon != null) TextButton(onPressed: () => Navigator.pop(sheet, ''), child: Text(l.defaultIcon)),
          ],
        ),
      ),
    ),
  );
  if (picked == null) return;
  await ref.read(ledgerProvider).setCategoryIcon(e.type, e.name, picked.isEmpty ? null : picked);
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
                  if (type == AccountType.expense) {
                    await ref.read(budgetRepositoryProvider).renameCategory(existing.name, controller.text.trim());
                  }
                  await ref
                      .read(recurringRepositoryProvider)
                      .renameCategory(existing.name, controller.text.trim(), isExpense: type == AccountType.expense);
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
      leading: IconButton(
        tooltip: l.changeIcon,
        onPressed: e.archived ? null : () => _pickIcon(context, ref, e),
        icon: Icon(
          CategoryIcons.of(e.icon, name: e.name, type: type),
          color: e.archived ? c.textFaint : c.accentText,
        ),
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
