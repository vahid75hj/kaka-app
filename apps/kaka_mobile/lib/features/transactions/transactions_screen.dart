import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaka_domain/kaka_domain.dart';

import '../../app/providers.dart';
import '../../core/date_picker.dart';
import '../../core/l10n_x.dart';
import '../../theme/kaka_colors.dart';
import 'transaction_tile.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  final _search = TextEditingController();
  var _query = const TransactionQuery();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _toggleKind(TransactionKind k) {
    final kinds = {..._query.kinds};
    if (!kinds.remove(k)) kinds.add(k);
    setState(() => _query = _query.copyWith(kinds: kinds));
  }

  Future<void> _pickRange(bool start) async {
    final f = ref.read(formatProvider);
    final picked = await pickDate(context, f, initial: (start ? _query.from : _query.to) ?? DateTime.now());
    if (picked == null) return;
    setState(() => _query = start ? _query.copyWith(from: () => picked) : _query.copyWith(to: () => picked));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = KakaColors.of(context);
    final f = ref.watch(formatProvider);
    final accounts = ref.watch(accountsProvider).value ?? const <Account>[];
    final byId = {for (final a in accounts) a.id: a};
    final views = ref
        .watch(transactionViewsProvider((opening: l.opening, asset: l.goldAndCoins)))
        .where((v) => _query.matches(v.txn, byId))
        .toList();
    final pickable = accounts.where((a) => !a.isSystem && a.type != AccountType.equity).toList();

    return Scaffold(
      appBar: AppBar(title: Text(l.navTransactions)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _search,
              onChanged: (t) => setState(() => _query = _query.copyWith(text: t)),
              decoration: InputDecoration(
                hintText: l.searchHint,
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _search.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => setState(() {
                          _search.clear();
                          _query = _query.copyWith(text: '');
                        }),
                      ),
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                for (final (k, label) in [
                  (TransactionKind.expense, l.expense),
                  (TransactionKind.income, l.income),
                  (TransactionKind.transfer, l.transfer),
                ])
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: FilterChip(
                      label: Text(label),
                      selected: _query.kinds.contains(k),
                      onSelected: (_) => _toggleKind(k),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: PopupMenuButton<String?>(
                    tooltip: l.filterAccount,
                    onSelected: (id) => setState(() => _query = _query.copyWith(accountId: () => id)),
                    itemBuilder: (_) => [
                      PopupMenuItem(value: null, child: Text(l.allAccounts)),
                      for (final a in pickable)
                        PopupMenuItem(value: a.id, child: Text('${a.name} · ${a.currency.code}')),
                    ],
                    child: Chip(
                      avatar: const Icon(Icons.account_balance_wallet_outlined, size: 18),
                      label: Text(byId[_query.accountId]?.name ?? l.allAccounts),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: ActionChip(
                    avatar: const Icon(Icons.event_outlined, size: 18),
                    label: Text(_query.from == null ? l.fromDate : f.date(_query.from!)),
                    onPressed: () => _pickRange(true),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: ActionChip(
                    avatar: const Icon(Icons.event_outlined, size: 18),
                    label: Text(_query.to == null ? l.toDate : f.date(_query.to!)),
                    onPressed: () => _pickRange(false),
                  ),
                ),
                if (!_query.isEmpty)
                  ActionChip(
                    avatar: const Icon(Icons.filter_alt_off_outlined, size: 18),
                    label: Text(l.clearFilters),
                    onPressed: () => setState(() {
                      _search.clear();
                      _query = const TransactionQuery();
                    }),
                  ),
              ],
            ),
          ),
          Expanded(
            child: views.isEmpty
                ? Center(
                    child: Text(_query.isEmpty ? l.noTransactions : l.noResults, style: TextStyle(color: c.textMuted)),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                    itemCount: views.length,
                    separatorBuilder: (_, _) => const Divider(),
                    itemBuilder: (_, i) => TransactionTile(views[i]),
                  ),
          ),
        ],
      ),
    );
  }
}
