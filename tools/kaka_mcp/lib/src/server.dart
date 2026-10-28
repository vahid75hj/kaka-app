import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:kaka_data/kaka_data.dart';
import 'package:kaka_domain/kaka_domain.dart';
import 'package:kaka_tools/kaka_tools.dart';

/// Server name/version reported to MCP clients.
const serverInfo = {'name': 'kaka-mcp', 'version': '0.1.0'};

/// The protocol revisions this server speaks; it answers with the client's if known.
const supportedProtocols = ['2025-06-18', '2025-03-26', '2024-11-05'];

/// A decrypted backup loaded into a RAM-only database. Nothing is written back.
class BackupLedger {
  BackupLedger._(this.db, this.runner, this.exportedAt);
  final KakaDatabase db;
  final ToolRunner runner;
  final String? exportedAt;

  static Future<BackupLedger> open(Uint8List file, String password) async {
    final snapshot = await BackupCodec.decrypt(file, password);
    final db = KakaDatabase.inMemory();
    await LedgerSnapshot(db).restore(snapshot);
    final accounts = DriftAccountRepository(db);
    final txns = DriftTransactionRepository(db);
    final runner = ToolRunner(
      accounts: accounts,
      transactions: txns,
      ledger: LedgerService(accounts, txns),
      budgets: DriftBudgetRepository(db),
      // Read-only: a backup is a snapshot, so suggestions have nowhere to go.
      onDraft: (_) async => throw const DomainException('read_only'),
    );
    return BackupLedger._(db, runner, snapshot['exported_at'] as String?);
  }

  Future<void> close() => db.close();
}

/// JSON-RPC 2.0 over newline-delimited stdio, as MCP's stdio transport specifies.
class McpServer {
  McpServer(this.ledger);
  final BackupLedger ledger;

  /// Read tools only; `add_transaction` is not offered.
  static List<ToolSpec> get tools => [
    for (final t in kakaTools)
      if (t.access == ToolAccess.read) t,
  ];

  /// Handles one message; returns the response line, or `null` for notifications.
  Future<String?> handle(String line) async {
    Object? id;
    try {
      final msg = jsonDecode(line);
      if (msg is! Map) return _err(null, -32600, 'Invalid Request');
      id = msg['id'];
      final method = msg['method'];
      final params = (msg['params'] as Map?)?.cast<String, Object?>() ?? const {};
      if (method is! String) return _err(id, -32600, 'Invalid Request');
      if (!msg.containsKey('id')) return null; // notification (e.g. notifications/initialized)
      switch (method) {
        case 'initialize':
          final asked = params['protocolVersion'] as String?;
          return _ok(id, {
            'protocolVersion': supportedProtocols.contains(asked) ? asked : supportedProtocols.first,
            'capabilities': {'tools': <String, Object?>{}},
            'serverInfo': serverInfo,
            'instructions':
                'Read-only view of a Kaka backup${ledger.exportedAt == null ? '' : ' exported ${ledger.exportedAt}'}. '
                'Amounts are integers in minor units (value = amount_minor / 10^scale). '
                'Card and account numbers are masked.',
          });
        case 'ping':
          return _ok(id, const <String, Object?>{});
        case 'tools/list':
          return _ok(id, {
            'tools': [for (final t in tools) t.toMcp()],
          });
        case 'tools/call':
          final name = params['name'] as String?;
          if (name == null || !tools.any((t) => t.name == name)) {
            return _err(id, -32602, 'Unknown tool: $name');
          }
          final args = (params['arguments'] as Map?)?.cast<String, Object?>() ?? const {};
          final result = Masking.json(await ledger.runner(name, args));
          final isError = result is Map && result.containsKey('error');
          return _ok(id, {
            'content': [
              {'type': 'text', 'text': jsonEncode(result)},
            ],
            'structuredContent': result,
            'isError': isError,
          });
        default:
          return _err(id, -32601, 'Method not found: $method');
      }
    } on FormatException {
      return _err(id, -32700, 'Parse error');
    } catch (e) {
      return _err(id, -32603, 'Internal error');
    }
  }

  /// Serves until [input] closes. Logs go to [log] (stderr), never stdout.
  Future<void> serve(Stream<String> input, void Function(String) output, {void Function(String)? log}) async {
    await for (final line in input) {
      if (line.trim().isEmpty) continue;
      final reply = await handle(line);
      if (reply != null) output(reply);
    }
    log?.call('kaka-mcp: input closed');
  }

  static String _ok(Object? id, Object result) => jsonEncode({'jsonrpc': '2.0', 'id': id, 'result': result});
  static String _err(Object? id, int code, String message) => jsonEncode({
    'jsonrpc': '2.0',
    'id': id,
    'error': {'code': code, 'message': message},
  });
}
