import 'package:meta/meta.dart';

import '../money/currency.dart';

/// Classic double-entry account types. Categories are income/expense accounts.
enum AccountType {
  asset,
  liability,
  equity,
  income,
  expense;

  /// Income and equity are credit-normal, so their posted sum is negated for
  /// display. Assets, expenses and liabilities show it as-is, so a debt reads
  /// as a negative balance and net worth is a plain sum.
  bool get displaysNegated => this == income || this == equity;

  /// Accounts the user holds money in (shown on the home screen).
  bool get isBalanceSheet => this == asset || this == liability;
}

@immutable
class Account {
  const Account({
    required this.id,
    required this.name,
    required this.type,
    required this.currency,
    required this.createdAt,
    this.isSystem = false,
    this.archived = false,
    this.icon,
  });

  final String id;
  final String name;
  final AccountType type;
  final Currency currency;
  final DateTime createdAt;

  /// Created by Kaka itself (e.g. opening balances); hidden from pickers.
  final bool isSystem;
  final bool archived;

  /// Optional icon key for categories (the app maps keys to glyphs).
  final String? icon;

  Account copyWith({String? name, bool? archived, String? Function()? icon}) => Account(
    id: id,
    name: name ?? this.name,
    type: type,
    currency: currency,
    createdAt: createdAt,
    isSystem: isSystem,
    archived: archived ?? this.archived,
    icon: icon != null ? icon() : this.icon,
  );

  @override
  bool operator ==(Object other) =>
      other is Account &&
      other.id == id &&
      other.name == name &&
      other.type == type &&
      other.currency == currency &&
      other.archived == archived &&
      other.icon == icon;

  @override
  int get hashCode => Object.hash(id, name, type, currency, archived, icon);
}
