import 'package:kaka_domain/kaka_domain.dart';

/// What a transaction means to a human, derived from its postings.
class TransactionView {
  const TransactionView({required this.txn, required this.title, required this.subtitle, required this.amount});

  final LedgerTransaction txn;
  final String title;
  final String subtitle;

  /// Signed from the user's point of view: expenses negative, income positive,
  /// transfers unsigned.
  final Money amount;

  static TransactionView of(LedgerTransaction t, Map<String, Account> accounts, {required String openingLabel}) {
    Account? acc(Posting p) => accounts[p.accountId];
    final debit = t.postings.firstWhere((p) => p.amount.isPositive);
    final credit = t.postings.firstWhere((p) => p.amount.isNegative);
    final d = acc(debit)?.name ?? '?';
    final c = acc(credit)?.name ?? '?';
    String withNote(String s) => t.note.isEmpty ? s : t.note;
    return switch (t.kind) {
      TransactionKind.expense => TransactionView(
        txn: t,
        title: withNote(d),
        subtitle: t.note.isEmpty ? c : '$d · $c',
        amount: -debit.amount,
      ),
      TransactionKind.income => TransactionView(
        txn: t,
        title: withNote(c),
        subtitle: t.note.isEmpty ? d : '$c · $d',
        amount: debit.amount,
      ),
      TransactionKind.transfer => TransactionView(
        txn: t,
        title: withNote('$c → $d'),
        subtitle: '$c → $d',
        amount: debit.amount,
      ),
      TransactionKind.exchange => () {
        // postings: [to +, FX:to −, FX:from +, from −]
        final user = t.postings.where((p) => !(acc(p)?.isSystem ?? true)).toList();
        final into = user.where((p) => p.amount.isPositive).firstOrNull ?? debit;
        final out = user.where((p) => p.amount.isNegative).firstOrNull ?? credit;
        final route = '${acc(out)?.name ?? '?'} → ${acc(into)?.name ?? '?'}';
        return TransactionView(txn: t, title: withNote(route), subtitle: route, amount: into.amount);
      }(),
      TransactionKind.opening => TransactionView(
        txn: t,
        title: openingLabel,
        subtitle: (acc(debit)?.isSystem ?? false) ? c : d,
        amount: (acc(debit)?.isSystem ?? false) ? credit.amount : debit.amount,
      ),
    };
  }
}
