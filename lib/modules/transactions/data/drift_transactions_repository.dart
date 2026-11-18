import 'package:drift/drift.dart';

import '../../../../core/domain/domain_exception.dart';
import '../../../../core/time/months.dart';
import '../../core_db/core_db.dart';
import '../domain/movement.dart';
import '../domain/transactions_repository.dart';

class DriftTransactionsRepository implements TransactionsRepository {
  DriftTransactionsRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<List<MovementView>> watchMovements({
    DateTime? from,
    DateTime? to,
    String query = '',
  }) {
    final transferAccount = _db.alias(_db.accountRows, 'transfer_account');
    final statement =
        _db.select(_db.movementRows).join([
          innerJoin(
            _db.accountRows,
            _db.accountRows.id.equalsExp(_db.movementRows.accountId),
          ),
          leftOuterJoin(
            _db.envelopeRows,
            _db.envelopeRows.id.equalsExp(_db.movementRows.envelopeId),
          ),
          leftOuterJoin(
            transferAccount,
            transferAccount.id.equalsExp(_db.movementRows.transferAccountId),
          ),
        ])..orderBy([
          OrderingTerm.desc(_db.movementRows.date),
          OrderingTerm.desc(_db.movementRows.id),
        ]);

    if (from != null) {
      statement.where(_db.movementRows.date.isBiggerOrEqualValue(from));
    }
    if (to != null) {
      statement.where(_db.movementRows.date.isSmallerThanValue(to));
    }
    final cleanQuery = query.trim();
    if (cleanQuery.isNotEmpty) {
      final escaped = cleanQuery
          .replaceAll(r'\', r'\\')
          .replaceAll('%', r'\%')
          .replaceAll('_', r'\_');
      final pattern = '%$escaped%';
      statement.where(
        _db.movementRows.description.like(pattern, escapeChar: r'\') |
            _db.accountRows.name.like(pattern, escapeChar: r'\') |
            _db.envelopeRows.name.like(pattern, escapeChar: r'\'),
      );
    }

    return statement.watch().map(
      (rows) => rows
          .map((row) {
            final movement = row.readTable(_db.movementRows);
            final account = row.readTable(_db.accountRows);
            final envelope = row.readTableOrNull(_db.envelopeRows);
            final transfer = row.readTableOrNull(transferAccount);
            return MovementView(
              movement: _toDomain(movement),
              accountName: account.name,
              envelopeName: envelope?.name,
              transferAccountName: transfer?.name,
            );
          })
          .toList(growable: false),
    );
  }

  @override
  Stream<List<CategorisationRule>> watchRules() {
    final query = _db.select(_db.categorisationRuleRows)
      ..orderBy([
        (row) => OrderingTerm.asc(row.priority),
        (row) => OrderingTerm.asc(row.id),
      ]);
    return query.watch().map(
      (rows) => rows
          .map(
            (row) => CategorisationRule(
              id: row.id,
              pattern: row.pattern,
              envelopeId: row.envelopeId,
              priority: row.priority,
              isActive: row.isActive,
            ),
          )
          .toList(growable: false),
    );
  }

  @override
  Future<MoneyMovement> recordExpense({
    required int accountId,
    int? envelopeId,
    required int amountCents,
    required String description,
    required DateTime date,
    bool applyRules = true,
  }) async {
    _requirePositive(amountCents);
    final cleanDescription = _cleanDescription(description);
    return _db.transaction(() async {
      var targetEnvelopeId = envelopeId;
      if (targetEnvelopeId != null) {
        await _requireActiveEnvelope(targetEnvelopeId);
      } else if (applyRules) {
        targetEnvelopeId = await _matchRule(cleanDescription);
      }
      final affected = await _db.customUpdate(
        'UPDATE accounts SET balance_cents = balance_cents - ? '
        'WHERE id = ? AND archived = 0',
        variables: [Variable.withInt(amountCents), Variable.withInt(accountId)],
        updates: {_db.accountRows},
      );
      if (affected != 1) {
        throw const DomainException('La cuenta no existe o está archivada.');
      }
      final id = await _db
          .into(_db.movementRows)
          .insert(
            MovementRowsCompanion.insert(
              accountId: accountId,
              envelopeId: Value(targetEnvelopeId),
              type: MovementType.expense.name,
              amountCents: amountCents,
              description: cleanDescription,
              date: date,
            ),
          );
      if (targetEnvelopeId != null) {
        await _db.customUpdate(
          'INSERT INTO envelope_allocations '
          '(envelope_id, month, assigned_cents, spent_cents) VALUES (?, ?, 0, ?) '
          'ON CONFLICT(envelope_id, month) DO UPDATE SET '
          'spent_cents = spent_cents + excluded.spent_cents',
          variables: [
            Variable.withInt(targetEnvelopeId),
            Variable.withString(monthKey(date)),
            Variable.withInt(amountCents),
          ],
          updates: {_db.envelopeAllocationRows},
        );
      }
      return MoneyMovement(
        id: id,
        accountId: accountId,
        envelopeId: targetEnvelopeId,
        type: MovementType.expense,
        amountCents: amountCents,
        description: cleanDescription,
        date: date,
        transferAccountId: null,
      );
    });
  }

  @override
  Future<MoneyMovement> recordIncome({
    required int accountId,
    required int amountCents,
    required String description,
    required DateTime date,
  }) async {
    _requirePositive(amountCents);
    final cleanDescription = _cleanDescription(description);
    return _db.transaction(() async {
      final affected = await _db.customUpdate(
        'UPDATE accounts SET balance_cents = balance_cents + ? '
        'WHERE id = ? AND archived = 0',
        variables: [Variable.withInt(amountCents), Variable.withInt(accountId)],
        updates: {_db.accountRows},
      );
      if (affected != 1) {
        throw const DomainException('La cuenta no existe o está archivada.');
      }
      final id = await _db
          .into(_db.movementRows)
          .insert(
            MovementRowsCompanion.insert(
              accountId: accountId,
              type: MovementType.income.name,
              amountCents: amountCents,
              description: cleanDescription,
              date: date,
            ),
          );
      return MoneyMovement(
        id: id,
        accountId: accountId,
        envelopeId: null,
        type: MovementType.income,
        amountCents: amountCents,
        description: cleanDescription,
        date: date,
        transferAccountId: null,
      );
    });
  }

  @override
  Future<MoneyMovement> recordTransfer({
    required int fromAccountId,
    required int toAccountId,
    required int amountCents,
    required String description,
    required DateTime date,
  }) async {
    if (fromAccountId == toAccountId) {
      throw const DomainException('Elige dos cuentas distintas.');
    }
    _requirePositive(amountCents);
    final cleanDescription = _cleanDescription(description);
    return _db.transaction(() async {
      final debited = await _db.customUpdate(
        'UPDATE accounts SET balance_cents = balance_cents - ? '
        'WHERE id = ? AND archived = 0',
        variables: [
          Variable.withInt(amountCents),
          Variable.withInt(fromAccountId),
        ],
        updates: {_db.accountRows},
      );
      if (debited != 1) {
        throw const DomainException('La cuenta de origen no existe.');
      }
      final credited = await _db.customUpdate(
        'UPDATE accounts SET balance_cents = balance_cents + ? '
        'WHERE id = ? AND archived = 0',
        variables: [
          Variable.withInt(amountCents),
          Variable.withInt(toAccountId),
        ],
        updates: {_db.accountRows},
      );
      if (credited != 1) {
        throw const DomainException('La cuenta de destino no existe.');
      }
      final id = await _db
          .into(_db.movementRows)
          .insert(
            MovementRowsCompanion.insert(
              accountId: fromAccountId,
              type: MovementType.transfer.name,
              amountCents: amountCents,
              description: cleanDescription,
              date: date,
              transferAccountId: Value(toAccountId),
            ),
          );
      return MoneyMovement(
        id: id,
        accountId: fromAccountId,
        envelopeId: null,
        type: MovementType.transfer,
        amountCents: amountCents,
        description: cleanDescription,
        date: date,
        transferAccountId: toAccountId,
      );
    });
  }

  @override
  Future<int?> suggestEnvelope(String description) async {
    final cleanDescription = description.trim();
    if (cleanDescription.isEmpty) return null;
    return _matchRule(cleanDescription);
  }

  @override
  Future<void> saveRule({
    int? id,
    required String pattern,
    required int envelopeId,
    int priority = 0,
    bool isActive = true,
  }) async {
    final cleanPattern = pattern.trim();
    if (cleanPattern.isEmpty) {
      throw const DomainException('La regla necesita un texto a buscar.');
    }
    if (cleanPattern.length > 100) {
      throw const DomainException('La regla es demasiado larga.');
    }
    await _requireActiveEnvelope(envelopeId);
    if (id == null) {
      await _db
          .into(_db.categorisationRuleRows)
          .insert(
            CategorisationRuleRowsCompanion.insert(
              pattern: cleanPattern,
              envelopeId: envelopeId,
              priority: Value(priority),
              isActive: Value(isActive),
            ),
          );
      return;
    }
    final changed =
        await (_db.update(
          _db.categorisationRuleRows,
        )..where((row) => row.id.equals(id))).write(
          CategorisationRuleRowsCompanion(
            pattern: Value(cleanPattern),
            envelopeId: Value(envelopeId),
            priority: Value(priority),
            isActive: Value(isActive),
          ),
        );
    if (changed == 0) {
      throw const DomainException('La regla no existe.');
    }
  }

  @override
  Future<void> deleteRule(int id) async {
    await (_db.delete(
      _db.categorisationRuleRows,
    )..where((row) => row.id.equals(id))).go();
  }

  Future<int?> _matchRule(String description) async {
    final query =
        _db.select(_db.categorisationRuleRows).join([
          innerJoin(
            _db.envelopeRows,
            _db.envelopeRows.id.equalsExp(
                  _db.categorisationRuleRows.envelopeId,
                ) &
                _db.envelopeRows.archived.equals(false),
          ),
        ])..orderBy([
          OrderingTerm.asc(_db.categorisationRuleRows.priority),
          OrderingTerm.asc(_db.categorisationRuleRows.id),
        ]);
    query.where(_db.categorisationRuleRows.isActive.equals(true));
    final rows = await query.get();
    final needle = description.toLowerCase();
    for (final row in rows) {
      final rule = row.readTable(_db.categorisationRuleRows);
      if (needle.contains(rule.pattern.toLowerCase())) {
        return rule.envelopeId;
      }
    }
    return null;
  }

  Future<void> _requireActiveEnvelope(int envelopeId) async {
    final envelope =
        await (_db.select(_db.envelopeRows)..where(
              (row) => row.id.equals(envelopeId) & row.archived.equals(false),
            ))
            .getSingleOrNull();
    if (envelope == null) {
      throw const DomainException('El sobre no existe o está archivado.');
    }
  }

  void _requirePositive(int amountCents) {
    if (amountCents <= 0) {
      throw const DomainException('El monto debe ser mayor que cero.');
    }
  }

  String _cleanDescription(String description) {
    final clean = description.trim();
    if (clean.isEmpty) {
      throw const DomainException('La descripción es obligatoria.');
    }
    if (clean.length > 200) {
      throw const DomainException('La descripción es demasiado larga.');
    }
    return clean;
  }

  MoneyMovement _toDomain(MovementRow row) {
    return MoneyMovement(
      id: row.id,
      accountId: row.accountId,
      envelopeId: row.envelopeId,
      type: MovementType.fromDb(row.type),
      amountCents: row.amountCents,
      description: row.description,
      date: row.date,
      transferAccountId: row.transferAccountId,
    );
  }
}
