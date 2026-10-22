import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaka_domain/kaka_domain.dart';

import '../l10n/gen/app_localizations.dart';
import '../theme/kaka_theme.dart';
import 'providers.dart';
import 'router.dart';

class KakaApp extends ConsumerWidget {
  const KakaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    return MaterialApp.router(
      onGenerateTitle: (c) => AppLocalizations.of(c).appName,
      debugShowCheckedModeBanner: false,
      routerConfig: ref.watch(routerProvider),
      locale: Locale(s.localeCode),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: KakaTheme.build(Brightness.light, s.accent),
      darkTheme: KakaTheme.build(Brightness.dark, s.accent),
      themeMode: switch (s.theme) {
        ThemePreference.system => ThemeMode.system,
        ThemePreference.light => ThemeMode.light,
        ThemePreference.dark => ThemeMode.dark,
      },
    );
  }
}
