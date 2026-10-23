import 'dart:io';

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
    await tester.runAsync(() async {
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
      final accounts = await DriftAccountRepository(db).getAll();
      expect(accounts.firstWhere((a) => a.type == AccountType.asset).currency, Currency.irr);

      // Dispose providers so drift's stream-cleanup timers run before the test ends.
      await tester.pumpWidget(const SizedBox());
      await tester.pump(Duration.zero);
      await db.close();
    });
  });
}
