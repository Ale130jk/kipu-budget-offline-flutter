const List<String> _monthNames = [
  'enero',
  'febrero',
  'marzo',
  'abril',
  'mayo',
  'junio',
  'julio',
  'agosto',
  'septiembre',
  'octubre',
  'noviembre',
  'diciembre',
];

/// Canonical month key stored in SQLite: `YYYY-MM`.
String monthKey(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}';

String currentMonthKey() => monthKey(DateTime.now());

DateTime monthStart(String key) {
  final parts = key.split('-');
  final year = int.parse(parts[0]);
  final month = int.parse(parts[1]);
  return DateTime(year, month);
}

/// Exclusive upper bound for a month key.
DateTime monthEnd(String key) {
  final start = monthStart(key);
  return DateTime(start.year, start.month + 1);
}

String shiftMonth(String key, int delta) {
  final start = monthStart(key);
  return monthKey(DateTime(start.year, start.month + delta));
}

String monthLabel(String key) {
  final start = monthStart(key);
  final name = _monthNames[start.month - 1];
  return '${name[0].toUpperCase()}${name.substring(1)} ${start.year}';
}
