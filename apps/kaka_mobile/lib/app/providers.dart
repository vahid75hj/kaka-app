import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaka_data/kaka_data.dart';

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:kaka_domain/kaka_domain.dart';
import 'package:kaka_sms/kaka_sms.dart';
import 'package:kaka_prices/kaka_prices.dart';

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

final portfolioRepositoryProvider = Provider<PortfolioRepository>(
  (ref) => DriftPortfolioRepository(ref.watch(databaseProvider)),
);
final portfolioServiceProvider = Provider<PortfolioService>(
  (ref) => PortfolioService(
    ref.watch(portfolioRepositoryProvider),
    ref.watch(ledgerProvider),
    ref.watch(accountRepositoryProvider),
    label: (i) => i.name(ref.read(settingsProvider).isPersian),
  ),
);
final instrumentsProvider = StreamProvider<List<Instrument>>(
  (ref) => ref.watch(portfolioRepositoryProvider).watchInstruments(),
);
final platformsProvider = StreamProvider<List<AssetPlatform>>(
  (ref) => ref.watch(portfolioRepositoryProvider).watchPlatforms(),
);
final portfolioEventsProvider = StreamProvider<List<PortfolioEvent>>(
  (ref) => ref.watch(portfolioRepositoryProvider).watchEvents(),
);
final priceQuotesProvider = StreamProvider<List<PriceQuote>>(
  (ref) => ref.watch(portfolioRepositoryProvider).watchPrices(),
);
final valuationSnapshotsProvider = StreamProvider<List<ValuationSnapshot>>(
  (ref) => ref.watch(portfolioRepositoryProvider).watchSnapshots(),
);
final costBasisProvider = Provider<CostBasisResult>(
  (ref) => CostBasis.compute(
    ref.watch(instrumentsProvider).value ?? const [],
    ref.watch(portfolioEventsProvider).value ?? const [],
  ),
);

/// Every holding with quantity, its latest price applied.
final holdingViewsProvider = Provider<List<HoldingView>>(
  (ref) => PortfolioValuation.views(ref.watch(costBasisProvider), ref.watch(priceQuotesProvider).value ?? const []),
);

/// Holdings counted in net worth (real estate / vehicles can be left out in settings).
final netWorthHoldingsProvider = Provider<List<HoldingView>>((ref) {
  final excludeIlliquid = ref.watch(settingsProvider.select((s) => s.excludeIlliquidFromNetWorth));
  return [
    for (final v in ref.watch(holdingViewsProvider))
      if (!excludeIlliquid ||
          (v.instrument.assetClass != AssetClass.realEstate && v.instrument.assetClass != AssetClass.vehicle))
        v,
  ];
});

final netWorthProvider = Provider<NetWorth>(
  (ref) => NetWorth.of(ref.watch(balancesProvider).value ?? const [], [
    for (final v in ref.watch(netWorthHoldingsProvider)) v.bestValue,
  ], ref.watch(converterProvider)),
);

final budgetRepositoryProvider = Provider<DriftBudgetRepository>(
  (ref) => DriftBudgetRepository(ref.watch(databaseProvider)),
);
final budgetsProvider = StreamProvider<List<Budget>>((ref) => ref.watch(budgetRepositoryProvider).watchAll());

final recurringRepositoryProvider = Provider<DriftRecurringRepository>(
  (ref) => DriftRecurringRepository(ref.watch(databaseProvider)),
);
final recurringRulesProvider = StreamProvider<List<RecurringRule>>(
  (ref) => ref.watch(recurringRepositoryProvider).watchAll(),
);
final recurringServiceProvider = Provider<RecurringService>(
  (ref) => RecurringService(
    ref.watch(recurringRepositoryProvider),
    ref.watch(draftServiceProvider),
    addMonths: monthAdderFor(ref.watch(settingsProvider.select((s) => s.calendar))),
  ),
);

/// Whole history, for screens that look at any past range (report). Auto-disposed when unused.
final allTransactionsProvider = StreamProvider.autoDispose<List<LedgerTransaction>>(
  (ref) => ref.watch(transactionRepositoryProvider).watchRecent(limit: 1 << 30),
);

// ---- price sources (v0.8 catalog) ----

final priceBindingStoreProvider = Provider<DriftPriceBindingStore>(
  (ref) => DriftPriceBindingStore(ref.watch(databaseProvider)),
);
final userPriceSourceStoreProvider = Provider<DriftUserPriceSourceStore>(
  (ref) => DriftUserPriceSourceStore(ref.watch(databaseProvider)),
);
final priceSourceEnabledStoreProvider = Provider<DriftPriceSourceEnabledStore>(
  (ref) => DriftPriceSourceEnabledStore(ref.watch(databaseProvider)),
);

final priceSourceEnabledProvider = StreamProvider<Set<String>>(
  (ref) => ref.watch(priceSourceEnabledStoreProvider).watch(),
);

final priceBindingsProvider = StreamProvider<List<PriceBinding>>((ref) {
  return ref.watch(priceBindingStoreProvider).watchAll().map(
    (rows) => [
      for (final r in rows)
        PriceBinding(
          id: r.id,
          instrumentId: r.instrumentId,
          sourceId: r.sourceId,
          symbol: r.symbol,
          priority: r.priority,
          enabled: r.enabled,
        ),
    ],
  );
});

final userPriceSourcesProvider = StreamProvider<List<PriceSource>>((ref) {
  return ref.watch(userPriceSourceStoreProvider).watchAll().map((rows) {
    final out = <PriceSource>[];
    for (final (_, json) in rows) {
      try {
        final cat = PriceCatalog.parse(json);
        out.addAll(cat.sources);
      } on Object {
        // skip corrupt rows
      }
    }
    return out;
  });
});

final priceCatalogProvider = FutureProvider<PriceCatalog>((ref) async {
  final json = await rootBundle.loadString('packages/kaka_prices/assets/price_sources.v1.json');
  final bundled = PriceCatalog.parseStrict(json, builtin: true);
  final user = ref.watch(userPriceSourcesProvider).value ?? const <PriceSource>[];
  return bundled.mergeUser(user);
});
