import 'package:flutter/services.dart';
import 'package:kaka_sms/kaka_sms.dart';

/// Thin wrapper over the native `app.kaka/sms` channel (see `SmsBridge.kt`).
class SmsPlatform {
  static const _channel = MethodChannel('app.kaka/sms');

  void Function(IncomingSms sms)? _onSms;

  SmsPlatform() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'sms') _onSms?.call(_toSms((call.arguments as Map).cast<String, Object?>()));
    });
  }

  Future<bool> hasPermission() => _bool('hasPermission');
  Future<bool> requestPermission() => _bool('requestPermission');

  Future<List<SenderSummary>> senders({required DateTime since}) async {
    final rows = await _channel.invokeListMethod<Map<Object?, Object?>>('senders', {
      'sinceMs': since.millisecondsSinceEpoch,
    });
    return [
      for (final r in rows ?? const <Map<Object?, Object?>>[])
        SenderSummary(
          sender: r['sender']! as String,
          count: r['count']! as int,
          samples: (r['samples']! as List).cast<String>(),
        ),
    ];
  }

  Future<List<IncomingSms>> inbox({required DateTime since, List<String>? senders}) async {
    final rows = await _channel.invokeListMethod<Map<Object?, Object?>>('inbox', {
      'sinceMs': since.millisecondsSinceEpoch,
      'senders': senders,
    });
    return [for (final r in rows ?? const <Map<Object?, Object?>>[]) _toSms(r.cast<String, Object?>())];
  }

  Future<void> startListening(void Function(IncomingSms sms) onSms) async {
    _onSms = onSms;
    await _channel.invokeMethod<Object?>('startListening');
  }

  Future<void> stopListening() async {
    _onSms = null;
    try {
      await _channel.invokeMethod<Object?>('stopListening');
    } on MissingPluginException {
      // Not on Android (tests / desktop).
    }
  }

  static IncomingSms _toSms(Map<String, Object?> m) => IncomingSms(
    sender: m['sender'] as String?,
    body: m['body']! as String,
    receivedAt: DateTime.fromMillisecondsSinceEpoch((m['date']! as num).toInt()),
  );

  Future<bool> _bool(String method) async {
    try {
      return await _channel.invokeMethod<bool>(method) ?? false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }
}
