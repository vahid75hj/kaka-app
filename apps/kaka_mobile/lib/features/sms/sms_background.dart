import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:kaka_data/kaka_data.dart';
import 'package:kaka_domain/kaka_domain.dart';
import 'package:kaka_sms/kaka_sms.dart';

import '../../app/bootstrap.dart';
import '../../l10n/gen/app_localizations.dart';
import 'sms_platform.dart';

const _channel = MethodChannel('app.kaka/sms_bg');

/// Headless run (no UI): store SMS the background receiver caught as drafts in
/// the question queue, then report back so `SmsWorker` can notify and finish.
/// Nothing is recorded in the ledger. Only linked senders are read, as in the app.
Future<void> runSmsBackground() async {
  WidgetsFlutterBinding.ensureInitialized();
  var ack = 0;
  String? title;
  String? body;
  KakaDatabase? db;
  try {
    final rows = await _channel.invokeListMethod<Map<Object?, Object?>>('takePending') ?? const [];
    final pending = [for (final r in rows) SmsPlatform.toSms(r.cast<String, Object?>())];
    db = await openLedger();
    final settings = await DriftSettingsStore(db).load();
    if (settings == null || !settings.smsAutoRead || !settings.smsBackground) {
      ack = pending.length; // Feature off: drop them; nothing is read.
    } else {
      final added = await ingestPending(db, settings, pending);
      ack = pending.length;
      if (added > 0) {
        final l = lookupAppLocalizations(Locale(settings.localeCode));
        title = l.appName;
        body = l.bgSmsBody(Digits.render('$added', settings.digits));
      }
    }
  } catch (_) {
    // Leave items pending (ack = 0): the app stores them on next open.
    ack = 0;
  } finally {
    await db?.close();
    await _channel.invokeMethod<Object?>('done', {'ack': ack, 'title': title, 'body': body});
  }
}

/// Shared with tests: builds the same parser/ingest pipeline as the app.
Future<int> ingestPending(KakaDatabase db, AppSettings settings, List<IncomingSms> pending) async {
  final json = await rootBundle.loadString('packages/kaka_sms/assets/sms-parsers.v1.json');
  final local = [
    for (final (_, j) in await DriftCustomParserStore(db).getAll())
      BankParser.fromJson(jsonDecode(j) as Map<String, Object?>),
  ];
  final service = SmsIngestService(
    parser: SmsParser(ParserCatalog.parse(json).withLocal(local)),
    links: DriftSmsLinkRepository(db),
    drafts: DraftService(DriftDraftRepository(db)),
    bankName: (b) => settings.isPersian ? b.nameFa : b.nameEn,
  );
  var added = 0;
  for (final m in pending) {
    if (await service.ingest(m, source: DraftSource.sms, onlyLinkedSenders: true) == IngestResult.added) added++;
  }
  return added;
}
