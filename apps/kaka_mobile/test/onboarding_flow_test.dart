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
}
