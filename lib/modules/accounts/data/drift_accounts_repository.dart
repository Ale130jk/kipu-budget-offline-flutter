import 'package:drift/drift.dart';

import '../../../../core/domain/domain_exception.dart';
import '../../core_db/core_db.dart';
import '../domain/account.dart';
import '../domain/accounts_repository.dart';

class DriftAccountsRepository implements AccountsRepository {
  DriftAccountsRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Account>> watchAccounts() {
    final query = _db.select(_db.accountRows)
      ..orderBy([(row) => OrderingTerm.asc(row.createdAt)]);
    return query.watch().map(
      (rows) => rows.map(_toDomain).toList(growable: false),
    );
  }

  @override
  Future<Account> createAccount({
    required String name,
    required AccountType type,
    required int openingBalanceCents,
  }) async {
    final cleanName = name.trim();
    if (cleanName.isEmpty) {
      throw const DomainException('El nombre de la cuenta es obligatorio.');
    }
    final id = await _db
        .into(_db.accountRows)
        .insert(
          AccountRowsCompanion.insert(
            name: cleanName,
            type: type.name,
            openingBalanceCents: openingBalanceCents,
            balanceCents: openingBalanceCents,
          ),
        );
    return Account(
      id: id,
      name: cleanName,
      type: type,
      openingBalanceCents: openingBalanceCents,
      balanceCents: openingBalanceCents,
      archived: false,
    );
  }

  @override
  Future<void> setArchived(int accountId, bool archived) async {
    if (archived) {
      final active =
          await (_db.selectOnly(_db.accountRows)
                ..addColumns([_db.accountRows.id.count()])
                ..where(_db.accountRows.archived.equals(false)))
              .getSingle();
      final activeCount = active.read(_db.accountRows.id.count()) ?? 0;
      if (activeCount <= 1) {
        throw const DomainException(
          'Debes conservar al menos una cuenta activa.',
        );
      }
    }
    final changed =
        await (_db.update(_db.accountRows)
              ..where((row) => row.id.equals(accountId)))
            .write(AccountRowsCompanion(archived: Value(archived)));
    if (changed == 0) {
      throw const DomainException('La cuenta no existe.');
    }
  }

  Account _toDomain(AccountRow row) {
    return Account(
      id: row.id,
      name: row.name,
      type: AccountType.fromDb(row.type),
      openingBalanceCents: row.openingBalanceCents,
      balanceCents: row.balanceCents,
      archived: row.archived,
    );
  }
}
