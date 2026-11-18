import 'package:intl/intl.dart';

/// Display-only currency formatting. Persistence always uses integer cents.
const String kCurrencySymbol = r'$';

final NumberFormat _formatter = NumberFormat.currency(
  locale: 'en_US',
  symbol: kCurrencySymbol,
  decimalDigits: 2,
);

String formatCents(int cents) => _formatter.format(cents / 100);

/// Parses user input such as `1,234.56` or `12,34` into cents.
///
/// Returns null when the input is not a non-negative amount with at most two
/// decimal places.
int? parseCents(String raw) {
  var value = raw.trim().replaceAll(RegExp(r'[^0-9.,]'), '');
  if (value.isEmpty) return null;
  if (value.contains(',') && value.contains('.')) {
    value = value.replaceAll(',', '');
  }
  value = value.replaceAll(',', '.');
  final parts = value.split('.');
  if (parts.length > 2) return null;
  final whole = parts.first.isEmpty ? '0' : parts.first;
  final decimals = parts.length == 2 ? parts[1] : '';
  if (decimals.length > 2) return null;
  final wholeValue = int.tryParse(whole);
  if (wholeValue == null) return null;
  final cents = int.tryParse(decimals.padRight(2, '0'));
  if (cents == null) return null;
  return wholeValue * 100 + cents;
}
