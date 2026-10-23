import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaka_data/kaka_data.dart';
import 'package:kaka_domain/kaka_domain.dart';
import 'package:kaka_mobile/app/providers.dart';
import 'package:kaka_mobile/features/sms/sms_auto_reader.dart';
import 'package:kaka_mobile/features/sms/sms_platform.dart';
import 'package:kaka_sms/kaka_sms.dart';

class _FakePlatform extends SmsPlatform {
  var granted = true;
  var listening = false;
  var permissionAsked = 0;
  final inboxRows = <IncomingSms>[];

  @override
  Future<bool> hasPermission() async => granted;
  @override
  Future<bool> requestPermission() async {
    permissionAsked++;
    return granted;
  }

  @override
  Future<List<IncomingSms>> inbox({required DateTime since, List<String>? senders}) async =>
      inboxRows.where((m) => m.receivedAt.isAfter(since)).toList();
  @override
  Future<void> startListening(void Function(IncomingSms sms) onSms) async => listening = true;
  @override
  Future<void> stopListening() async => listening = false;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory dir;
  late KakaDatabase db;
  late ProviderContainer container;
  late _FakePlatform platform;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('kaka_sms_auto');
    db = KakaDatabase.open(File('${dir.path}/l.db'), key: 'k');
    platform = _FakePlatform();
    container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        initialSettingsProvider.overrideWithValue(AppSettings.defaultsFor('fa').copyWith(onboarded: true)),
        smsPlatformProvider.overrideWithValue(platform),
      ],
    );
  });
  tearDown(() async {
    container.dispose();
    await db.close();
    dir.deleteSync(recursive: true);
  });

  test('off by default: nothing is requested or read', () async {
    expect(container.read(settingsProvider).smsAutoRead, isFalse);
    expect(await container.read(smsAutoReaderProvider).resume(), 0);
    expect(platform.permissionAsked, 0);
    expect(platform.listening, isFalse);
  });

  test('enable → scan only linked senders → disable stops the receiver', () async {
    final now = DateTime.now();
    platform.inboxRows.addAll([
      IncomingSms(
        sender: '+98700717',
        body: 'بانك ملي ايران\nانتقالي:2,000,000-\nحساب:06009\nمانده:950,788\n0713-12:14',
        receivedAt: now.subtract(const Duration(days: 2)),
      ),
      IncomingSms(
        sender: 'OtherBank',
        body: 'بانك صادرات ايران\n انتقال: 18,300,000+\n حساب:85009\n مانده:119,877,823\n 0305 - 08:23',
        receivedAt: now.subtract(const Duration(days: 1)),
      ),
    ]);
    final reader = container.read(smsAutoReaderProvider);
    expect(await reader.enable(), isTrue);
    expect(platform.listening, isTrue);

    final ledger = container.read(ledgerProvider);
    final melli = await ledger.createAccount(name: 'ملی', type: AccountType.asset, currency: Currency.irr);
    await container
        .read(smsLinkRepositoryProvider)
        .upsert(SmsLink(id: 's', sender: SmsText.sender('+98700717'), accountId: melli.id));

    expect(await reader.scan(), 1);
    final drafts = await container.read(draftServiceProvider).watchPending().first;
    expect(drafts.single.accountId, melli.id);
    expect(drafts.single.balance?.minor, 950788);
    expect(await reader.scan(), 0, reason: 'incremental + dedup');

    await reader.disable();
    expect(platform.listening, isFalse);
    expect(container.read(settingsProvider).smsAutoRead, isFalse);
  });

  test('denied permission keeps the feature off', () async {
    platform.granted = false;
    expect(await container.read(smsAutoReaderProvider).enable(), isFalse);
    expect(container.read(settingsProvider).smsAutoRead, isFalse);
  });
}
