import 'dart:convert';

import 'package:kaka_tools/kaka_tools.dart';

import 'ai_provider.dart';

/// Runs the model ↔ tools loop on the device, at most [maxRounds] rounds.
class ToolLoop {
  ToolLoop(this.provider, this.runTool, {this.maxRounds = 5});

  final AiProvider provider;
  final Future<Map<String, Object?>> Function(String name, Map<String, Object?> args) runTool;
  final int maxRounds;

  Future<String> ask(List<ChatMessage> history) async {
    final messages = [...history];
    for (var round = 0; round < maxRounds; round++) {
      final reply = await provider.complete(messages, tools: provider.capabilities.toolCalling ? kakaTools : const []);
      if (reply.toolCalls.isEmpty) return reply.text;
      messages.add(ChatMessage(Role.assistant, reply.text, toolCalls: reply.toolCalls));
      for (final call in reply.toolCalls) {
        final result = await runTool(call.name, call.arguments);
        messages.add(ChatMessage(Role.tool, jsonEncode(result), toolCallId: call.id));
      }
    }
    return '';
  }
}
