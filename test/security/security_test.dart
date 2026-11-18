import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:kipu_budget/core/domain/domain_exception.dart';
import 'package:kipu_budget/modules/accounts/domain/account.dart';
import 'package:kipu_budget/modules/security/data/local_security_repository.dart';

import '../support/test_env.dart';

void main() {
  late TestEnv env;
  late Directory workingDirectory;
  late LocalSecurityRepository security;

  setUp(() async {
    env = await TestEnv.create();
    workingDirectory = await Directory.systemTemp.createTemp('kipu_security_');
    security = LocalSecurityRepository(
      env.db,
      workingDirectory: workingDirectory,
    );
  });

  tearDown(() async {
    await env.dispose();
    if (await workingDirectory.exists()) {
      await workingDirectory.delete(recursive: true);
    }
  });

  test('backup and restore round-trips every table', () async {
    final account = await env.accounts.createAccount(
      name: 'Efectivo',
      type: AccountType.cash,
      openingBalanceCents: 0,
    );
    await env.transactions.recordIncome(
      accountId: account.id,
      amountCents: 50000,
      description: 'Sueldo',
      date: DateTime(2026, 11, 1),
    );
    final backup = await security.exportBackup();
    expect(backup.length, greaterThan(1024));

    await env.transactions.recordIncome(
      accountId: account.id,
      amountCents: 99900,
      description: 'Extra',
      date: DateTime(2026, 11, 2),
    );
    var views = await env.transactions.watchMovements().first;
    expect(views, hasLength(2));

    await security.restoreBackup(backup);
    views = await env.transactions.watchMovements().first;
    expect(views, hasLength(1));
    expect(views.single.movement.description, 'Sueldo');
    final accounts = await env.accounts.watchAccounts().first;
    expect(accounts.single.balanceCents, 50000);
  });

  test('restore rejects a file that is not a SQLite backup', () async {
    final account = await env.accounts.createAccount(
      name: 'Efectivo',
      type: AccountType.cash,
      openingBalanceCents: 0,
    );
    await expectLater(
      security.restoreBackup(Uint8List.fromList([1, 2, 3, 4])),
      throwsA(isA<DomainException>()),
    );
    expect(await env.accounts.watchAccounts().first, hasLength(1));
    expect(account.id, greaterThan(0));
  });

  test('backup file name is timestamped', () {
    final name = security.backupFileName(DateTime(2026, 11, 5, 9, 7));
    expect(name, 'kipu_budget_backup_20261105_0907.sqlite');
  });

  test('biometric flag defaults to disabled', () async {
    expect(await security.isBiometricEnabled(), isFalse);
  });
}
