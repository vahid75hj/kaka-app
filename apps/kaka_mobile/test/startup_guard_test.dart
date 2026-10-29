import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kaka_data/kaka_data.dart';
import 'package:kaka_mobile/app/startup_error.dart';

void main() {
  test('a ledger restored without its key fails at the first read (what the guard catches)', () async {
    final dir = Directory.systemTemp.createTempSync('kaka_guard');
    addTearDown(() => dir.deleteSync(recursive: true));
    final f = File('${dir.path}/kaka.ledger');
    final a = KakaDatabase.open(f, key: 'old-key');
    await DriftSettingsStore(a).load();
    await a.close();
    final b = KakaDatabase.open(f, key: 'new-key');
    await expectLater(DriftSettingsStore(b).load(), throwsA(anything));
    await b.close();
  });

  testWidgets('startup error screen shows a copyable error', (tester) async {
    await tester.pumpWidget(
      StartupErrorApp(
        error: StateError('boom'),
        stack: StackTrace.empty,
        onRetry: () async {},
        onReset: () async => null,
      ),
    );
    expect(find.textContaining('boom'), findsOneWidget);
    expect(find.text('کپی خطا / Copy error'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
