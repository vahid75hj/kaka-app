import 'dart:io';
import 'dart:typed_data';

import 'package:kaka_data/kaka_data.dart';
import 'package:kaka_domain/kaka_domain.dart';
import 'package:test/test.dart';

const _fastKdf = KdfParams(memoryKiB: 256, iterations: 1);

void main() {
  late Directory dir;
  late KakaDatabase db;
  setUp(() {
    dir = Directory.systemTemp.createTempSync('kaka_mvp2');
    db = KakaDatabase.open(File('${dir.path}/a.db'), key: 'k1');
  });
  tearDown(() async {
    await db.close();
    dir.deleteSync(recursive: true);
  });

  test('drafts persist, dedup and leave the pending list when resolved', () async {
    final service = DraftService(DriftDraftRepository(db));
    final d = Draft(
      id: Ids.next(),
      source: DraftSource.sms,
      isExpense: true,
      amount: const Money(120000, Currency.irr),
      createdAt: DateTime(2026, 10, 23),
      rawText: 'raw',
      dedupKey: 'melli|1234|120000',
    );
    expect(await service.enqueue(d), isTrue);
    expect(await service.enqueue(d), isFalse);
    expect((await service.watchPending().first).single.rawText, 'raw');
    await service.discard(d.id);
    expect(await service.watchPending().first, isEmpty);
  });

  test('encrypted backup round-trips into a fresh database; wrong password and tampering fail', () async {
    final ledger = LedgerService(DriftAccountRepository(db), DriftTransactionRepository(db));
    final wallet = await ledger.createAccount(
      name: 'Wallet',
      type: AccountType.asset,
      currency: Currency.irr,
      openingBalance: const Money(5000000, Currency.irr),
    );
    final food = await ledger.ensureCategory('Food', AccountType.expense, Currency.irr);
    await ledger.recordExpense(from: wallet, category: food, amount: const Money(1000, Currency.irr), note: 'نان');

    final file = await BackupCodec.encrypt(await LedgerSnapshot(db).export(), 'pass word', kdf: _fastKdf);
    expect(String.fromCharCodes(file.take(11)), 'KAKA-BACKUP');
    expect(String.fromCharCodes(file).contains('Wallet'), isFalse, reason: 'payload must be encrypted');

    await expectLater(
      BackupCodec.decrypt(file, 'nope'),
      throwsA(isA<BackupException>().having((e) => e.code, 'code', 'backup.wrong_password')),
    );
    final tampered = Uint8List.fromList(file)..[file.length - 20] ^= 1;
    await expectLater(BackupCodec.decrypt(tampered, 'pass word'), throwsA(isA<BackupException>()));

    final other = KakaDatabase.open(File('${dir.path}/b.db'), key: 'k2');
    addTearDown(other.close);
    await LedgerService(
      DriftAccountRepository(other),
      DriftTransactionRepository(other),
    ).createAccount(name: 'Old', type: AccountType.asset, currency: Currency.usd);
    await LedgerSnapshot(other).restore(await BackupCodec.decrypt(file, 'pass word'));

    final restored = LedgerService(DriftAccountRepository(other), DriftTransactionRepository(other));
    final balances = await restored.watchBalances().first;
    expect(balances.map((b) => b.account.name), isNot(contains('Old')));
    expect(balances.firstWhere((b) => b.account.name == 'Wallet').balance.minor, 4999000);
    final txns = await DriftTransactionRepository(other).watchRecent().first;
    expect(txns.map((t) => t.note), contains('نان'));
  });

  test('not a backup', () async {
    await expectLater(
      BackupCodec.decrypt(Uint8List.fromList([1, 2, 3]), 'x'),
      throwsA(isA<BackupException>().having((e) => e.code, 'code', 'backup.not_kaka')),
    );
  });
}
