import 'package:drift/drift.dart';

import '../../../../core/domain/domain_exception.dart';
import '../../../../core/time/months.dart';
import '../../core_db/core_db.dart';
import '../../transactions/domain/movement.dart';
import '../domain/monthly_report.dart';
import '../domain/reports_repository.dart';
import 'excel_report_exporter.dart';
import 'pdf_report_exporter.dart';

class DriftReportsRepository implements ReportsRepository {
  DriftReportsRepository(this._db);

  final AppDatabase _db;

  @override
  Future<MonthlyReport> buildMonthlyReport(String month) async {
    _validateMonth(month);
    final start = monthStart(month);
    final end = monthEnd(month);
    final income = await _sumMovements(MovementType.income, start, end);
    final expenses = await _sumMovements(MovementType.expense, start, end);
    final assets = await _totalAssets();
    final envelopeRows = await _envelopes(month);
    final movementRows = await _movements(start, end);
    return MonthlyReport(
      month: month,
      assetsCents: assets,
      incomeCents: income,
      expenseCents: expenses,
      envelopes: envelopeRows,
      movements: movementRows,
    );
  }

  @override
  Future<Uint8List> exportPdf(String month) async {
    return buildMonthlyReportPdf(await buildMonthlyReport(month));
  }

  @override
  Future<List<MonthlyCashFlow>> monthlyCashFlow({
    required String endMonth,
    int months = 6,
  }) async {
    _validateMonth(endMonth);
    if (months <= 0) {
      throw const DomainException('El rango de meses debe ser positivo.');
    }
    final firstMonth = shiftMonth(endMonth, -(months - 1));
    final start = monthStart(firstMonth);
    final end = monthEnd(endMonth);
    final rows =
        await (_db.select(_db.movementRows)
              ..where(
                (row) =>
                    row.date.isBiggerOrEqualValue(start) &
                    row.date.isSmallerThanValue(end) &
                    row.type.isIn([
                      MovementType.income.name,
                      MovementType.expense.name,
                    ]),
              )
              ..orderBy([(row) => OrderingTerm.asc(row.date)]))
            .get();
    final buckets = <String, List<int>>{
      for (var i = 0; i < months; i++) shiftMonth(firstMonth, i): [0, 0],
    };
    for (final row in rows) {
      final values = buckets[monthKey(row.date)];
      if (values == null) continue;
      if (row.type == MovementType.income.name) {
        values[0] += row.amountCents;
      } else {
        values[1] += row.amountCents;
      }
    }
    return buckets.entries
        .map(
          (entry) => MonthlyCashFlow(
            month: entry.key,
            incomeCents: entry.value[0],
            expenseCents: entry.value[1],
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<Uint8List> exportExcel(String month) async {
    return buildMonthlyReportExcel(await buildMonthlyReport(month));
  }

  Future<int> _sumMovements(
    MovementType type,
    DateTime start,
    DateTime end,
  ) async {
    final sum = _db.movementRows.amountCents.sum();
    final query = _db.selectOnly(_db.movementRows)
      ..addColumns([sum])
      ..where(
        _db.movementRows.type.equals(type.name) &
            _db.movementRows.date.isBiggerOrEqualValue(start) &
            _db.movementRows.date.isSmallerThanValue(end),
      );
    final row = await query.getSingle();
    return row.read(sum) ?? 0;
  }

  Future<int> _totalAssets() async {
    final sum = _db.accountRows.balanceCents.sum();
    final query = _db.selectOnly(_db.accountRows)
      ..addColumns([sum])
      ..where(_db.accountRows.archived.equals(false));
    final row = await query.getSingle();
    return row.read(sum) ?? 0;
  }

  Future<List<MonthlyEnvelopeRow>> _envelopes(String month) async {
    const sql = '''
SELECT g.name AS group_name,
       e.name AS name,
       COALESCE(a.assigned_cents, 0) AS assigned_cents,
       COALESCE(a.spent_cents, 0) AS spent_cents
FROM envelopes e
JOIN envelope_groups g ON g.id = e.group_id
LEFT JOIN envelope_allocations a
       ON a.envelope_id = e.id AND a.month = ?
WHERE e.archived = 0
ORDER BY g.sort_order, g.name, e.sort_order, e.name
''';
    final rows = await _db
        .customSelect(
          sql,
          variables: [Variable.withString(month)],
          readsFrom: {
            _db.envelopeRows,
            _db.envelopeGroupRows,
            _db.envelopeAllocationRows,
          },
        )
        .get();
    return rows
        .map(
          (row) => MonthlyEnvelopeRow(
            groupName: row.read<String>('group_name'),
            name: row.read<String>('name'),
            assignedCents: row.read<int>('assigned_cents'),
            spentCents: row.read<int>('spent_cents'),
          ),
        )
        .toList(growable: false);
  }

  Future<List<ReportMovement>> _movements(DateTime start, DateTime end) async {
    final transferAccount = _db.alias(
      _db.accountRows,
      'report_transfer_account',
    );
    final statement =
        _db.select(_db.movementRows).join([
            innerJoin(
              _db.accountRows,
              _db.accountRows.id.equalsExp(_db.movementRows.accountId),
            ),
            leftOuterJoin(
              _db.envelopeRows,
              _db.envelopeRows.id.equalsExp(_db.movementRows.envelopeId),
            ),
            leftOuterJoin(
              transferAccount,
              transferAccount.id.equalsExp(_db.movementRows.transferAccountId),
            ),
          ])
          ..where(
            _db.movementRows.date.isBiggerOrEqualValue(start) &
                _db.movementRows.date.isSmallerThanValue(end),
          )
          ..orderBy([
            OrderingTerm.asc(_db.movementRows.date),
            OrderingTerm.asc(_db.movementRows.id),
          ]);
    final rows = await statement.get();
    return rows
        .map((row) {
          final movement = row.readTable(_db.movementRows);
          return ReportMovement(
            date: movement.date,
            description: movement.description,
            type: MovementType.fromDb(movement.type),
            amountCents: movement.amountCents,
            accountName: row.readTable(_db.accountRows).name,
            envelopeName: row.readTableOrNull(_db.envelopeRows)?.name,
            transferAccountName: row.readTableOrNull(transferAccount)?.name,
          );
        })
        .toList(growable: false);
  }

  void _validateMonth(String month) {
    if (!RegExp(r'^\d{4}-\d{2}$').hasMatch(month) ||
        monthKey(monthStart(month)) != month) {
      throw DomainException('Mes inválido: $month');
    }
  }
}
