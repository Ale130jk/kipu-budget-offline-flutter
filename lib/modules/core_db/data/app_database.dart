import 'package:drift/drift.dart';

import 'tables.dart';

part 'app_database.g.dart';

/// Single SQLite database shared by every module.
///
/// Modules never open their own connection: they receive this instance and
/// only touch their own tables, except read-only aggregations in `reports`.
@DriftDatabase(
  tables: [
    AccountRows,
    MovementRows,
    EnvelopeGroupRows,
    EnvelopeRows,
    EnvelopeAllocationRows,
    EnvelopeTransferRows,
    CategorisationRuleRows,
    AppSettingRows,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    beforeOpen: (OpeningDetails details) async {
      // SQLite disables foreign keys per connection: re-enable on every open.
      await customStatement('PRAGMA foreign_keys = ON');
      await customStatement('PRAGMA busy_timeout = 5000');
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Versioned migrations: append guarded steps here when schemaVersion
      // grows. Each step must be idempotent for interrupted upgrades.
      if (from < 1) {
        throw StateError('Unsupported schema version: $from');
      }
    },
  );
}
