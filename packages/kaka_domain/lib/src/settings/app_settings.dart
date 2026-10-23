import 'package:meta/meta.dart';

import '../format/digits.dart';
import '../money/display_unit.dart';

enum CalendarSystem { jalali, gregorian }

enum ThemePreference { system, light, dark }

enum Accent { monochrome, orange, lime, blue }

/// User preferences chosen in onboarding and editable in settings.
@immutable
class AppSettings {
  const AppSettings({
    required this.localeCode,
    required this.calendar,
    required this.digits,
    required this.baseUnit,
    required this.displayDecimals,
    this.theme = ThemePreference.system,
    this.accent = Accent.monochrome,
    this.onboarded = false,
    this.appLock = false,
    this.smsAutoRead = false,
    this.smsLastScan,
    this.secureScreen = false,
    this.aiProvider = 'none',
    this.aiBaseUrl = '',
    this.aiModel = '',
  });

  factory AppSettings.defaultsFor(String localeCode) {
    final fa = localeCode == 'fa';
    return AppSettings(
      localeCode: fa ? 'fa' : 'en',
      calendar: fa ? CalendarSystem.jalali : CalendarSystem.gregorian,
      digits: fa ? DigitSystem.persian : DigitSystem.latin,
      baseUnit: fa ? DisplayUnit.irt : DisplayUnit.byCode('USD'),
      displayDecimals: fa ? 0 : 2,
    );
  }

  final String localeCode;
  final CalendarSystem calendar;
  final DigitSystem digits;

  /// Base currency (and how it is displayed, e.g. toman for rial).
  final DisplayUnit baseUnit;
  final int displayDecimals;
  final ThemePreference theme;
  final Accent accent;
  final bool onboarded;

  /// Ask for the device biometric / PIN when the app opens or returns.
  final bool appLock;

  /// Opt-in automatic bank SMS reading (Android).
  final bool smsAutoRead;

  /// Newest SMS already scanned from the inbox.
  final DateTime? smsLastScan;

  /// Android FLAG_SECURE: hide content from screenshots and the app switcher.
  final bool secureScreen;

  /// `none`, `openai` (any OpenAI-compatible server) or `ollama`. The key lives in secure storage.
  final String aiProvider;
  final String aiBaseUrl;
  final String aiModel;

  bool get isPersian => localeCode == 'fa';

  AppSettings copyWith({
    String? localeCode,
    CalendarSystem? calendar,
    DigitSystem? digits,
    DisplayUnit? baseUnit,
    int? displayDecimals,
    ThemePreference? theme,
    Accent? accent,
    bool? onboarded,
    bool? appLock,
    bool? smsAutoRead,
    DateTime? Function()? smsLastScan,
    bool? secureScreen,
    String? aiProvider,
    String? aiBaseUrl,
    String? aiModel,
  }) => AppSettings(
    localeCode: localeCode ?? this.localeCode,
    calendar: calendar ?? this.calendar,
    digits: digits ?? this.digits,
    baseUnit: baseUnit ?? this.baseUnit,
    displayDecimals: displayDecimals ?? this.displayDecimals,
    theme: theme ?? this.theme,
    accent: accent ?? this.accent,
    onboarded: onboarded ?? this.onboarded,
    appLock: appLock ?? this.appLock,
    smsAutoRead: smsAutoRead ?? this.smsAutoRead,
    smsLastScan: smsLastScan != null ? smsLastScan() : this.smsLastScan,
    secureScreen: secureScreen ?? this.secureScreen,
    aiProvider: aiProvider ?? this.aiProvider,
    aiBaseUrl: aiBaseUrl ?? this.aiBaseUrl,
    aiModel: aiModel ?? this.aiModel,
  );

  Map<String, Object?> toJson() => {
    'locale': localeCode,
    'calendar': calendar.name,
    'digits': digits.name,
    'base_unit': baseUnit.code,
    'display_decimals': displayDecimals,
    'theme': theme.name,
    'accent': accent.name,
    'onboarded': onboarded,
    'app_lock': appLock,
    'sms_auto_read': smsAutoRead,
    'sms_last_scan': smsLastScan?.toUtc().toIso8601String(),
    'secure_screen': secureScreen,
    'ai_provider': aiProvider,
    'ai_base_url': aiBaseUrl,
    'ai_model': aiModel,
  };

  factory AppSettings.fromJson(Map<String, Object?> j) => AppSettings(
    localeCode: j['locale'] as String,
    calendar: CalendarSystem.values.byName(j['calendar'] as String),
    digits: DigitSystem.values.byName(j['digits'] as String),
    baseUnit: DisplayUnit.byCode(j['base_unit'] as String),
    displayDecimals: j['display_decimals'] as int,
    theme: ThemePreference.values.byName(j['theme'] as String),
    accent: Accent.values.byName(j['accent'] as String),
    onboarded: j['onboarded'] as bool,
    appLock: j['app_lock'] as bool? ?? false,
    smsAutoRead: j['sms_auto_read'] as bool? ?? false,
    smsLastScan: j['sms_last_scan'] == null ? null : DateTime.parse(j['sms_last_scan'] as String).toLocal(),
    secureScreen: j['secure_screen'] as bool? ?? false,
    aiProvider: j['ai_provider'] as String? ?? 'none',
    aiBaseUrl: j['ai_base_url'] as String? ?? '',
    aiModel: j['ai_model'] as String? ?? '',
  );
}
