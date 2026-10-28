import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kaka_data/kaka_data.dart';
import 'package:kaka_domain/kaka_domain.dart';
import 'package:kaka_mobile/features/sms/sms_background.dart';
import 'package:kaka_sms/kaka_sms.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('background ingest: linked senders become drafts once, others are ignored', () async {
    final dir = Directory.systemTemp.createTempSync('kaka_bg');
    addTearDown(() => dir.deleteSync(recursive: true));
    final db = KakaDatabase.open(File('${dir.path}/l.db'), key: 'k');
    addTearDown(db.close);
    await DriftSmsLinkRepository(db).upsert(SmsLink(id: 'sender:bank', sender: SmsText.sender('+98700717')));
    final settings = AppSettings.defaultsFor('fa').copyWith(smsAutoRead: true, smsBackground: true);
    const body = 'پرداخت گروهي\nحساب:761670007641552001\nمبلغ:120,000,000\nمانده:131,788,333\nزمان:1405/7/4-11:57';
    final at = DateTime(2026, 9, 26, 11, 58);
    final sms = [
      IncomingSms(sender: '+98700717', body: body, receivedAt: at),
      IncomingSms(sender: '+98700717', body: body, receivedAt: at), // duplicate delivery
      IncomingSms(sender: '+98912000000', body: body, receivedAt: at), // not linked
    ];
    expect(await ingestPending(db, settings, sms), 1);
    // The app draining the same items again (e.g. worker was killed before ack) adds nothing.
    expect(await ingestPending(db, settings, sms), 0);
    final drafts = await DraftService(DriftDraftRepository(db)).watchPending().first;
    expect(drafts.single.amount.minor, 120000000);
    expect(drafts.single.isExpense, isTrue);
  });
}
