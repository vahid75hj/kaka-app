import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaka_domain/kaka_domain.dart';
import 'package:kaka_sms/kaka_sms.dart';

import '../../app/providers.dart';

export 'package:kaka_sms/kaka_sms.dart' show IngestResult;

/// Shared / pasted text → [SmsIngestService] → question queue.
class ShareIngest {
  ShareIngest(this._ref);
  final Ref _ref;

  Future<IngestResult> ingest(String text, {DraftSource source = DraftSource.share}) async {
    final service = await _ref.read(smsIngestServiceProvider.future);
    return service.ingest(
      IncomingSms(body: text, receivedAt: DateTime.now()),
      source: source,
    );
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
