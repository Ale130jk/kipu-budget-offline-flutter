import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:excel/excel.dart';

import '../../../../core/time/months.dart';
import '../../transactions/domain/movement.dart';
import '../domain/monthly_report.dart';

/// Builds a multi-sheet `.xlsx` workbook: Resumen, Movimientos and
/// Presupuesto_Sobres, with currency formats and autofilters.
Uint8List buildMonthlyReportExcel(MonthlyReport report) {
  final excel = Excel.createExcel();
  excel.rename('Sheet1', 'Resumen');
  final summary = excel['Resumen'];
  final movements = excel['Movimientos'];
  final envelopes = excel['Presupuesto_Sobres'];
  excel.setDefaultSheet('Resumen');

  final titleStyle = CellStyle(
    bold: true,
    fontSize: 18,
    fontColorHex: ExcelColor.fromHexString('#0F766E'),
  );
  final subtitleStyle = CellStyle(
    fontSize: 12,
    fontColorHex: ExcelColor.fromHexString('#334155'),
  );
  final headerStyle = CellStyle(
    bold: true,
    fontColorHex: ExcelColor.white,
    backgroundColorHex: ExcelColor.fromHexString('#0F766E'),
    horizontalAlign: HorizontalAlign.Center,
    verticalAlign: VerticalAlign.Center,
    fontSize: 11,
  );
  const currencyCode = r'"$"#,##0.00';
  final currencyStyle = CellStyle(
    numberFormat: NumFormat.custom(formatCode: currencyCode),
    horizontalAlign: HorizontalAlign.Right,
  );
  final boldCurrencyStyle = CellStyle(
    bold: true,
    numberFormat: NumFormat.custom(formatCode: currencyCode),
    horizontalAlign: HorizontalAlign.Right,
  );

  _text(summary, 0, 0, 'KipuBudget', style: titleStyle);
  _text(summary, 1, 0, 'Estado de cuenta mensual', style: subtitleStyle);
  _text(summary, 2, 0, monthLabel(report.month), style: subtitleStyle);
  summary.setColumnWidth(0, 28);
  summary.setColumnWidth(1, 18);

  _text(summary, 4, 0, 'Concepto', style: headerStyle);
  _text(summary, 4, 1, 'Monto', style: headerStyle);
  const summaryRows = [
    'Patrimonio',
    'Ingresos del mes',
    'Gastos del mes',
    'Neto',
  ];
  final summaryValues = [
    report.assetsCents,
    report.incomeCents,
    report.expenseCents,
    report.netCents,
  ];
  for (var i = 0; i < summaryRows.length; i++) {
    _text(summary, 5 + i, 0, summaryRows[i]);
    _money(
      summary,
      5 + i,
      1,
      summaryValues[i],
      style: i == summaryRows.length - 1 ? boldCurrencyStyle : currencyStyle,
    );
  }

  movements.setColumnWidth(0, 12);
  movements.setColumnWidth(1, 15);
  movements.setColumnWidth(2, 40);
  movements.setColumnWidth(3, 22);
  movements.setColumnWidth(4, 22);
  movements.setColumnWidth(5, 16);
  const movementHeaders = [
    'Fecha',
    'Tipo',
    'Descripción',
    'Cuenta',
    'Sobre',
    'Monto',
  ];
  for (var i = 0; i < movementHeaders.length; i++) {
    _text(movements, 0, i, movementHeaders[i], style: headerStyle);
  }
  for (var i = 0; i < report.movements.length; i++) {
    final movement = report.movements[i];
    final row = i + 1;
    _text(movements, row, 0, _date(movement.date));
    _text(movements, row, 1, movement.type.label);
    _text(movements, row, 2, movement.description);
    _text(movements, row, 3, movement.accountName);
    _text(movements, row, 4, movement.envelopeName ?? '');
    _money(
      movements,
      row,
      5,
      movement.type == MovementType.income
          ? movement.amountCents
          : -movement.amountCents,
      style: currencyStyle,
    );
  }

  envelopes.setColumnWidth(0, 20);
  envelopes.setColumnWidth(1, 24);
  envelopes.setColumnWidth(2, 16);
  envelopes.setColumnWidth(3, 14);
  envelopes.setColumnWidth(4, 16);
  const envelopeHeaders = [
    'Grupo',
    'Sobre',
    'Presupuestado',
    'Gastado',
    'Disponible',
  ];
  for (var i = 0; i < envelopeHeaders.length; i++) {
    _text(envelopes, 0, i, envelopeHeaders[i], style: headerStyle);
  }
  for (var i = 0; i < report.envelopes.length; i++) {
    final envelope = report.envelopes[i];
    final row = i + 1;
    _text(envelopes, row, 0, envelope.groupName);
    _text(envelopes, row, 1, envelope.name);
    _money(envelopes, row, 2, envelope.assignedCents, style: currencyStyle);
    _money(envelopes, row, 3, envelope.spentCents, style: currencyStyle);
    _money(envelopes, row, 4, envelope.availableCents, style: currencyStyle);
  }

  final bytes = excel.save();
  if (bytes == null) {
    throw StateError('No se pudo serializar el libro de Excel.');
  }
  return _addAutoFilters(Uint8List.fromList(bytes), {
    'Movimientos': 'A1:F${report.movements.length + 1}',
    'Presupuesto_Sobres': 'A1:E${report.envelopes.length + 1}',
  });
}

void _text(Sheet sheet, int row, int column, String text, {CellStyle? style}) {
  sheet.updateCell(
    CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
    TextCellValue(text),
    cellStyle: style,
  );
}

void _money(Sheet sheet, int row, int column, int cents, {CellStyle? style}) {
  sheet.updateCell(
    CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
    DoubleCellValue(cents / 100),
    cellStyle: style,
  );
}

String _date(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}

/// The `excel` package does not expose autofilters, so patch the generated
/// sheet XML. The filter is schema-valid right after `sheetData`.
Uint8List _addAutoFilters(Uint8List bytes, Map<String, String> ranges) {
  final archive = ZipDecoder().decodeBytes(bytes);
  final workbookFile = archive.findFile('xl/workbook.xml');
  final relsFile = archive.findFile('xl/_rels/workbook.xml.rels');
  if (workbookFile == null || relsFile == null) return bytes;

  final relTargets = <String, String>{};
  final rels = utf8.decode(relsFile.content as List<int>);
  for (final tag in RegExp(r'<Relationship\b[^>]*>').allMatches(rels)) {
    final raw = tag.group(0)!;
    final id = RegExp(r'Id="([^"]+)"').firstMatch(raw)?.group(1);
    final target = RegExp(r'Target="([^"]+)"').firstMatch(raw)?.group(1);
    if (id != null && target != null) relTargets[id] = target;
  }

  final sheetTargets = <String, String>{};
  final workbook = utf8.decode(workbookFile.content as List<int>);
  for (final tag in RegExp(r'<sheet\b[^>]*>').allMatches(workbook)) {
    final raw = tag.group(0)!;
    final name = RegExp(r'name="([^"]+)"').firstMatch(raw)?.group(1);
    final relId = RegExp(r'r:id="([^"]+)"').firstMatch(raw)?.group(1);
    if (name == null || relId == null) continue;
    final target = relTargets[relId];
    if (target == null) continue;
    sheetTargets[name] = target.startsWith('/')
        ? target.substring(1)
        : 'xl/$target';
  }

  final patched = <String, List<int>>{};
  for (final entry in ranges.entries) {
    final sheetPath = sheetTargets[entry.key];
    if (sheetPath == null) continue;
    final file = archive.findFile(sheetPath);
    if (file == null) continue;
    final xml = utf8.decode(file.content as List<int>);
    if (xml.contains('<autoFilter')) continue;
    final filter = '<autoFilter ref="${entry.value}"/>';
    final sheetDataEnd = xml.indexOf('</sheetData>');
    final String next;
    if (sheetDataEnd >= 0) {
      final index = sheetDataEnd + '</sheetData>'.length;
      next = xml.substring(0, index) + filter + xml.substring(index);
    } else if (xml.contains('<sheetData/>')) {
      next = xml.replaceFirst('<sheetData/>', '<sheetData/>$filter');
    } else {
      next = xml.replaceFirst('</worksheet>', '$filter</worksheet>');
    }
    patched[sheetPath] = utf8.encode(next);
  }
  if (patched.isEmpty) return bytes;

  final updated = Archive();
  for (final file in archive.files) {
    final data = patched[file.name];
    if (data == null) {
      updated.addFile(file);
    } else {
      updated.addFile(ArchiveFile(file.name, data.length, data));
    }
  }
  final encoded = ZipEncoder().encode(updated);
  if (encoded == null) return bytes;
  return Uint8List.fromList(encoded);
}
