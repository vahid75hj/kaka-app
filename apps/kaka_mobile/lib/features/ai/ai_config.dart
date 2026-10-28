import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kaka_ai/kaka_ai.dart';
import 'package:kaka_domain/kaka_domain.dart';
import 'package:kaka_tools/kaka_tools.dart';

import '../../app/providers.dart';

/// The API key never goes into the database or backups: Android Keystore only.
class AiKeyStore {
  static const _key = 'kaka.ai.api_key.v1';
  final _storage = const FlutterSecureStorage();

  Future<String?> read() async {
    try {
      return await _storage.read(key: _key);
    } catch (_) {
      return null;
    }
  }

  Future<void> write(String? value) =>
      value == null || value.isEmpty ? _storage.delete(key: _key) : _storage.write(key: _key, value: value);
}

/// `http://` to a host outside this device / the local network: the API key and
/// (masked) data would cross the internet unencrypted.
bool isInsecureEndpoint(String url) {
  final u = Uri.tryParse(url.trim());
  if (u == null || u.scheme != 'http' || u.host.isEmpty) return false;
  final h = u.host.toLowerCase();
  if (h == 'localhost' || h.endsWith('.local') || h.startsWith('127.') || h == '::1' || h == '[::1]') return false;
  final ip = RegExp(r'^(\d+)\.(\d+)\.\d+\.\d+$').firstMatch(h);
  if (ip != null) {
    final a = int.parse(ip[1]!);
    final b = int.parse(ip[2]!);
    if (a == 10 || (a == 192 && b == 168) || (a == 172 && b >= 16 && b <= 31) || (a == 100 && b >= 64 && b <= 127)) {
      return false;
    }
  }
  return true;
}

final aiKeyStoreProvider = Provider<AiKeyStore>((ref) => AiKeyStore());

/// Builds the provider chosen in settings (`none` → [NoAiProvider]).
final aiProviderProvider = FutureProvider<AiProvider>((ref) async {
  final s = ref.watch(settingsProvider);
  switch (s.aiProvider) {
    case 'openai':
      return OpenAiCompatProvider(
        baseUrl: s.aiBaseUrl.replaceFirst(RegExp(r'/+$'), ''),
        model: s.aiModel,
        apiKey: await ref.read(aiKeyStoreProvider).read(),
      );
    case 'ollama':
      return OpenAiCompatProvider.ollama(
        model: s.aiModel,
        host: s.aiBaseUrl.isEmpty ? 'http://localhost:11434' : s.aiBaseUrl.replaceFirst(RegExp(r'/+$'), ''),
      );
    default:
      return const NoAiProvider();
  }
});

/// Tool runner whose only write (`add_transaction`) lands in the question queue.
final toolRunnerProvider = Provider<ToolRunner>((ref) {
  return ToolRunner(
    accounts: ref.watch(accountRepositoryProvider),
    transactions: ref.watch(transactionRepositoryProvider),
    ledger: ref.watch(ledgerProvider),
    onDraft: (draft) async {
      final a = draft.arguments;
      final account = await ref.read(accountRepositoryProvider).findById(a['account_id']! as String);
      if (account == null) return;
      final amount = AmountParser.parse(a['amount']! as String, DisplayUnit.of(account.currency));
      final kind = a['kind'] as String? ?? 'expense';
      await ref
          .read(draftServiceProvider)
          .enqueue(
            Draft(
              id: Ids.next(),
              source: DraftSource.ai,
              // A transfer leaves [accountId] and lands in [toAccountId].
              isExpense: kind != 'income',
              amount: amount,
              createdAt: DateTime.now(),
              occurredAt: a['date'] == null ? null : DateTime.tryParse(a['date']! as String),
              note: (a['note'] as String? ?? '').trim(),
              category: kind == 'transfer' ? null : (a['category'] as String?)?.trim(),
              accountId: account.id,
              toAccountId: kind == 'transfer' ? a['to_account_id'] as String? : null,
            ),
          );
    },
  );
});

/// Every tool result and user message passes through [Masking] before it reaches a model.
Future<Map<String, Object?>> maskedTool(ToolRunner runner, String name, Map<String, Object?> args) async =>
    Masking.json(await runner.call(name, args))! as Map<String, Object?>;
