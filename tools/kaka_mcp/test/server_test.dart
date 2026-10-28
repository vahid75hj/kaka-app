import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:kaka_data/kaka_data.dart';
import 'package:kaka_domain/kaka_domain.dart';
import 'package:kaka_mcp/kaka_mcp.dart';
import 'package:test/test.dart';

Future<Uint8List> _backup() async {
  final db = KakaDatabase.inMemory();
  final accounts = DriftAccountRepository(db);
  final ledger = LedgerService(accounts, DriftTransactionRepository(db));
  final bank = await ledger.createAccount(
    name: 'ملت 6104337912345678',
    type: AccountType.asset,
    currency: Currency.irr,
    openingBalance: const Money(5000000, Currency.irr),
  );
  final food = await ledger.ensureCategory('غذا', AccountType.expense, Currency.irr);
  await ledger.recordExpense(
    from: bank,
    category: food,
    amount: const Money(1200000, Currency.irr),
    at: DateTime(2026, 10, 5),
  );
  final snap = await LedgerSnapshot(db).export();
  await db.close();
  return BackupCodec.encrypt(snap, 'correct horse', kdf: const KdfParams(memoryKiB: 1024, iterations: 1));
}

Map<String, Object?> _json(String? s) => (jsonDecode(s!) as Map).cast<String, Object?>();

void main() {
  late Uint8List file;
  setUpAll(() async => file = await _backup());

  test('initialize, list read tools only, call get_balance with masking', () async {
    final ledger = await BackupLedger.open(file, 'correct horse');
    addTearDown(ledger.close);
    final server = McpServer(ledger);

    final init = _json(
      await server.handle('{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18"}}'),
    );
    expect((init['result'] as Map)['protocolVersion'], '2025-06-18');
    expect(await server.handle('{"jsonrpc":"2.0","method":"notifications/initialized"}'), isNull);

    final list = _json(await server.handle('{"jsonrpc":"2.0","id":2,"method":"tools/list"}'));
    final names = [for (final t in (list['result'] as Map)['tools'] as List) (t as Map)['name']];
    expect(names, containsAll(['list_accounts', 'get_balance', 'summarize_spending']));
    expect(names, isNot(contains('add_transaction')));

    final call = _json(
      await server.handle(
        '{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"get_balance","arguments":{}}}',
      ),
    );
    final text = (((call['result'] as Map)['content'] as List).single as Map)['text'] as String;
    expect(text, contains('"amount_minor":3800000'));
    expect(text, isNot(contains('6104337912345678')), reason: 'card numbers are masked');
    expect(text, contains('5678'));

    final spend = _json(
      await server.handle(
        '{"jsonrpc":"2.0","id":4,"method":"tools/call","params":{"name":"summarize_spending",'
        '"arguments":{"from":"2026-10-01","to":"2026-10-31"}}}',
      ),
    );
    expect(jsonEncode(spend), contains('1200000'));

    final write = _json(
      await server.handle(
        '{"jsonrpc":"2.0","id":5,"method":"tools/call","params":{"name":"add_transaction","arguments":{}}}',
      ),
    );
    expect((write['error'] as Map)['code'], -32602);
    expect((_json(await server.handle('not json'))['error'] as Map)['code'], -32700);
    expect((_json(await server.handle('{"jsonrpc":"2.0","id":6,"method":"nope"}'))['error'] as Map)['code'], -32601);
  });

  test('wrong password is rejected', () async {
    expect(
      () => BackupLedger.open(file, 'wrong password'),
      throwsA(isA<BackupException>().having((e) => e.code, 'code', 'backup.wrong_password')),
    );
  });

  test('binary speaks MCP over stdio; password comes from env, not args', () async {
    final dir = Directory.systemTemp.createTempSync('kaka_mcp');
    addTearDown(() => dir.deleteSync(recursive: true));
    final path = '${dir.path}/b.kaka';
    File(path).writeAsBytesSync(file);
    final p = await Process.start(
      Platform.resolvedExecutable,
      ['run', 'bin/kaka_mcp.dart', path],
      environment: {'KAKA_BACKUP_PASSWORD': 'correct horse'},
    );
    p.stdin.writeln('{"jsonrpc":"2.0","id":1,"method":"initialize","params":{}}');
    p.stdin.writeln('{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"list_accounts","arguments":{}}}');
    await p.stdin.close();
    final out = await p.stdout.transform(utf8.decoder).transform(const LineSplitter()).toList();
    expect(await p.exitCode, 0);
    expect(out, hasLength(2));
    expect(_json(out[1])['id'], 2);
    expect(out[1], contains('••••5678'));
  }, timeout: const Timeout(Duration(minutes: 3)));
}
