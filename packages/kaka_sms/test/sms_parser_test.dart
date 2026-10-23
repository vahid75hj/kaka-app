import 'dart:convert';
import 'dart:io';

import 'package:kaka_sms/kaka_sms.dart';
import 'package:test/test.dart';

void _check(ParsedSms? r, Map<String, Object?> e) {
  expect(r, isNotNull, reason: 'not parsed');
  expect(r!.direction.name, e['direction']);
  expect(r.amount.minor, e['amount_minor']);
  expect(r.balance?.minor, e['balance_minor']);
  if (e.containsKey('account')) expect(r.account, e['account']);
  if (e.containsKey('last4')) expect(r.account, e['last4']);
  if (e.containsKey('occurred_at')) expect(r.occurredAt?.toIso8601String(), e['occurred_at']);
  if (e.containsKey('bank_id')) expect(r.bankId, e['bank_id']);
}

void main() {
  final bundled = ParserCatalog.parse(File('assets/sms-parsers.v1.json').readAsStringSync());
  final parser = SmsParser(bundled);

  group('bundled catalog: every bank sample', () {
    for (final bank in bundled.banks) {
      for (final t in bank.tests) {
        test('${bank.bankId} (${bank.status.name}): ${t.input.split('\n').skip(1).first.trim()}', () {
          final r = parser.parse(t.input, receivedAt: t.receivedAt);
          _check(r, t.expect);
          expect(r!.bankId, bank.bankId);
          expect(r.templateId, isNotNull, reason: 'should be read by a template, not the heuristic');
          expect(r.confidence, greaterThan(0.9));
        });
      }
    }
    test('verified banks', () {
      expect(bundled.banks.where((b) => b.enabledByDefault).map((b) => b.bankId).toSet(), {
        'melli',
        'saderat',
        'tejarat',
        'mehriran',
      });
    });
  });

  group('real samples read by the heuristic', () {
    final fx = jsonDecode(File('test/fixtures/real_samples.json').readAsStringSync()) as Map<String, Object?>;
    for (final s in (fx['samples'] as List).cast<Map<String, Object?>>()) {
      test((s['input'] as String).split('\n').first, () {
        final r = parser.parse(s['input'] as String, receivedAt: DateTime.parse(s['received_at'] as String));
        _check(r, (s['expect'] as Map).cast<String, Object?>());
        expect(r!.templateId, isNull);
        expect(r.confidence, inInclusiveRange(0.5, 0.9));
      });
    }
  });

  group('heuristic alone also reads every bank sample', () {
    final heuristicOnly = SmsParser(const ParserCatalog(schemaVersion: 1, catalogVersion: 'none', banks: []));
    for (final bank in bundled.banks.where((b) => b.enabledByDefault)) {
      for (final t in bank.tests) {
        test(bank.bankId, () {
          final e = {...t.expect}..remove('bank_id');
          _check(heuristicOnly.parse(t.input, receivedAt: t.receivedAt), e);
        });
      }
    }
  });

  group('dates', () {
    test('MMDD without year: year comes from when the SMS was received', () {
      expect(SmsDate.find('0305 - 08:23', receivedAt: DateTime(2027, 1, 10)), DateTime(2026, 5, 26, 8, 23));
      // Received in Esfand 1404: a Khordad date must be from 1404, not the future.
      expect(SmsDate.find('0305-08:23', receivedAt: DateTime(2026, 3, 1)), DateTime(2025, 5, 26, 8, 23));
    });
    test('date and time on separate lines', () {
      expect(SmsDate.find('1405/07/30\n19:32', receivedAt: DateTime(2026, 10, 23)), DateTime(2026, 10, 22, 19, 32));
    });
    test('invalid dates are ignored', () {
      expect(SmsDate.find('1405/13/40', receivedAt: DateTime(2026, 10, 23)), isNull);
    });
  });

  group('normalization', () {
    test('Arabic letters, bidi marks and stars', () {
      expect(SmsText.normalize('*بانك ملي* \n\u202a۱۲۳\u202c\u200e'), 'بانک ملی\n123');
    });
    test('sender numbers compare equal across formats', () {
      expect(SmsText.sender('+98 700-717'), SmsText.sender('98700717'));
      expect(SmsText.sender('BankMelli'), 'bankmelli');
    });
  });

  group('account matching', () {
    test('suffix', () => expect(AccountRef.matches('06009', '0101234506009'), isTrue));
    test('dashed form without zero padding', () {
      expect(AccountRef.matches('7616-700-7641552-1', '761670007641552001'), isTrue);
      expect(AccountRef.matches('7616-700-7641552-2', '761670007641552001'), isFalse);
    });
    test('different accounts', () => expect(AccountRef.matches('85009', '06009'), isFalse));
  });

  test('dedup key is stable across digit and letter styles', () {
    final t = bundled.banks.first.tests.first;
    final a = parser.parse(t.input, receivedAt: t.receivedAt)!;
    final b = parser.parse(
      t.input.replaceAll('2,950,788', '۲,۹۵۰,۷۸۸').replaceAll('ی', 'ي'),
      receivedAt: t.receivedAt,
    )!;
    expect(a.dedupKey, b.dedupKey);
  });

  test('not a bank SMS', () {
    expect(parser.parse('سلام، کد تخفیف شما ۱۲۳۴'), isNull);
    expect(parser.parse('کد تایید: 552311'), isNull);
  });
}
