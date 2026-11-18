import 'package:drift/drift.dart';

/// Database schema owned by the `core_db` module.
///
/// All monetary values are stored as integer cents. Tables are named after
/// their module vocabulary so SQL stays readable across modules.
@TableIndex(name: 'idx_movements_date_envelope', columns: {#date, #envelopeId})
@TableIndex(name: 'idx_movements_account', columns: {#accountId})
class MovementRows extends Table {
  @override
  String get tableName => 'movements';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId =>
      integer().references(AccountRows, #id, onDelete: KeyAction.restrict)();
  IntColumn get envelopeId => integer().nullable().references(
    EnvelopeRows,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get type => text().withLength(min: 1, max: 16)();
  IntColumn get amountCents => integer()();
  TextColumn get description => text().withLength(min: 1, max: 200)();
  DateTimeColumn get date => dateTime()();
  IntColumn get transferAccountId => integer().nullable().references(
    AccountRows,
    #id,
    onDelete: KeyAction.setNull,
  )();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@TableIndex(name: 'idx_accounts_archived', columns: {#archived})
class AccountRows extends Table {
  @override
  String get tableName => 'accounts';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  TextColumn get type => text().withLength(min: 1, max: 16)();
  IntColumn get openingBalanceCents => integer()();
  IntColumn get balanceCents => integer()();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class EnvelopeGroupRows extends Table {
  @override
  String get tableName => 'envelope_groups';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  TextColumn get colorHex => text().nullable().withLength(min: 6, max: 9)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class EnvelopeRows extends Table {
  @override
  String get tableName => 'envelopes';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get groupId => integer().references(
    EnvelopeGroupRows,
    #id,
    onDelete: KeyAction.restrict,
  )();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class EnvelopeAllocationRows extends Table {
  @override
  String get tableName => 'envelope_allocations';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get envelopeId =>
      integer().references(EnvelopeRows, #id, onDelete: KeyAction.cascade)();
  TextColumn get month => text().withLength(min: 7, max: 7)();
  IntColumn get assignedCents => integer().withDefault(const Constant(0))();
  IntColumn get spentCents => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {envelopeId, month},
  ];
}

class EnvelopeTransferRows extends Table {
  @override
  String get tableName => 'envelope_transfers';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get month => text().withLength(min: 7, max: 7)();
  IntColumn get fromEnvelopeId =>
      integer().references(EnvelopeRows, #id, onDelete: KeyAction.cascade)();
  IntColumn get toEnvelopeId =>
      integer().references(EnvelopeRows, #id, onDelete: KeyAction.cascade)();
  IntColumn get amountCents => integer()();
  TextColumn get note => text().nullable().withLength(max: 200)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@TableIndex(name: 'idx_rules_active_priority', columns: {#isActive, #priority})
class CategorisationRuleRows extends Table {
  @override
  String get tableName => 'categorisation_rules';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get pattern => text().withLength(min: 1, max: 100)();
  IntColumn get envelopeId =>
      integer().references(EnvelopeRows, #id, onDelete: KeyAction.cascade)();
  IntColumn get priority => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class AppSettingRows extends Table {
  @override
  String get tableName => 'app_settings';

  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
