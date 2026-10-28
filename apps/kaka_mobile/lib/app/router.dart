import 'package:kaka_domain/kaka_domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/accounts/account_form_screen.dart';
import '../features/ai/ai_settings_screen.dart';
import '../features/ai/chat_screen.dart';
import '../features/assets/assets_screen.dart';
import '../features/fx/rates_screen.dart';
import '../features/report/report_screen.dart';
import '../features/budgets/budgets_screen.dart';
import '../features/import/import_screen.dart';
import '../features/recurring/recurring_screen.dart';
import '../features/sms/learn_bank_screen.dart';
import '../features/accounts/accounts_screen.dart';
import '../features/categories/categories_screen.dart';
import '../features/home/home_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/queue/queue_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/sms/sms_setup_screen.dart';
import '../features/shell/app_shell.dart';
import '../features/transactions/add_transaction_screen.dart';
import '../features/transactions/transactions_screen.dart';
import 'providers.dart';

abstract final class Routes {
  static const onboarding = '/welcome';
  static const home = '/';
  static const transactions = '/transactions';
  static const accounts = '/accounts';
  static const settings = '/settings';
  static const addTransaction = '/add';
  static const newAccount = '/accounts/new';
  static String editAccount(String id) => '/accounts/$id';
  static const queue = '/queue';
  static const categories = '/categories';
  static const smsSetup = '/sms';
  static const rates = '/rates';
  static const assets = '/assets';
  static const report = '/report';
  static const budgets = '/budgets';
  static const importCsv = '/import';
  static const recurring = '/recurring';
  static const filteredTransactions = '/transactions-filtered';
  static const learnBank = '/sms/learn';
  static const aiSettings = '/ai';
  static const chat = '/chat';
  static String confirmDraft(String id) => '/add?draft=$id';
  static String editTransaction(String id) => '/add?edit=$id';
}

final routerProvider = Provider<GoRouter>((ref) {
  // Only onboarding state drives redirects; read the rest lazily.
  final onboarded = ref.watch(settingsProvider.select((s) => s.onboarded));
  return GoRouter(
    initialLocation: onboarded ? Routes.home : Routes.onboarding,
    redirect: (context, state) {
      final atOnboarding = state.matchedLocation == Routes.onboarding;
      if (!onboarded && !atOnboarding) return Routes.onboarding;
      if (onboarded && atOnboarding) return Routes.home;
      return null;
    },
    routes: [
      GoRoute(path: Routes.onboarding, builder: (_, _) => const OnboardingScreen()),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: Routes.home, builder: (_, _) => const HomeScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: Routes.transactions, builder: (_, _) => const TransactionsScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: Routes.accounts, builder: (_, _) => const AccountsScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: Routes.settings, builder: (_, _) => const SettingsScreen())],
          ),
        ],
      ),
      GoRoute(
        path: Routes.addTransaction,
        builder: (_, state) => AddTransactionScreen(
          initialAccountId: state.uri.queryParameters['account'],
          draftId: state.uri.queryParameters['draft'],
          editTxnId: state.uri.queryParameters['edit'],
        ),
      ),
      GoRoute(path: Routes.queue, builder: (_, _) => const QueueScreen()),
      GoRoute(path: Routes.categories, builder: (_, _) => const CategoriesScreen()),
      GoRoute(path: Routes.smsSetup, builder: (_, _) => const SmsSetupScreen()),
      GoRoute(path: Routes.rates, builder: (_, _) => const RatesScreen()),
      GoRoute(path: Routes.assets, builder: (_, _) => const AssetsScreen()),
      GoRoute(path: Routes.report, builder: (_, _) => const ReportScreen()),
      GoRoute(path: Routes.budgets, builder: (_, _) => const BudgetsScreen()),
      GoRoute(path: Routes.importCsv, builder: (_, _) => const ImportScreen()),
      GoRoute(
        path: Routes.filteredTransactions,
        builder: (_, state) => TransactionsScreen(initialQuery: state.extra as TransactionQuery?),
      ),
      GoRoute(path: Routes.recurring, builder: (_, _) => const RecurringScreen()),
      GoRoute(path: Routes.learnBank, builder: (_, _) => const LearnBankScreen()),
      GoRoute(path: Routes.aiSettings, builder: (_, _) => const AiSettingsScreen()),
      GoRoute(path: Routes.chat, builder: (_, _) => const ChatScreen()),
      GoRoute(path: Routes.newAccount, builder: (_, _) => const AccountFormScreen()),
      GoRoute(
        path: '/accounts/:id',
        builder: (_, state) => AccountFormScreen(accountId: state.pathParameters['id']),
      ),
    ],
  );
});
