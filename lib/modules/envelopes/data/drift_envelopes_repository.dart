import 'package:drift/drift.dart';

import '../../../../core/domain/domain_exception.dart';
import '../../../../core/money/money.dart';
import '../../../../core/time/months.dart';
import '../../core_db/core_db.dart';
import '../domain/envelope.dart';
import '../domain/envelopes_repository.dart';

class DriftEnvelopesRepository implements EnvelopesRepository {
  DriftEnvelopesRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<List<EnvelopeGroup>> watchGroups() {
    final query = _db.select(_db.envelopeGroupRows)
      ..orderBy([
        (row) => OrderingTerm.asc(row.sortOrder),
        (row) => OrderingTerm.asc(row.name),
      ]);
    return query.watch().map(
      (rows) => rows
          .map(
            (row) => EnvelopeGroup(
              id: row.id,
              name: row.name,
              colorHex: row.colorHex,
              sortOrder: row.sortOrder,
            ),
          )
          .toList(growable: false),
    );
  }

  @override
  Stream<List<EnvelopeBudget>> watchMonth(String month) {
    _validateMonth(month);
    const sql = '''
SELECT e.id AS envelope_id,
       e.group_id AS group_id,
       g.name AS group_name,
       e.name AS name,
       COALESCE(a.assigned_cents, 0) AS assigned_cents,
       COALESCE(a.spent_cents, 0) AS spent_cents
FROM envelopes e
JOIN envelope_groups g ON g.id = e.group_id
LEFT JOIN envelope_allocations a
       ON a.envelope_id = e.id AND a.month = ?
WHERE e.archived = 0
ORDER BY g.sort_order, g.name, e.sort_order, e.name
''';
    return _db
        .customSelect(
          sql,
          variables: [Variable.withString(month)],
          readsFrom: {
            _db.envelopeRows,
            _db.envelopeGroupRows,
            _db.envelopeAllocationRows,
          },
        )
        .watch()
        .map(
          (rows) => rows
              .map(
                (row) => EnvelopeBudget(
                  envelopeId: row.read<int>('envelope_id'),
                  groupId: row.read<int>('group_id'),
                  groupName: row.read<String>('group_name'),
                  name: row.read<String>('name'),
                  assignedCents: row.read<int>('assigned_cents'),
                  spentCents: row.read<int>('spent_cents'),
                ),
              )
              .toList(growable: false),
        );
  }

  @override
  Stream<int> watchToAssign() {
    const sql = '''
SELECT
  (SELECT COALESCE(SUM(amount_cents), 0) FROM movements WHERE type = 'income')
  -
  (SELECT COALESCE(SUM(assigned_cents), 0) FROM envelope_allocations) AS to_assign
''';
    return _db
        .customSelect(
          sql,
          readsFrom: {_db.movementRows, _db.envelopeAllocationRows},
        )
        .watchSingle()
        .map((row) => row.read<int>('to_assign'));
  }

  @override
  Future<int> createGroup(String name) async {
    final cleanName = name.trim();
    if (cleanName.isEmpty) {
      throw const DomainException('El nombre del grupo es obligatorio.');
    }
    final existing =
        await (_db.select(
              _db.envelopeGroupRows,
            )..where((row) => row.name.lower().equals(cleanName.toLowerCase())))
            .getSingleOrNull();
    if (existing != null) {
      throw const DomainException('Ya existe un grupo con ese nombre.');
    }
    return _db
        .into(_db.envelopeGroupRows)
        .insert(EnvelopeGroupRowsCompanion.insert(name: cleanName));
  }

  @override
  Future<int> createEnvelope({
    required int groupId,
    required String name,
  }) async {
    final cleanName = name.trim();
    if (cleanName.isEmpty) {
      throw const DomainException('El nombre del sobre es obligatorio.');
    }
    final group = await (_db.select(
      _db.envelopeGroupRows,
    )..where((row) => row.id.equals(groupId))).getSingleOrNull();
    if (group == null) {
      throw const DomainException('El grupo no existe.');
    }
    final existing =
        await (_db.select(_db.envelopeRows)..where(
              (row) =>
                  row.groupId.equals(groupId) &
                  row.name.lower().equals(cleanName.toLowerCase()),
            ))
            .getSingleOrNull();
    if (existing != null) {
      throw const DomainException('Ya existe un sobre con ese nombre.');
    }
    return _db
        .into(_db.envelopeRows)
        .insert(
          EnvelopeRowsCompanion.insert(groupId: groupId, name: cleanName),
        );
  }

  @override
  Future<void> assign({
    required String month,
    required int envelopeId,
    required int deltaCents,
  }) async {
    _validateMonth(month);
    if (deltaCents == 0) {
      throw const DomainException(
        'El monto a asignar debe ser distinto de cero.',
      );
    }
    await _db.transaction(() async {
      await _requireEnvelope(envelopeId);
      final allocation = await _allocation(envelopeId, month);
      final currentAssigned = allocation?.assignedCents ?? 0;
      final nextAssigned = currentAssigned + deltaCents;
      if (nextAssigned < 0) {
        throw const DomainException(
          'No puedes retirar más de lo asignado en este sobre.',
        );
      }
      if (deltaCents > 0) {
        final toAssign = await _readToAssign();
        if (deltaCents > toAssign) {
          throw DomainException(
            'Solo tienes ${formatCents(toAssign)} por asignar.',
          );
        }
      }
      if (allocation == null) {
        await _db
            .into(_db.envelopeAllocationRows)
            .insert(
              EnvelopeAllocationRowsCompanion.insert(
                envelopeId: envelopeId,
                month: month,
                assignedCents: Value(nextAssigned),
              ),
            );
      } else {
        await (_db.update(
          _db.envelopeAllocationRows,
        )..where((row) => row.id.equals(allocation.id))).write(
          EnvelopeAllocationRowsCompanion(assignedCents: Value(nextAssigned)),
        );
      }
    });
  }

  @override
  Future<void> moveBetweenEnvelopes({
    required String month,
    required int fromEnvelopeId,
    required int toEnvelopeId,
    required int amountCents,
    String? note,
  }) async {
    _validateMonth(month);
    if (amountCents <= 0) {
      throw const DomainException('El monto debe ser mayor que cero.');
    }
    if (fromEnvelopeId == toEnvelopeId) {
      throw const DomainException('Elige dos sobres distintos.');
    }
    await _db.transaction(() async {
      await _requireEnvelope(fromEnvelopeId);
      await _requireEnvelope(toEnvelopeId);
      final source = await _allocation(fromEnvelopeId, month);
      final sourceAvailable =
          (source?.assignedCents ?? 0) - (source?.spentCents ?? 0);
      if (sourceAvailable < amountCents) {
        throw DomainException(
          'Ese sobre solo tiene ${formatCents(sourceAvailable)} disponibles.',
        );
      }
      final target = await _allocation(toEnvelopeId, month);
      await _writeAssigned(
        fromEnvelopeId,
        month,
        (source?.assignedCents ?? 0) - amountCents,
        source,
      );
      await _writeAssigned(
        toEnvelopeId,
        month,
        (target?.assignedCents ?? 0) + amountCents,
        target,
      );
      await _db
          .into(_db.envelopeTransferRows)
          .insert(
            EnvelopeTransferRowsCompanion.insert(
              month: month,
              fromEnvelopeId: fromEnvelopeId,
              toEnvelopeId: toEnvelopeId,
              amountCents: amountCents,
              note: Value(_cleanNote(note)),
            ),
          );
    });
  }

  Future<EnvelopeRow> _requireEnvelope(int envelopeId) async {
    final envelope =
        await (_db.select(_db.envelopeRows)..where(
              (row) => row.id.equals(envelopeId) & row.archived.equals(false),
            ))
            .getSingleOrNull();
    if (envelope == null) {
      throw const DomainException('El sobre no existe o está archivado.');
    }
    return envelope;
  }

  Future<EnvelopeAllocationRow?> _allocation(int envelopeId, String month) {
    return (_db.select(_db.envelopeAllocationRows)..where(
          (row) => row.envelopeId.equals(envelopeId) & row.month.equals(month),
        ))
        .getSingleOrNull();
  }

  Future<void> _writeAssigned(
    int envelopeId,
    String month,
    int assignedCents,
    EnvelopeAllocationRow? existing,
  ) async {
    if (existing == null) {
      await _db
          .into(_db.envelopeAllocationRows)
          .insert(
            EnvelopeAllocationRowsCompanion.insert(
              envelopeId: envelopeId,
              month: month,
              assignedCents: Value(assignedCents),
            ),
          );
      return;
    }
    await (_db.update(
      _db.envelopeAllocationRows,
    )..where((row) => row.id.equals(existing.id))).write(
      EnvelopeAllocationRowsCompanion(assignedCents: Value(assignedCents)),
    );
  }

  Future<int> _readToAssign() async {
    const sql = '''
SELECT
  (SELECT COALESCE(SUM(amount_cents), 0) FROM movements WHERE type = 'income')
  -
  (SELECT COALESCE(SUM(assigned_cents), 0) FROM envelope_allocations) AS to_assign
''';
    final row = await _db.customSelect(sql).getSingle();
    return row.read<int>('to_assign');
  }

  void _validateMonth(String month) {
    if (!RegExp(r'^\d{4}-\d{2}$').hasMatch(month) ||
        monthKey(monthStart(month)) != month) {
      throw DomainException('Mes inválido: $month');
    }
  }
}

String? _cleanNote(String? note) {
  final clean = note?.trim();
  return clean == null || clean.isEmpty ? null : clean;
}
