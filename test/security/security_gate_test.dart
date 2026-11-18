import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kipu_budget/app/app.dart';
import 'package:kipu_budget/app/providers.dart';
import 'package:kipu_budget/modules/core_db/core_db.dart';
import 'package:kipu_budget/modules/security/domain/security_repository.dart';

/// Public seam stand-in: the gate must never read private state to decide.
class _FakeSecurity implements SecurityRepository {
  _FakeSecurity({
    this.enabled = false,
    this.authentication = true,
    this.readFails = false,
  });

  bool enabled;
  bool authentication;
  final bool readFails;
  int authenticateCalls = 0;

  @override
  Future<bool> isBiometricEnabled() async {
    if (readFails) throw StateError('settings unavailable');
    return enabled;
  }

  @override
  Future<bool> canUseBiometrics() async => true;

  @override
  Future<void> setBiometricEnabled(bool value) async => enabled = value;

  @override
  Future<bool> authenticate() async {
    authenticateCalls++;
    return authentication;
  }

  @override
  Future<Uint8List> exportBackup() async => Uint8List(0);

  @override
  Future<void> restoreBackup(Uint8List bytes) async {}

  @override
  String backupFileName([DateTime? now]) => 'kipu_budget_backup.sqlite';
}

void main() {
  Future<AppDatabase> pumpApp(
    WidgetTester tester,
    _FakeSecurity security,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    await db.customSelect('SELECT 1').get();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          securityRepositoryProvider.overrideWithValue(security),
        ],
        child: const KipuBudgetApp(),
      ),
    );
    await tester.pumpAndSettle();
    return db;
  }

  Future<void> unmount(WidgetTester tester, AppDatabase db) async {
    // Unmount so Drift cancels its streams, flush zero-duration timers, close.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 10));
    await db.close();
  }

  testWidgets('locked gate hides every budgeting screen', (tester) async {
    final security = _FakeSecurity(enabled: true, authentication: false);
    final db = await pumpApp(tester, security);

    expect(security.authenticateCalls, 1);
    expect(find.text('Desbloquear'), findsOneWidget);
    expect(find.text('Sobres'), findsNothing);
    expect(find.text('Por asignar'), findsNothing);
    expect(find.byType(NavigationBar), findsNothing);

    await unmount(tester, db);
  });

  testWidgets('a successful check reveals the app', (tester) async {
    final security = _FakeSecurity(enabled: true);
    final db = await pumpApp(tester, security);

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Por asignar'), findsOneWidget);
    expect(find.text('Desbloquear'), findsNothing);

    await unmount(tester, db);
  });

  testWidgets('retry unlocks after the first check is rejected', (
    tester,
  ) async {
    final security = _FakeSecurity(enabled: true, authentication: false);
    final db = await pumpApp(tester, security);

    expect(find.text('Desbloquear'), findsOneWidget);
    security.authentication = true;
    await tester.tap(find.text('Desbloquear'));
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(security.authenticateCalls, 2);

    await unmount(tester, db);
  });

  testWidgets('an unreadable setting fails closed', (tester) async {
    final security = _FakeSecurity(
      enabled: true,
      authentication: false,
      readFails: true,
    );
    final db = await pumpApp(tester, security);

    expect(find.text('Desbloquear'), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);

    await unmount(tester, db);
  });
}
