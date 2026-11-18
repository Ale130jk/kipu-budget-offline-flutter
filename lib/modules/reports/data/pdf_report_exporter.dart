import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../core/money/money.dart';
import '../../../../core/time/months.dart';
import '../../transactions/domain/movement.dart';
import '../domain/monthly_report.dart';

const PdfColor _emerald = PdfColor.fromInt(0xFF0F766E);
const PdfColor _emeraldSoft = PdfColor.fromInt(0xFFE6F4F1);
const PdfColor _coral = PdfColor.fromInt(0xFFB91C1C);
const PdfColor _slate = PdfColor.fromInt(0xFF334155);
const PdfColor _line = PdfColor.fromInt(0xFFE2E8F0);

/// Renders the monthly statement as an A4 PDF. Pure function: no Flutter,
/// no platform plugins, so it runs in unit tests.
Future<Uint8List> buildMonthlyReportPdf(MonthlyReport report) async {
  final theme = await _reportTheme();
  final document = pw.Document(theme: theme);
  document.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(32, 32, 32, 36),
      footer: (context) => pw.Container(
        alignment: pw.Alignment.centerRight,
        margin: const pw.EdgeInsets.only(top: 8),
        child: pw.Text(
          'KipuBudget · Página ${context.pageNumber} de ${context.pagesCount}',
          style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
        ),
      ),
      build: (context) => [
        _header(report),
        pw.SizedBox(height: 18),
        _summary(report),
        pw.SizedBox(height: 22),
        _sectionTitle('Ejecución por sobres'),
        pw.SizedBox(height: 8),
        _envelopeTable(report.envelopes),
        pw.SizedBox(height: 22),
        _sectionTitle('Detalle de movimientos'),
        pw.SizedBox(height: 8),
        _movementTable(report.movements),
      ],
    ),
  );
  return document.save();
}

Future<pw.ThemeData> _reportTheme() async {
  final regular = pw.Font.ttf(
    await rootBundle.load('assets/fonts/Roboto-Regular.ttf'),
  );
  final bold = pw.Font.ttf(
    await rootBundle.load('assets/fonts/Roboto-Bold.ttf'),
  );
  return pw.ThemeData.withFont(base: regular, bold: bold);
}

pw.Widget _header(MonthlyReport report) {
  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Expanded(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'KipuBudget',
              style: pw.TextStyle(
                fontSize: 26,
                fontWeight: pw.FontWeight.bold,
                color: _emerald,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              'Estado de cuenta mensual',
              style: const pw.TextStyle(fontSize: 12, color: _slate),
            ),
          ],
        ),
      ),
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Text(
            monthLabel(report.month),
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: _slate,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Generado ${_date(DateTime.now())}',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
          ),
        ],
      ),
    ],
  );
}

pw.Widget _summary(MonthlyReport report) {
  return pw.Row(
    children: [
      _summaryBox('Patrimonio', formatCents(report.assetsCents), _emeraldSoft),
      pw.SizedBox(width: 8),
      _summaryBox('Ingresos', formatCents(report.incomeCents), _emeraldSoft),
      pw.SizedBox(width: 8),
      _summaryBox('Gastos', formatCents(report.expenseCents), _emeraldSoft),
      pw.SizedBox(width: 8),
      _summaryBox('Neto', formatCents(report.netCents), _emeraldSoft),
    ],
  );
}

pw.Widget _summaryBox(String label, String value, PdfColor background) {
  return pw.Expanded(
    child: pw.Container(
      padding: const pw.EdgeInsets.all(9),
      decoration: pw.BoxDecoration(
        color: background,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: _line, width: 0.5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 8, color: _slate)),
          pw.SizedBox(height: 5),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
              color: _slate,
            ),
          ),
        ],
      ),
    ),
  );
}

pw.Widget _sectionTitle(String title) {
  return pw.Text(
    title,
    style: pw.TextStyle(
      fontSize: 13,
      fontWeight: pw.FontWeight.bold,
      color: _emerald,
    ),
  );
}

pw.Widget _envelopeTable(List<MonthlyEnvelopeRow> envelopes) {
  final totalAssigned = envelopes.fold<int>(
    0,
    (sum, row) => sum + row.assignedCents,
  );
  final totalSpent = envelopes.fold<int>(0, (sum, row) => sum + row.spentCents);
  final rows = <pw.TableRow>[
    _tableHeader(['Grupo', 'Sobre', 'Presupuestado', 'Gastado', 'Disponible']),
    for (var i = 0; i < envelopes.length; i++)
      _tableRow(
        [
          envelopes[i].groupName,
          envelopes[i].name,
          formatCents(envelopes[i].assignedCents),
          formatCents(envelopes[i].spentCents),
          formatCents(envelopes[i].availableCents),
        ],
        shaded: i.isOdd,
        valueColor: envelopes[i].availableCents < 0 ? _coral : _slate,
      ),
    if (envelopes.isNotEmpty)
      _tableRow(
        [
          '',
          'Total',
          formatCents(totalAssigned),
          formatCents(totalSpent),
          formatCents(totalAssigned - totalSpent),
        ],
        bold: true,
        shaded: true,
      ),
  ];
  return pw.Table(
    border: pw.TableBorder.all(color: _line, width: 0.5),
    columnWidths: const {
      0: pw.FlexColumnWidth(1.4),
      1: pw.FlexColumnWidth(1.8),
      2: pw.FlexColumnWidth(1.3),
      3: pw.FlexColumnWidth(1.1),
      4: pw.FlexColumnWidth(1.3),
    },
    children: rows,
  );
}

pw.Widget _movementTable(List<ReportMovement> movements) {
  if (movements.isEmpty) {
    return pw.Text(
      'Sin movimientos registrados en este mes.',
      style: const pw.TextStyle(fontSize: 10, color: _slate),
    );
  }
  final rows = <pw.TableRow>[
    _tableHeader(['Fecha', 'Descripción', 'Cuenta', 'Sobre', 'Monto']),
    for (var i = 0; i < movements.length; i++)
      _movementRow(movements[i], shaded: i.isOdd),
  ];
  return pw.Table(
    border: pw.TableBorder.all(color: _line, width: 0.5),
    columnWidths: const {
      0: pw.FlexColumnWidth(0.8),
      1: pw.FlexColumnWidth(2.6),
      2: pw.FlexColumnWidth(1.5),
      3: pw.FlexColumnWidth(1.2),
      4: pw.FlexColumnWidth(1.1),
    },
    children: rows,
  );
}

pw.TableRow _movementRow(ReportMovement movement, {required bool shaded}) {
  final account = movement.transferAccountName == null
      ? movement.accountName
      : '${movement.accountName} a ${movement.transferAccountName}';
  final sign = switch (movement.type) {
    MovementType.income => '+',
    MovementType.expense => '-',
    MovementType.transfer => '',
  };
  final color = switch (movement.type) {
    MovementType.income => _emerald,
    MovementType.expense => _slate,
    MovementType.transfer => PdfColors.grey700,
  };
  return _tableRow(
    [
      _date(movement.date),
      movement.description,
      account,
      movement.envelopeName ?? '-',
      '$sign${formatCents(movement.amountCents)}',
    ],
    shaded: shaded,
    valueColor: color,
  );
}

pw.TableRow _tableHeader(List<String> values) {
  return pw.TableRow(
    decoration: const pw.BoxDecoration(color: _emerald),
    children: [
      for (final value in values)
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
          child: pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 8.5,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
          ),
        ),
    ],
  );
}

pw.TableRow _tableRow(
  List<String> values, {
  required bool shaded,
  bool bold = false,
  PdfColor valueColor = _slate,
}) {
  return pw.TableRow(
    decoration: pw.BoxDecoration(
      color: shaded ? const PdfColor.fromInt(0xFFF8FAFC) : PdfColors.white,
    ),
    children: [
      for (final value in values)
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 8.5,
              color: valueColor,
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ),
    ],
  );
}

String _date(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}
