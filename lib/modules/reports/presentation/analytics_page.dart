import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/providers.dart';
import '../../../core/time/months.dart';
import '../../../core/ui/app_colors.dart';
import '../../../core/ui/money_text.dart';
import '../domain/monthly_report.dart';

final _compact = NumberFormat.compactCurrency(
  locale: 'en_US',
  symbol: r'$',
  decimalDigits: 0,
);

String _shortMonth(String key) {
  const names = [
    'Ene',
    'Feb',
    'Mar',
    'Abr',
    'May',
    'Jun',
    'Jul',
    'Ago',
    'Sep',
    'Oct',
    'Nov',
    'Dic',
  ];
  final start = monthStart(key);
  return names[start.month - 1];
}

class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(monthlyReportProvider);
    final flow = ref.watch(cashFlowProvider);
    final month = ref.watch(selectedMonthProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Analítica')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
        children: [
          Text(
            monthLabel(month),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          report.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, _) => Text('No se pudo cargar el resumen.\n$error'),
            data: (data) => _SummaryRow(report: data),
          ),
          const SizedBox(height: 20),
          Text(
            'Flujo de caja',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 20, 16, 12),
              child: flow.when(
                loading: () => const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) =>
                    SizedBox(height: 200, child: Center(child: Text('$error'))),
                data: (points) => _CashFlowChart(points: points),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Top sobres del mes',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 20, 16, 12),
              child: report.when(
                loading: () => const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) =>
                    SizedBox(height: 200, child: Center(child: Text('$error'))),
                data: (data) => _TopEnvelopesChart(rows: data.envelopes),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.report});

  final MonthlyReport report;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SummaryCard(
          label: 'Ingresos',
          cents: report.incomeCents,
          color: positiveColor(context),
        ),
        const SizedBox(width: 8),
        _SummaryCard(
          label: 'Gastos',
          cents: report.expenseCents,
          color: negativeColor(context),
        ),
        const SizedBox(width: 8),
        _SummaryCard(
          label: 'Neto',
          cents: report.netCents,
          color: report.netCents >= 0
              ? positiveColor(context)
              : negativeColor(context),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.cents,
    required this.color,
  });

  final String label;
  final int cents;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.bodySmall),
              const SizedBox(height: 6),
              MoneyText(
                cents,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CashFlowChart extends StatelessWidget {
  const _CashFlowChart({required this.points});

  final List<MonthlyCashFlow> points;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (points.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('Sin datos de flujo de caja.')),
      );
    }
    final incomeColor = positiveColor(context);
    final expenseColor = negativeColor(context);
    final maxCents = points.fold<int>(
      0,
      (max, point) => [
        max,
        point.incomeCents,
        point.expenseCents,
      ].reduce((a, b) => a > b ? a : b),
    );
    final maxY = maxCents == 0 ? 100.0 : maxCents / 100 * 1.15;
    return Column(
      children: [
        Row(
          children: [
            _LegendDot(color: incomeColor, label: 'Ingresos'),
            const SizedBox(width: 14),
            _LegendDot(color: expenseColor, label: 'Gastos'),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 190,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: (points.length - 1).toDouble(),
              minY: 0,
              maxY: maxY,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: maxY / 4,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.4,
                  ),
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 52,
                    interval: maxY / 4,
                    getTitlesWidget: (value, meta) => Text(
                      _compact.format(value),
                      style: theme.textTheme.labelSmall,
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) {
                      final index = value.round();
                      if (index < 0 || index >= points.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          _shortMonth(points[index].month),
                          style: theme.textTheme.labelSmall,
                        ),
                      );
                    },
                  ),
                ),
              ),
              lineTouchData: const LineTouchData(enabled: false),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    for (var i = 0; i < points.length; i++)
                      FlSpot(i.toDouble(), points[i].incomeCents / 100),
                  ],
                  isCurved: true,
                  barWidth: 3,
                  color: incomeColor,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    color: incomeColor.withValues(alpha: 0.08),
                  ),
                ),
                LineChartBarData(
                  spots: [
                    for (var i = 0; i < points.length; i++)
                      FlSpot(i.toDouble(), points[i].expenseCents / 100),
                  ],
                  isCurved: true,
                  barWidth: 3,
                  color: expenseColor,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    color: expenseColor.withValues(alpha: 0.08),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _TopEnvelopesChart extends StatelessWidget {
  const _TopEnvelopesChart({required this.rows});

  final List<MonthlyEnvelopeRow> rows;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final top = rows.where((row) => row.spentCents > 0).toList()
      ..sort((a, b) => b.spentCents.compareTo(a.spentCents));
    final data = top.take(5).toList(growable: false);
    if (data.isEmpty) {
      return const SizedBox(
        height: 180,
        child: Center(child: Text('Aún no hay gastos por sobre.')),
      );
    }
    final maxCents = data.first.spentCents;
    final maxY = maxCents / 100 * 1.2;
    return SizedBox(
      height: 210,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          alignment: BarChartAlignment.spaceAround,
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 34,
                getTitlesWidget: (value, meta) {
                  final index = value.round();
                  if (index < 0 || index >= data.length) {
                    return const SizedBox.shrink();
                  }
                  final name = data[index].name;
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      name.length > 9 ? '${name.substring(0, 8)}…' : name,
                      style: theme.textTheme.labelSmall,
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < data.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: data[i].spentCents / 100,
                    width: 22,
                    color: data[i].availableCents < 0
                        ? negativeColor(context)
                        : theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
