import 'package:kaka_tools/kaka_tools.dart';

enum Role { system, user, assistant, tool }

class ToolCall {
  const ToolCall({required this.id, required this.name, required this.arguments});
  final String id;
  final String name;
  final Map<String, Object?> arguments;
}

class ChatMessage {
  const ChatMessage(this.role, this.content, {this.toolCalls = const [], this.toolCallId});

  final Role role;
  final String content;
  final List<ToolCall> toolCalls;
  final String? toolCallId;
}

class AiCapabilities {
  const AiCapabilities({required this.toolCalling, required this.local});
  final bool toolCalling;

  /// Runs on this device or LAN; data never leaves the user's hardware.
  final bool local;
}

/// One assistant turn: text and/or tool calls.
class AiReply {
  const AiReply({this.text = '', this.toolCalls = const []});
  final String text;
  final List<ToolCall> toolCalls;
}

/// Every AI backend Kaka can use implements this.
abstract interface class AiProvider {
  String get id;
  AiCapabilities get capabilities;
  Future<AiReply> complete(List<ChatMessage> messages, {List<ToolSpec> tools = const []});
}

/// The "no AI" choice: the app works fully without it, the chat tab is hidden.
class NoAiProvider implements AiProvider {
  const NoAiProvider();
  @override
  String get id => 'none';
  @override
  AiCapabilities get capabilities => const AiCapabilities(toolCalling: false, local: true);
  @override
  Future<AiReply> complete(List<ChatMessage> messages, {List<ToolSpec> tools = const []}) =>
      throw UnsupportedError('AI is turned off');
}

/// Contract for on-device runtimes (LiteRT-LM via flutter_gemma, llama.cpp…).
/// Adapters live in the app because they need platform plugins; MVP-2.
abstract interface class LocalModelRuntime {
  String get id;
  bool supports(ModelManifest manifest);
}

/// Minimal manifest view needed by runtimes; full parsing in [ModelCatalog].
abstract interface class ModelManifest {
  String get id;
  String get runtime;
  String get format;
}
