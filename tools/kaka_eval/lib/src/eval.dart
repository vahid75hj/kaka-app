import 'dart:convert';

import 'package:kaka_ai/kaka_ai.dart';
import 'package:kaka_domain/kaka_domain.dart';

import 'fixture.dart';

/// One prompt and what a good model does with it.
class EvalCase {
  const EvalCase({required this.id, required this.prompt, this.tool, this.args = const {}, this.forbid = const []});

  final String id;
  final String prompt;

  /// Tool that must be called (any step); null = no particular tool.
  final String? tool;

  /// Subset of arguments that must match. `account` / `to_account` are account
  /// names (resolved to ids); `amount` compares numerically; `category` and
  /// `note` match if either contains the other.
  final Map<String, Object?> args;

  /// Tools that must not be called (e.g. add_transaction for a question).
  final List<String> forbid;

  factory EvalCase.fromJson(Map<String, Object?> j) => EvalCase(
    id: j['id']! as String,
    prompt: j['prompt']! as String,
    tool: j['tool'] as String?,
    args: (j['args'] as Map?)?.cast<String, Object?>() ?? const {},
    forbid: (j['forbid'] as List?)?.cast<String>() ?? const [],
  );

  static List<EvalCase> parseList(String json) => [
    for (final c in (jsonDecode(json) as Map)['cases'] as List) EvalCase.fromJson((c as Map).cast()),
  ];
}

class RecordedCall {
  const RecordedCall(this.name, this.arguments);
  final String name;
  final Map<String, Object?> arguments;

  Map<String, Object?> toJson() => {'name': name, 'arguments': arguments};
}

class CaseResult {
  const CaseResult(this.evalCase, this.calls, this.passed, this.reason, {this.answer = '', this.millis = 0});
  final EvalCase evalCase;
  final List<RecordedCall> calls;
  final bool passed;
  final String reason;
  final String answer;
  final int millis;

  Map<String, Object?> toJson() => {
    'id': evalCase.id,
    'passed': passed,
    'reason': reason,
    'ms': millis,
    'calls': [for (final c in calls) c.toJson()],
    'answer': answer,
  };
}

abstract final class EvalScorer {
  static (bool, String) score(EvalCase c, List<RecordedCall> calls, Map<String, String> accountIds) {
    for (final f in c.forbid) {
      if (calls.any((x) => x.name == f)) return (false, 'called forbidden $f');
    }
    final tool = c.tool;
    if (tool == null) return (true, 'ok');
    final candidates = calls.where((x) => x.name == tool).toList();
    if (candidates.isEmpty) return (false, 'no $tool call (got ${calls.map((x) => x.name).join(', ')})');
    String? last;
    for (final call in candidates) {
      final miss = _mismatch(c.args, call.arguments, accountIds);
      if (miss == null) return (true, 'ok');
      last = miss;
    }
    return (false, last!);
  }

  static String? _mismatch(Map<String, Object?> want, Map<String, Object?> got, Map<String, String> ids) {
    for (final e in want.entries) {
      switch (e.key) {
        case 'account' || 'to_account':
          final key = e.key == 'account' ? 'account_id' : 'to_account_id';
          if (got[key] != ids[e.value]) return '$key ${got[key]} ≠ ${e.value}';
        case 'amount':
          final a = _number(got['amount']), b = _number(e.value);
          if (a == null || b == null || (a - b).abs() > 1e-9) return 'amount ${got['amount']} ≠ ${e.value}';
        case 'category' || 'note' || 'query':
          final g = Digits.normalize('${got[e.key] ?? ''}').trim(), w = '${e.value}'.trim();
          if (g.isEmpty || !(g.contains(w) || w.contains(g))) return '${e.key} "$g" ≠ "$w"';
        default:
          if ('${got[e.key]}' != '${e.value}') return '${e.key} ${got[e.key]} ≠ ${e.value}';
      }
    }
    return null;
  }

  static double? _number(Object? v) => v is num
      ? v.toDouble()
      : double.tryParse(Digits.normalize('${v ?? ''}').replaceAll(RegExp(r'[,٬\s]'), '').replaceAll('٫', '.'));
}

/// Runs every case against [provider] on a fresh fixture each time.
class EvalRunner {
  EvalRunner(this.provider, {this.maxRounds = 4});
  final AiProvider provider;
  final int maxRounds;

  Future<CaseResult> run(EvalCase c) async {
    final fixture = await EvalFixture.create();
    final calls = <RecordedCall>[];
    final watch = Stopwatch()..start();
    try {
      final loop = ToolLoop(provider, (name, args) {
        calls.add(RecordedCall(name, args));
        return fixture.runner(name, args);
      }, maxRounds: maxRounds);
      final answer = await loop.ask([
        ChatMessage(Role.system, KakaPrompt.system(persian: true, today: evalToday)),
        ChatMessage(Role.user, c.prompt),
      ]);
      final (ok, why) = EvalScorer.score(c, calls, fixture.accountIds);
      return CaseResult(c, calls, ok, why, answer: answer, millis: watch.elapsedMilliseconds);
    } catch (e) {
      return CaseResult(c, calls, false, 'error: $e', millis: watch.elapsedMilliseconds);
    } finally {
      await fixture.close();
    }
  }
}
