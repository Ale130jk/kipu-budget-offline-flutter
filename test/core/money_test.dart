import 'package:flutter_test/flutter_test.dart';
import 'package:kipu_budget/core/money/money.dart';

void main() {
  test('parseCents accepts dot and comma decimals', () {
    expect(parseCents('12.34'), 1234);
    expect(parseCents('12,34'), 1234);
    expect(parseCents('1,234.56'), 123456);
    expect(parseCents('7'), 700);
    expect(parseCents('0.5'), 50);
  });

  test('parseCents rejects invalid input', () {
    expect(parseCents(''), isNull);
    expect(parseCents('12.345'), isNull);
    expect(parseCents('abc'), isNull);
    expect(parseCents('1.2.3'), isNull);
  });

  test('formatCents renders cents without floating point drift', () {
    expect(formatCents(1234), r'$12.34');
    expect(formatCents(0), r'$0.00');
    expect(formatCents(-500), r'-$5.00');
  });
}
