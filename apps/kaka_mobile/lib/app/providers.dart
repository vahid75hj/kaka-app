import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaka_data/kaka_data.dart';

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:kaka_domain/kaka_domain.dart';
import 'package:kaka_sms/kaka_sms.dart';

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

  /// Re-reads settings from the database (after a backup restore).
  Future<void> reload() async {
    final loaded = await _store.load();
    if (loaded != null) state = loaded;
  }

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
  (ref) => ref.watch(transactionRepositoryProvider).watchRecent(limit: 5000),
);

final draftServiceProvider = Provider<DraftService>(
  (ref) => DraftService(DriftDraftRepository(ref.watch(databaseProvider))),
);
final pendingDraftsProvider = StreamProvider<List<Draft>>((ref) => ref.watch(draftServiceProvider).watchPending());

/// Bundled bank SMS templates + heuristic fallback. Every result is only a draft.
final customParserStoreProvider = Provider<DriftCustomParserStore>(
  (ref) => DriftCustomParserStore(ref.watch(databaseProvider)),
);

/// Banks the user taught Kaka ("learn a new bank"); they run before bundled templates.
final localBanksProvider = StreamProvider<List<BankParser>>(
  (ref) => ref
      .watch(customParserStoreProvider)
      .watchAll()
      .map((rows) => [for (final (_, json) in rows) BankParser.fromJson(jsonDecode(json) as Map<String, Object?>)]),
);

final smsParserProvider = FutureProvider<SmsParser>((ref) async {
  final json = await rootBundle.loadString('packages/kaka_sms/assets/sms-parsers.v1.json');
  final local = await ref.watch(localBanksProvider.future);
  return SmsParser(ParserCatalog.parse(json).withLocal(local));
});

final smsLinkRepositoryProvider = Provider<SmsLinkRepository>(
  (ref) => DriftSmsLinkRepository(ref.watch(databaseProvider)),
);
final smsLinksProvider = StreamProvider<List<SmsLink>>((ref) => ref.watch(smsLinkRepositoryProvider).watchAll());

final smsIngestServiceProvider = FutureProvider<SmsIngestService>((ref) async {
  final parser = await ref.watch(smsParserProvider.future);
  return SmsIngestService(
    parser: parser,
    links: ref.watch(smsLinkRepositoryProvider),
    drafts: ref.watch(draftServiceProvider),
    bankName: (b) => ref.read(settingsProvider).isPersian ? b.nameFa : b.nameEn,
  );
});

// ---- exchange rates, assets, net worth ----

final exchangeRateRepositoryProvider = Provider<ExchangeRateRepository>(
  (ref) => DriftExchangeRateRepository(ref.watch(databaseProvider)),
);
final exchangeRatesProvider = StreamProvider<List<ExchangeRate>>(
  (ref) => ref.watch(exchangeRateRepositoryProvider).watchAll(),
);
final converterProvider = Provider<CurrencyConverter>(
  (ref) => CurrencyConverter(
    ref.watch(settingsProvider.select((s) => s.baseUnit.currency)),
    ref.watch(exchangeRatesProvider).value ?? const [],
  ),
);

final assetRepositoryProvider = Provider<DriftAssetRepository>((ref) {
  final repo = DriftAssetRepository(ref.watch(databaseProvider));
  repo.ensureBuiltIns().ignore();
  return repo;
});
final assetTypesProvider = StreamProvider<List<AssetType>>((ref) => ref.watch(assetRepositoryProvider).watchTypes());
final assetMovementsProvider = StreamProvider<List<AssetMovement>>(
  (ref) => ref.watch(assetRepositoryProvider).watchMovements(),
);
final assetPricesProvider = StreamProvider<List<AssetPrice>>((ref) => ref.watch(assetRepositoryProvider).watchPrices());
final holdingsProvider = Provider<List<AssetHolding>>(
  (ref) => AssetMath.holdings(
    ref.watch(assetTypesProvider).value ?? const [],
    ref.watch(assetMovementsProvider).value ?? const [],
    ref.watch(assetPricesProvider).value ?? const [],
  ),
);
final netWorthProvider = Provider<NetWorth>(
  (ref) => NetWorth.of(
    ref.watch(balancesProvider).value ?? const [],
    ref.watch(holdingsProvider),
    ref.watch(converterProvider),
  ),
);
