import 'dart:convert';
import 'dart:io';

import 'package:kaka_ai/kaka_ai.dart';
import 'package:kaka_eval/kaka_eval.dart';

const _usage = '''
kaka-eval: Persian tool-calling eval for Kaka.

  dart run kaka_eval --base-url http://localhost:11434/v1 --model qwen2.5:3b [--cases data/fa_v1.json] [--only id,id] [--out report.json]

The API key, if any, is read from KAKA_EVAL_API_KEY (never a flag, so it stays out of shell history).
''';

Future<void> main(List<String> argv) async {
  final args = <String, String>{};
  for (var i = 0; i + 1 < argv.length; i += 2) {
    if (!argv[i].startsWith('--')) break;
    args[argv[i].substring(2)] = argv[i + 1];
  }
  if (argv.contains('--help') || args['model'] == null) {
    stdout.write(_usage);
    exit(args['model'] == null && !argv.contains('--help') ? 64 : 0);
  }
  final baseUrl = args['base-url'] ?? 'http://localhost:11434/v1';
  final key = Platform.environment['KAKA_EVAL_API_KEY'];
  final provider = OpenAiCompatProvider(baseUrl: baseUrl, model: args['model']!, apiKey: key);
  var cases = EvalCase.parseList(File(args['cases'] ?? 'data/fa_v1.json').readAsStringSync());
  final only = args['only']?.split(',').toSet();
  if (only != null) cases = cases.where((c) => only.contains(c.id)).toList();

  final runner = EvalRunner(provider);
  final results = <CaseResult>[];
  for (final c in cases) {
    final r = await runner.run(c);
    results.add(r);
    stdout.writeln(
      '${r.passed ? 'PASS' : 'FAIL'}  ${c.id.padRight(28)} ${r.millis.toString().padLeft(6)} ms  ${r.passed ? '' : r.reason}',
    );
  }
  final passed = results.where((r) => r.passed).length;
  stdout.writeln('\n${args['model']}: $passed / ${results.length} passed');
  final out = args['out'];
  if (out != null) {
    File(out).writeAsStringSync(
      const JsonEncoder.withIndent('  ').convert({
        'model': args['model'],
        'base_url': baseUrl,
        'passed': passed,
        'total': results.length,
        'results': [for (final r in results) r.toJson()],
      }),
    );
  }
  exit(passed == results.length ? 0 : 1);
}
