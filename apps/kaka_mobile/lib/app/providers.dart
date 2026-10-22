import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaka_data/kaka_data.dart';
import 'package:kaka_domain/kaka_domain.dart';

import '../core/app_format.dart';

/// Overridden in `main()` once the encrypted database is open.
final databaseProvider = Provider<KakaDatabase>((ref) => throw UnimplementedError('databaseProvider'));

/// Settings loaded at startup (device-language defaults on first run); overridden in `main()`.
final initialSettingsProvider = Provider<AppSettings>((ref) => throw UnimplementedError('initialSettingsProvider'));

final accountRepositoryProvider = Provider<AccountRepository>(
  (ref) => DriftAccountRepository(ref.watch(databaseProvider)),
);
final transactionRepositoryProvider = Provider<TransactionRepository>(
  (ref) => DriftTransactionRepository(ref.watch(databaseProvider)),
);
final ledgerProvider = Provider<LedgerService>(
  (ref) => LedgerService(ref.watch(accountRepositoryProvider), ref.watch(transactionRepositoryProvider)),
);

class SettingsController extends Notifier<AppSettings> {
  late final DriftSettingsStore _store = DriftSettingsStore(ref.read(databaseProvider));

  @override
  AppSettings build() => ref.read(initialSettingsProvider);

  Future<void> update(AppSettings Function(AppSettings) change) async {
    state = change(state);
    await _store.save(state);
  }
}

final settingsProvider = NotifierProvider<SettingsController, AppSettings>(SettingsController.new);
final formatProvider = Provider<AppFormat>((ref) => AppFormat(ref.watch(settingsProvider)));

final accountsProvider = StreamProvider<List<Account>>((ref) => ref.watch(accountRepositoryProvider).watchAll());
final balancesProvider = StreamProvider<List<AccountBalance>>((ref) => ref.watch(ledgerProvider).watchBalances());
final transactionsProvider = StreamProvider<List<LedgerTransaction>>(
  (ref) => ref.watch(transactionRepositoryProvider).watchRecent(),
);
