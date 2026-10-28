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

  /// No description provided for @editTransaction.
  ///
  /// In en, this message translates to:
  /// **'Edit transaction'**
  String get editTransaction;

  /// No description provided for @amountReceived.
  ///
  /// In en, this message translates to:
  /// **'Amount received'**
  String get amountReceived;

  /// No description provided for @exchangeHint.
  ///
  /// In en, this message translates to:
  /// **'Different currencies: recorded as an exchange through FX accounts. The original stays in history (voided) when you edit.'**
  String get exchangeHint;

  /// No description provided for @exchangeRates.
  ///
  /// In en, this message translates to:
  /// **'Exchange rates'**
  String get exchangeRates;

  /// No description provided for @addRate.
  ///
  /// In en, this message translates to:
  /// **'Add rate'**
  String get addRate;

  /// No description provided for @noRates.
  ///
  /// In en, this message translates to:
  /// **'No rates yet. Add one so balances in other currencies count toward your net worth.'**
  String get noRates;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @assets.
  ///
  /// In en, this message translates to:
  /// **'Gold & coins'**
  String get assets;

  /// No description provided for @buySell.
  ///
  /// In en, this message translates to:
  /// **'Buy / sell'**
  String get buySell;

  /// No description provided for @buy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buy;

  /// No description provided for @sell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get sell;

  /// No description provided for @assetsValue.
  ///
  /// In en, this message translates to:
  /// **'Total value'**
  String get assetsValue;

  /// No description provided for @holdings.
  ///
  /// In en, this message translates to:
  /// **'Holdings'**
  String get holdings;

  /// No description provided for @noHoldings.
  ///
  /// In en, this message translates to:
  /// **'Nothing yet — tap Buy / sell.'**
  String get noHoldings;

  /// No description provided for @unitPrices.
  ///
  /// In en, this message translates to:
  /// **'Unit prices'**
  String get unitPrices;

  /// No description provided for @noPrice.
  ///
  /// In en, this message translates to:
  /// **'no price'**
  String get noPrice;

  /// No description provided for @setPrice.
  ///
  /// In en, this message translates to:
  /// **'Set price'**
  String get setPrice;

  /// No description provided for @pricePerUnit.
  ///
  /// In en, this message translates to:
  /// **'Price per unit'**
  String get pricePerUnit;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @totalOptional.
  ///
  /// In en, this message translates to:
  /// **'Total paid / received (optional)'**
  String get totalOptional;

  /// No description provided for @unitGram.
  ///
  /// In en, this message translates to:
  /// **'g'**
  String get unitGram;

  /// No description provided for @unitCoin.
  ///
  /// In en, this message translates to:
  /// **'pcs'**
  String get unitCoin;

  /// No description provided for @monthlyReport.
  ///
  /// In en, this message translates to:
  /// **'Monthly report'**
  String get monthlyReport;

  /// No description provided for @exportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get exportCsv;

  /// No description provided for @net.
  ///
  /// In en, this message translates to:
  /// **'Net'**
  String get net;

  /// No description provided for @reportSkipped.
  ///
  /// In en, this message translates to:
  /// **'Some transactions are in a currency without a rate and are not included.'**
  String get reportSkipped;

  /// No description provided for @noRateFor.
  ///
  /// In en, this message translates to:
  /// **'No exchange rate yet:'**
  String get noRateFor;

  /// No description provided for @learnBank.
  ///
  /// In en, this message translates to:
  /// **'Teach Kaka a new bank'**
  String get learnBank;

  /// No description provided for @learnBankHint.
  ///
  /// In en, this message translates to:
  /// **'Paste 3–5 SMS from the same bank'**
  String get learnBankHint;

  /// No description provided for @learnHint.
  ///
  /// In en, this message translates to:
  /// **'Paste 3 to 5 SMS of the same bank and layout (different amounts are best). Kaka compares them and builds a template — everything stays on this phone.'**
  String get learnHint;

  /// No description provided for @bankName.
  ///
  /// In en, this message translates to:
  /// **'Bank name'**
  String get bankName;

  /// No description provided for @customBank.
  ///
  /// In en, this message translates to:
  /// **'My bank'**
  String get customBank;

  /// No description provided for @learnDirection.
  ///
  /// In en, this message translates to:
  /// **'If the SMS doesn\'t say debit/credit'**
  String get learnDirection;

  /// No description provided for @learnDirectionAuto.
  ///
  /// In en, this message translates to:
  /// **'Detect'**
  String get learnDirectionAuto;

  /// No description provided for @learn.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get learn;

  /// No description provided for @learnConfirm.
  ///
  /// In en, this message translates to:
  /// **'Looks right — save'**
  String get learnConfirm;

  /// No description provided for @learnSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved. New SMS from this bank will be read with it.'**
  String get learnSaved;

  /// No description provided for @learnedBanks.
  ///
  /// In en, this message translates to:
  /// **'Learned banks'**
  String get learnedBanks;

  /// No description provided for @learnNeedThree.
  ///
  /// In en, this message translates to:
  /// **'At least 3 samples'**
  String get learnNeedThree;

  /// No description provided for @learnLayoutMismatch.
  ///
  /// In en, this message translates to:
  /// **'These SMS don\'t share one layout. Use messages of the same type (e.g. only withdrawals).'**
  String get learnLayoutMismatch;

  /// No description provided for @learnNoAmount.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t find an amount that changes between samples.'**
  String get learnNoAmount;

  /// No description provided for @learnNoDirection.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t tell debit from credit — choose it above.'**
  String get learnNoDirection;

  /// No description provided for @learnFailed.
  ///
  /// In en, this message translates to:
  /// **'The template didn\'t read every sample.'**
  String get learnFailed;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @aiSettings.
  ///
  /// In en, this message translates to:
  /// **'AI assistant'**
  String get aiSettings;

  /// No description provided for @aiSettingsHint.
  ///
  /// In en, this message translates to:
  /// **'Your own key, Ollama, or none'**
  String get aiSettingsHint;

  /// No description provided for @aiHint.
  ///
  /// In en, this message translates to:
  /// **'Kaka has no server and no built-in AI. Bring your own: any OpenAI-compatible API with your key, or Ollama on your computer. Off by default.'**
  String get aiHint;

  /// No description provided for @aiNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get aiNone;

  /// No description provided for @aiBaseUrl.
  ///
  /// In en, this message translates to:
  /// **'Base URL'**
  String get aiBaseUrl;

  /// No description provided for @aiModel.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get aiModel;

  /// No description provided for @aiKey.
  ///
  /// In en, this message translates to:
  /// **'API key'**
  String get aiKey;

  /// No description provided for @aiKeyHint.
  ///
  /// In en, this message translates to:
  /// **'Stored only in this phone\'s secure storage, never in backups'**
  String get aiKeyHint;

  /// No description provided for @aiKeySaved.
  ///
  /// In en, this message translates to:
  /// **'A key is saved (leave empty to keep it)'**
  String get aiKeySaved;

  /// No description provided for @aiKeyRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove saved key'**
  String get aiKeyRemove;

  /// No description provided for @aiPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Only what the assistant asks for via tools is sent, with card and account numbers masked. New transactions from chat only become drafts in Questions.'**
  String get aiPrivacy;

  /// No description provided for @aiNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Choose an AI provider first.'**
  String get aiNotConfigured;

  /// No description provided for @aiError.
  ///
  /// In en, this message translates to:
  /// **'The AI request failed. Check the URL, model and key.'**
  String get aiError;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @chatHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. How much did I spend on food this month?'**
  String get chatHint;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @secureScreen.
  ///
  /// In en, this message translates to:
  /// **'Hide from screenshots'**
  String get secureScreen;

  /// No description provided for @secureScreenHint.
  ///
  /// In en, this message translates to:
  /// **'Blocks screenshots and hides Kaka in recent apps'**
  String get secureScreenHint;

  /// No description provided for @rateLabel.
  ///
  /// In en, this message translates to:
  /// **'1 {currency} ='**
  String rateLabel(String currency);

  /// No description provided for @sampleN.
  ///
  /// In en, this message translates to:
  /// **'Sample {n}'**
  String sampleN(int n);

  /// No description provided for @sampleNotRead.
  ///
  /// In en, this message translates to:
  /// **'Sample {n} was not read'**
  String sampleNotRead(int n);

  /// No description provided for @ratesAsOf.
  ///
  /// In en, this message translates to:
  /// **'Rates as of {date}'**
  String ratesAsOf(String date);

  /// No description provided for @ratesStale.
  ///
  /// In en, this message translates to:
  /// **'Rates are old ({date})'**
  String ratesStale(String date);

  /// No description provided for @payFrom.
  ///
  /// In en, this message translates to:
  /// **'Paid from account'**
  String get payFrom;

  /// No description provided for @receiveInto.
  ///
  /// In en, this message translates to:
  /// **'Received into account'**
  String get receiveInto;

  /// No description provided for @noCashAccount.
  ///
  /// In en, this message translates to:
  /// **'None (holdings only)'**
  String get noCashAccount;

  /// No description provided for @errTotalRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the total to move money'**
  String get errTotalRequired;

  /// No description provided for @errSellMoreThanHeld.
  ///
  /// In en, this message translates to:
  /// **'You hold only {held}'**
  String errSellMoreThanHeld(Object held);

  /// No description provided for @assetHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get assetHistory;

  /// No description provided for @assetVoidBody.
  ///
  /// In en, this message translates to:
  /// **'Void this movement? Linked cash is returned too.'**
  String get assetVoidBody;

  /// No description provided for @goldAndCoins.
  ///
  /// In en, this message translates to:
  /// **'Gold & coins'**
  String get goldAndCoins;

  /// No description provided for @estimateFromPrice.
  ///
  /// In en, this message translates to:
  /// **'Estimate: {amount}'**
  String estimateFromPrice(Object amount);

  /// No description provided for @fromAi.
  ///
  /// In en, this message translates to:
  /// **'Suggested by AI'**
  String get fromAi;

  /// No description provided for @bgSmsBody.
  ///
  /// In en, this message translates to:
  /// **'{count} new bank SMS to review'**
  String bgSmsBody(Object count);

  /// No description provided for @smsBackgroundTitle.
  ///
  /// In en, this message translates to:
  /// **'Also when Kaka is closed'**
  String get smsBackgroundTitle;

  /// No description provided for @smsBackgroundBody.
  ///
  /// In en, this message translates to:
  /// **'Bank SMS from linked senders become drafts in the background, and you get a notification. Nothing is recorded until you confirm.'**
  String get smsBackgroundBody;

  /// No description provided for @backupDueTitle.
  ///
  /// In en, this message translates to:
  /// **'Time for a backup'**
  String get backupDueTitle;

  /// No description provided for @backupDueBody.
  ///
  /// In en, this message translates to:
  /// **'Kaka keeps everything only on this phone. Save an encrypted backup somewhere safe.'**
  String get backupDueBody;

  /// No description provided for @backupNow.
  ///
  /// In en, this message translates to:
  /// **'Back up now'**
  String get backupNow;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @backupReminder.
  ///
  /// In en, this message translates to:
  /// **'Backup reminder'**
  String get backupReminder;

  /// No description provided for @backupReminderOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get backupReminderOff;

  /// No description provided for @everyNDays.
  ///
  /// In en, this message translates to:
  /// **'Every {days} days'**
  String everyNDays(Object days);

  /// No description provided for @lastBackup.
  ///
  /// In en, this message translates to:
  /// **'Last backup: {date}'**
  String lastBackup(Object date);

  /// No description provided for @neverBackedUp.
  ///
  /// In en, this message translates to:
  /// **'No backup yet'**
  String get neverBackedUp;

  /// No description provided for @changeIcon.
  ///
  /// In en, this message translates to:
  /// **'Change icon'**
  String get changeIcon;

  /// No description provided for @defaultIcon.
  ///
  /// In en, this message translates to:
  /// **'Default icon'**
  String get defaultIcon;

  /// No description provided for @aiInsecureUrl.
  ///
  /// In en, this message translates to:
  /// **'Not encrypted: use https:// for servers outside your home network.'**
  String get aiInsecureUrl;

  /// No description provided for @addFirstTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add your first transaction'**
  String get addFirstTransaction;

  /// No description provided for @gettingStarted.
  ///
  /// In en, this message translates to:
  /// **'Getting started'**
  String get gettingStarted;

  /// No description provided for @gsAccount.
  ///
  /// In en, this message translates to:
  /// **'Add an account (wallet, bank, card)'**
  String get gsAccount;

  /// No description provided for @gsTransaction.
  ///
  /// In en, this message translates to:
  /// **'Record your first income or expense'**
  String get gsTransaction;

  /// No description provided for @gsSms.
  ///
  /// In en, this message translates to:
  /// **'Let Kaka read your bank SMS (optional)'**
  String get gsSms;

  /// No description provided for @gsBackup.
  ///
  /// In en, this message translates to:
  /// **'Save an encrypted backup'**
  String get gsBackup;

  /// No description provided for @hide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hide;

  /// No description provided for @stepsDone.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total}'**
  String stepsDone(Object done, Object total);

  /// No description provided for @budgets.
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get budgets;

  /// No description provided for @addBudget.
  ///
  /// In en, this message translates to:
  /// **'Add budget'**
  String get addBudget;

  /// No description provided for @editBudget.
  ///
  /// In en, this message translates to:
  /// **'Edit budget'**
  String get editBudget;

  /// No description provided for @noBudgets.
  ///
  /// In en, this message translates to:
  /// **'Set a monthly limit for a category and Kaka shows how much is left — and warns when you are spending faster than the month is passing.'**
  String get noBudgets;

  /// No description provided for @monthlyLimit.
  ///
  /// In en, this message translates to:
  /// **'Monthly limit'**
  String get monthlyLimit;

  /// No description provided for @budgetSpentOf.
  ///
  /// In en, this message translates to:
  /// **'{spent} of {limit}'**
  String budgetSpentOf(Object spent, Object limit);

  /// No description provided for @budgetLeft.
  ///
  /// In en, this message translates to:
  /// **'{amount} left'**
  String budgetLeft(Object amount);

  /// No description provided for @budgetAhead.
  ///
  /// In en, this message translates to:
  /// **'Spending ahead of the month · {amount} left'**
  String budgetAhead(Object amount);

  /// No description provided for @budgetOver.
  ///
  /// In en, this message translates to:
  /// **'Over by {amount}'**
  String budgetOver(Object amount);

  /// No description provided for @budgetCurrencyChanged.
  ///
  /// In en, this message translates to:
  /// **'Base currency changed — edit this budget to set a new limit.'**
  String get budgetCurrencyChanged;

  /// No description provided for @allCategoriesBudgeted.
  ///
  /// In en, this message translates to:
  /// **'Every expense category already has a budget.'**
  String get allCategoriesBudgeted;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @importCsv.
  ///
  /// In en, this message translates to:
  /// **'Import CSV / Excel'**
  String get importCsv;

  /// No description provided for @importCsvHint.
  ///
  /// In en, this message translates to:
  /// **'Bank statement, spreadsheet or Kaka export'**
  String get importCsvHint;

  /// No description provided for @importHint.
  ///
  /// In en, this message translates to:
  /// **'Pick a CSV or Excel (.xlsx) file. Kaka guesses the columns; check them, see the preview, then import. Rows already in the account are skipped, and you can undo the whole import.'**
  String get importHint;

  /// No description provided for @importChooseFile.
  ///
  /// In en, this message translates to:
  /// **'Choose file'**
  String get importChooseFile;

  /// No description provided for @importEmpty.
  ///
  /// In en, this message translates to:
  /// **'This file has no data rows.'**
  String get importEmpty;

  /// No description provided for @importNotUtf8.
  ///
  /// In en, this message translates to:
  /// **'Could not read the file as UTF-8. In Excel use Save As → \"CSV UTF-8\".'**
  String get importNotUtf8;

  /// No description provided for @importNeedAccount.
  ///
  /// In en, this message translates to:
  /// **'Add an account first.'**
  String get importNeedAccount;

  /// No description provided for @importInto.
  ///
  /// In en, this message translates to:
  /// **'Import into'**
  String get importInto;

  /// No description provided for @importAmountsInToman.
  ///
  /// In en, this message translates to:
  /// **'Amounts are in toman'**
  String get importAmountsInToman;

  /// No description provided for @importAmountsInTomanHint.
  ///
  /// In en, this message translates to:
  /// **'Bank statements are usually in rial; Kaka exports are in rial.'**
  String get importAmountsInTomanHint;

  /// No description provided for @importColumns.
  ///
  /// In en, this message translates to:
  /// **'Columns'**
  String get importColumns;

  /// No description provided for @importNone.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get importNone;

  /// No description provided for @importSignedAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount (negative = spent)'**
  String get importSignedAmount;

  /// No description provided for @importDebit.
  ///
  /// In en, this message translates to:
  /// **'Money out'**
  String get importDebit;

  /// No description provided for @importCredit.
  ///
  /// In en, this message translates to:
  /// **'Money in'**
  String get importCredit;

  /// No description provided for @importMappingHint.
  ///
  /// In en, this message translates to:
  /// **'Choose a date column and either an amount column or money out / money in.'**
  String get importMappingHint;

  /// No description provided for @importPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get importPreview;

  /// No description provided for @importSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} new · {dupes} already in the account'**
  String importSummary(Object count, Object dupes);

  /// No description provided for @importBadLines.
  ///
  /// In en, this message translates to:
  /// **'Unreadable lines: {lines} ({count} total)'**
  String importBadLines(Object lines, Object count);

  /// No description provided for @importSkippedKinds.
  ///
  /// In en, this message translates to:
  /// **'{count} transfer/exchange/opening/voided rows skipped'**
  String importSkippedKinds(Object count);

  /// No description provided for @importFallbackCategory.
  ///
  /// In en, this message translates to:
  /// **'Imported'**
  String get importFallbackCategory;

  /// No description provided for @importMore.
  ///
  /// In en, this message translates to:
  /// **'and {count} more'**
  String importMore(Object count);

  /// No description provided for @importNothingNew.
  ///
  /// In en, this message translates to:
  /// **'Nothing new to import.'**
  String get importNothingNew;

  /// No description provided for @importNow.
  ///
  /// In en, this message translates to:
  /// **'Import {count}'**
  String importNow(Object count);

  /// No description provided for @importDone.
  ///
  /// In en, this message translates to:
  /// **'{count} transactions imported'**
  String importDone(Object count);

  /// No description provided for @recurringTag.
  ///
  /// In en, this message translates to:
  /// **'Repeats'**
  String get recurringTag;

  /// No description provided for @recurring.
  ///
  /// In en, this message translates to:
  /// **'Repeating'**
  String get recurring;

  /// No description provided for @recurringHint.
  ///
  /// In en, this message translates to:
  /// **'Rent, salary, subscriptions — due ones appear in the queue for a tap to confirm'**
  String get recurringHint;

  /// No description provided for @repeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get repeat;

  /// No description provided for @repeatNever.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get repeatNever;

  /// No description provided for @repeatWeekly.
  ///
  /// In en, this message translates to:
  /// **'Every week'**
  String get repeatWeekly;

  /// No description provided for @repeatMonthly.
  ///
  /// In en, this message translates to:
  /// **'Every month'**
  String get repeatMonthly;

  /// No description provided for @noRecurring.
  ///
  /// In en, this message translates to:
  /// **'Nothing repeats yet. When adding a transaction, choose \"Repeat\" — rent, salary, subscriptions — and Kaka will put it in the queue on its day.'**
  String get noRecurring;

  /// No description provided for @recurringNext.
  ///
  /// In en, this message translates to:
  /// **'Next: {date}'**
  String recurringNext(Object date);

  /// No description provided for @recurringPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get recurringPaused;

  /// No description provided for @recurringDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Stop repeating this? Transactions already recorded stay.'**
  String get recurringDeleteConfirm;

  /// No description provided for @importBadXlsx.
  ///
  /// In en, this message translates to:
  /// **'Could not read this Excel file. Try saving it as \"CSV UTF-8\".'**
  String get importBadXlsx;

  /// No description provided for @comingUp.
  ///
  /// In en, this message translates to:
  /// **'Coming up'**
  String get comingUp;

  /// No description provided for @settingsPlanning.
  ///
  /// In en, this message translates to:
  /// **'Planning'**
  String get settingsPlanning;

  /// No description provided for @settingsTools.
  ///
  /// In en, this message translates to:
  /// **'Import & AI'**
  String get settingsTools;

  /// No description provided for @repeatSaved.
  ///
  /// In en, this message translates to:
  /// **'It will repeat; due ones appear in the queue.'**
  String get repeatSaved;
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
