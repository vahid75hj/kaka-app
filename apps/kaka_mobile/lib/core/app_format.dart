import 'package:intl/intl.dart';
import 'package:kaka_domain/kaka_domain.dart';
import 'package:shamsi_date/shamsi_date.dart';

/// Formats money and dates according to the user's settings.
class AppFormat {
  AppFormat(this.settings);
  final AppSettings settings;

  static const _jalaliMonthsEn = [
    'Farvardin', 'Ordibehesht', 'Khordad', 'Tir', 'Mordad', 'Shahrivar', //
    'Mehr', 'Aban', 'Azar', 'Dey', 'Bahman', 'Esfand',
  ];

  bool get _fa => settings.isPersian;

  /// The unit an amount in [c] is shown in: the base unit for the base
  /// currency (so rial shows as toman if chosen), otherwise the currency itself.
  DisplayUnit unitFor(Currency c) => c == settings.baseUnit.currency ? settings.baseUnit : DisplayUnit.of(c);

  int decimalsFor(DisplayUnit u) => u == settings.baseUnit ? settings.displayDecimals : u.defaultDisplayDecimals;

  MoneyFormatter _formatter(DisplayUnit u) => settings.digits == DigitSystem.persian
      ? MoneyFormatter.persian(decimals: decimalsFor(u))
      : MoneyFormatter(digits: DigitSystem.latin, decimals: decimalsFor(u));

  String money(Money m, {bool signed = false}) {
    final u = unitFor(m.currency);
    return _formatter(u).format(m, u, persian: _fa, signed: signed);
  }

  String number(Money m) {
    final u = unitFor(m.currency);
    return _formatter(u).number(m, u);
  }

  String symbol(Currency c) => _fa ? unitFor(c).symbolFa : unitFor(c).symbolEn;

  String digits(String s) => Digits.render(s, settings.digits);

  String date(DateTime d) {
    final local = d.toLocal();
    if (settings.calendar == CalendarSystem.jalali) {
      final j = Jalali.fromDateTime(local);
      final month = _fa ? j.formatter.mN : _jalaliMonthsEn[j.month - 1];
      return digits('${j.day} $month ${j.year}');
    }
    return digits(DateFormat.yMMMd(settings.localeCode).format(local));
  }

  /// First instant of the current month in the user's calendar.
  DateTime startOfMonth(DateTime now) {
    if (settings.calendar == CalendarSystem.jalali) {
      final j = Jalali.fromDateTime(now);
      return Jalali(j.year, j.month, 1).toDateTime();
    }
    return DateTime(now.year, now.month);
  }

  /// First instant of the month [delta] months after the one containing [d].
  DateTime addMonths(DateTime d, int delta) {
    if (settings.calendar == CalendarSystem.jalali) {
      final j = Jalali.fromDateTime(d);
      var y = j.year, m = j.month + delta;
      while (m > 12) {
        m -= 12;
        y++;
      }
      while (m < 1) {
        m += 12;
        y--;
      }
      return Jalali(y, m, 1).toDateTime();
    }
    return DateTime(d.year, d.month + delta);
  }

  String monthTitle(DateTime now) {
    if (settings.calendar == CalendarSystem.jalali) {
      final j = Jalali.fromDateTime(now);
      return digits('${_fa ? j.formatter.mN : _jalaliMonthsEn[j.month - 1]} ${j.year}');
    }
    return digits(DateFormat.yMMMM(settings.localeCode).format(now));
  }
}

/// Month stepping for repeating transactions in the user's calendar: "the 1st
/// of every month" means 1 Farvardin, 1 Ordibehesht… for Jalali users.
MonthAdder monthAdderFor(CalendarSystem calendar) {
  if (calendar != CalendarSystem.jalali) return gregorianAddMonths;
  return (a, n) {
    final j = Jalali.fromDateTime(a);
    var y = j.year, m = j.month + n;
    y += ((m - 1) / 12).floor();
    m = (m - 1) % 12 + 1;
    final first = Jalali(y, m, 1);
    final day = j.day > first.monthLength ? first.monthLength : j.day;
    final g = Jalali(y, m, day).toDateTime();
    return DateTime(g.year, g.month, g.day, a.hour, a.minute);
  };
}
