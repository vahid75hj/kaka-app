import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaka_data/kaka_data.dart';
import 'package:kaka_domain/kaka_domain.dart';
import 'package:kaka_mobile/app/kaka_app.dart';
import 'package:kaka_mobile/app/providers.dart';
import 'package:kaka_mobile/app/router.dart';
import 'package:go_router/go_router.dart';

void main() {
  late Directory dir;
  late KakaDatabase db;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('kaka_widget');
    db = KakaDatabase.open(File('${dir.path}/ledger.db'), key: 'k');
  });
  tearDown(() => dir.deleteSync(recursive: true));

  testWidgets('Persian onboarding creates a toman account and lands on home', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);
    await tester.runAsync(() async {
      if (Platform.environment['KAKA_SHOT'] != null) {
        for (final w in ['Regular', 'Bold', 'ExtraBold']) {
          final loader = FontLoader('Vazirmatn')
            ..addFont(File('assets/fonts/Vazirmatn-$w.ttf').readAsBytes().then(ByteData.sublistView));
          await loader.load();
        }
      }
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            initialSettingsProvider.overrideWithValue(AppSettings.defaultsFor('fa')),
          ],
          child: const KakaApp(),
        ),
      );
      await tester.pumpAndSettle();
      expect(Directionality.of(tester.element(find.byType(Scaffold).first)), TextDirection.rtl);

      for (var i = 0; i < 3; i++) {
        await tester.tap(find.text('بعدی'));
        await tester.pumpAndSettle();
      }
      await tester.enterText(find.byType(TextField).last, '1250000');
      await tester.tap(find.text('شروع کن'));
      // Let the database writes and streams settle.
      for (var i = 0; i < 20; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
        await tester.pump();
      }
      await tester.pumpAndSettle();

      expect(find.text('دارایی خالص'), findsOneWidget);
      expect(find.text('۱٬۲۵۰٬۰۰۰'), findsOneWidget);
      // First-run checklist: the account step is already done (1 of 4).
      expect(find.textContaining('شروع کار'), findsOneWidget);
      expect(find.text('۱ از ۴'), findsOneWidget);
      expect(tester.takeException(), isNull, reason: 'no layout overflow in RTL');
      if (Platform.environment['KAKA_SHOT'] != null) {
        final boundary = tester.renderObject<RenderRepaintBoundary>(find.byType(RepaintBoundary).first);
        final image = await boundary.toImage(pixelRatio: 1);
        final png = await image.toByteData(format: ui.ImageByteFormat.png);
        File(Platform.environment['KAKA_SHOT']!).writeAsBytesSync(png!.buffer.asUint8List());
      }
      final accounts = await DriftAccountRepository(db).getAll();
      expect(accounts.firstWhere((a) => a.type == AccountType.asset).currency, Currency.irr);

      // Dispose providers so drift's stream-cleanup timers run before the test ends.
      await tester.pumpWidget(const SizedBox());
      await tester.pump(Duration.zero);
      await db.close();
    });
  });

  testWidgets('budgets: home card and screen render in RTL without overflow', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);
    await tester.runAsync(() async {
      final shot = Platform.environment['KAKA_SHOT'];
      if (shot != null) {
        for (final w in ['Regular', 'Bold', 'ExtraBold']) {
          final loader = FontLoader('Vazirmatn')
            ..addFont(File('assets/fonts/Vazirmatn-$w.ttf').readAsBytes().then(ByteData.sublistView));
          await loader.load();
        }
      }
      final ledger = LedgerService(DriftAccountRepository(db), DriftTransactionRepository(db));
      final cash = await ledger.createAccount(
        name: 'نقد',
        type: AccountType.asset,
        currency: Currency.irr,
        openingBalance: const Money(50000000, Currency.irr),
      );
      for (final (name, spent, limit) in [('غذا', 9000000, 8000000), ('حمل‌ونقل', 1000000, 5000000)]) {
        final cat = await ledger.ensureCategory(name, AccountType.expense, Currency.irr);
        await ledger.recordExpense(from: cash, category: cat, amount: Money(spent, Currency.irr));
        await DriftBudgetRepository(db)
            .upsert(Budget(id: Budget.idFor(name), category: name, limit: Money(limit, Currency.irr)));
      }
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            initialSettingsProvider.overrideWithValue(
              AppSettings.defaultsFor('fa').copyWith(onboarded: true, hideGettingStarted: true),
            ),
          ],
          child: const KakaApp(),
        ),
      );
      for (var i = 0; i < 20; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
        await tester.pump();
      }
      await tester.pumpAndSettle();
      expect(find.textContaining('بیشتر از سقف'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.ensureVisible(find.widgetWithText(ActionChip, 'بودجه‌ها'));
      await tester.tap(find.widgetWithText(ActionChip, 'بودجه‌ها'));
      await tester.pumpAndSettle();
      expect(find.text('۸۰۰٬۰۰۰ تومان'), findsNothing); // limit is shown inside "spent of limit"
      expect(find.textContaining('مونده'), findsOneWidget);
      expect(tester.takeException(), isNull, reason: 'no layout overflow in RTL');
      if (shot != null) {
        final boundary = tester.renderObject<RenderRepaintBoundary>(find.byType(RepaintBoundary).first);
        final image = await boundary.toImage(pixelRatio: 1);
        final png = await image.toByteData(format: ui.ImageByteFormat.png);
        File(shot.replaceFirst('.png', '_budgets.png')).writeAsBytesSync(png!.buffer.asUint8List());
      }

      await DriftRecurringRepository(db).upsert(
        RecurringRule(
          id: 'rent',
          isExpense: true,
          accountId: cash.id,
          category: 'اجاره‌ی خونه‌ی خیابان ولیعصر',
          amount: const Money(1500000000, Currency.irr),
          every: RecurrenceEvery.monthly,
          start: DateTime(2026, 10, 23, 9),
          lastDone: DateTime(2026, 10, 23, 9),
          note: 'به آقای صاحب‌خونه',
        ),
      );
      GoRouter.of(tester.element(find.byType(Scaffold).last)).push(Routes.recurring);
      for (var i = 0; i < 10; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
        await tester.pump();
      }
      await tester.pumpAndSettle();
      expect(find.textContaining('هر ماه · بعدی:'), findsOneWidget);
      expect(tester.takeException(), isNull, reason: 'recurring list fits in RTL');
      if (shot != null) {
        final boundary = tester.renderObject<RenderRepaintBoundary>(find.byType(RepaintBoundary).first);
        final image = await boundary.toImage(pixelRatio: 1);
        final png = await image.toByteData(format: ui.ImageByteFormat.png);
        File(shot.replaceFirst('.png', '_recurring.png')).writeAsBytesSync(png!.buffer.asUint8List());
      }
      await tester.pumpWidget(const SizedBox());
      await tester.pump(Duration.zero);
      await db.close();
    });
  });

  testWidgets('add form: "every month" saves the expense and a rule already done for today', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);
    await tester.runAsync(() async {
      final ledger = LedgerService(DriftAccountRepository(db), DriftTransactionRepository(db));
      await ledger.createAccount(name: 'نقد', type: AccountType.asset, currency: Currency.irr);
      await ledger.ensureCategory('اجاره', AccountType.expense, Currency.irr);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            initialSettingsProvider.overrideWithValue(
              AppSettings.defaultsFor('fa').copyWith(onboarded: true, hideGettingStarted: true),
            ),
          ],
          child: const KakaApp(),
        ),
      );
      Future<void> settle() async {
        for (var i = 0; i < 10; i++) {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          await tester.pump();
        }
        await tester.pumpAndSettle();
      }

      await settle();
      GoRouter.of(tester.element(find.byType(Scaffold).last)).push(Routes.addTransaction);
      await settle();
      await tester.enterText(find.byType(TextField).first, '15000000');
      await tester.tap(find.widgetWithText(ChoiceChip, 'اجاره'));
      await settle();
      final repeat = find.text('تکرار نشه');
      final vertical = find.byWidgetPredicate((w) => w is Scrollable && w.axisDirection == AxisDirection.down).first;
      await tester.scrollUntilVisible(repeat, 200, scrollable: vertical);
      await tester.tap(repeat);
      await settle();
      await tester.tap(find.text('هر ماه').last);
      await settle();
      await tester.scrollUntilVisible(find.widgetWithText(FilledButton, 'ذخیره'), 200, scrollable: vertical);
      await tester.tap(find.widgetWithText(FilledButton, 'ذخیره'));
      await settle();
      final rule = (await DriftRecurringRepository(db).getAll()).single;
      expect((rule.category, rule.amount.minor, rule.every), ('اجاره', 150000000, RecurrenceEvery.monthly));
      expect(rule.lastDone, rule.start, reason: 'today is recorded, not queued again');
      final txns = await DriftTransactionRepository(db).watchRecent().first;
      expect(txns.where((t) => t.kind == TransactionKind.expense), hasLength(1));
      await tester.pumpWidget(const SizedBox());
      await tester.pump(Duration.zero);
      await db.close();
    });
  });
}
