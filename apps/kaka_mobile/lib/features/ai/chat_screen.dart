import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kaka_ai/kaka_ai.dart';
import 'package:kaka_tools/kaka_tools.dart';

import '../../app/providers.dart';
import '../../app/router.dart';
import '../../core/l10n_x.dart';
import '../../theme/kaka_colors.dart';
import 'ai_config.dart';

/// Basic chat over the user's own AI. The model only sees tool results
/// (masked); `add_transaction` produces drafts in the question queue.
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _input = TextEditingController();
  final _history = <ChatMessage>[];
  var _busy = false;

  String get _system => KakaPrompt.system(persian: ref.read(settingsProvider).isPersian, today: DateTime.now());

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty || _busy) return;
    _input.clear();
    setState(() {
      _history.add(ChatMessage(Role.user, Masking.text(text)));
      _busy = true;
    });
    try {
      final provider = await ref.read(aiProviderProvider.future);
      final runner = ref.read(toolRunnerProvider);
      final loop = ToolLoop(provider, (name, args) => maskedTool(runner, name, args));
      final answer = await loop.ask([ChatMessage(Role.system, _system), ..._history]);
      setState(() => _history.add(ChatMessage(Role.assistant, answer.isEmpty ? '…' : answer)));
    } catch (e) {
      if (mounted) setState(() => _history.add(ChatMessage(Role.assistant, '⚠️ ${context.l10n.aiError}')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = KakaColors.of(context);
    final configured = ref.watch(settingsProvider.select((s) => s.aiProvider)) != 'none';
    return Scaffold(
      appBar: AppBar(
        title: Text(l.chat),
        actions: [
          IconButton(
            tooltip: l.aiSettings,
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => context.push(Routes.aiSettings),
          ),
        ],
      ),
      body: !configured
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l.aiNotConfigured,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: c.textMuted),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(onPressed: () => context.push(Routes.aiSettings), child: Text(l.aiSettings)),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      for (final m in _history)
                        Align(
                          alignment: m.role == Role.user
                              ? AlignmentDirectional.centerEnd
                              : AlignmentDirectional.centerStart,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.all(12),
                            constraints: const BoxConstraints(maxWidth: 320),
                            decoration: BoxDecoration(
                              color: m.role == Role.user ? c.accentSoft : c.card,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: c.line),
                            ),
                            child: SelectableText(m.content, style: const TextStyle(height: 1.6)),
                          ),
                        ),
                      if (_busy) const Padding(padding: EdgeInsets.all(12), child: LinearProgressIndicator()),
                    ],
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _input,
                            minLines: 1,
                            maxLines: 4,
                            onSubmitted: (_) => _send(),
                            decoration: InputDecoration(hintText: l.chatHint),
                          ),
                        ),
                        IconButton(
                          tooltip: l.send,
                          onPressed: _busy ? null : _send,
                          icon: const Icon(Icons.send_rounded),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
