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

  @override
  String get smsSection => 'Bank SMS';

  @override
  String get smsAutoRead => 'Read bank SMS automatically';

  @override
  String get smsAutoReadHint =>
      'Off by default. Kaka reads only the senders you pick, on this phone, and turns them into drafts for you to confirm.';

  @override
  String get smsPermissionDenied => 'SMS permission was not granted';

  @override
  String get smsSetupTitle => 'Bank senders & accounts';

  @override
  String get smsSetupHint =>
      'Turn on the senders that are your banks and pick which Kaka account each one (or each account number) belongs to. Other senders are never read.';

  @override
  String get smsShowAllSenders => 'Show all senders';

  @override
  String get smsNoSenders => 'No bank-like senders found in the last 6 months';

  @override
  String get smsDefaultAccount => 'Default account';

  @override
  String get smsAskEachTime => 'Ask me each time';

  @override
  String get smsUseDefault => 'Use the default';

  @override
  String get smsScanNow => 'Scan last 30 days';

  @override
  String get smsNoAccount => 'Account not linked';

  @override
  String smsScanResult(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count new drafts in Questions',
      one: '1 new draft in Questions',
      zero: 'No new transactions',
    );
    return '$_temp0';
  }

  @override
  String smsMessageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count messages', one: '1 message');
    return '$_temp0';
  }

  @override
  String smsAccountNumber(String number) {
    return 'Account $number';
  }

  @override
  String confidence(int percent) {
    return '$percent% sure';
  }

  @override
  String balanceMismatch(String bank, String kaka) {
    return 'Bank balance $bank, Kaka would show $kaka — a transaction may be missing';
  }

  @override
  String get editTransaction => 'Edit transaction';

  @override
  String get amountReceived => 'Amount received';

  @override
  String get exchangeHint =>
      'Different currencies: recorded as an exchange through FX accounts. The original stays in history (voided) when you edit.';

  @override
  String get exchangeRates => 'Exchange rates';

  @override
  String get addRate => 'Add rate';

  @override
  String get noRates => 'No rates yet. Add one so balances in other currencies count toward your net worth.';

  @override
  String get delete => 'Delete';

  @override
  String get assets => 'Gold & coins';

  @override
  String get buySell => 'Buy / sell';

  @override
  String get buy => 'Buy';

  @override
  String get sell => 'Sell';

  @override
  String get assetsValue => 'Total value';

  @override
  String get holdings => 'Holdings';

  @override
  String get noHoldings => 'Nothing yet — tap Buy / sell.';

  @override
  String get unitPrices => 'Unit prices';

  @override
  String get noPrice => 'no price';

  @override
  String get setPrice => 'Set price';

  @override
  String get pricePerUnit => 'Price per unit';

  @override
  String get quantity => 'Quantity';

  @override
  String get totalOptional => 'Total paid / received (optional)';

  @override
  String get unitGram => 'g';

  @override
  String get unitCoin => 'pcs';

  @override
  String get monthlyReport => 'Monthly report';

  @override
  String get exportCsv => 'Export CSV';

  @override
  String get net => 'Net';

  @override
  String get reportSkipped => 'Some transactions are in a currency without a rate and are not included.';

  @override
  String get noRateFor => 'No exchange rate yet:';

  @override
  String get learnBank => 'Teach Kaka a new bank';

  @override
  String get learnBankHint => 'Paste 3–5 SMS from the same bank';

  @override
  String get learnHint =>
      'Paste 3 to 5 SMS of the same bank and layout (different amounts are best). Kaka compares them and builds a template — everything stays on this phone.';

  @override
  String get bankName => 'Bank name';

  @override
  String get customBank => 'My bank';

  @override
  String get learnDirection => 'If the SMS doesn\'t say debit/credit';

  @override
  String get learnDirectionAuto => 'Detect';

  @override
  String get learn => 'Learn';

  @override
  String get learnConfirm => 'Looks right — save';

  @override
  String get learnSaved => 'Saved. New SMS from this bank will be read with it.';

  @override
  String get learnedBanks => 'Learned banks';

  @override
  String get learnNeedThree => 'At least 3 samples';

  @override
  String get learnLayoutMismatch =>
      'These SMS don\'t share one layout. Use messages of the same type (e.g. only withdrawals).';

  @override
  String get learnNoAmount => 'Couldn\'t find an amount that changes between samples.';

  @override
  String get learnNoDirection => 'Couldn\'t tell debit from credit — choose it above.';

  @override
  String get learnFailed => 'The template didn\'t read every sample.';

  @override
  String get balance => 'Balance';

  @override
  String get aiSettings => 'AI assistant';

  @override
  String get aiSettingsHint => 'Your own key, Ollama, or none';

  @override
  String get aiHint =>
      'Kaka has no server and no built-in AI. Bring your own: any OpenAI-compatible API with your key, or Ollama on your computer. Off by default.';

  @override
  String get aiNone => 'None';

  @override
  String get aiBaseUrl => 'Base URL';

  @override
  String get aiModel => 'Model';

  @override
  String get aiKey => 'API key';

  @override
  String get aiKeyHint => 'Stored only in this phone\'s secure storage, never in backups';

  @override
  String get aiKeySaved => 'A key is saved (leave empty to keep it)';

  @override
  String get aiKeyRemove => 'Remove saved key';

  @override
  String get aiPrivacy =>
      'Only what the assistant asks for via tools is sent, with card and account numbers masked. New transactions from chat only become drafts in Questions.';

  @override
  String get aiNotConfigured => 'Choose an AI provider first.';

  @override
  String get aiError => 'The AI request failed. Check the URL, model and key.';

  @override
  String get chat => 'Chat';

  @override
  String get chatHint => 'e.g. How much did I spend on food this month?';

  @override
  String get send => 'Send';

  @override
  String get secureScreen => 'Hide from screenshots';

  @override
  String get secureScreenHint => 'Blocks screenshots and hides Kaka in recent apps';

  @override
  String rateLabel(String currency) {
    return '1 $currency =';
  }

  @override
  String sampleN(int n) {
    return 'Sample $n';
  }

  @override
  String sampleNotRead(int n) {
    return 'Sample $n was not read';
  }

  @override
  String ratesAsOf(String date) {
    return 'Rates as of $date';
  }

  @override
  String ratesStale(String date) {
    return 'Rates are old ($date)';
  }

  @override
  String get payFrom => 'Paid from account';

  @override
  String get receiveInto => 'Received into account';

  @override
  String get noCashAccount => 'None (holdings only)';

  @override
  String get errTotalRequired => 'Enter the total to move money';

  @override
  String errSellMoreThanHeld(Object held) {
    return 'You hold only $held';
  }

  @override
  String get assetHistory => 'History';

  @override
  String get assetVoidBody => 'Void this movement? Linked cash is returned too.';

  @override
  String get goldAndCoins => 'Gold & coins';

  @override
  String estimateFromPrice(Object amount) {
    return 'Estimate: $amount';
  }

  @override
  String get fromAi => 'Suggested by AI';

  @override
  String bgSmsBody(Object count) {
    return '$count new bank SMS to review';
  }

  @override
  String get smsBackgroundTitle => 'Also when Kaka is closed';

  @override
  String get smsBackgroundBody =>
      'Bank SMS from linked senders become drafts in the background, and you get a notification. Nothing is recorded until you confirm.';

  @override
  String get backupDueTitle => 'Time for a backup';

  @override
  String get backupDueBody => 'Kaka keeps everything only on this phone. Save an encrypted backup somewhere safe.';

  @override
  String get backupNow => 'Back up now';

  @override
  String get later => 'Later';

  @override
  String get backupReminder => 'Backup reminder';

  @override
  String get backupReminderOff => 'Off';

  @override
  String everyNDays(Object days) {
    return 'Every $days days';
  }

  @override
  String lastBackup(Object date) {
    return 'Last backup: $date';
  }

  @override
  String get neverBackedUp => 'No backup yet';
}
