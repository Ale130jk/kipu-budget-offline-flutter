import 'package:flutter/material.dart';

import '../modules/security/presentation/security_gate.dart';
import 'app_theme.dart';
import 'shell.dart';

class KipuBudgetApp extends StatelessWidget {
  const KipuBudgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KipuBudget',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(Brightness.light),
      darkTheme: buildAppTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      home: const SecurityGate(child: AppShell()),
    );
  }
}
