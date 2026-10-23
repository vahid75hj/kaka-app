import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaka_domain/kaka_domain.dart';

import '../features/lock/app_lock.dart';
import '../features/queue/queue_screen.dart';
import '../features/queue/share_ingest.dart';
import '../features/sms/sms_auto_reader.dart';
import '../l10n/gen/app_localizations.dart';
import '../theme/kaka_theme.dart';
import 'providers.dart';
import 'router.dart';

class KakaApp extends ConsumerStatefulWidget {
  const KakaApp({super.key});

  @override
  ConsumerState<KakaApp> createState() => _KakaAppState();
}

class _KakaAppState extends ConsumerState<KakaApp> {
  @override
  void initState() {
    super.initState();
    ShareInbox.listen(_onShared);
    ShareInbox.takeInitial().then((t) {
      if (t != null) _onShared(t);
    });
  }

  /// Shared text → parser → question queue. Never writes to the ledger directly.
  Future<void> _onShared(String text) async {
    if (!ref.read(settingsProvider).onboarded) return;
    final result = await ref.read(shareIngestProvider).ingest(text);
    final router = ref.read(routerProvider);
    router.push(Routes.queue);
    final ctx = router.routerDelegate.navigatorKey.currentContext;
    if (ctx != null && ctx.mounted) showIngestResult(ctx, result);
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(settingsProvider);
    return MaterialApp.router(
      builder: (context, child) => AppLockGate(child: SmsLifecycle(child: child ?? const SizedBox.shrink())),
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
