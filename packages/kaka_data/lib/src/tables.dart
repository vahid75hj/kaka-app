import 'package:drift/drift.dart';

@DataClassName('AccountRow')
class Accounts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text()();
  TextColumn get currency => text().withLength(min: 3, max: 8)();
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  // v5
  TextColumn get icon => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('TransactionRow')
class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get kind => text()();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get voidedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PostingRow')
class Postings extends Table {
  TextColumn get id => text()();
  TextColumn get txnId => text().references(Transactions, #id)();
  TextColumn get accountId => text().references(Accounts, #id)();

  /// Integer minor units of [currency]. Never a float.
  IntColumn get amountMinor => integer()();
  TextColumn get currency => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Tiny key/value table for preferences (stored as JSON strings).
@DataClassName('SettingRow')
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

/// The question queue: suggested transactions awaiting the user's decision.
@DataClassName('DraftRow')
class Drafts extends Table {
  TextColumn get id => text()();
  TextColumn get source => text()();
  TextColumn get status => text()();
  BoolColumn get isExpense => boolean()();
  IntColumn get amountMinor => integer()();
  TextColumn get currency => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get occurredAt => dateTime().nullable()();
  TextColumn get rawText => text().withDefault(const Constant(''))();
  TextColumn get note => text().withDefault(const Constant(''))();
  TextColumn get bankId => text().nullable()();
  TextColumn get last4 => text().nullable()();
  TextColumn get dedupKey => text().nullable()();
  // v3
  TextColumn get accountId => text().nullable()();
  IntColumn get balanceMinor => integer().nullable()();
  TextColumn get sender => text().nullable()();
  RealColumn get confidence => real().nullable()();
  // v5
  TextColumn get toAccountId => text().nullable()();
  TextColumn get category => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Which bank SMS senders / account numbers belong to which Kaka account (v3).
@DataClassName('SmsLinkRow')
class SmsLinks extends Table {
  TextColumn get id => text()();
  TextColumn get sender => text().nullable()();
  TextColumn get accountId => text().nullable()();
  TextColumn get accountNumber => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// ---- v4 ----

@DataClassName('FxRateRow')
class FxRates extends Table {
  TextColumn get id => text()();
  TextColumn get currency => text()();
  TextColumn get base => text()();
  DateTimeColumn get rateDate => dateTime()();

  /// Exact decimal string ("1050000", "0.00095").
  TextColumn get rate => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('InstrumentRow')
class Instruments extends Table {
  TextColumn get id => text()();
  TextColumn get assetClass => text()();
  TextColumn get nameFa => text()();
  TextColumn get nameEn => text()();
  TextColumn get unitFa => text()();
  TextColumn get unitEn => text()();
  IntColumn get qtyScale => integer()();
  TextColumn get symbol => text().withDefault(const Constant(''))();
  TextColumn get quoteCurrency => text().nullable()();
  TextColumn get costMethod => text().withDefault(const Constant('average'))();
  TextColumn get catalogId => text().nullable()();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PlatformRow')
class Platforms extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get kind => text()();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Append-only portfolio events (buy, sell, opening, income, split, transfer…).
@DataClassName('PortfolioEventRow')
class PortfolioEvents extends Table {
  TextColumn get id => text()();
  TextColumn get instrumentId => text().references(Instruments, #id)();
  TextColumn get platformId => text().nullable()();
  TextColumn get kind => text()();
  DateTimeColumn get at => dateTime()();
  TextColumn get currency => text()();
  IntColumn get qty => integer().withDefault(const Constant(0))();
  IntColumn get gross => integer().nullable()();
  IntColumn get fee => integer().withDefault(const Constant(0))();
  TextColumn get costMode => text().withDefault(const Constant('paid'))();
  IntColumn get cost => integer().nullable()();
  IntColumn get splitNum => integer().nullable()();
  IntColumn get splitDen => integer().nullable()();
  TextColumn get groupId => text().nullable()();
  TextColumn get cashAccountId => text().nullable()();
  TextColumn get txnId => text().nullable()();
  TextColumn get txnSig => text().nullable()();
  TextColumn get source => text().withDefault(const Constant('manual'))();
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get voidedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PriceQuoteRow')
class PriceQuotes extends Table {
  TextColumn get id => text()();
  TextColumn get instrumentId => text().references(Instruments, #id)();
  IntColumn get priceMinor => integer()();
  TextColumn get currency => text()();
  DateTimeColumn get asOf => dateTime()();
  TextColumn get source => text().withDefault(const Constant('manual'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ValuationSnapshotRow')
class ValuationSnapshots extends Table {
  TextColumn get id => text()();
  DateTimeColumn get at => dateTime()();
  TextColumn get base => text()();
  IntColumn get netWorth => integer()();
  IntColumn get assetsValue => integer()();
  IntColumn get unrealized => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// SMS templates the user taught Kaka ("learn a new bank"), as catalog JSON.
@DataClassName('CustomParserRow')
class CustomParsers extends Table {
  TextColumn get id => text()();
  TextColumn get json => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// v5: monthly spending limit per expense category name, in the base currency.
@DataClassName('BudgetRow')
class Budgets extends Table {
  TextColumn get id => text()();
  TextColumn get category => text()();
  IntColumn get limitMinor => integer()();
  TextColumn get currency => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// v5: repeating transactions; due ones are queued as drafts.
@DataClassName('RecurringRuleRow')
class RecurringRules extends Table {
  TextColumn get id => text()();
  BoolColumn get isExpense => boolean()();
  TextColumn get accountId => text()();
  TextColumn get toAccountId => text().nullable()();
  TextColumn get category => text().nullable()();
  IntColumn get amountMinor => integer()();
  TextColumn get currency => text()();
  TextColumn get note => text().withDefault(const Constant(''))();
  TextColumn get every => text()();
  DateTimeColumn get start => dateTime()();
  DateTimeColumn get lastDone => dateTime().nullable()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

/// v7: which online price source feeds an instrument (manual is always last resort).
@DataClassName('PriceBindingRow')
class PriceBindings extends Table {
  TextColumn get id => text()();
  TextColumn get instrumentId => text().references(Instruments, #id)();
  TextColumn get sourceId => text()();
  TextColumn get symbol => text()();
  IntColumn get priority => integer().withDefault(const Constant(100))();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

/// v7: user-imported / custom price sources (JSON), same idea as CustomParsers.
@DataClassName('UserPriceSourceRow')
class UserPriceSources extends Table {
  TextColumn get id => text()();
  TextColumn get json => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
