import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('fa')];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Kaka'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Your offline, open-source money buddy.'**
  String get tagline;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @obLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get obLanguageTitle;

  /// No description provided for @obRegionTitle.
  ///
  /// In en, this message translates to:
  /// **'Calendar and digits'**
  String get obRegionTitle;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @calendarJalali.
  ///
  /// In en, this message translates to:
  /// **'Solar Hijri (Jalali)'**
  String get calendarJalali;

  /// No description provided for @calendarGregorian.
  ///
  /// In en, this message translates to:
  /// **'Gregorian'**
  String get calendarGregorian;

  /// No description provided for @digits.
  ///
  /// In en, this message translates to:
  /// **'Digits'**
  String get digits;

  /// No description provided for @digitsPersian.
  ///
  /// In en, this message translates to:
  /// **'Persian ۱۲۳'**
  String get digitsPersian;

  /// No description provided for @digitsLatin.
  ///
  /// In en, this message translates to:
  /// **'Latin 123'**
  String get digitsLatin;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @obCurrencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Base currency'**
  String get obCurrencyTitle;

  /// No description provided for @tomanNote.
  ///
  /// In en, this message translates to:
  /// **'Toman is only a display unit: Kaka stores everything in rial.'**
  String get tomanNote;

  /// No description provided for @decimals.
  ///
  /// In en, this message translates to:
  /// **'Decimals shown'**
  String get decimals;

  /// No description provided for @obAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Your first account'**
  String get obAccountTitle;

  /// No description provided for @obAccountHint.
  ///
  /// In en, this message translates to:
  /// **'A bank account, a card or your wallet. You can add more later.'**
  String get obAccountHint;

  /// No description provided for @offlineNote.
  ///
  /// In en, this message translates to:
  /// **'Everything stays encrypted on this phone. No sign-up, no server.'**
  String get offlineNote;

  /// No description provided for @accountName.
  ///
  /// In en, this message translates to:
  /// **'Account name'**
  String get accountName;

  /// No description provided for @accountNameDefault.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get accountNameDefault;

  /// No description provided for @openingBalance.
  ///
  /// In en, this message translates to:
  /// **'Opening balance'**
  String get openingBalance;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @accountType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get accountType;

  /// No description provided for @typeAsset.
  ///
  /// In en, this message translates to:
  /// **'Money I have'**
  String get typeAsset;

  /// No description provided for @typeLiability.
  ///
  /// In en, this message translates to:
  /// **'Debt / credit card'**
  String get typeLiability;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get navTransactions;

  /// No description provided for @navAccounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get navAccounts;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @netWorth.
  ///
  /// In en, this message translates to:
  /// **'Net worth'**
  String get netWorth;

  /// No description provided for @otherCurrencies.
  ///
  /// In en, this message translates to:
  /// **'Other currencies'**
  String get otherCurrencies;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get thisMonth;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recent;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @accounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accounts;

  /// No description provided for @noTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet. Tap + to add one.'**
  String get noTransactions;

  /// No description provided for @newAccount.
  ///
  /// In en, this message translates to:
  /// **'New account'**
  String get newAccount;

  /// No description provided for @editAccount.
  ///
  /// In en, this message translates to:
  /// **'Edit account'**
  String get editAccount;

  /// No description provided for @archive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// No description provided for @unarchive.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get unarchive;

  /// No description provided for @archived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archived;

  /// No description provided for @archiveHint.
  ///
  /// In en, this message translates to:
  /// **'Accounts are archived, never deleted, so your history stays correct.'**
  String get archiveHint;

  /// No description provided for @addTransaction.
  ///
  /// In en, this message translates to:
  /// **'New transaction'**
  String get addTransaction;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @fromAccount.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get fromAccount;

  /// No description provided for @toAccount.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get toAccount;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @voidTitle.
  ///
  /// In en, this message translates to:
  /// **'Void this transaction?'**
  String get voidTitle;

  /// No description provided for @voidBody.
  ///
  /// In en, this message translates to:
  /// **'It stays in history, crossed out, and no longer affects balances.'**
  String get voidBody;

  /// No description provided for @voidAction.
  ///
  /// In en, this message translates to:
  /// **'Void'**
  String get voidAction;

  /// No description provided for @voided.
  ///
  /// In en, this message translates to:
  /// **'Voided'**
  String get voided;

  /// No description provided for @opening.
  ///
  /// In en, this message translates to:
  /// **'Opening balance'**
  String get opening;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @accent.
  ///
  /// In en, this message translates to:
  /// **'Accent'**
  String get accent;

  /// No description provided for @accentMonochrome.
  ///
  /// In en, this message translates to:
  /// **'Black & white'**
  String get accentMonochrome;

  /// No description provided for @accentOrange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get accentOrange;

  /// No description provided for @accentLime.
  ///
  /// In en, this message translates to:
  /// **'Lime'**
  String get accentLime;

  /// No description provided for @accentBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get accentBlue;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutBody.
  ///
  /// In en, this message translates to:
  /// **'Free and open source (MIT). Offline-first, bring your own AI.'**
  String get aboutBody;

  /// No description provided for @baseCurrencyLocked.
  ///
  /// In en, this message translates to:
  /// **'Changing the base currency only changes how totals are shown; stored amounts are untouched.'**
  String get baseCurrencyLocked;

  /// No description provided for @errAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get errAmount;

  /// No description provided for @errTooPrecise.
  ///
  /// In en, this message translates to:
  /// **'Too many decimal places for this currency'**
  String get errTooPrecise;

  /// No description provided for @errName.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get errName;

  /// No description provided for @errSameAccount.
  ///
  /// In en, this message translates to:
  /// **'Pick two different accounts'**
  String get errSameAccount;

  /// No description provided for @errCrossCurrency.
  ///
  /// In en, this message translates to:
  /// **'Transfers between currencies come in a later version'**
  String get errCrossCurrency;

  /// No description provided for @errNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Add an account first'**
  String get errNoAccount;

  /// No description provided for @errGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errGeneric;

  /// No description provided for @catFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get catFood;

  /// No description provided for @catTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get catTransport;

  /// No description provided for @catShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get catShopping;

  /// No description provided for @catBills.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get catBills;

  /// No description provided for @catHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get catHealth;

  /// No description provided for @catFun.
  ///
  /// In en, this message translates to:
  /// **'Fun'**
  String get catFun;

  /// No description provided for @catHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get catHome;

  /// No description provided for @catOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get catOther;

  /// No description provided for @catSalary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get catSalary;

  /// No description provided for @catGift.
  ///
  /// In en, this message translates to:
  /// **'Gift'**
  String get catGift;

  /// No description provided for @catBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get catBusiness;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get addCategory;

  /// No description provided for @renameCategory.
  ///
  /// In en, this message translates to:
  /// **'Rename category'**
  String get renameCategory;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get categoryName;

  /// No description provided for @noCategories.
  ///
  /// In en, this message translates to:
  /// **'No categories yet'**
  String get noCategories;

  /// No description provided for @errCategoryExists.
  ///
  /// In en, this message translates to:
  /// **'A category with this name already exists'**
  String get errCategoryExists;

  /// No description provided for @previousMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get previousMonth;

  /// No description provided for @nextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get nextMonth;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @queueTitle.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get queueTitle;

  /// No description provided for @queueEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing to confirm.\nShare a bank SMS to Kaka (or paste it) and it shows up here as a draft.'**
  String get queueEmpty;

  /// No description provided for @pasteSms.
  ///
  /// In en, this message translates to:
  /// **'Paste a bank SMS'**
  String get pasteSms;

  /// No description provided for @pasteSmsHint.
  ///
  /// In en, this message translates to:
  /// **'Paste the SMS text here'**
  String get pasteSmsHint;

  /// No description provided for @read.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get read;

  /// No description provided for @ingestAdded.
  ///
  /// In en, this message translates to:
  /// **'Added to questions — check and confirm it'**
  String get ingestAdded;

  /// No description provided for @ingestDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Already in Kaka'**
  String get ingestDuplicate;

  /// No description provided for @ingestUnreadable.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t read this SMS. Add it manually or send us a masked sample.'**
  String get ingestUnreadable;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @editAndConfirm.
  ///
  /// In en, this message translates to:
  /// **'Review & save'**
  String get editAndConfirm;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search notes, accounts, amounts'**
  String get searchHint;

  /// No description provided for @filterAccount.
  ///
  /// In en, this message translates to:
  /// **'Filter by account'**
  String get filterAccount;

  /// No description provided for @allAccounts.
  ///
  /// In en, this message translates to:
  /// **'All accounts'**
  String get allAccounts;

  /// No description provided for @fromDate.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get fromDate;

  /// No description provided for @toDate.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get toDate;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearFilters;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No matching transactions'**
  String get noResults;

  /// No description provided for @settingsData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get settingsData;

  /// No description provided for @shareTip.
  ///
  /// In en, this message translates to:
  /// **'Tip: in your SMS app, share a bank message to Kaka'**
  String get shareTip;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security & backup'**
  String get security;

  /// No description provided for @appLock.
  ///
  /// In en, this message translates to:
  /// **'App lock'**
  String get appLock;

  /// No description provided for @appLockHint.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint, face or your phone\'s PIN'**
  String get appLockHint;

  /// No description provided for @appLockUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Set a screen lock on your phone first'**
  String get appLockUnavailable;

  /// No description provided for @lockReason.
  ///
  /// In en, this message translates to:
  /// **'Unlock Kaka'**
  String get lockReason;

  /// No description provided for @lockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Kaka is locked'**
  String get lockedTitle;

  /// No description provided for @unlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// No description provided for @backupExport.
  ///
  /// In en, this message translates to:
  /// **'Export encrypted backup'**
  String get backupExport;

  /// No description provided for @backupExportHint.
  ///
  /// In en, this message translates to:
  /// **'A .kaka file protected by your password'**
  String get backupExportHint;

  /// No description provided for @backupRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore from backup'**
  String get backupRestore;

  /// No description provided for @backupWorking.
  ///
  /// In en, this message translates to:
  /// **'Encrypting… this takes a few seconds'**
  String get backupWorking;

  /// No description provided for @backupPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup password'**
  String get backupPasswordTitle;

  /// No description provided for @backupPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'There is no way to recover this password. Keep it safe.'**
  String get backupPasswordHint;

  /// No description provided for @backupEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter backup password'**
  String get backupEnterPassword;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordRepeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat password'**
  String get passwordRepeat;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match'**
  String get passwordMismatch;

  /// No description provided for @backupWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong password'**
  String get backupWrongPassword;

  /// No description provided for @backupNotKaka.
  ///
  /// In en, this message translates to:
  /// **'This is not a Kaka backup'**
  String get backupNotKaka;

  /// No description provided for @backupCorrupt.
  ///
  /// In en, this message translates to:
  /// **'The backup is damaged or from a newer version'**
  String get backupCorrupt;

  /// No description provided for @restoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Replace all data?'**
  String get restoreTitle;

  /// No description provided for @restoreBody.
  ///
  /// In en, this message translates to:
  /// **'Everything on this phone will be replaced by the backup.'**
  String get restoreBody;

  /// No description provided for @restoreAction.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get restoreAction;

  /// No description provided for @restoreDone.
  ///
  /// In en, this message translates to:
  /// **'Backup restored'**
  String get restoreDone;

  /// No description provided for @queueBanner.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 transaction waiting for your confirmation} other{{count} transactions waiting for your confirmation}}'**
  String queueBanner(int count);

  /// No description provided for @smsSection.
  ///
  /// In en, this message translates to:
  /// **'Bank SMS'**
  String get smsSection;

  /// No description provided for @smsAutoRead.
  ///
  /// In en, this message translates to:
  /// **'Read bank SMS automatically'**
  String get smsAutoRead;

  /// No description provided for @smsAutoReadHint.
  ///
  /// In en, this message translates to:
  /// **'Off by default. Kaka reads only the senders you pick, on this phone, and turns them into drafts for you to confirm.'**
  String get smsAutoReadHint;

  /// No description provided for @smsPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'SMS permission was not granted'**
  String get smsPermissionDenied;

  /// No description provided for @smsSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Bank senders & accounts'**
  String get smsSetupTitle;

  /// No description provided for @smsSetupHint.
  ///
  /// In en, this message translates to:
  /// **'Turn on the senders that are your banks and pick which Kaka account each one (or each account number) belongs to. Other senders are never read.'**
  String get smsSetupHint;

  /// No description provided for @smsShowAllSenders.
  ///
  /// In en, this message translates to:
  /// **'Show all senders'**
  String get smsShowAllSenders;

  /// No description provided for @smsNoSenders.
  ///
  /// In en, this message translates to:
  /// **'No bank-like senders found in the last 6 months'**
  String get smsNoSenders;

  /// No description provided for @smsDefaultAccount.
  ///
  /// In en, this message translates to:
  /// **'Default account'**
  String get smsDefaultAccount;

  /// No description provided for @smsAskEachTime.
  ///
  /// In en, this message translates to:
  /// **'Ask me each time'**
  String get smsAskEachTime;

  /// No description provided for @smsUseDefault.
  ///
  /// In en, this message translates to:
  /// **'Use the default'**
  String get smsUseDefault;

  /// No description provided for @smsScanNow.
  ///
  /// In en, this message translates to:
  /// **'Scan last 30 days'**
  String get smsScanNow;

  /// No description provided for @smsNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Account not linked'**
  String get smsNoAccount;

  /// No description provided for @smsScanResult.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No new transactions} =1{1 new draft in Questions} other{{count} new drafts in Questions}}'**
  String smsScanResult(int count);

  /// No description provided for @smsMessageCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 message} other{{count} messages}}'**
  String smsMessageCount(int count);

  /// No description provided for @smsAccountNumber.
  ///
  /// In en, this message translates to:
  /// **'Account {number}'**
  String smsAccountNumber(String number);

  /// No description provided for @confidence.
  ///
  /// In en, this message translates to:
  /// **'{percent}% sure'**
  String confidence(int percent);

  /// No description provided for @balanceMismatch.
  ///
  /// In en, this message translates to:
  /// **'Bank balance {bank}, Kaka would show {kaka} — a transaction may be missing'**
  String balanceMismatch(String bank, String kaka);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fa'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
