import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaka_data/kaka_data.dart';
import 'package:kaka_domain/kaka_domain.dart';

import 'app/bootstrap.dart';
import 'app/kaka_app.dart';
import 'app/providers.dart';
import 'app/startup_error.dart';
import 'features/sms/sms_background.dart';

/// Headless entry point started by `SmsWorker` (Android) when a bank SMS arrives while Kaka is closed.
@pragma('vm:entry-point')
Future<void> smsBackgroundMain() => runSmsBackground();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // A broken widget shows its error (selectable) instead of a blank grey box in release.
  ErrorWidget.builder = (d) => Material(
    child: Padding(padding: const EdgeInsets.all(12), child: SelectableText('Kaka error: ${d.exceptionAsString()}')),
  );
  await _start();
}

/// Any init failure (keystore, ledger key, schema, settings) shows an error
/// screen with a copyable message instead of leaving the app stuck/closed.
Future<void> _start() async {
  try {
    final db = await openLedger();
    final settings =
        await DriftSettingsStore(db).load() ?? AppSettings.defaultsFor(PlatformDispatcher.instance.locale.languageCode);
    runApp(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db), initialSettingsProvider.overrideWithValue(settings)],
        child: const KakaApp(),
      ),
    );
  } catch (e, st) {
    debugPrint('startup: $e\n$st');
    runApp(StartupErrorApp(error: e, stack: st, onRetry: _start, onReset: moveLedgerAside));
  }
}
