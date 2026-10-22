import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:kaka_ai/kaka_ai.dart';
import 'package:test/test.dart';

void main() {
  test('tool loop calls a Kaka tool and returns the final answer', () async {
    final requests = <Map<String, Object?>>[];
    final client = MockClient((req) async {
      final body = jsonDecode(req.body) as Map<String, Object?>;
      requests.add(body);
      final first = requests.length == 1;
      final message = first
          ? {
              'role': 'assistant',
              'content': null,
              'tool_calls': [
                {
                  'id': 'c1',
                  'type': 'function',
                  'function': {'name': 'get_balance', 'arguments': '{}'},
                },
              ],
            }
          : {'role': 'assistant', 'content': 'You have 80.01 USD.'};
      return http.Response(
        jsonEncode({
          'choices': [
            {'message': message},
          ],
        }),
        200,
        headers: {'content-type': 'application/json'},
      );
    });

    final provider = OpenAiCompatProvider.ollama(model: 'gemma3', client: client);
    final calls = <String>[];
    final loop = ToolLoop(provider, (name, args) async {
      calls.add(name);
      return {'balances': []};
    });

    final answer = await loop.ask([const ChatMessage(Role.user, 'How much money do I have?')]);
    expect(answer, 'You have 80.01 USD.');
    expect(calls, ['get_balance']);
    expect((requests.first['tools'] as List), isNotEmpty);
    final second = requests[1]['messages'] as List;
    expect((second.last as Map)['role'], 'tool');
    expect((second.last as Map)['tool_call_id'], 'c1');
  });

  test('catalog merge prefers newer versions', () {
    const a =
        '{"schema_version":1,"catalog_version":"a","models":[{"id":"m","version":1,"name":{"en":"M","fa":"M"},"runtime":"litert_lm","format":"litertlm"}]}';
    const b =
        '{"schema_version":1,"catalog_version":"b","models":[{"id":"m","version":2,"name":{"en":"M2","fa":"M2"},"runtime":"litert_lm","format":"litertlm"}]}';
    final merged = ModelCatalog.parse(a).merge(ModelCatalog.parse(b));
    expect(merged.models.single.nameEn, 'M2');
  });
}
