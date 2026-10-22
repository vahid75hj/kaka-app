import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaka_domain/kaka_domain.dart';

import '../../app/providers.dart';
import '../../core/l10n_x.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/kaka_colors.dart';

/// Four steps, no sign-up: language → calendar & digits → base currency → first account.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const _steps = 4;
  final _pages = PageController();
  final _name = TextEditingController();
  final _opening = TextEditingController();
  var _step = 0;
  var _type = AccountType.asset;
  var _busy = false;
  String? _error;

  @override
  void dispose() {
    _pages.dispose();
    _name.dispose();
    _opening.dispose();
    super.dispose();
  }

  void _go(int step) {
    setState(() => _step = step);
    _pages.animateToPage(step, duration: const Duration(milliseconds: 280), curve: Curves.easeOutCubic);
  }

  void _update(AppSettings Function(AppSettings) f) => ref.read(settingsProvider.notifier).update(f);

  Future<void> _finish() async {
    final l = context.l10n;
    final settings = ref.read(settingsProvider);
    final ledger = ref.read(ledgerProvider);
    final unit = settings.baseUnit;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final opening = _opening.text.trim().isEmpty ? null : AmountParser.parse(_opening.text, unit);
      await ledger.seedCategories(unit.currency, names: defaultCategories(l));
      await ledger.createAccount(
        name: _name.text.trim().isEmpty ? l.accountNameDefault : _name.text,
        type: _type,
        currency: unit.currency,
        openingBalance: opening,
      );
      _update((s) => s.copyWith(onboarded: true));
    } catch (e) {
      setState(() {
        _busy = false;
        _error = context.domainError(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = KakaColors.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  for (var i = 0; i < _steps; i++)
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsetsDirectional.only(end: 6),
                        height: 4,
                        decoration: BoxDecoration(
                          color: i <= _step ? c.accent : c.line,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                ],
              ),
              Expanded(
                child: PageView(
                  controller: _pages,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _LanguageStep(
                      onPick: (code) =>
                          _update((s) => AppSettings.defaultsFor(code).copyWith(theme: s.theme, accent: s.accent)),
                    ),
                    _RegionStep(onChange: _update),
                    _CurrencyStep(onChange: _update),
                    _AccountStep(name: _name, opening: _opening, type: _type, onType: (t) => setState(() => _type = t)),
                  ],
                ),
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    _error!,
                    style: TextStyle(color: c.negative),
                    textAlign: TextAlign.center,
                  ),
                ),
              Row(
                children: [
                  if (_step > 0) ...[
                    TextButton(onPressed: _busy ? null : () => _go(_step - 1), child: Text(l.back)),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: FilledButton(
                      onPressed: _busy ? null : (_step == _steps - 1 ? _finish : () => _go(_step + 1)),
                      child: Text(_step == _steps - 1 ? l.start : l.next),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// Localized starter categories, created in the base currency.
Map<AccountType, List<String>> defaultCategories(AppLocalizations l) => {
  AccountType.expense: [
    l.catFood,
    l.catTransport,
    l.catShopping,
    l.catBills,
    l.catHome,
    l.catHealth,
    l.catFun,
    l.catOther,
  ],
  AccountType.income: [l.catSalary, l.catBusiness, l.catGift, l.catOther],
};

class _StepTitle extends StatelessWidget {
  const _StepTitle(this.title, [this.subtitle]);
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 36, bottom: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(subtitle!, style: TextStyle(color: KakaColors.of(context).textMuted, height: 1.6)),
        ],
      ],
    ),
  );
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({required this.title, required this.selected, required this.onTap, this.subtitle});
  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = KakaColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: selected ? c.accentSoft : c.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: selected ? c.accent : c.line, width: selected ? 1.4 : 1),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      if (subtitle != null) Text(subtitle!, style: TextStyle(fontSize: 12.5, color: c.textMuted)),
                    ],
                  ),
                ),
                Icon(
                  selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                  color: selected ? c.accentText : c.textFaint,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageStep extends ConsumerWidget {
  const _LanguageStep({required this.onPick});
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final code = ref.watch(settingsProvider.select((s) => s.localeCode));
    final l = context.l10n;
    return ListView(
      children: [
        _StepTitle('${l.appName} · ${l.obLanguageTitle}', l.tagline),
        _ChoiceTile(title: 'فارسی', subtitle: 'Persian', selected: code == 'fa', onTap: () => onPick('fa')),
        _ChoiceTile(title: 'English', subtitle: 'انگلیسی', selected: code == 'en', onTap: () => onPick('en')),
      ],
    );
  }
}

class _RegionStep extends ConsumerWidget {
  const _RegionStep({required this.onChange});
  final void Function(AppSettings Function(AppSettings)) onChange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final f = ref.watch(formatProvider);
    final l = context.l10n;
    final sample = const Money(123456789, Currency.usd);
    final previewFormatter = s.digits == DigitSystem.persian
        ? const MoneyFormatter.persian(decimals: 2)
        : const MoneyFormatter(digits: DigitSystem.latin, decimals: 2);
    return ListView(
      children: [
        _StepTitle(l.obRegionTitle),
        Text(l.calendar, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        SegmentedButton<CalendarSystem>(
          segments: [
            ButtonSegment(value: CalendarSystem.jalali, label: Text(l.calendarJalali)),
            ButtonSegment(value: CalendarSystem.gregorian, label: Text(l.calendarGregorian)),
          ],
          selected: {s.calendar},
          onSelectionChanged: (v) => onChange((s) => s.copyWith(calendar: v.first)),
        ),
        const SizedBox(height: 20),
        Text(l.digits, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        SegmentedButton<DigitSystem>(
          segments: [
            ButtonSegment(value: DigitSystem.persian, label: Text(l.digitsPersian)),
            ButtonSegment(value: DigitSystem.latin, label: Text(l.digitsLatin)),
          ],
          selected: {s.digits},
          onSelectionChanged: (v) => onChange((s) => s.copyWith(digits: v.first)),
        ),
        const SizedBox(height: 28),
        Text(l.preview, style: TextStyle(color: KakaColors.of(context).textMuted)),
        const SizedBox(height: 6),
        Text(
          previewFormatter.number(sample, DisplayUnit.of(Currency.usd)),
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
        ),
        Text(f.date(DateTime.now()), style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}

class _CurrencyStep extends ConsumerWidget {
  const _CurrencyStep({required this.onChange});
  final void Function(AppSettings Function(AppSettings)) onChange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final l = context.l10n;
    final fa = s.isPersian;
    return ListView(
      children: [
        _StepTitle(l.obCurrencyTitle, l.tomanNote),
        for (final u in DisplayUnit.choices)
          _ChoiceTile(
            title: fa ? u.nameFa : u.nameEn,
            subtitle: u.code,
            selected: s.baseUnit == u,
            onTap: () => onChange((s) => s.copyWith(baseUnit: u, displayDecimals: u.defaultDisplayDecimals)),
          ),
        const SizedBox(height: 12),
        Text(l.decimals, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        DecimalsPicker(
          value: s.displayDecimals,
          onChanged: (d) => onChange((s) => s.copyWith(displayDecimals: d)),
        ),
      ],
    );
  }
}

/// 0–4 decimals, shared with the settings screen.
class DecimalsPicker extends ConsumerWidget {
  const DecimalsPicker({super.key, required this.value, required this.onChanged});
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final f = ref.watch(formatProvider);
    return SegmentedButton<int>(
      showSelectedIcon: false,
      segments: [for (var d = 0; d <= 4; d++) ButtonSegment(value: d, label: Text(f.digits('$d')))],
      selected: {value},
      onSelectionChanged: (v) => onChanged(v.first),
    );
  }
}

class _AccountStep extends ConsumerWidget {
  const _AccountStep({required this.name, required this.opening, required this.type, required this.onType});
  final TextEditingController name;
  final TextEditingController opening;
  final AccountType type;
  final ValueChanged<AccountType> onType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final f = ref.watch(formatProvider);
    final unit = ref.watch(settingsProvider.select((s) => s.baseUnit));
    final c = KakaColors.of(context);
    return ListView(
      children: [
        _StepTitle(l.obAccountTitle, l.obAccountHint),
        TextField(
          controller: name,
          decoration: InputDecoration(labelText: l.accountName, hintText: l.accountNameDefault),
        ),
        const SizedBox(height: 14),
        SegmentedButton<AccountType>(
          segments: [
            ButtonSegment(value: AccountType.asset, label: Text(l.typeAsset)),
            ButtonSegment(value: AccountType.liability, label: Text(l.typeLiability)),
          ],
          selected: {type},
          onSelectionChanged: (v) => onType(v.first),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: opening,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: l.openingBalance, suffixText: f.symbol(unit.currency)),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Icon(Icons.lock_outline_rounded, size: 18, color: c.textMuted),
            const SizedBox(width: 8),
            Expanded(
              child: Text(l.offlineNote, style: TextStyle(color: c.textMuted, fontSize: 13)),
            ),
          ],
        ),
      ],
    );
  }
}
