import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kipu_budget/app/app.dart';
import 'package:kipu_budget/app/providers.dart';
import 'package:kipu_budget/modules/core_db/core_db.dart';

void main() {
  testWidgets('app shell exposes the four budgeting destinations', (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    await db.customSelect('SELECT 1').get();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const KipuBudgetApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Sobres'), findsWidgets);
    expect(find.text('Movimientos'), findsWidgets);
    expect(find.text('Analítica'), findsWidgets);
    expect(find.text('Herramientas'), findsWidgets);
    expect(find.text('Por asignar'), findsOneWidget);

    // Unmount first so Drift cancels its query streams, then flush the
    // zero-duration timers those cancellations schedule.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 10));
    await db.close();
  });
}
