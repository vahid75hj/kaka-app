import 'package:flutter/material.dart';
import 'package:kaka_domain/kaka_domain.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../theme/kaka_colors.dart';
import 'app_format.dart';
import 'l10n_x.dart';

/// Opens a Jalali picker when the user's calendar is Jalali, otherwise the
/// Material one. Returns a date-only value (midnight local time).
Future<DateTime?> pickDate(
  BuildContext context,
  AppFormat format, {
  required DateTime initial,
  DateTime? first,
  DateTime? last,
}) {
  final firstDate = first ?? DateTime(2000);
  final lastDate = last ?? DateTime.now().add(const Duration(days: 365));
  if (format.settings.calendar != CalendarSystem.jalali) {
    return showDatePicker(context: context, initialDate: initial, firstDate: firstDate, lastDate: lastDate);
  }
  return showDialog<DateTime>(
    context: context,
    builder: (_) => JalaliDatePickerDialog(format: format, initial: initial, first: firstDate, last: lastDate),
  );
}

class JalaliDatePickerDialog extends StatefulWidget {
  const JalaliDatePickerDialog({
    super.key,
    required this.format,
    required this.initial,
    required this.first,
    required this.last,
  });
  final AppFormat format;
  final DateTime initial;
  final DateTime first;
  final DateTime last;

  @override
  State<JalaliDatePickerDialog> createState() => _JalaliDatePickerDialogState();
}

class _JalaliDatePickerDialogState extends State<JalaliDatePickerDialog> {
  late Jalali _selected = Jalali.fromDateTime(widget.initial);
  late Jalali _month = Jalali(_selected.year, _selected.month, 1);

  // Saturday-first week, as on Iranian calendars.
  static const _weekdaysFa = ['ش', 'ی', 'د', 'س', 'چ', 'پ', 'ج'];
  static const _weekdaysEn = ['Sa', 'Su', 'Mo', 'Tu', 'We', 'Th', 'Fr'];

  void _shift(int months) {
    var y = _month.year;
    var m = _month.month + months;
    while (m > 12) {
      m -= 12;
      y++;
    }
    while (m < 1) {
      m += 12;
      y--;
    }
    setState(() => _month = Jalali(y, m, 1));
  }

  bool _enabled(Jalali d) {
    final g = d.toDateTime();
    final first = DateUtils.dateOnly(widget.first);
    final last = DateUtils.dateOnly(widget.last);
    return !g.isBefore(first) && !g.isAfter(last);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = KakaColors.of(context);
    final f = widget.format;
    final fa = f.settings.isPersian;
    final leading = _month.weekDay - 1; // weekDay: 1 = Saturday
    final days = _month.monthLength;
    final today = Jalali.now();

    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      content: SizedBox(
        width: 320,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(f.date(_selected.toDateTime()), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    tooltip: l.previousMonth,
                    icon: const Icon(Icons.chevron_left_rounded),
                    onPressed: () => _shift(fa ? 1 : -1),
                  ),
                  Expanded(
                    child: Text(
                      f.monthTitle(_month.toDateTime()),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  IconButton(
                    tooltip: l.nextMonth,
                    icon: const Icon(Icons.chevron_right_rounded),
                    onPressed: () => _shift(fa ? -1 : 1),
                  ),
                ],
              ),
              GridView.count(
                crossAxisCount: 7,
                childAspectRatio: 1.15,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (final w in fa ? _weekdaysFa : _weekdaysEn)
                    Center(
                      child: Text(w, style: TextStyle(color: c.textMuted, fontSize: 12)),
                    ),
                  for (var i = 0; i < leading; i++) const SizedBox.shrink(),
                  for (var d = 1; d <= days; d++) _day(Jalali(_month.year, _month.month, d), today, c),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => setState(() {
            _selected = today;
            _month = Jalali(today.year, today.month, 1);
          }),
          child: Text(l.today),
        ),
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
        FilledButton(onPressed: () => Navigator.pop(context, _selected.toDateTime()), child: Text(l.ok)),
      ],
    );
  }

  Widget _day(Jalali d, Jalali today, KakaColors c) {
    final selected = d == _selected;
    final enabled = _enabled(d);
    final isToday = d == today;
    return Padding(
      padding: const EdgeInsets.all(2),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: enabled ? () => setState(() => _selected = d) : null,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? c.accent : null,
            shape: BoxShape.circle,
            border: isToday && !selected ? Border.all(color: c.accent) : null,
          ),
          child: Text(
            widget.format.digits('${d.day}'),
            style: TextStyle(
              color: selected ? c.onAccent : (enabled ? c.text : c.textFaint),
              fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
