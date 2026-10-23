import 'package:flutter/services.dart';

/// Android FLAG_SECURE (no screenshots / hidden in recents). No-op elsewhere.
abstract final class SecureWindow {
  static const _channel = MethodChannel('app.kaka/window');

  static Future<void> set(bool secure) async {
    try {
      await _channel.invokeMethod<void>('setSecure', secure);
    } on MissingPluginException {
      // tests / non-Android
    }
  }
}
