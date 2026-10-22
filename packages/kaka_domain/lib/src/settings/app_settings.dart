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
  }) => AppSettings(
    localeCode: localeCode ?? this.localeCode,
    calendar: calendar ?? this.calendar,
    digits: digits ?? this.digits,
    baseUnit: baseUnit ?? this.baseUnit,
    displayDecimals: displayDecimals ?? this.displayDecimals,
    theme: theme ?? this.theme,
    accent: accent ?? this.accent,
    onboarded: onboarded ?? this.onboarded,
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
  );
}
