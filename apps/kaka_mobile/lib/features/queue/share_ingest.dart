import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaka_domain/kaka_domain.dart';
import 'package:kaka_sms/kaka_sms.dart';

import '../../app/providers.dart';

enum IngestResult { added, duplicate, unreadable }

/// Turns shared / pasted text into a question-queue draft. Nothing is
/// written to the ledger here: the user always confirms.
class ShareIngest {
  ShareIngest(this._ref);
  final Ref _ref;

  Future<IngestResult> ingest(String text, {DraftSource source = DraftSource.share}) async {
    final parser = await _ref.read(smsParserProvider.future);
    final parsed = parser.parse(text);
    if (parsed == null) return IngestResult.unreadable;
    final bank = parser.catalog.banks.where((b) => b.bankId == parsed.bankId).firstOrNull;
    final fa = _ref.read(settingsProvider).isPersian;
    final draft = Draft(
      id: Ids.next(),
      source: source,
      isExpense: parsed.direction == SmsDirection.debit,
      amount: parsed.amount,
      createdAt: DateTime.now(),
      rawText: text.trim(),
      note: bank == null ? '' : (fa ? bank.nameFa : bank.nameEn),
      bankId: parsed.bankId,
      last4: parsed.last4,
      dedupKey: parsed.dedupKey,
    );
    final added = await _ref.read(draftServiceProvider).enqueue(draft);
    return added ? IngestResult.added : IngestResult.duplicate;
  }
}

final shareIngestProvider = Provider<ShareIngest>(ShareIngest.new);

/// Text handed to Kaka by Android (`ACTION_SEND` / `ACTION_PROCESS_TEXT`).
abstract final class ShareInbox {
  static const _channel = MethodChannel('app.kaka/share');

  /// The text that launched the app, if any (consumed once).
  static Future<String?> takeInitial() async {
    try {
      return await _channel.invokeMethod<String>('takeSharedText');
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return null;
    }
  }

  /// Text shared while the app is already running.
  static void listen(void Function(String text) onText) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'sharedText' && call.arguments is String) onText(call.arguments as String);
    });
  }
}
