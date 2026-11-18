import 'dart:typed_data';

import 'monthly_report.dart';

/// Public seam of the reports module.
abstract interface class ReportsRepository {
  Future<MonthlyReport> buildMonthlyReport(String month);

  /// Last [months] months ending at [endMonth], oldest first.
  Future<List<MonthlyCashFlow>> monthlyCashFlow({
    required String endMonth,
    int months = 6,
  });

  Future<Uint8List> exportPdf(String month);

  Future<Uint8List> exportExcel(String month);
}
