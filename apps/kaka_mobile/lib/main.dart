import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaka_data/kaka_data.dart';
import 'package:kaka_domain/kaka_domain.dart';

import 'app/bootstrap.dart';
import 'app/kaka_app.dart';
import 'app/providers.dart';
import 'features/sms/sms_background.dart';

/// Headless entry point started by `SmsWorker` (Android) when a bank SMS arrives while Kaka is closed.
@pragma('vm:entry-point')
Future<void> smsBackgroundMain() => runSmsBackground();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = await openLedger();
  final settings =
      await DriftSettingsStore(db).load() ?? AppSettings.defaultsFor(PlatformDispatcher.instance.locale.languageCode);
  runApp(
    ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db), initialSettingsProvider.overrideWithValue(settings)],
      child: const KakaApp(),
    ),
  );
}
