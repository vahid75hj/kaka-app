import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaka_data/kaka_data.dart';
import 'package:kaka_domain/kaka_domain.dart';
import 'package:kaka_mobile/app/providers.dart';
import 'package:kaka_mobile/features/import/import_screen.dart';
import 'package:kaka_mobile/l10n/gen/app_localizations.dart';
import 'package:kaka_mobile/theme/kaka_theme.dart';

void main() {
  test('Jalali converter rejects day 31 in autumn and maps 1 Aban 1405', () {
    expect(jalaliToGregorian(1405, 8, 1), DateTime(2026, 10, 23));
    expect(() => jalaliToGregorian(1405, 7, 31), throwsA(anything));
    expect(CsvImport.parseDate('1405/07/31', jalali: jalaliToGregorian), isNull);
  });

  testWidgets('Persian bank statement: preview, skip duplicate, import, undo', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);
    final dir = Directory.systemTemp.createTempSync('kaka_import');
    addTearDown(() => dir.deleteSync(recursive: true));
    final db = KakaDatabase.open(File('${dir.path}/l.db'), key: 'k');
    await tester.runAsync(() async {
      final ledger = LedgerService(DriftAccountRepository(db), DriftTransactionRepository(db));
      final card = await ledger.createAccount(name: 'کارت ملت', type: AccountType.asset, currency: Currency.irr);
      final food = await ledger.ensureCategory('غذا', AccountType.expense, Currency.irr);
      // Already recorded from SMS: the first statement row must be skipped.
      await ledger.recordExpense(
        from: card,
        category: food,
        amount: const Money(2000000, Currency.irr),
        at: DateTime(2026, 10, 23, 9),
      );
      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
          initialSettingsProvider.overrideWithValue(AppSettings.defaultsFor('fa').copyWith(onboarded: true)),
        ],
      );
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            locale: const Locale('fa'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: KakaTheme.build(Brightness.light, AppSettings.defaultsFor('fa').accent),
            home: const Scaffold(body: Builder(builder: _host)),
          ),
        ),
      );
      for (var i = 0; i < 10; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
        await tester.pump();
      }
      await tester.tap(find.text('open'));
      for (var i = 0; i < 10; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
        await tester.pump();
      }
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'no overflow in RTL');
      expect(find.text('۲ ردیف تازه · ۱ تا قبلاً توی حساب بوده'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('واریز حقوق'), 200);
      expect(find.textContaining('ردیف‌های ناخوانا: ۵ (در کل ۱)'), findsOneWidget);
      expect(find.text('خرید فروشگاه'), findsNothing, reason: 'already recorded');

      final button = find.text('وارد کن (۲)');
      await tester.scrollUntilVisible(button, 200);
      await tester.pumpAndSettle();
      await tester.tap(button);
      for (var i = 0; i < 20; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
        await tester.pump();
      }
      final txns = await DriftTransactionRepository(db).watchRecent().first;
      final live = txns.where((t) => !t.isVoided).toList();
      expect(live, hasLength(3));
      final accounts = {for (final a in await DriftAccountRepository(db).getAll()) a.id: a};
      final imported = {
        for (final t in live)
          for (final p in t.postings)
            if (accounts[p.accountId]!.type != AccountType.asset) '${accounts[p.accountId]!.name}:${p.amount.minor}',
      };
      expect(imported, {'غذا:2000000', 'وارد شده:-150000000', 'وارد شده:5000'});

      await tester.pumpAndSettle();
      expect(find.text('۲ تراکنش وارد شد'), findsOneWidget);
      await tester.tap(find.text('برگردون'));
      for (var i = 0; i < 20; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
        await tester.pump();
      }
      final after = await DriftTransactionRepository(db).watchRecent().first;
      expect(after.where((t) => !t.isVoided), hasLength(1));

      await tester.pumpWidget(const SizedBox());
      container.dispose();
      await tester.pump(Duration.zero);
      await db.close();
    });
  });

  testWidgets('import screen fits a 320dp phone in English dark mode', (tester) async {
    tester.view.physicalSize = const Size(640, 1200);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    final dir = Directory.systemTemp.createTempSync('kaka_import_en');
    addTearDown(() => dir.deleteSync(recursive: true));
    final db = KakaDatabase.open(File('${dir.path}/l.db'), key: 'k');
    await tester.runAsync(() async {
      final ledger = LedgerService(DriftAccountRepository(db), DriftTransactionRepository(db));
      await ledger.createAccount(
        name: 'A very long bank account name',
        type: AccountType.asset,
        currency: Currency.irr,
      );
      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
          initialSettingsProvider.overrideWithValue(AppSettings.defaultsFor('en').copyWith(onboarded: true)),
        ],
      );
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            locale: const Locale('en'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: KakaTheme.build(Brightness.dark, AppSettings.defaultsFor('en').accent),
            home: const ImportScreen(
              initialText: 'Transaction date,Description,Withdrawal amount,Deposit amount\n2026-10-01,Groceries at a shop with a long name,120000,\n',
            ),
          ),
        ),
      );
      for (var i = 0; i < 10; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
        await tester.pump();
      }
      await tester.pumpAndSettle();
      for (var i = 0; i < 6; i++) {
        await tester.drag(find.byType(ListView), const Offset(0, -300));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
      expect(find.text('Import 1'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      container.dispose();
      await tester.pump(Duration.zero);
      await db.close();
    });
  });
}

Widget _host(BuildContext context) => Center(
  child: TextButton(
    onPressed: () => Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const ImportScreen(
          initialText:
              'ردیف,تاریخ,شرح,برداشت,واریز,مانده\n'
              '1,۱۴۰۵/۰۸/۰۱,خرید فروشگاه,"۲٬۰۰۰٬۰۰۰",,\n'
              '2,1405/08/02,واریز حقوق,,"150,000,000",\n'
              '3,1405/08/03,کارمزد,5000,,\n'
              '4,نامعلوم,x,1,,\n',
        ),
      ),
    ),
    child: const Text('open'),
  ),
);
