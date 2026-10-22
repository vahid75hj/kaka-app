import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kaka_tools/kaka_tools.dart';

import 'ai_provider.dart';

/// Any `/v1/chat/completions` server: Gemini's OpenAI endpoint, OpenRouter,
/// DeepSeek, Groq, or a local Ollama / LM Studio / llama-server.
class OpenAiCompatProvider implements AiProvider {
  OpenAiCompatProvider({
    required this.baseUrl,
    required this.model,
    this.apiKey,
    this.local = false,
    http.Client? client,
  }) : _http = client ?? http.Client();

  /// Ollama on this machine or the LAN; no key needed.
  factory OpenAiCompatProvider.ollama({
    required String model,
    String host = 'http://localhost:11434',
    http.Client? client,
  }) => OpenAiCompatProvider(baseUrl: '$host/v1', model: model, local: true, client: client);

  final String baseUrl;
  final String model;
  final String? apiKey;
  final bool local;
  final http.Client _http;

  @override
  String get id => local ? 'ollama' : 'openai_compat';

  @override
  AiCapabilities get capabilities => AiCapabilities(toolCalling: true, local: local);

  @override
  Future<AiReply> complete(List<ChatMessage> messages, {List<ToolSpec> tools = const []}) async {
    final res = await _http.post(
      Uri.parse('$baseUrl/chat/completions'),
      headers: {'content-type': 'application/json', if (apiKey != null) 'authorization': 'Bearer $apiKey'},
      body: jsonEncode({
        'model': model,
        'messages': [for (final m in messages) _encode(m)],
        if (tools.isNotEmpty) 'tools': [for (final t in tools) t.toOpenAi()],
      }),
    );
    if (res.statusCode != 200) {
      throw http.ClientException('AI provider returned ${res.statusCode}: ${res.body}', res.request?.url);
    }
    final msg = ((jsonDecode(utf8.decode(res.bodyBytes)) as Map)['choices'] as List).first['message'] as Map;
    return AiReply(
      text: (msg['content'] as String?) ?? '',
      toolCalls: [
        for (final c in (msg['tool_calls'] as List? ?? const []))
          ToolCall(
            id: c['id'] as String,
            name: c['function']['name'] as String,
            arguments: _args(c['function']['arguments']),
          ),
      ],
    );
  }

  static Map<String, Object?> _args(Object? raw) => switch (raw) {
    final String s when s.trim().isNotEmpty => (jsonDecode(s) as Map).cast<String, Object?>(),
    final Map m => m.cast<String, Object?>(),
    _ => const {},
  };

  static Map<String, Object?> _encode(ChatMessage m) => {
    'role': m.role.name,
    'content': m.content,
    if (m.toolCalls.isNotEmpty)
      'tool_calls': [
        for (final c in m.toolCalls)
          {
            'id': c.id,
            'type': 'function',
            'function': {'name': c.name, 'arguments': jsonEncode(c.arguments)},
          },
      ],
    'tool_call_id': ?m.toolCallId,
  };
}
