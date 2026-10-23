import 'package:shamsi_date/shamsi_date.dart';

/// Finds the transaction time in an SMS. Banks write it as `1405/07/30`,
/// `1405/7/4-11:57`, `0712-15:10` (MMDD, no year), with the time on the same
/// or next line. A missing year is inferred from when the SMS was received.
abstract final class SmsDate {
  static final _full = RegExp(r'(1[34]\d{2})/(\d{1,2})/(\d{1,2})(?:\s*[-_\s]\s*(\d{1,2}):(\d{2}))?');
  static final _short = RegExp(r'(?:^|\s)(\d{2})(\d{2})\s*-\s*(\d{1,2}):(\d{2})(?:\s|$)', multiLine: true);
  static final _time = RegExp(r'(?:^|\s)(\d{1,2}):(\d{2})(?:\s|$)', multiLine: true);

  /// Regexes that match date/time fragments, so amount search can skip them.
  static final patterns = [_full, _short, _time];

  static DateTime? find(String text, {required DateTime receivedAt}) {
    final received = Jalali.fromDateTime(receivedAt);
    int? y, m, d, hh, mm;
    final full = _full.firstMatch(text);
    if (full != null) {
      y = int.parse(full[1]!);
      m = int.parse(full[2]!);
      d = int.parse(full[3]!);
      if (full[4] != null) {
        hh = int.parse(full[4]!);
        mm = int.parse(full[5]!);
      }
    } else {
      final short = _short.firstMatch(text);
      if (short != null) {
        m = int.parse(short[1]!);
        d = int.parse(short[2]!);
        hh = int.parse(short[3]!);
        mm = int.parse(short[4]!);
        // No year: the SMS can't be from the future, so a later month/day means last year.
        y = (m > received.month || (m == received.month && d > received.day)) ? received.year - 1 : received.year;
      }
    }
    if (y == null || m == null || d == null) return null;
    if (hh == null) {
      final rest = full == null ? text : text.substring(full.end);
      final t = _time.firstMatch(rest);
      if (t != null) {
        hh = int.parse(t[1]!);
        mm = int.parse(t[2]!);
      }
    }
    if (m < 1 || m > 12 || d < 1 || d > 31 || (hh ?? 0) > 23 || (mm ?? 0) > 59) return null;
    try {
      final j = Jalali(y, m, d);
      if (d > j.monthLength) return null;
      final g = j.toDateTime();
      return DateTime(g.year, g.month, g.day, hh ?? 12, mm ?? 0);
    } catch (_) {
      return null;
    }
  }
}
