import '../../../../core/domain/domain_exception.dart';

enum AccountType {
  cash('Efectivo'),
  debit('Débito'),
  credit('Crédito'),
  savings('Ahorro');

  const AccountType(this.label);

  final String label;

  static AccountType fromDb(String value) {
    for (final type in values) {
      if (type.name == value) return type;
    }
    throw DomainException('Tipo de cuenta desconocido: $value');
  }
}

class Account {
  const Account({
    required this.id,
    required this.name,
    required this.type,
    required this.openingBalanceCents,
    required this.balanceCents,
    required this.archived,
  });

  final int id;
  final String name;
  final AccountType type;
  final int openingBalanceCents;
  final int balanceCents;
  final bool archived;
}
