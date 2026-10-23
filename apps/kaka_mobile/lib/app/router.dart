import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/accounts/account_form_screen.dart';
import '../features/accounts/accounts_screen.dart';
import '../features/categories/categories_screen.dart';
import '../features/home/home_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/queue/queue_screen.dart';
import '../features/settings/settings_screen.dart';
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
  static String confirmDraft(String id) => '/add?draft=$id';
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
        ),
      ),
      GoRoute(path: Routes.queue, builder: (_, _) => const QueueScreen()),
      GoRoute(path: Routes.categories, builder: (_, _) => const CategoriesScreen()),
      GoRoute(path: Routes.newAccount, builder: (_, _) => const AccountFormScreen()),
      GoRoute(
        path: '/accounts/:id',
        builder: (_, state) => AccountFormScreen(accountId: state.pathParameters['id']),
      ),
    ],
  );
});
