import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaka_data/kaka_data.dart';
import 'package:kaka_domain/kaka_domain.dart';
import 'package:kaka_mobile/app/providers.dart';
import 'package:kaka_mobile/features/assets/assets_screen.dart';
import 'package:kaka_mobile/features/assets/event_form_screen.dart';
import 'package:kaka_mobile/l10n/gen/app_localizations.dart';
import 'package:kaka_mobile/theme/kaka_theme.dart';

void main() {
  for (final lang in ['fa', 'en']) {
    testWidgets('portfolio overview, holding detail and buy form render on a 320dp phone ($lang)', (tester) async {
      tester.view.physicalSize = const Size(640, 1400);
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);
      final dir = Directory.systemTemp.createTempSync('kaka_assets');
      addTearDown(() => dir.deleteSync(recursive: true));
      final db = KakaDatabase.open(File('${dir.path}/l.db'), key: 'k');
      await tester.runAsync(() async {
        final container = ProviderContainer(
          overrides: [
            databaseProvider.overrideWithValue(db),
            initialSettingsProvider.overrideWithValue(AppSettings.defaultsFor(lang).copyWith(onboarded: true)),
          ],
        );
        final ledger = container.read(ledgerProvider);
        final bank = await ledger.createAccount(
          name: 'Bank',
          type: AccountType.asset,
          currency: Currency.irr,
          openingBalance: const Money(5000000000, Currency.irr),
        );
        final svc = container.read(portfolioServiceProvider);
        await svc.saveInstrument(
          InstrumentCatalog.entries.firstWhere((e) => e.id == 'coin_emami').toInstrument('coin'),
        );
        await svc.saveInstrument(InstrumentCatalog.entries.firstWhere((e) => e.id == 'btc').toInstrument('btc'));
        await svc.record(
          instrumentId: 'coin',
          kind: EventKind.buy,
          currency: Currency.irr,
          qty: 3,
          gross: 2552000000,
          cash: bank,
        );
        await svc.record(
          instrumentId: 'btc',
          kind: EventKind.opening,
          currency: Currency.usd,
          qty: 999000,
          costMode: CostMode.unknown,
        );
        await svc.setPrice('coin', const Money(1050000000, Currency.irr), DateTime.now());

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              locale: Locale(lang),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              theme: KakaTheme.build(Brightness.light, AppSettings.defaultsFor(lang).accent),
              home: const AssetsScreen(),
            ),
          ),
        );
        Future<void> settle() async {
          for (var i = 0; i < 10; i++) {
            await Future<void>.delayed(const Duration(milliseconds: 50));
            await tester.pump();
          }
        }

        await settle();
        expect(tester.takeException(), isNull);
        final coinName = lang == 'fa' ? 'سکه امامی' : 'Emami gold coin';
        expect(find.text(coinName), findsOneWidget);
        expect(find.text(lang == 'fa' ? 'بیت‌کوین' : 'Bitcoin'), findsOneWidget);

        await tester.tap(find.text(coinName));
        await settle();
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text(lang == 'fa' ? 'میانگین قیمت خرید' : 'Average cost'), findsOneWidget);

        await tester.tap(find.text(lang == 'fa' ? 'فروش' : 'Sell').first);
        await settle();
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.byType(EventFormScreen), findsOneWidget);
        await tester.enterText(find.byType(TextField).first, '5');
        await settle();
        expect(find.textContaining(lang == 'fa' ? 'موجودی' : 'You hold only'), findsWidgets);

        await tester.pumpWidget(const SizedBox());
        container.dispose();
        await tester.pump(Duration.zero);
        await db.close();
      });
    });
  }
}
