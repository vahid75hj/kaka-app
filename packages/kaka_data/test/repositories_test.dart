import 'dart:io';

import 'package:kaka_data/kaka_data.dart';
import 'package:kaka_domain/kaka_domain.dart';
import 'package:test/test.dart';

void main() {
  late KakaDatabase db;
  late LedgerService ledger;
  late DriftTransactionRepository txns;

  late Directory dir;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('kaka_test');
    db = KakaDatabase.open(File('${dir.path}/ledger.db'), key: 's3cret');
    txns = DriftTransactionRepository(db);
    ledger = LedgerService(DriftAccountRepository(db), txns);
  });
  tearDown(() async {
    await db.close();
    dir.deleteSync(recursive: true);
  });

  test('runs on the encrypted SQLite build', () async {
    final rows = await db.customSelect('PRAGMA cipher').get();
    expect(rows, isNotEmpty);
  });

  test('stores balanced transactions and computes balances; voiding reverts them', () async {
    final bank = await ledger.createAccount(
      name: 'Bank',
      type: AccountType.asset,
      currency: Currency.usd,
      openingBalance: const Money(10000, Currency.usd),
    );
    final food = await ledger.createAccount(name: 'Food', type: AccountType.expense, currency: Currency.usd);
    await ledger.recordExpense(from: bank, category: food, amount: const Money(2550, Currency.usd), note: 'lunch');

    Future<int> balanceOf(Account a) async =>
        (await ledger.watchBalances().first).firstWhere((b) => b.account.id == a.id).balance.minor;

    expect(await balanceOf(bank), 7450);
    final recent = await txns.watchRecent().first;
    expect(recent, hasLength(2));
    final lunch = recent.firstWhere((t) => t.note == 'lunch');
    expect(lunch.postings.fold<int>(0, (s, p) => s + p.amount.minor), 0);

    await ledger.voidTransaction(lunch);
    expect(await balanceOf(bank), 10000);
  });

  test('the file cannot be read with a wrong key', () async {
    await DriftSettingsStore(db).save(AppSettings.defaultsFor('en'));
    await db.close();
    final wrong = KakaDatabase.open(File('${dir.path}/ledger.db'), key: 'nope');
    await expectLater(DriftSettingsStore(wrong).load(), throwsA(anything));
    await wrong.close();
    db = KakaDatabase.open(File('${dir.path}/ledger.db'), key: 's3cret');
    expect(await DriftSettingsStore(db).load(), isNotNull);
  });

  test('settings round-trip', () async {
    final store = DriftSettingsStore(db);
    expect(await store.load(), isNull);
    final s = AppSettings.defaultsFor('fa').copyWith(accent: Accent.lime, onboarded: true);
    await store.save(s);
    final loaded = (await store.load())!;
    expect(loaded.baseUnit, DisplayUnit.irt);
    expect(loaded.accent, Accent.lime);
    expect(loaded.onboarded, isTrue);
  });
}
