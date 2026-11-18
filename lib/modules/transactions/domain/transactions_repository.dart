import 'movement.dart';

/// Public seam of the transactions module.
abstract interface class TransactionsRepository {
  /// [from] is inclusive, [to] is exclusive.
  Stream<List<MovementView>> watchMovements({
    DateTime? from,
    DateTime? to,
    String query = '',
  });

  Stream<List<CategorisationRule>> watchRules();

  Future<MoneyMovement> recordExpense({
    required int accountId,
    int? envelopeId,
    required int amountCents,
    required String description,
    required DateTime date,
  });

  Future<MoneyMovement> recordIncome({
    required int accountId,
    required int amountCents,
    required String description,
    required DateTime date,
  });

  Future<MoneyMovement> recordTransfer({
    required int fromAccountId,
    required int toAccountId,
    required int amountCents,
    required String description,
    required DateTime date,
  });

  /// First active rule whose pattern is contained in [description].
  Future<int?> suggestEnvelope(String description);

  Future<void> saveRule({
    int? id,
    required String pattern,
    required int envelopeId,
    int priority = 0,
    bool isActive = true,
  });

  Future<void> deleteRule(int id);
}
