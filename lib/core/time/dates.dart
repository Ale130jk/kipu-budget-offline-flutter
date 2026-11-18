bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

String formatShortDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}

String friendlyDayLabel(DateTime date, {DateTime? now}) {
  final today = now ?? DateTime.now();
  if (isSameDay(date, today)) return 'Hoy';
  if (isSameDay(date, DateTime(today.year, today.month, today.day - 1))) {
    return 'Ayer';
  }
  return formatShortDate(date);
}
