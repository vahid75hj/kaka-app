// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Kaka';

  @override
  String get tagline => 'Your offline, open-source money buddy.';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get start => 'Start';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get obLanguageTitle => 'Choose your language';

  @override
  String get obRegionTitle => 'Calendar and digits';

  @override
  String get calendar => 'Calendar';

  @override
  String get calendarJalali => 'Solar Hijri (Jalali)';

  @override
  String get calendarGregorian => 'Gregorian';

  @override
  String get digits => 'Digits';

  @override
  String get digitsPersian => 'Persian ۱۲۳';

  @override
  String get digitsLatin => 'Latin 123';

  @override
  String get preview => 'Preview';

  @override
  String get obCurrencyTitle => 'Base currency';

  @override
  String get tomanNote => 'Toman is only a display unit: Kaka stores everything in rial.';

  @override
  String get decimals => 'Decimals shown';

  @override
  String get obAccountTitle => 'Your first account';

  @override
  String get obAccountHint => 'A bank account, a card or your wallet. You can add more later.';

  @override
  String get offlineNote => 'Everything stays encrypted on this phone. No sign-up, no server.';

  @override
  String get accountName => 'Account name';

  @override
  String get accountNameDefault => 'Wallet';

  @override
  String get openingBalance => 'Opening balance';

  @override
  String get currency => 'Currency';

  @override
  String get accountType => 'Type';

  @override
  String get typeAsset => 'Money I have';

  @override
  String get typeLiability => 'Debt / credit card';

  @override
  String get navHome => 'Home';

  @override
  String get navTransactions => 'Transactions';

  @override
  String get navAccounts => 'Accounts';

  @override
  String get navSettings => 'Settings';

  @override
  String get add => 'Add';

  @override
  String get netWorth => 'Net worth';

  @override
  String get otherCurrencies => 'Other currencies';

  @override
  String get thisMonth => 'This month';

  @override
  String get income => 'Income';

  @override
  String get expense => 'Expense';

  @override
  String get transfer => 'Transfer';

  @override
  String get recent => 'Recent';

  @override
  String get seeAll => 'See all';

  @override
  String get accounts => 'Accounts';

  @override
  String get noTransactions => 'No transactions yet. Tap + to add one.';

  @override
  String get newAccount => 'New account';

  @override
  String get editAccount => 'Edit account';

  @override
  String get archive => 'Archive';

  @override
  String get unarchive => 'Restore';

  @override
  String get archived => 'Archived';

  @override
  String get archiveHint => 'Accounts are archived, never deleted, so your history stays correct.';

  @override
  String get addTransaction => 'New transaction';

  @override
  String get amount => 'Amount';

  @override
  String get fromAccount => 'From';

  @override
  String get toAccount => 'To';

  @override
  String get account => 'Account';

  @override
  String get category => 'Category';

  @override
  String get date => 'Date';

  @override
  String get note => 'Note';

  @override
  String get voidTitle => 'Void this transaction?';

  @override
  String get voidBody => 'It stays in history, crossed out, and no longer affects balances.';

  @override
  String get voidAction => 'Void';

  @override
  String get voided => 'Voided';

  @override
  String get opening => 'Opening balance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get accent => 'Accent';

  @override
  String get accentMonochrome => 'Black & white';

  @override
  String get accentOrange => 'Orange';

  @override
  String get accentLime => 'Lime';

  @override
  String get accentBlue => 'Blue';

  @override
  String get language => 'Language';

  @override
  String get about => 'About';

  @override
  String get aboutBody => 'Free and open source (MIT). Offline-first, bring your own AI.';

  @override
  String get baseCurrencyLocked =>
      'Changing the base currency only changes how totals are shown; stored amounts are untouched.';

  @override
  String get errAmount => 'Enter a valid amount';

  @override
  String get errTooPrecise => 'Too many decimal places for this currency';

  @override
  String get errName => 'Name is required';

  @override
  String get errSameAccount => 'Pick two different accounts';

  @override
  String get errCrossCurrency => 'Transfers between currencies come in a later version';

  @override
  String get errNoAccount => 'Add an account first';

  @override
  String get errGeneric => 'Something went wrong';

  @override
  String get catFood => 'Food';

  @override
  String get catTransport => 'Transport';

  @override
  String get catShopping => 'Shopping';

  @override
  String get catBills => 'Bills';

  @override
  String get catHealth => 'Health';

  @override
  String get catFun => 'Fun';

  @override
  String get catHome => 'Home';

  @override
  String get catOther => 'Other';

  @override
  String get catSalary => 'Salary';

  @override
  String get catGift => 'Gift';

  @override
  String get catBusiness => 'Business';

  @override
  String get saved => 'Saved';

  @override
  String get categories => 'Categories';

  @override
  String get addCategory => 'New category';

  @override
  String get renameCategory => 'Rename category';

  @override
  String get categoryName => 'Category name';

  @override
  String get noCategories => 'No categories yet';

  @override
  String get errCategoryExists => 'A category with this name already exists';

  @override
  String get previousMonth => 'Previous month';

  @override
  String get nextMonth => 'Next month';

  @override
  String get today => 'Today';

  @override
  String get ok => 'OK';

  @override
  String get queueTitle => 'Questions';

  @override
  String get queueEmpty =>
      'Nothing to confirm.\nShare a bank SMS to Kaka (or paste it) and it shows up here as a draft.';

  @override
  String get pasteSms => 'Paste a bank SMS';

  @override
  String get pasteSmsHint => 'Paste the SMS text here';

  @override
  String get read => 'Read';

  @override
  String get ingestAdded => 'Added to questions — check and confirm it';

  @override
  String get ingestDuplicate => 'Already in Kaka';

  @override
  String get ingestUnreadable => 'Couldn\'t read this SMS. Add it manually or send us a masked sample.';

  @override
  String get unverifiedParser => 'Read by an unverified template';

  @override
  String get discard => 'Discard';

  @override
  String get editAndConfirm => 'Review & save';

  @override
  String get searchHint => 'Search notes, accounts, amounts';

  @override
  String get filterAccount => 'Filter by account';

  @override
  String get allAccounts => 'All accounts';

  @override
  String get fromDate => 'From';

  @override
  String get toDate => 'To';

  @override
  String get clearFilters => 'Clear';

  @override
  String get noResults => 'No matching transactions';

  @override
  String get settingsData => 'Data';

  @override
  String get shareTip => 'Tip: in your SMS app, share a bank message to Kaka';

  @override
  String get security => 'Security & backup';

  @override
  String get appLock => 'App lock';

  @override
  String get appLockHint => 'Fingerprint, face or your phone\'s PIN';

  @override
  String get appLockUnavailable => 'Set a screen lock on your phone first';

  @override
  String get lockReason => 'Unlock Kaka';

  @override
  String get lockedTitle => 'Kaka is locked';

  @override
  String get unlock => 'Unlock';

  @override
  String get backupExport => 'Export encrypted backup';

  @override
  String get backupExportHint => 'A .kaka file protected by your password';

  @override
  String get backupRestore => 'Restore from backup';

  @override
  String get backupWorking => 'Encrypting… this takes a few seconds';

  @override
  String get backupPasswordTitle => 'Backup password';

  @override
  String get backupPasswordHint => 'There is no way to recover this password. Keep it safe.';

  @override
  String get backupEnterPassword => 'Enter backup password';

  @override
  String get password => 'Password';

  @override
  String get passwordRepeat => 'Repeat password';

  @override
  String get passwordTooShort => 'At least 8 characters';

  @override
  String get passwordMismatch => 'Passwords don\'t match';

  @override
  String get backupWrongPassword => 'Wrong password';

  @override
  String get backupNotKaka => 'This is not a Kaka backup';

  @override
  String get backupCorrupt => 'The backup is damaged or from a newer version';

  @override
  String get restoreTitle => 'Replace all data?';

  @override
  String get restoreBody => 'Everything on this phone will be replaced by the backup.';

  @override
  String get restoreAction => 'Replace';

  @override
  String get restoreDone => 'Backup restored';

  @override
  String queueBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions waiting for your confirmation',
      one: '1 transaction waiting for your confirmation',
    );
    return '$_temp0';
  }
}
