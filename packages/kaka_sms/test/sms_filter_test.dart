import 'dart:convert';
import 'dart:io';

import 'package:kaka_sms/kaka_sms.dart';
import 'package:test/test.dart';

void main() {
  final f = jsonDecode(File('test/fixtures/sms_filter.json').readAsStringSync()) as Map<String, Object?>;
  for (final s in (f['transactions']! as List).cast<String>()) {
    test('stores: ${s.split('\n').first}', () {
      expect(SmsFilter.looksLikeTransaction(s), isTrue);
      expect(SmsFilter.shouldStore(s, knownSender: false), isTrue);
    });
  }
  for (final s in (f['not_transactions']! as List).cast<String>()) {
    test('ignores: ${s.split('\n').first}', () {
      expect(SmsFilter.shouldStore(s, knownSender: true), isFalse);
    });
  }
}
