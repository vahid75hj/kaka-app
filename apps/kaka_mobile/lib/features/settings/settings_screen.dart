import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaka_domain/kaka_domain.dart';

import '../../app/providers.dart';
import '../../core/l10n_x.dart';
import '../../core/widgets.dart';
import '../../theme/kaka_colors.dart';

import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../backup/backup_actions.dart';
import '../lock/app_lock.dart';
import '../onboarding/onboarding_screen.dart' show DecimalsPicker;
import '../queue/queue_screen.dart' show showPasteSmsDialog;
import '../sms/sms_auto_reader.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = KakaColors.of(context);
    final s = ref.watch(settingsProvider);
    void update(AppSettings Function(AppSettings) f) => ref.read(settingsProvider.notifier).update(f);

    return Scaffold(
      appBar: AppBar(title: Text(l.navSettings)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
        children: [
          SectionHeader(l.settingsData),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.sell_outlined),
            title: Text(l.categories),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push(Routes.categories),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.inbox_outlined),
            title: Text(l.queueTitle),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push(Routes.queue),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.sms_outlined),
            title: Text(l.pasteSms),
            subtitle: Text(l.shareTip, style: TextStyle(color: c.textMuted, fontSize: 12)),
            onTap: () => showPasteSmsDialog(context, ref),
          ),
          SectionHeader(l.smsSection),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: const Icon(Icons.mark_chat_read_outlined),
            title: Text(l.smsAutoRead),
            subtitle: Text(l.smsAutoReadHint, style: TextStyle(color: c.textMuted, fontSize: 12, height: 1.5)),
            value: s.smsAutoRead,
            onChanged: (on) async {
              final reader = ref.read(smsAutoReaderProvider);
              if (!on) return reader.disable();
              if (await reader.enable()) {
                if (context.mounted) context.push(Routes.smsSetup);
              } else if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.smsPermissionDenied)));
              }
            },
          ),
          if (s.smsAutoRead)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.link_rounded),
              title: Text(l.smsSetupTitle),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push(Routes.smsSetup),
            ),
          SectionHeader(l.security),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: const Icon(Icons.lock_outline_rounded),
            title: Text(l.appLock),
            subtitle: Text(l.appLockHint, style: TextStyle(color: c.textMuted, fontSize: 12)),
            value: s.appLock,
            onChanged: (on) async {
              // Turning it on or off must itself pass the device check, so nobody locks themselves out.
              final auth = ref.read(deviceAuthProvider);
              if (!await auth.available()) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.appLockUnavailable)));
                }
                return;
              }
              if (await auth.authenticate(l.lockReason)) update((s) => s.copyWith(appLock: on));
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.ios_share_rounded),
            title: Text(l.backupExport),
            subtitle: Text(l.backupExportHint, style: TextStyle(color: c.textMuted, fontSize: 12)),
            onTap: () => exportBackup(context, ref),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.settings_backup_restore_rounded),
            title: Text(l.backupRestore),
            onTap: () => restoreBackup(context, ref),
          ),
          SectionHeader(l.settingsTheme),
          SegmentedButton<ThemePreference>(
            segments: [
              ButtonSegment(value: ThemePreference.system, label: Text(l.themeSystem)),
              ButtonSegment(value: ThemePreference.light, label: Text(l.themeLight)),
              ButtonSegment(value: ThemePreference.dark, label: Text(l.themeDark)),
            ],
            selected: {s.theme},
            onSelectionChanged: (v) => update((s) => s.copyWith(theme: v.first)),
          ),
          SectionHeader(l.accent),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final a in Accent.values)
                _AccentSwatch(
                  accent: a,
                  selected: s.accent == a,
                  onTap: () => update((s) => s.copyWith(accent: a)),
                ),
            ],
          ),
          SectionHeader(l.language),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'fa', label: Text('فارسی')),
              ButtonSegment(value: 'en', label: Text('English')),
            ],
            selected: {s.localeCode},
            onSelectionChanged: (v) => update((s) => s.copyWith(localeCode: v.first)),
          ),
          SectionHeader(l.calendar),
          SegmentedButton<CalendarSystem>(
            segments: [
              ButtonSegment(value: CalendarSystem.jalali, label: Text(l.calendarJalali)),
              ButtonSegment(value: CalendarSystem.gregorian, label: Text(l.calendarGregorian)),
            ],
            selected: {s.calendar},
            onSelectionChanged: (v) => update((s) => s.copyWith(calendar: v.first)),
          ),
          SectionHeader(l.digits),
          SegmentedButton<DigitSystem>(
            segments: [
              ButtonSegment(value: DigitSystem.persian, label: Text(l.digitsPersian)),
              ButtonSegment(value: DigitSystem.latin, label: Text(l.digitsLatin)),
            ],
            selected: {s.digits},
            onSelectionChanged: (v) => update((s) => s.copyWith(digits: v.first)),
          ),
          SectionHeader(l.obCurrencyTitle),
          DropdownButtonFormField<DisplayUnit>(
            initialValue: s.baseUnit,
            items: [
              for (final u in DisplayUnit.choices)
                DropdownMenuItem(value: u, child: Text('${s.isPersian ? u.nameFa : u.nameEn} (${u.code})')),
            ],
            onChanged: (u) => update((s) => s.copyWith(baseUnit: u, displayDecimals: u!.defaultDisplayDecimals)),
          ),
          const SizedBox(height: 6),
          Text(l.baseCurrencyLocked, style: TextStyle(color: c.textFaint, fontSize: 12)),
          SectionHeader(l.decimals),
          DecimalsPicker(
            value: s.displayDecimals,
            onChanged: (d) => update((s) => s.copyWith(displayDecimals: d)),
          ),
          SectionHeader(l.about),
          Text('${l.appName} 0.3.0 — ${l.aboutBody}', style: TextStyle(color: c.textMuted, height: 1.6)),
        ],
      ),
    );
  }
}

class _AccentSwatch extends StatelessWidget {
  const _AccentSwatch({required this.accent, required this.selected, required this.onTap});
  final Accent accent;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = KakaColors.of(context);
    final color = KakaColors.resolve(Theme.of(context).brightness, accent).accent;
    final label = switch (accent) {
      Accent.monochrome => l.accentMonochrome,
      Accent.orange => l.accentOrange,
      Accent.lime => l.accentLime,
      Accent.blue => l.accentBlue,
    };
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: selected ? c.text : c.line, width: selected ? 2.5 : 1),
            ),
            child: selected
                ? Icon(Icons.check_rounded, color: KakaColors.resolve(Theme.of(context).brightness, accent).onAccent)
                : null,
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
