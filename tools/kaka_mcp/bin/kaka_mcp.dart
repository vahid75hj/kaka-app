import 'dart:convert';
import 'dart:io';

import 'package:kaka_data/kaka_data.dart';
import 'package:kaka_mcp/kaka_mcp.dart';

const _usage = '''
kaka-mcp: read-only MCP server (stdio) over an encrypted Kaka backup.

Usage: kaka-mcp <backup.kaka>

The backup password is read from the KAKA_BACKUP_PASSWORD environment variable or
from the file named by KAKA_BACKUP_PASSWORD_FILE. It is never accepted as an argument
(arguments show up in process lists).

Claude Desktop / Cursor config:
  "kaka": {
    "command": "dart",
    "args": ["run", "/path/to/kaka-app/tools/kaka_mcp/bin/kaka_mcp.dart", "/path/to/kaka-20261028.kaka"],
    "env": {"KAKA_BACKUP_PASSWORD_FILE": "/path/to/password.txt"}
  }
''';

Future<void> main(List<String> args) async {
  if (args.length != 1 || args.first == '-h' || args.first == '--help') {
    stderr.write(_usage);
    exitCode = args.isEmpty ? 64 : 0;
    return;
  }
  final env = Platform.environment;
  var password = env['KAKA_BACKUP_PASSWORD'];
  final passwordFile = env['KAKA_BACKUP_PASSWORD_FILE'];
  if ((password == null || password.isEmpty) && passwordFile != null) {
    password = File(passwordFile).readAsStringSync().trim();
  }
  if (password == null || password.isEmpty) {
    stderr.writeln('kaka-mcp: set KAKA_BACKUP_PASSWORD or KAKA_BACKUP_PASSWORD_FILE');
    exitCode = 64;
    return;
  }
  final BackupLedger ledger;
  try {
    ledger = await BackupLedger.open(File(args.first).readAsBytesSync(), password);
  } on BackupException catch (e) {
    stderr.writeln('kaka-mcp: cannot open backup (${e.code})');
    exitCode = 65;
    return;
  } on FileSystemException catch (e) {
    stderr.writeln('kaka-mcp: ${e.message}: ${args.first}');
    exitCode = 66;
    return;
  }
  stderr.writeln('kaka-mcp: serving ${args.first} (read-only)');
  await McpServer(
    ledger,
  ).serve(stdin.transform(utf8.decoder).transform(const LineSplitter()), stdout.writeln, log: stderr.writeln);
  await ledger.close();
}
