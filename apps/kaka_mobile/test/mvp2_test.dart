import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaka_data/kaka_data.dart';
import 'package:kaka_domain/kaka_domain.dart';
import 'package:kaka_mobile/app/providers.dart';
import 'package:kaka_mobile/core/app_format.dart';
import 'package:kaka_mobile/core/date_picker.dart';
import 'package:kaka_mobile/features/queue/share_ingest.dart';
import 'package:kaka_mobile/features/transactions/add_transaction_screen.dart';
import 'package:kaka_mobile/l10n/gen/app_localizations.dart';
import 'package:kaka_mobile/theme/kaka_theme.dart';

void main() {
  test('draft amounts are shown without display rounding', () {
    expect(exactAmountText(const Money(1234567, Currency.irr), DisplayUnit.irt), '123456.7');
    expect(exactAmountText(const Money(2500000, Currency.irr), DisplayUnit.irt), '250000');
    expect(exactAmountText(const Money(1999, Currency.usd), DisplayUnit.byCode('USD')), '19.99');
  });

  test('a shared Mellat SMS becomes one pending draft (deduplicated)', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final dir = Directory.systemTemp.createTempSync('kaka_ingest');
    final db = KakaDatabase.open(File('${dir.path}/l.db'), key: 'k');
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        initialSettingsProvider.overrideWithValue(AppSettings.defaultsFor('fa').copyWith(onboarded: true)),
      ],
    );
    addTearDown(() async {
      container.dispose();
      await db.close();
      dir.deleteSync(recursive: true);
    });
    const sms = 'حساب5463\nبرداشت250,000\nمانده1,234,000\n0801-14:22';
    final ingest = container.read(shareIngestProvider);
    expect(await ingest.ingest(sms), IngestResult.added);
    expect(await ingest.ingest(sms), IngestResult.duplicate);
    expect(await ingest.ingest('hello'), IngestResult.unreadable);
    final pending = await container.read(draftServiceProvider).watchPending().first;
    expect(pending.single.amount, const Money(250000, Currency.irr));
    expect(pending.single.isExpense, isTrue);
    expect(pending.single.note, 'بانک ملت');
  });

  testWidgets('Jalali picker shows Persian month and picks a day', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final format = AppFormat(AppSettings.defaultsFor('fa'));
    DateTime? picked;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('fa'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        theme: KakaTheme.build(Brightness.light, Accent.monochrome),
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async => picked = await pickDate(context, format, initial: DateTime(2026, 10, 23)),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('آبان ۱۴۰۵'), findsOneWidget); // 23 Oct 2026 = 1 Aban 1405
    await tester.tap(find.text('۱۰'));
    await tester.tap(find.text('تأیید'));
    await tester.pumpAndSettle();
    expect(picked, DateTime(2026, 11, 1));
  });
}
