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

@DataClassName('AssetTypeRow')
class AssetTypes extends Table {
  TextColumn get id => text()();
  TextColumn get nameFa => text()();
  TextColumn get nameEn => text()();
  TextColumn get unit => text()();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('AssetMovementRow')
class AssetMovements extends Table {
  TextColumn get id => text()();
  TextColumn get assetTypeId => text().references(AssetTypes, #id)();
  IntColumn get quantityMilli => integer()();
  DateTimeColumn get movedAt => dateTime()();
  IntColumn get totalMinor => integer().nullable()();
  TextColumn get totalCurrency => text().nullable()();
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get voidedAt => dateTime().nullable()();

  /// v5: the ledger transaction that moved cash for this buy/sell.
  TextColumn get transactionId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('AssetPriceRow')
class AssetPrices extends Table {
  TextColumn get id => text()();
  TextColumn get assetTypeId => text().references(AssetTypes, #id)();
  DateTimeColumn get priceDate => dateTime()();
  IntColumn get priceMinor => integer()();
  TextColumn get currency => text()();

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
