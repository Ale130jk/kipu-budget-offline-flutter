import 'package:flutter/material.dart';

import '../modules/envelopes/presentation/envelopes_page.dart';
import '../modules/reports/presentation/analytics_page.dart';
import '../modules/transactions/presentation/movements_page.dart';
import '../modules/transactions/presentation/quick_add_sheet.dart';
import 'tools_page.dart';

/// Root navigation: four destinations plus the global quick-add action.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const _pages = [
    EnvelopesPage(),
    MovementsPage(),
    AnalyticsPage(),
    ToolsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      floatingActionButton: _index == _pages.length - 1
          ? null
          : FloatingActionButton(
              onPressed: () => showQuickAddSheet(context),
              tooltip: 'Registrar movimiento',
              child: const Icon(Icons.add_rounded),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet_rounded),
            label: 'Sobres',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded),
            label: 'Movimientos',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights_rounded),
            label: 'Analítica',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune_outlined),
            selectedIcon: Icon(Icons.tune_rounded),
            label: 'Herramientas',
          ),
        ],
      ),
    );
  }
}
