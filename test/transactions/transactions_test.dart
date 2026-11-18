import 'package:flutter_test/flutter_test.dart';
import 'package:kipu_budget/core/domain/domain_exception.dart';
import 'package:kipu_budget/modules/accounts/domain/account.dart';

import '../support/test_env.dart';

const _month = '2026-11';
final _date = DateTime(2026, 11, 5, 12, 30);

void main() {
  late TestEnv env;
  late int accountId;
  late int foodEnvelopeId;
  late int funEnvelopeId;

  setUp(() async {
    env = await TestEnv.create();
    final account = await env.accounts.createAccount(
      name: 'Efectivo',
      type: AccountType.cash,
      openingBalanceCents: 0,
    );
    accountId = account.id;
    final groupId = await env.envelopes.createGroup('Vida diaria');
    foodEnvelopeId = await env.envelopes.createEnvelope(
      groupId: groupId,
      name: 'Comida',
    );
    funEnvelopeId = await env.envelopes.createEnvelope(
      groupId: groupId,
      name: 'Ocio',
    );
    await env.transactions.recordIncome(
      accountId: accountId,
      amountCents: 100000,
      description: 'Sueldo',
      date: _date,
    );
  });

  tearDown(() async {
    await env.dispose();
  });

  Future<int> accountBalance() async {
    final accounts = await env.accounts.watchAccounts().first;
    return accounts
        .firstWhere((account) => account.id == accountId)
        .balanceCents;
  }

  Future<int> toAssign() => env.envelopes.watchToAssign().first;

  Future<int> availableOf(int envelopeId) async {
    final budgets = await env.envelopes.watchMonth(_month).first;
    return budgets
        .firstWhere((budget) => budget.envelopeId == envelopeId)
        .availableCents;
  }

  test('RF-01: income increases the pool, not the envelope budget', () async {
    expect(await toAssign(), 100000);
    expect(await accountBalance(), 100000);
    final budgets = await env.envelopes.watchMonth(_month).first;
    expect(budgets.every((budget) => budget.assignedCents == 0), isTrue);
  });

  test('RF-01: assigning money moves the pool but not bank balance', () async {
    await env.envelopes.assign(
      month: _month,
      envelopeId: foodEnvelopeId,
      deltaCents: 40000,
    );
    expect(await toAssign(), 60000);
    expect(await accountBalance(), 100000);
    expect(await availableOf(foodEnvelopeId), 40000);
    final budgets = await env.envelopes.watchMonth(_month).first;
    final food = budgets.firstWhere((b) => b.envelopeId == foodEnvelopeId);
    expect(food.assignedCents, 40000);
    expect(food.spentCents, 0);
  });

  test('assigning more than the pool fails without partial writes', () async {
    await expectLater(
      env.envelopes.assign(
        month: _month,
        envelopeId: foodEnvelopeId,
        deltaCents: 100001,
      ),
      throwsA(isA<DomainException>()),
    );
    expect(await toAssign(), 100000);
    final budgets = await env.envelopes.watchMonth(_month).first;
    expect(budgets.every((budget) => budget.assignedCents == 0), isTrue);
  });

  test(
    'RF-02: expense updates account, envelope and movement atomically',
    () async {
      await env.envelopes.assign(
        month: _month,
        envelopeId: foodEnvelopeId,
        deltaCents: 40000,
      );
      final movement = await env.transactions.recordExpense(
        accountId: accountId,
        envelopeId: foodEnvelopeId,
        amountCents: 1250,
        description: 'Almuerzo',
        date: _date,
      );
      expect(movement.envelopeId, foodEnvelopeId);
      expect(await accountBalance(), 98750);
      expect(await availableOf(foodEnvelopeId), 38750);
      final views = await env.transactions.watchMovements().first;
      expect(views.map((view) => view.movement.id), contains(movement.id));
      expect(
        views.firstWhere((v) => v.movement.id == movement.id).envelopeName,
        'Comida',
      );
    },
  );

  test(
    'RF-02: failure during envelope update rolls back account and movement',
    () async {
      await env.envelopes.assign(
        month: _month,
        envelopeId: foodEnvelopeId,
        deltaCents: 40000,
      );
      await env.db.customStatement(
        "CREATE TRIGGER fail_spent BEFORE UPDATE OF spent_cents "
        "ON envelope_allocations BEGIN SELECT RAISE(ABORT, 'boom'); END;",
      );
      await expectLater(
        env.transactions.recordExpense(
          accountId: accountId,
          envelopeId: foodEnvelopeId,
          amountCents: 1000,
          description: 'Falla forzada',
          date: _date,
        ),
        throwsA(anything),
      );
      expect(await accountBalance(), 100000);
      expect(await availableOf(foodEnvelopeId), 40000);
      final views = await env.transactions.watchMovements().first;
      expect(
        views.any((view) => view.movement.description == 'Falla forzada'),
        isFalse,
      );
    },
  );

  test(
    'RF-03: overage is detected and covered from another envelope',
    () async {
      await env.envelopes.assign(
        month: _month,
        envelopeId: foodEnvelopeId,
        deltaCents: 5000,
      );
      await env.envelopes.assign(
        month: _month,
        envelopeId: funEnvelopeId,
        deltaCents: 10000,
      );
      await env.transactions.recordExpense(
        accountId: accountId,
        envelopeId: foodEnvelopeId,
        amountCents: 6500,
        description: 'Cena',
        date: _date,
      );
      var budgets = await env.envelopes.watchMonth(_month).first;
      var food = budgets.firstWhere((b) => b.envelopeId == foodEnvelopeId);
      expect(food.availableCents, -1500);
      expect(food.isOverage, isTrue);
      expect(await toAssign(), 85000);

      await env.envelopes.moveBetweenEnvelopes(
        month: _month,
        fromEnvelopeId: funEnvelopeId,
        toEnvelopeId: foodEnvelopeId,
        amountCents: 2000,
        note: 'Cubrir cena',
      );
      budgets = await env.envelopes.watchMonth(_month).first;
      food = budgets.firstWhere((b) => b.envelopeId == foodEnvelopeId);
      final fun = budgets.firstWhere((b) => b.envelopeId == funEnvelopeId);
      expect(food.availableCents, 500);
      expect(fun.availableCents, 8000);
      expect(await toAssign(), 85000);
    },
  );

  test(
    'RF-03: cannot move more than the source envelope has available',
    () async {
      await env.envelopes.assign(
        month: _month,
        envelopeId: funEnvelopeId,
        deltaCents: 3000,
      );
      await expectLater(
        env.envelopes.moveBetweenEnvelopes(
          month: _month,
          fromEnvelopeId: funEnvelopeId,
          toEnvelopeId: foodEnvelopeId,
          amountCents: 3001,
        ),
        throwsA(isA<DomainException>()),
      );
      expect(await availableOf(funEnvelopeId), 3000);
    },
  );

  test('RF-04: rules suggest and auto-assign the matching envelope', () async {
    final groupId = await env.envelopes.createGroup('Hogar');
    final supermarket = await env.envelopes.createEnvelope(
      groupId: groupId,
      name: 'Supermercado',
    );
    await env.transactions.saveRule(
      pattern: 'super',
      envelopeId: supermarket,
      priority: 1,
    );
    expect(
      await env.transactions.suggestEnvelope('Compra SUPERMERCADO'),
      supermarket,
    );
    expect(await env.transactions.suggestEnvelope('Taxi'), isNull);

    final movement = await env.transactions.recordExpense(
      accountId: accountId,
      amountCents: 2200,
      description: 'Supermercado del barrio',
      date: _date,
    );
    expect(movement.envelopeId, supermarket);
    final budgets = await env.envelopes.watchMonth(_month).first;
    final row = budgets.firstWhere((b) => b.envelopeId == supermarket);
    expect(row.spentCents, 2200);
    expect(row.availableCents, -2200);
  });

  test('account transfer is atomic and does not touch the pool', () async {
    final savings = await env.accounts.createAccount(
      name: 'Ahorro',
      type: AccountType.savings,
      openingBalanceCents: 0,
    );
    await env.transactions.recordTransfer(
      fromAccountId: accountId,
      toAccountId: savings.id,
      amountCents: 30000,
      description: 'Ahorro mensual',
      date: _date,
    );
    final accounts = await env.accounts.watchAccounts().first;
    expect(
      accounts.firstWhere((account) => account.id == accountId).balanceCents,
      70000,
    );
    expect(
      accounts.firstWhere((account) => account.id == savings.id).balanceCents,
      30000,
    );
    expect(await toAssign(), 100000);
  });

  test('expense with unknown account leaves no movement behind', () async {
    await expectLater(
      env.transactions.recordExpense(
        accountId: 9999,
        amountCents: 100,
        description: 'Fantasma',
        date: _date,
      ),
      throwsA(isA<DomainException>()),
    );
    final views = await env.transactions.watchMovements().first;
    expect(
      views.any((view) => view.movement.description == 'Fantasma'),
      isFalse,
    );
  });
}
