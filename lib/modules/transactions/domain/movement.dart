import '../../../../core/domain/domain_exception.dart';

enum MovementType {
  income('Ingreso'),
  expense('Gasto'),
  transfer('Transferencia');

  const MovementType(this.label);

  final String label;

  static MovementType fromDb(String value) {
    for (final type in values) {
      if (type.name == value) return type;
    }
    throw DomainException('Tipo de movimiento desconocido: $value');
  }
}

class MoneyMovement {
  const MoneyMovement({
    required this.id,
    required this.accountId,
    required this.envelopeId,
    required this.type,
    required this.amountCents,
    required this.description,
    required this.date,
    required this.transferAccountId,
  });

  final int id;
  final int accountId;
  final int? envelopeId;
  final MovementType type;
  final int amountCents;
  final String description;
  final DateTime date;
  final int? transferAccountId;
}

/// Movement joined with the display names needed by the UI.
class MovementView {
  const MovementView({
    required this.movement,
    required this.accountName,
    required this.envelopeName,
    required this.transferAccountName,
  });

  final MoneyMovement movement;
  final String accountName;
  final String? envelopeName;
  final String? transferAccountName;
}

class CategorisationRule {
  const CategorisationRule({
    required this.id,
    required this.pattern,
    required this.envelopeId,
    required this.priority,
    required this.isActive,
  });

  final int id;
  final String pattern;
  final int envelopeId;
  final int priority;
  final bool isActive;
}
