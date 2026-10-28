import 'dart:convert';
import 'dart:io';

import 'package:kaka_ai/kaka_ai.dart';
import 'package:kaka_eval/kaka_eval.dart';
import 'package:kaka_tools/kaka_tools.dart';
import 'package:test/test.dart';

/// Plays back fixed tool calls, then answers; looks up account ids from the
/// list_accounts result like a real model has to.
class _Scripted implements AiProvider {
  _Scripted(this.plan);
  final List<(String, Map<String, Object?>)> Function(Map<String, String> ids) plan;
  int _step = 0;
  Map<String, String> _ids = const {};

  @override
  AiCapabilities get capabilities => const AiCapabilities(toolCalling: true, local: true);
  @override
  String get id => 'scripted';

  @override
  Future<AiReply> complete(List<ChatMessage> messages, {List<ToolSpec> tools = const []}) async {
    expect(messages.first.content, contains('1 toman = 10 rial'));
    for (final m in messages.where((m) => m.role == Role.tool)) {
      final j = jsonDecode(m.content) as Map;
      if (j['accounts'] is List) {
        _ids = {for (final a in j['accounts'] as List) (a as Map)['name'] as String: a['id'] as String};
      }
    }
    if (_step == 0) {
      _step++;
      return const AiReply(
        toolCalls: [ToolCall(id: '1', name: 'list_accounts', arguments: {})],
      );
    }
    final steps = plan(_ids);
    if (_step - 1 < steps.length) {
      final (name, args) = steps[_step - 1];
      _step++;
      return AiReply(
        toolCalls: [ToolCall(id: '$_step', name: name, arguments: args)],
      );
    }
    return const AiReply(text: 'ثبت شد؛ توی کاکا تأییدش کن.');
  }
}

void main() {
  final cases = EvalCase.parseList(File('data/fa_v1.json').readAsStringSync());

  test('dataset: unique ids, known tools, every case says what it expects', () {
    final names = kakaTools.map((t) => t.name).toSet();
    expect(cases.map((c) => c.id).toSet(), hasLength(cases.length));
    for (final c in cases) {
      expect(c.tool == null || names.contains(c.tool), isTrue, reason: c.id);
      expect(c.tool != null || c.forbid.isNotEmpty, isTrue, reason: c.id);
    }
    expect(cases.length, greaterThanOrEqualTo(30));
  });

  test('a model doing the right thing passes; drafts reach the fixture, not the ledger', () async {
    final c = cases.firstWhere((c) => c.id == 'add_expense_toman');
    final r = await EvalRunner(
      _Scripted(
        (ids) => [
          ('add_transaction', {'kind': 'expense', 'account_id': ids['کارت ملت'], 'amount': '1,200,000'}),
        ],
      ),
    ).run(c);
    expect((r.passed, r.reason), (true, 'ok'));
    expect(r.calls.map((x) => x.name), ['list_accounts', 'add_transaction']);
    expect(r.answer, contains('تأیید'));
  });

  test('toman passed as rial fails with the reason; forbidden write fails a question', () async {
    final c = cases.firstWhere((c) => c.id == 'add_expense_toman');
    final wrong = await EvalRunner(
      _Scripted(
        (ids) => [
          ('add_transaction', {'kind': 'expense', 'account_id': ids['کارت ملت'], 'amount': '120000'}),
        ],
      ),
    ).run(c);
    expect(wrong.passed, isFalse);
    expect(wrong.reason, contains('amount 120000'));

    final q = cases.firstWhere((c) => c.id == 'read_balance_all');
    final eager = await EvalRunner(
      _Scripted(
        (ids) => [
          ('get_balance', <String, Object?>{}),
          ('add_transaction', {'kind': 'expense', 'account_id': ids['کیف پول'], 'amount': '1'}),
        ],
      ),
    ).run(q);
    expect((eager.passed, eager.reason), (false, 'called forbidden add_transaction'));
  });

  test('budgets and search read from the fixture', () async {
    final fixture = await EvalFixture.create();
    addTearDown(fixture.close);
    final b = await fixture.runner('list_budgets', {});
    final food = (b['budgets'] as List).single as Map;
    expect((food['spent'] as Map)['amount_minor'], 6300000);
    expect(food['over'], isTrue);
    final s = await fixture.runner('list_transactions', {'query': 'اسنپ'});
    expect(s['transactions'], hasLength(1));
  });

  test('scorer: Persian digits, contains-match for category, dates exact', () {
    const c = EvalCase(
      id: 'x',
      prompt: '',
      tool: 'add_transaction',
      args: {'amount': '3000000', 'category': 'قبوض', 'date': '2026-10-22'},
    );
    final ok = EvalScorer.score(c, const [
      RecordedCall('add_transaction', {'amount': '۳٬۰۰۰٬۰۰۰', 'category': 'قبوض خانه', 'date': '2026-10-22'}),
    ], const {});
    expect(ok, (true, 'ok'));
    final bad = EvalScorer.score(c, const [
      RecordedCall('add_transaction', {'amount': 3000000, 'category': 'قبوض', 'date': '2026-10-23'}),
    ], const {});
    expect(bad.$1, isFalse);
  });
}
