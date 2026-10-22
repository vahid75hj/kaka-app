import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/l10n_x.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final showFab = shell.currentIndex <= 1;
    return Scaffold(
      body: shell,
      floatingActionButton: showFab
          ? FloatingActionButton(
              onPressed: () => context.push(Routes.addTransaction),
              tooltip: l.addTransaction,
              child: const Icon(Icons.add_rounded, size: 28),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: l.navHome,
          ),
          NavigationDestination(icon: const Icon(Icons.swap_vert_rounded), label: l.navTransactions),
          NavigationDestination(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: const Icon(Icons.account_balance_wallet_rounded),
            label: l.navAccounts,
          ),
          NavigationDestination(icon: const Icon(Icons.tune_rounded), label: l.navSettings),
        ],
      ),
    );
  }
}
