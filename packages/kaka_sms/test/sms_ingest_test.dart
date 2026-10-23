import 'dart:io';

import 'package:kaka_domain/kaka_domain.dart';
import 'package:kaka_sms/kaka_sms.dart';
import 'package:test/test.dart';

class _Links implements SmsLinkRepository {
  final items = <SmsLink>[];
  @override
  Future<void> delete(String id) async => items.removeWhere((l) => l.id == id);
  @override
  Future<List<SmsLink>> getAll() async => items;
  @override
  Future<void> upsert(SmsLink l) async => items
    ..removeWhere((x) => x.id == l.id)
    ..add(l);
  @override
  Stream<List<SmsLink>> watchAll() => Stream.value(items);
}

class _Drafts implements DraftRepository {
  final items = <String, Draft>{};
  @override
  Future<bool> existsWithDedupKey(String key) async => items.values.any((d) => d.dedupKey == key);
  @override
  Future<Draft?> findById(String id) async => items[id];
  @override
  Future<void> upsert(Draft d) async => items[d.id] = d;
  @override
  Stream<List<Draft>> watchPending() => Stream.value(items.values.toList());
}

void main() {
  final parser = SmsParser(ParserCatalog.parse(File('assets/sms-parsers.v1.json').readAsStringSync()));
  late _Links links;
  late _Drafts drafts;
  late SmsIngestService service;
  setUp(() {
    links = _Links();
    drafts = _Drafts();
    service = SmsIngestService(parser: parser, links: links, drafts: DraftService(drafts), bankName: (b) => b.nameFa);
  });

  const melli = 'بانك ملي ايران\nانتقالي:2,000,000-\nحساب:06009\nمانده:950,788\n0713-12:14';
  const mehr =
      'بانک قرض الحسنه مهرايران\nحساب:\u202a7616-700-7641552-1\u202c\nمبلغ:100,000,000-\nانتقال از خودپرداز\nمانده:58,871,131\nزمان:1403/8/29-9:22';
  const group =
      'پرداخت گروهي\nحساب:\u202a761670007641552001\u202c\nمبلغ:120,000,000\nمانده:131,788,333\nزمان:1405/7/4-11:57';

  test('auto-read only processes linked senders', () async {
    final sms = IncomingSms(body: melli, sender: '+98 9999', receivedAt: DateTime(2026, 10, 5));
    expect(await service.ingest(sms, source: DraftSource.sms, onlyLinkedSenders: true), IngestResult.ignoredSender);
    await links.upsert(const SmsLink(id: 'l1', sender: '989999', accountId: 'melli-acc'));
    expect(await service.ingest(sms, source: DraftSource.sms, onlyLinkedSenders: true), IngestResult.added);
    expect(drafts.items.values.single.accountId, 'melli-acc');
    expect(drafts.items.values.single.note, 'بانک ملی');
    // The same SMS shared by hand later is a duplicate.
    expect(await service.ingest(sms, source: DraftSource.share), IngestResult.duplicate);
  });

  test('account number links work across senders and dashed forms', () async {
    await links.upsert(const SmsLink(id: 'n', accountNumber: '761670007641552001', accountId: 'mehr-acc'));
    await service.ingest(
      IncomingSms(body: mehr, receivedAt: DateTime(2024, 11, 19)),
      source: DraftSource.share,
    );
    await service.ingest(
      IncomingSms(body: group, receivedAt: DateTime(2026, 9, 26)),
      source: DraftSource.share,
    );
    expect(drafts.items.values.map((d) => d.accountId), everyElement('mehr-acc'));
  });

  test('unknown account from a linked sender is still queued, without a suggestion', () async {
    await links.upsert(const SmsLink(id: 's', sender: 'bankmelli'));
    final r = await service.ingest(
      IncomingSms(body: melli, sender: 'BankMelli', receivedAt: DateTime(2026, 10, 5)),
      source: DraftSource.sms,
      onlyLinkedSenders: true,
    );
    expect(r, IngestResult.added);
    expect(drafts.items.values.single.accountId, isNull);
    expect(drafts.items.values.single.balance?.minor, 950788);
  });

  test('sender classification flags bank-like senders', () {
    final bank = parser.classify(const SenderSummary(sender: '700717', count: 3, samples: [melli]));
    expect(bank.looksLikeBank, isTrue);
    expect(bank.bank?.bankId, 'melli');
    expect(bank.accounts, {'06009'});
    final otp = parser.classify(const SenderSummary(sender: 'Digikala', count: 9, samples: ['کد ورود شما: 55231']));
    expect(otp.looksLikeBank, isFalse);
  });
}
