import 'package:flutter_test/flutter_test.dart';
import 'package:kipu_budget/modules/core_db/core_db.dart';

import '../support/test_env.dart';

void main() {
  late TestEnv env;

  setUp(() async {
    env = await TestEnv.create();
  });

  tearDown(() async {
    await env.dispose();
  });

  test('foreign keys are enabled on open', () async {
    final pragma = await env.db.customSelect('PRAGMA foreign_keys').getSingle();
    expect(pragma.read<int>('foreign_keys'), 1);
  });

  test('movement with unknown account is rejected by SQLite', () async {
    await expectLater(
      env.db
          .into(env.db.movementRows)
          .insert(
            MovementRowsCompanion.insert(
              accountId: 999,
              type: 'expense',
              amountCents: 100,
              description: 'huérfano',
              date: DateTime(2026, 11, 1),
            ),
          ),
      throwsA(anything),
    );
    final count = await env.db
        .customSelect('SELECT COUNT(*) AS c FROM movements')
        .getSingle();
    expect(count.read<int>('c'), 0);
  });

  test('composite indexes on movements exist', () async {
    final rows = await env.db
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type = 'index' "
          "AND name IN ('idx_movements_date_envelope', 'idx_movements_account')",
        )
        .get();
    expect(rows.map((row) => row.read<String>('name')), {
      'idx_movements_date_envelope',
      'idx_movements_account',
    });
  });

  test('envelope allocation is unique per envelope and month', () async {
    final accountId = await env.db
        .into(env.db.accountRows)
        .insert(
          AccountRowsCompanion.insert(
            name: 'Efectivo',
            type: 'cash',
            openingBalanceCents: 0,
            balanceCents: 0,
          ),
        );
    expect(accountId, greaterThan(0));
    final groupId = await env.db
        .into(env.db.envelopeGroupRows)
        .insert(EnvelopeGroupRowsCompanion.insert(name: 'Vida'));
    final envelopeId = await env.db
        .into(env.db.envelopeRows)
        .insert(EnvelopeRowsCompanion.insert(groupId: groupId, name: 'Comida'));
    final companion = EnvelopeAllocationRowsCompanion.insert(
      envelopeId: envelopeId,
      month: '2026-11',
    );
    await env.db.into(env.db.envelopeAllocationRows).insert(companion);
    await expectLater(
      env.db.into(env.db.envelopeAllocationRows).insert(companion),
      throwsA(anything),
    );
  });
}
