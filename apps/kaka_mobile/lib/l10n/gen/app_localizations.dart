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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fa'),
  ];

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
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fa'].contains(locale.languageCode);

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
