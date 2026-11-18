import '../../transactions/domain/movement.dart';

class MonthlyEnvelopeRow {
  const MonthlyEnvelopeRow({
    required this.groupName,
    required this.name,
    required this.assignedCents,
    required this.spentCents,
  });

  final String groupName;
  final String name;
  final int assignedCents;
  final int spentCents;

  int get availableCents => assignedCents - spentCents;
}

class ReportMovement {
  const ReportMovement({
    required this.date,
    required this.description,
    required this.type,
    required this.amountCents,
    required this.accountName,
    required this.envelopeName,
    required this.transferAccountName,
  });

  final DateTime date;
  final String description;
  final MovementType type;
  final int amountCents;
  final String accountName;
  final String? envelopeName;
  final String? transferAccountName;
}

class MonthlyReport {
  const MonthlyReport({
    required this.month,
    required this.assetsCents,
    required this.incomeCents,
    required this.expenseCents,
    required this.envelopes,
    required this.movements,
  });

  final String month;
  final int assetsCents;
  final int incomeCents;
  final int expenseCents;
  final List<MonthlyEnvelopeRow> envelopes;
  final List<ReportMovement> movements;

  int get netCents => incomeCents - expenseCents;
}

class MonthlyCashFlow {
  const MonthlyCashFlow({
    required this.month,
    required this.incomeCents,
    required this.expenseCents,
  });

  final String month;
  final int incomeCents;
  final int expenseCents;
}
