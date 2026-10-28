import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/l10n_x.dart';
import '../../theme/kaka_colors.dart';
import 'ai_config.dart';

class AiSettingsScreen extends ConsumerStatefulWidget {
  const AiSettingsScreen({super.key});

  @override
  ConsumerState<AiSettingsScreen> createState() => _AiSettingsScreenState();
}

class _AiSettingsScreenState extends ConsumerState<AiSettingsScreen> {
  late final _s = ref.read(settingsProvider);
  late String _provider = _s.aiProvider;
  late final _url = TextEditingController(text: _s.aiBaseUrl);
  late final _model = TextEditingController(text: _s.aiModel);
  final _key = TextEditingController();
  var _hasKey = false;

  @override
  void initState() {
    super.initState();
    ref.read(aiKeyStoreProvider).read().then((k) {
      if (mounted) setState(() => _hasKey = k != null && k.isNotEmpty);
    });
  }

  @override
  void dispose() {
    _url.dispose();
    _model.dispose();
    _key.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_key.text.isNotEmpty) await ref.read(aiKeyStoreProvider).write(_key.text.trim());
    await ref
        .read(settingsProvider.notifier)
        .update((s) => s.copyWith(aiProvider: _provider, aiBaseUrl: _url.text.trim(), aiModel: _model.text.trim()));
    ref.invalidate(aiProviderProvider);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = KakaColors.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.aiSettings)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(l.aiHint, style: TextStyle(color: c.textMuted, height: 1.6)),
          const SizedBox(height: 16),
          SegmentedButton<String>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(value: 'none', label: Text(l.aiNone)),
              const ButtonSegment(value: 'openai', label: Text('OpenAI API')),
              const ButtonSegment(value: 'ollama', label: Text('Ollama')),
            ],
            selected: {_provider},
            onSelectionChanged: (v) => setState(() => _provider = v.first),
          ),
          if (_provider != 'none') ...[
            const SizedBox(height: 16),
            TextField(
              controller: _url,
              keyboardType: TextInputType.url,
              textDirection: TextDirection.ltr,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: l.aiBaseUrl,
                hintText: _provider == 'ollama' ? 'http://192.168.1.10:11434' : 'https://api.openai.com/v1',
                errorText: isInsecureEndpoint(_url.text) ? l.aiInsecureUrl : null,
                errorMaxLines: 3,
              ),
            ),
            TextField(
              controller: _model,
              textDirection: TextDirection.ltr,
              decoration: InputDecoration(
                labelText: l.aiModel,
                hintText: _provider == 'ollama' ? 'qwen2.5:7b' : 'gpt-4o-mini',
              ),
            ),
            if (_provider == 'openai')
              TextField(
                controller: _key,
                obscureText: true,
                textDirection: TextDirection.ltr,
                decoration: InputDecoration(labelText: l.aiKey, helperText: _hasKey ? l.aiKeySaved : l.aiKeyHint),
              ),
            if (_provider == 'openai' && _hasKey)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton(
                  onPressed: () async {
                    await ref.read(aiKeyStoreProvider).write(null);
                    setState(() => _hasKey = false);
                  },
                  child: Text(l.aiKeyRemove),
                ),
              ),
            const SizedBox(height: 8),
            Text(l.aiPrivacy, style: TextStyle(color: c.textFaint, fontSize: 12, height: 1.6)),
          ],
          const SizedBox(height: 24),
          FilledButton(onPressed: _save, child: Text(l.save)),
        ],
      ),
    );
  }
}
