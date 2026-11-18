import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:excel/excel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kipu_budget/modules/accounts/domain/account.dart';

import '../support/test_env.dart';

const _month = '2026-11';
final _date = DateTime(2026, 11, 5, 12);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TestEnv env;
  late int envelopeId;

  setUp(() async {
    env = await TestEnv.create();
    final account = await env.accounts.createAccount(
      name: 'Efectivo',
      type: AccountType.cash,
      openingBalanceCents: 0,
    );
    final groupId = await env.envelopes.createGroup('Vida');
    envelopeId = await env.envelopes.createEnvelope(
      groupId: groupId,
      name: 'Comida',
    );
    await env.transactions.recordIncome(
      accountId: account.id,
      amountCents: 100000,
      description: 'Sueldo',
      date: _date,
    );
    await env.envelopes.assign(
      month: _month,
      envelopeId: envelopeId,
      deltaCents: 40000,
    );
    await env.transactions.recordExpense(
      accountId: account.id,
      envelopeId: envelopeId,
      amountCents: 1250,
      description: 'Almuerzo',
      date: _date,
    );
  });

  tearDown(() async {
    await env.dispose();
  });

  test(
    'monthly report aggregates income, expenses, assets and envelopes',
    () async {
      final report = await env.reports.buildMonthlyReport(_month);
      expect(report.incomeCents, 100000);
      expect(report.expenseCents, 1250);
      expect(report.netCents, 98750);
      expect(report.assetsCents, 98750);
      expect(report.envelopes.single.assignedCents, 40000);
      expect(report.envelopes.single.spentCents, 1250);
      expect(report.envelopes.single.availableCents, 38750);
      expect(report.movements, hasLength(2));
    },
  );

  test('cash flow aggregates the requested month window', () async {
    final flow = await env.reports.monthlyCashFlow(endMonth: _month, months: 2);
    expect(flow, hasLength(2));
    expect(flow.first.month, '2026-10');
    expect(flow.first.incomeCents, 0);
    expect(flow.last.month, _month);
    expect(flow.last.incomeCents, 100000);
    expect(flow.last.expenseCents, 1250);
  });

  test('PDF export returns a valid PDF document', () async {
    final bytes = await env.reports.exportPdf(_month);
    expect(bytes.length, greaterThan(1000));
    expect(ascii.decode(bytes.sublist(0, 4)), '%PDF');
  });

  test(
    'Excel export returns a workbook with audit sheets and filters',
    () async {
      final bytes = await env.reports.exportExcel(_month);
      expect(bytes.length, greaterThan(2000));
      final workbook = Excel.decodeBytes(bytes);
      expect(
        workbook.tables.keys,
        containsAll(['Resumen', 'Movimientos', 'Presupuesto_Sobres']),
      );
      final archive = ZipDecoder().decodeBytes(bytes);
      final hasFilter = archive.files.any((file) {
        if (!file.name.endsWith('.xml')) return false;
        return utf8.decode(file.content as List<int>).contains('<autoFilter');
      });
      expect(hasFilter, isTrue);
      expect(
        workbook.tables['Movimientos']!.rows[0]
            .map((cell) => cell?.value?.toString())
            .toList(),
        contains('Descripción'),
      );
    },
  );
}
