// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AccountRowsTable extends AccountRows
    with TableInfo<$AccountRowsTable, AccountRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 16,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _openingBalanceCentsMeta =
      const VerificationMeta('openingBalanceCents');
  @override
  late final GeneratedColumn<int> openingBalanceCents = GeneratedColumn<int>(
    'opening_balance_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _balanceCentsMeta = const VerificationMeta(
    'balanceCents',
  );
  @override
  late final GeneratedColumn<int> balanceCents = GeneratedColumn<int>(
    'balance_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    openingBalanceCents,
    balanceCents,
    archived,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccountRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('opening_balance_cents')) {
      context.handle(
        _openingBalanceCentsMeta,
        openingBalanceCents.isAcceptableOrUnknown(
          data['opening_balance_cents']!,
          _openingBalanceCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_openingBalanceCentsMeta);
    }
    if (data.containsKey('balance_cents')) {
      context.handle(
        _balanceCentsMeta,
        balanceCents.isAcceptableOrUnknown(
          data['balance_cents']!,
          _balanceCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_balanceCentsMeta);
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      openingBalanceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}opening_balance_cents'],
      )!,
      balanceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}balance_cents'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AccountRowsTable createAlias(String alias) {
    return $AccountRowsTable(attachedDatabase, alias);
  }
}

class AccountRow extends DataClass implements Insertable<AccountRow> {
  final int id;
  final String name;
  final String type;
  final int openingBalanceCents;
  final int balanceCents;
  final bool archived;
  final DateTime createdAt;
  const AccountRow({
    required this.id,
    required this.name,
    required this.type,
    required this.openingBalanceCents,
    required this.balanceCents,
    required this.archived,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['opening_balance_cents'] = Variable<int>(openingBalanceCents);
    map['balance_cents'] = Variable<int>(balanceCents);
    map['archived'] = Variable<bool>(archived);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AccountRowsCompanion toCompanion(bool nullToAbsent) {
    return AccountRowsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      openingBalanceCents: Value(openingBalanceCents),
      balanceCents: Value(balanceCents),
      archived: Value(archived),
      createdAt: Value(createdAt),
    );
  }

  factory AccountRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      openingBalanceCents: serializer.fromJson<int>(
        json['openingBalanceCents'],
      ),
      balanceCents: serializer.fromJson<int>(json['balanceCents']),
      archived: serializer.fromJson<bool>(json['archived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'openingBalanceCents': serializer.toJson<int>(openingBalanceCents),
      'balanceCents': serializer.toJson<int>(balanceCents),
      'archived': serializer.toJson<bool>(archived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AccountRow copyWith({
    int? id,
    String? name,
    String? type,
    int? openingBalanceCents,
    int? balanceCents,
    bool? archived,
    DateTime? createdAt,
  }) => AccountRow(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    openingBalanceCents: openingBalanceCents ?? this.openingBalanceCents,
    balanceCents: balanceCents ?? this.balanceCents,
    archived: archived ?? this.archived,
    createdAt: createdAt ?? this.createdAt,
  );
  AccountRow copyWithCompanion(AccountRowsCompanion data) {
    return AccountRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      openingBalanceCents: data.openingBalanceCents.present
          ? data.openingBalanceCents.value
          : this.openingBalanceCents,
      balanceCents: data.balanceCents.present
          ? data.balanceCents.value
          : this.balanceCents,
      archived: data.archived.present ? data.archived.value : this.archived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('openingBalanceCents: $openingBalanceCents, ')
          ..write('balanceCents: $balanceCents, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    type,
    openingBalanceCents,
    balanceCents,
    archived,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.openingBalanceCents == this.openingBalanceCents &&
          other.balanceCents == this.balanceCents &&
          other.archived == this.archived &&
          other.createdAt == this.createdAt);
}

class AccountRowsCompanion extends UpdateCompanion<AccountRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> type;
  final Value<int> openingBalanceCents;
  final Value<int> balanceCents;
  final Value<bool> archived;
  final Value<DateTime> createdAt;
  const AccountRowsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.openingBalanceCents = const Value.absent(),
    this.balanceCents = const Value.absent(),
    this.archived = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AccountRowsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String type,
    required int openingBalanceCents,
    required int balanceCents,
    this.archived = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       type = Value(type),
       openingBalanceCents = Value(openingBalanceCents),
       balanceCents = Value(balanceCents);
  static Insertable<AccountRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<int>? openingBalanceCents,
    Expression<int>? balanceCents,
    Expression<bool>? archived,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (openingBalanceCents != null)
        'opening_balance_cents': openingBalanceCents,
      if (balanceCents != null) 'balance_cents': balanceCents,
      if (archived != null) 'archived': archived,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AccountRowsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? type,
    Value<int>? openingBalanceCents,
    Value<int>? balanceCents,
    Value<bool>? archived,
    Value<DateTime>? createdAt,
  }) {
    return AccountRowsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      openingBalanceCents: openingBalanceCents ?? this.openingBalanceCents,
      balanceCents: balanceCents ?? this.balanceCents,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (openingBalanceCents.present) {
      map['opening_balance_cents'] = Variable<int>(openingBalanceCents.value);
    }
    if (balanceCents.present) {
      map['balance_cents'] = Variable<int>(balanceCents.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountRowsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('openingBalanceCents: $openingBalanceCents, ')
          ..write('balanceCents: $balanceCents, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $EnvelopeGroupRowsTable extends EnvelopeGroupRows
    with TableInfo<$EnvelopeGroupRowsTable, EnvelopeGroupRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EnvelopeGroupRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 6,
      maxTextLength: 9,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    colorHex,
    sortOrder,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'envelope_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<EnvelopeGroupRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EnvelopeGroupRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EnvelopeGroupRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $EnvelopeGroupRowsTable createAlias(String alias) {
    return $EnvelopeGroupRowsTable(attachedDatabase, alias);
  }
}

class EnvelopeGroupRow extends DataClass
    implements Insertable<EnvelopeGroupRow> {
  final int id;
  final String name;
  final String? colorHex;
  final int sortOrder;
  final DateTime createdAt;
  const EnvelopeGroupRow({
    required this.id,
    required this.name,
    this.colorHex,
    required this.sortOrder,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || colorHex != null) {
      map['color_hex'] = Variable<String>(colorHex);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EnvelopeGroupRowsCompanion toCompanion(bool nullToAbsent) {
    return EnvelopeGroupRowsCompanion(
      id: Value(id),
      name: Value(name),
      colorHex: colorHex == null && nullToAbsent
          ? const Value.absent()
          : Value(colorHex),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
    );
  }

  factory EnvelopeGroupRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EnvelopeGroupRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      colorHex: serializer.fromJson<String?>(json['colorHex']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'colorHex': serializer.toJson<String?>(colorHex),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  EnvelopeGroupRow copyWith({
    int? id,
    String? name,
    Value<String?> colorHex = const Value.absent(),
    int? sortOrder,
    DateTime? createdAt,
  }) => EnvelopeGroupRow(
    id: id ?? this.id,
    name: name ?? this.name,
    colorHex: colorHex.present ? colorHex.value : this.colorHex,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
  );
  EnvelopeGroupRow copyWithCompanion(EnvelopeGroupRowsCompanion data) {
    return EnvelopeGroupRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EnvelopeGroupRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorHex: $colorHex, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, colorHex, sortOrder, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EnvelopeGroupRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.colorHex == this.colorHex &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt);
}

class EnvelopeGroupRowsCompanion extends UpdateCompanion<EnvelopeGroupRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> colorHex;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  const EnvelopeGroupRowsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  EnvelopeGroupRowsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.colorHex = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<EnvelopeGroupRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? colorHex,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (colorHex != null) 'color_hex': colorHex,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  EnvelopeGroupRowsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? colorHex,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
  }) {
    return EnvelopeGroupRowsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      colorHex: colorHex ?? this.colorHex,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EnvelopeGroupRowsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorHex: $colorHex, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $EnvelopeRowsTable extends EnvelopeRows
    with TableInfo<$EnvelopeRowsTable, EnvelopeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EnvelopeRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES envelope_groups (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    groupId,
    name,
    sortOrder,
    archived,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'envelopes';
  @override
  VerificationContext validateIntegrity(
    Insertable<EnvelopeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EnvelopeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EnvelopeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}group_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $EnvelopeRowsTable createAlias(String alias) {
    return $EnvelopeRowsTable(attachedDatabase, alias);
  }
}

class EnvelopeRow extends DataClass implements Insertable<EnvelopeRow> {
  final int id;
  final int groupId;
  final String name;
  final int sortOrder;
  final bool archived;
  final DateTime createdAt;
  const EnvelopeRow({
    required this.id,
    required this.groupId,
    required this.name,
    required this.sortOrder,
    required this.archived,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['group_id'] = Variable<int>(groupId);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    map['archived'] = Variable<bool>(archived);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EnvelopeRowsCompanion toCompanion(bool nullToAbsent) {
    return EnvelopeRowsCompanion(
      id: Value(id),
      groupId: Value(groupId),
      name: Value(name),
      sortOrder: Value(sortOrder),
      archived: Value(archived),
      createdAt: Value(createdAt),
    );
  }

  factory EnvelopeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EnvelopeRow(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<int>(json['groupId']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      archived: serializer.fromJson<bool>(json['archived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<int>(groupId),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'archived': serializer.toJson<bool>(archived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  EnvelopeRow copyWith({
    int? id,
    int? groupId,
    String? name,
    int? sortOrder,
    bool? archived,
    DateTime? createdAt,
  }) => EnvelopeRow(
    id: id ?? this.id,
    groupId: groupId ?? this.groupId,
    name: name ?? this.name,
    sortOrder: sortOrder ?? this.sortOrder,
    archived: archived ?? this.archived,
    createdAt: createdAt ?? this.createdAt,
  );
  EnvelopeRow copyWithCompanion(EnvelopeRowsCompanion data) {
    return EnvelopeRow(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      archived: data.archived.present ? data.archived.value : this.archived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EnvelopeRow(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, groupId, name, sortOrder, archived, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EnvelopeRow &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder &&
          other.archived == this.archived &&
          other.createdAt == this.createdAt);
}

class EnvelopeRowsCompanion extends UpdateCompanion<EnvelopeRow> {
  final Value<int> id;
  final Value<int> groupId;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<bool> archived;
  final Value<DateTime> createdAt;
  const EnvelopeRowsCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.archived = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  EnvelopeRowsCompanion.insert({
    this.id = const Value.absent(),
    required int groupId,
    required String name,
    this.sortOrder = const Value.absent(),
    this.archived = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : groupId = Value(groupId),
       name = Value(name);
  static Insertable<EnvelopeRow> custom({
    Expression<int>? id,
    Expression<int>? groupId,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<bool>? archived,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (archived != null) 'archived': archived,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  EnvelopeRowsCompanion copyWith({
    Value<int>? id,
    Value<int>? groupId,
    Value<String>? name,
    Value<int>? sortOrder,
    Value<bool>? archived,
    Value<DateTime>? createdAt,
  }) {
    return EnvelopeRowsCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EnvelopeRowsCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MovementRowsTable extends MovementRows
    with TableInfo<$MovementRowsTable, MovementRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MovementRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _envelopeIdMeta = const VerificationMeta(
    'envelopeId',
  );
  @override
  late final GeneratedColumn<int> envelopeId = GeneratedColumn<int>(
    'envelope_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES envelopes (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 16,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transferAccountIdMeta = const VerificationMeta(
    'transferAccountId',
  );
  @override
  late final GeneratedColumn<int> transferAccountId = GeneratedColumn<int>(
    'transfer_account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    envelopeId,
    type,
    amountCents,
    description,
    date,
    transferAccountId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'movements';
  @override
  VerificationContext validateIntegrity(
    Insertable<MovementRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('envelope_id')) {
      context.handle(
        _envelopeIdMeta,
        envelopeId.isAcceptableOrUnknown(data['envelope_id']!, _envelopeIdMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('transfer_account_id')) {
      context.handle(
        _transferAccountIdMeta,
        transferAccountId.isAcceptableOrUnknown(
          data['transfer_account_id']!,
          _transferAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MovementRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MovementRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      envelopeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}envelope_id'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      transferAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}transfer_account_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MovementRowsTable createAlias(String alias) {
    return $MovementRowsTable(attachedDatabase, alias);
  }
}

class MovementRow extends DataClass implements Insertable<MovementRow> {
  final int id;
  final int accountId;
  final int? envelopeId;
  final String type;
  final int amountCents;
  final String description;
  final DateTime date;
  final int? transferAccountId;
  final DateTime createdAt;
  const MovementRow({
    required this.id,
    required this.accountId,
    this.envelopeId,
    required this.type,
    required this.amountCents,
    required this.description,
    required this.date,
    this.transferAccountId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<int>(accountId);
    if (!nullToAbsent || envelopeId != null) {
      map['envelope_id'] = Variable<int>(envelopeId);
    }
    map['type'] = Variable<String>(type);
    map['amount_cents'] = Variable<int>(amountCents);
    map['description'] = Variable<String>(description);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || transferAccountId != null) {
      map['transfer_account_id'] = Variable<int>(transferAccountId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MovementRowsCompanion toCompanion(bool nullToAbsent) {
    return MovementRowsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      envelopeId: envelopeId == null && nullToAbsent
          ? const Value.absent()
          : Value(envelopeId),
      type: Value(type),
      amountCents: Value(amountCents),
      description: Value(description),
      date: Value(date),
      transferAccountId: transferAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(transferAccountId),
      createdAt: Value(createdAt),
    );
  }

  factory MovementRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MovementRow(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<int>(json['accountId']),
      envelopeId: serializer.fromJson<int?>(json['envelopeId']),
      type: serializer.fromJson<String>(json['type']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      description: serializer.fromJson<String>(json['description']),
      date: serializer.fromJson<DateTime>(json['date']),
      transferAccountId: serializer.fromJson<int?>(json['transferAccountId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountId': serializer.toJson<int>(accountId),
      'envelopeId': serializer.toJson<int?>(envelopeId),
      'type': serializer.toJson<String>(type),
      'amountCents': serializer.toJson<int>(amountCents),
      'description': serializer.toJson<String>(description),
      'date': serializer.toJson<DateTime>(date),
      'transferAccountId': serializer.toJson<int?>(transferAccountId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MovementRow copyWith({
    int? id,
    int? accountId,
    Value<int?> envelopeId = const Value.absent(),
    String? type,
    int? amountCents,
    String? description,
    DateTime? date,
    Value<int?> transferAccountId = const Value.absent(),
    DateTime? createdAt,
  }) => MovementRow(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    envelopeId: envelopeId.present ? envelopeId.value : this.envelopeId,
    type: type ?? this.type,
    amountCents: amountCents ?? this.amountCents,
    description: description ?? this.description,
    date: date ?? this.date,
    transferAccountId: transferAccountId.present
        ? transferAccountId.value
        : this.transferAccountId,
    createdAt: createdAt ?? this.createdAt,
  );
  MovementRow copyWithCompanion(MovementRowsCompanion data) {
    return MovementRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      envelopeId: data.envelopeId.present
          ? data.envelopeId.value
          : this.envelopeId,
      type: data.type.present ? data.type.value : this.type,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      description: data.description.present
          ? data.description.value
          : this.description,
      date: data.date.present ? data.date.value : this.date,
      transferAccountId: data.transferAccountId.present
          ? data.transferAccountId.value
          : this.transferAccountId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MovementRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('envelopeId: $envelopeId, ')
          ..write('type: $type, ')
          ..write('amountCents: $amountCents, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('transferAccountId: $transferAccountId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    envelopeId,
    type,
    amountCents,
    description,
    date,
    transferAccountId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MovementRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.envelopeId == this.envelopeId &&
          other.type == this.type &&
          other.amountCents == this.amountCents &&
          other.description == this.description &&
          other.date == this.date &&
          other.transferAccountId == this.transferAccountId &&
          other.createdAt == this.createdAt);
}

class MovementRowsCompanion extends UpdateCompanion<MovementRow> {
  final Value<int> id;
  final Value<int> accountId;
  final Value<int?> envelopeId;
  final Value<String> type;
  final Value<int> amountCents;
  final Value<String> description;
  final Value<DateTime> date;
  final Value<int?> transferAccountId;
  final Value<DateTime> createdAt;
  const MovementRowsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.envelopeId = const Value.absent(),
    this.type = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.description = const Value.absent(),
    this.date = const Value.absent(),
    this.transferAccountId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MovementRowsCompanion.insert({
    this.id = const Value.absent(),
    required int accountId,
    this.envelopeId = const Value.absent(),
    required String type,
    required int amountCents,
    required String description,
    required DateTime date,
    this.transferAccountId = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : accountId = Value(accountId),
       type = Value(type),
       amountCents = Value(amountCents),
       description = Value(description),
       date = Value(date);
  static Insertable<MovementRow> custom({
    Expression<int>? id,
    Expression<int>? accountId,
    Expression<int>? envelopeId,
    Expression<String>? type,
    Expression<int>? amountCents,
    Expression<String>? description,
    Expression<DateTime>? date,
    Expression<int>? transferAccountId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (envelopeId != null) 'envelope_id': envelopeId,
      if (type != null) 'type': type,
      if (amountCents != null) 'amount_cents': amountCents,
      if (description != null) 'description': description,
      if (date != null) 'date': date,
      if (transferAccountId != null) 'transfer_account_id': transferAccountId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MovementRowsCompanion copyWith({
    Value<int>? id,
    Value<int>? accountId,
    Value<int?>? envelopeId,
    Value<String>? type,
    Value<int>? amountCents,
    Value<String>? description,
    Value<DateTime>? date,
    Value<int?>? transferAccountId,
    Value<DateTime>? createdAt,
  }) {
    return MovementRowsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      envelopeId: envelopeId ?? this.envelopeId,
      type: type ?? this.type,
      amountCents: amountCents ?? this.amountCents,
      description: description ?? this.description,
      date: date ?? this.date,
      transferAccountId: transferAccountId ?? this.transferAccountId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (envelopeId.present) {
      map['envelope_id'] = Variable<int>(envelopeId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (transferAccountId.present) {
      map['transfer_account_id'] = Variable<int>(transferAccountId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MovementRowsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('envelopeId: $envelopeId, ')
          ..write('type: $type, ')
          ..write('amountCents: $amountCents, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('transferAccountId: $transferAccountId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $EnvelopeAllocationRowsTable extends EnvelopeAllocationRows
    with TableInfo<$EnvelopeAllocationRowsTable, EnvelopeAllocationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EnvelopeAllocationRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _envelopeIdMeta = const VerificationMeta(
    'envelopeId',
  );
  @override
  late final GeneratedColumn<int> envelopeId = GeneratedColumn<int>(
    'envelope_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES envelopes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<String> month = GeneratedColumn<String>(
    'month',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 7,
      maxTextLength: 7,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assignedCentsMeta = const VerificationMeta(
    'assignedCents',
  );
  @override
  late final GeneratedColumn<int> assignedCents = GeneratedColumn<int>(
    'assigned_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _spentCentsMeta = const VerificationMeta(
    'spentCents',
  );
  @override
  late final GeneratedColumn<int> spentCents = GeneratedColumn<int>(
    'spent_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    envelopeId,
    month,
    assignedCents,
    spentCents,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'envelope_allocations';
  @override
  VerificationContext validateIntegrity(
    Insertable<EnvelopeAllocationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('envelope_id')) {
      context.handle(
        _envelopeIdMeta,
        envelopeId.isAcceptableOrUnknown(data['envelope_id']!, _envelopeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_envelopeIdMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('assigned_cents')) {
      context.handle(
        _assignedCentsMeta,
        assignedCents.isAcceptableOrUnknown(
          data['assigned_cents']!,
          _assignedCentsMeta,
        ),
      );
    }
    if (data.containsKey('spent_cents')) {
      context.handle(
        _spentCentsMeta,
        spentCents.isAcceptableOrUnknown(data['spent_cents']!, _spentCentsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {envelopeId, month},
  ];
  @override
  EnvelopeAllocationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EnvelopeAllocationRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      envelopeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}envelope_id'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}month'],
      )!,
      assignedCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}assigned_cents'],
      )!,
      spentCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}spent_cents'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $EnvelopeAllocationRowsTable createAlias(String alias) {
    return $EnvelopeAllocationRowsTable(attachedDatabase, alias);
  }
}

class EnvelopeAllocationRow extends DataClass
    implements Insertable<EnvelopeAllocationRow> {
  final int id;
  final int envelopeId;
  final String month;
  final int assignedCents;
  final int spentCents;
  final DateTime createdAt;
  const EnvelopeAllocationRow({
    required this.id,
    required this.envelopeId,
    required this.month,
    required this.assignedCents,
    required this.spentCents,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['envelope_id'] = Variable<int>(envelopeId);
    map['month'] = Variable<String>(month);
    map['assigned_cents'] = Variable<int>(assignedCents);
    map['spent_cents'] = Variable<int>(spentCents);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EnvelopeAllocationRowsCompanion toCompanion(bool nullToAbsent) {
    return EnvelopeAllocationRowsCompanion(
      id: Value(id),
      envelopeId: Value(envelopeId),
      month: Value(month),
      assignedCents: Value(assignedCents),
      spentCents: Value(spentCents),
      createdAt: Value(createdAt),
    );
  }

  factory EnvelopeAllocationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EnvelopeAllocationRow(
      id: serializer.fromJson<int>(json['id']),
      envelopeId: serializer.fromJson<int>(json['envelopeId']),
      month: serializer.fromJson<String>(json['month']),
      assignedCents: serializer.fromJson<int>(json['assignedCents']),
      spentCents: serializer.fromJson<int>(json['spentCents']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'envelopeId': serializer.toJson<int>(envelopeId),
      'month': serializer.toJson<String>(month),
      'assignedCents': serializer.toJson<int>(assignedCents),
      'spentCents': serializer.toJson<int>(spentCents),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  EnvelopeAllocationRow copyWith({
    int? id,
    int? envelopeId,
    String? month,
    int? assignedCents,
    int? spentCents,
    DateTime? createdAt,
  }) => EnvelopeAllocationRow(
    id: id ?? this.id,
    envelopeId: envelopeId ?? this.envelopeId,
    month: month ?? this.month,
    assignedCents: assignedCents ?? this.assignedCents,
    spentCents: spentCents ?? this.spentCents,
    createdAt: createdAt ?? this.createdAt,
  );
  EnvelopeAllocationRow copyWithCompanion(
    EnvelopeAllocationRowsCompanion data,
  ) {
    return EnvelopeAllocationRow(
      id: data.id.present ? data.id.value : this.id,
      envelopeId: data.envelopeId.present
          ? data.envelopeId.value
          : this.envelopeId,
      month: data.month.present ? data.month.value : this.month,
      assignedCents: data.assignedCents.present
          ? data.assignedCents.value
          : this.assignedCents,
      spentCents: data.spentCents.present
          ? data.spentCents.value
          : this.spentCents,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EnvelopeAllocationRow(')
          ..write('id: $id, ')
          ..write('envelopeId: $envelopeId, ')
          ..write('month: $month, ')
          ..write('assignedCents: $assignedCents, ')
          ..write('spentCents: $spentCents, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, envelopeId, month, assignedCents, spentCents, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EnvelopeAllocationRow &&
          other.id == this.id &&
          other.envelopeId == this.envelopeId &&
          other.month == this.month &&
          other.assignedCents == this.assignedCents &&
          other.spentCents == this.spentCents &&
          other.createdAt == this.createdAt);
}

class EnvelopeAllocationRowsCompanion
    extends UpdateCompanion<EnvelopeAllocationRow> {
  final Value<int> id;
  final Value<int> envelopeId;
  final Value<String> month;
  final Value<int> assignedCents;
  final Value<int> spentCents;
  final Value<DateTime> createdAt;
  const EnvelopeAllocationRowsCompanion({
    this.id = const Value.absent(),
    this.envelopeId = const Value.absent(),
    this.month = const Value.absent(),
    this.assignedCents = const Value.absent(),
    this.spentCents = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  EnvelopeAllocationRowsCompanion.insert({
    this.id = const Value.absent(),
    required int envelopeId,
    required String month,
    this.assignedCents = const Value.absent(),
    this.spentCents = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : envelopeId = Value(envelopeId),
       month = Value(month);
  static Insertable<EnvelopeAllocationRow> custom({
    Expression<int>? id,
    Expression<int>? envelopeId,
    Expression<String>? month,
    Expression<int>? assignedCents,
    Expression<int>? spentCents,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (envelopeId != null) 'envelope_id': envelopeId,
      if (month != null) 'month': month,
      if (assignedCents != null) 'assigned_cents': assignedCents,
      if (spentCents != null) 'spent_cents': spentCents,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  EnvelopeAllocationRowsCompanion copyWith({
    Value<int>? id,
    Value<int>? envelopeId,
    Value<String>? month,
    Value<int>? assignedCents,
    Value<int>? spentCents,
    Value<DateTime>? createdAt,
  }) {
    return EnvelopeAllocationRowsCompanion(
      id: id ?? this.id,
      envelopeId: envelopeId ?? this.envelopeId,
      month: month ?? this.month,
      assignedCents: assignedCents ?? this.assignedCents,
      spentCents: spentCents ?? this.spentCents,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (envelopeId.present) {
      map['envelope_id'] = Variable<int>(envelopeId.value);
    }
    if (month.present) {
      map['month'] = Variable<String>(month.value);
    }
    if (assignedCents.present) {
      map['assigned_cents'] = Variable<int>(assignedCents.value);
    }
    if (spentCents.present) {
      map['spent_cents'] = Variable<int>(spentCents.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EnvelopeAllocationRowsCompanion(')
          ..write('id: $id, ')
          ..write('envelopeId: $envelopeId, ')
          ..write('month: $month, ')
          ..write('assignedCents: $assignedCents, ')
          ..write('spentCents: $spentCents, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $EnvelopeTransferRowsTable extends EnvelopeTransferRows
    with TableInfo<$EnvelopeTransferRowsTable, EnvelopeTransferRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EnvelopeTransferRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<String> month = GeneratedColumn<String>(
    'month',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 7,
      maxTextLength: 7,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromEnvelopeIdMeta = const VerificationMeta(
    'fromEnvelopeId',
  );
  @override
  late final GeneratedColumn<int> fromEnvelopeId = GeneratedColumn<int>(
    'from_envelope_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES envelopes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _toEnvelopeIdMeta = const VerificationMeta(
    'toEnvelopeId',
  );
  @override
  late final GeneratedColumn<int> toEnvelopeId = GeneratedColumn<int>(
    'to_envelope_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES envelopes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    month,
    fromEnvelopeId,
    toEnvelopeId,
    amountCents,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'envelope_transfers';
  @override
  VerificationContext validateIntegrity(
    Insertable<EnvelopeTransferRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('from_envelope_id')) {
      context.handle(
        _fromEnvelopeIdMeta,
        fromEnvelopeId.isAcceptableOrUnknown(
          data['from_envelope_id']!,
          _fromEnvelopeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fromEnvelopeIdMeta);
    }
    if (data.containsKey('to_envelope_id')) {
      context.handle(
        _toEnvelopeIdMeta,
        toEnvelopeId.isAcceptableOrUnknown(
          data['to_envelope_id']!,
          _toEnvelopeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_toEnvelopeIdMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EnvelopeTransferRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EnvelopeTransferRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}month'],
      )!,
      fromEnvelopeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}from_envelope_id'],
      )!,
      toEnvelopeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}to_envelope_id'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $EnvelopeTransferRowsTable createAlias(String alias) {
    return $EnvelopeTransferRowsTable(attachedDatabase, alias);
  }
}

class EnvelopeTransferRow extends DataClass
    implements Insertable<EnvelopeTransferRow> {
  final int id;
  final String month;
  final int fromEnvelopeId;
  final int toEnvelopeId;
  final int amountCents;
  final String? note;
  final DateTime createdAt;
  const EnvelopeTransferRow({
    required this.id,
    required this.month,
    required this.fromEnvelopeId,
    required this.toEnvelopeId,
    required this.amountCents,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['month'] = Variable<String>(month);
    map['from_envelope_id'] = Variable<int>(fromEnvelopeId);
    map['to_envelope_id'] = Variable<int>(toEnvelopeId);
    map['amount_cents'] = Variable<int>(amountCents);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EnvelopeTransferRowsCompanion toCompanion(bool nullToAbsent) {
    return EnvelopeTransferRowsCompanion(
      id: Value(id),
      month: Value(month),
      fromEnvelopeId: Value(fromEnvelopeId),
      toEnvelopeId: Value(toEnvelopeId),
      amountCents: Value(amountCents),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory EnvelopeTransferRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EnvelopeTransferRow(
      id: serializer.fromJson<int>(json['id']),
      month: serializer.fromJson<String>(json['month']),
      fromEnvelopeId: serializer.fromJson<int>(json['fromEnvelopeId']),
      toEnvelopeId: serializer.fromJson<int>(json['toEnvelopeId']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'month': serializer.toJson<String>(month),
      'fromEnvelopeId': serializer.toJson<int>(fromEnvelopeId),
      'toEnvelopeId': serializer.toJson<int>(toEnvelopeId),
      'amountCents': serializer.toJson<int>(amountCents),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  EnvelopeTransferRow copyWith({
    int? id,
    String? month,
    int? fromEnvelopeId,
    int? toEnvelopeId,
    int? amountCents,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
  }) => EnvelopeTransferRow(
    id: id ?? this.id,
    month: month ?? this.month,
    fromEnvelopeId: fromEnvelopeId ?? this.fromEnvelopeId,
    toEnvelopeId: toEnvelopeId ?? this.toEnvelopeId,
    amountCents: amountCents ?? this.amountCents,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  EnvelopeTransferRow copyWithCompanion(EnvelopeTransferRowsCompanion data) {
    return EnvelopeTransferRow(
      id: data.id.present ? data.id.value : this.id,
      month: data.month.present ? data.month.value : this.month,
      fromEnvelopeId: data.fromEnvelopeId.present
          ? data.fromEnvelopeId.value
          : this.fromEnvelopeId,
      toEnvelopeId: data.toEnvelopeId.present
          ? data.toEnvelopeId.value
          : this.toEnvelopeId,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EnvelopeTransferRow(')
          ..write('id: $id, ')
          ..write('month: $month, ')
          ..write('fromEnvelopeId: $fromEnvelopeId, ')
          ..write('toEnvelopeId: $toEnvelopeId, ')
          ..write('amountCents: $amountCents, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    month,
    fromEnvelopeId,
    toEnvelopeId,
    amountCents,
    note,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EnvelopeTransferRow &&
          other.id == this.id &&
          other.month == this.month &&
          other.fromEnvelopeId == this.fromEnvelopeId &&
          other.toEnvelopeId == this.toEnvelopeId &&
          other.amountCents == this.amountCents &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class EnvelopeTransferRowsCompanion
    extends UpdateCompanion<EnvelopeTransferRow> {
  final Value<int> id;
  final Value<String> month;
  final Value<int> fromEnvelopeId;
  final Value<int> toEnvelopeId;
  final Value<int> amountCents;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  const EnvelopeTransferRowsCompanion({
    this.id = const Value.absent(),
    this.month = const Value.absent(),
    this.fromEnvelopeId = const Value.absent(),
    this.toEnvelopeId = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  EnvelopeTransferRowsCompanion.insert({
    this.id = const Value.absent(),
    required String month,
    required int fromEnvelopeId,
    required int toEnvelopeId,
    required int amountCents,
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : month = Value(month),
       fromEnvelopeId = Value(fromEnvelopeId),
       toEnvelopeId = Value(toEnvelopeId),
       amountCents = Value(amountCents);
  static Insertable<EnvelopeTransferRow> custom({
    Expression<int>? id,
    Expression<String>? month,
    Expression<int>? fromEnvelopeId,
    Expression<int>? toEnvelopeId,
    Expression<int>? amountCents,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (month != null) 'month': month,
      if (fromEnvelopeId != null) 'from_envelope_id': fromEnvelopeId,
      if (toEnvelopeId != null) 'to_envelope_id': toEnvelopeId,
      if (amountCents != null) 'amount_cents': amountCents,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  EnvelopeTransferRowsCompanion copyWith({
    Value<int>? id,
    Value<String>? month,
    Value<int>? fromEnvelopeId,
    Value<int>? toEnvelopeId,
    Value<int>? amountCents,
    Value<String?>? note,
    Value<DateTime>? createdAt,
  }) {
    return EnvelopeTransferRowsCompanion(
      id: id ?? this.id,
      month: month ?? this.month,
      fromEnvelopeId: fromEnvelopeId ?? this.fromEnvelopeId,
      toEnvelopeId: toEnvelopeId ?? this.toEnvelopeId,
      amountCents: amountCents ?? this.amountCents,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (month.present) {
      map['month'] = Variable<String>(month.value);
    }
    if (fromEnvelopeId.present) {
      map['from_envelope_id'] = Variable<int>(fromEnvelopeId.value);
    }
    if (toEnvelopeId.present) {
      map['to_envelope_id'] = Variable<int>(toEnvelopeId.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EnvelopeTransferRowsCompanion(')
          ..write('id: $id, ')
          ..write('month: $month, ')
          ..write('fromEnvelopeId: $fromEnvelopeId, ')
          ..write('toEnvelopeId: $toEnvelopeId, ')
          ..write('amountCents: $amountCents, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CategorisationRuleRowsTable extends CategorisationRuleRows
    with TableInfo<$CategorisationRuleRowsTable, CategorisationRuleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategorisationRuleRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _patternMeta = const VerificationMeta(
    'pattern',
  );
  @override
  late final GeneratedColumn<String> pattern = GeneratedColumn<String>(
    'pattern',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _envelopeIdMeta = const VerificationMeta(
    'envelopeId',
  );
  @override
  late final GeneratedColumn<int> envelopeId = GeneratedColumn<int>(
    'envelope_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES envelopes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    pattern,
    envelopeId,
    priority,
    isActive,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categorisation_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategorisationRuleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pattern')) {
      context.handle(
        _patternMeta,
        pattern.isAcceptableOrUnknown(data['pattern']!, _patternMeta),
      );
    } else if (isInserting) {
      context.missing(_patternMeta);
    }
    if (data.containsKey('envelope_id')) {
      context.handle(
        _envelopeIdMeta,
        envelopeId.isAcceptableOrUnknown(data['envelope_id']!, _envelopeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_envelopeIdMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategorisationRuleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategorisationRuleRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      pattern: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pattern'],
      )!,
      envelopeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}envelope_id'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CategorisationRuleRowsTable createAlias(String alias) {
    return $CategorisationRuleRowsTable(attachedDatabase, alias);
  }
}

class CategorisationRuleRow extends DataClass
    implements Insertable<CategorisationRuleRow> {
  final int id;
  final String pattern;
  final int envelopeId;
  final int priority;
  final bool isActive;
  final DateTime createdAt;
  const CategorisationRuleRow({
    required this.id,
    required this.pattern,
    required this.envelopeId,
    required this.priority,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pattern'] = Variable<String>(pattern);
    map['envelope_id'] = Variable<int>(envelopeId);
    map['priority'] = Variable<int>(priority);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CategorisationRuleRowsCompanion toCompanion(bool nullToAbsent) {
    return CategorisationRuleRowsCompanion(
      id: Value(id),
      pattern: Value(pattern),
      envelopeId: Value(envelopeId),
      priority: Value(priority),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory CategorisationRuleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategorisationRuleRow(
      id: serializer.fromJson<int>(json['id']),
      pattern: serializer.fromJson<String>(json['pattern']),
      envelopeId: serializer.fromJson<int>(json['envelopeId']),
      priority: serializer.fromJson<int>(json['priority']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pattern': serializer.toJson<String>(pattern),
      'envelopeId': serializer.toJson<int>(envelopeId),
      'priority': serializer.toJson<int>(priority),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CategorisationRuleRow copyWith({
    int? id,
    String? pattern,
    int? envelopeId,
    int? priority,
    bool? isActive,
    DateTime? createdAt,
  }) => CategorisationRuleRow(
    id: id ?? this.id,
    pattern: pattern ?? this.pattern,
    envelopeId: envelopeId ?? this.envelopeId,
    priority: priority ?? this.priority,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  CategorisationRuleRow copyWithCompanion(
    CategorisationRuleRowsCompanion data,
  ) {
    return CategorisationRuleRow(
      id: data.id.present ? data.id.value : this.id,
      pattern: data.pattern.present ? data.pattern.value : this.pattern,
      envelopeId: data.envelopeId.present
          ? data.envelopeId.value
          : this.envelopeId,
      priority: data.priority.present ? data.priority.value : this.priority,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategorisationRuleRow(')
          ..write('id: $id, ')
          ..write('pattern: $pattern, ')
          ..write('envelopeId: $envelopeId, ')
          ..write('priority: $priority, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, pattern, envelopeId, priority, isActive, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategorisationRuleRow &&
          other.id == this.id &&
          other.pattern == this.pattern &&
          other.envelopeId == this.envelopeId &&
          other.priority == this.priority &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class CategorisationRuleRowsCompanion
    extends UpdateCompanion<CategorisationRuleRow> {
  final Value<int> id;
  final Value<String> pattern;
  final Value<int> envelopeId;
  final Value<int> priority;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  const CategorisationRuleRowsCompanion({
    this.id = const Value.absent(),
    this.pattern = const Value.absent(),
    this.envelopeId = const Value.absent(),
    this.priority = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CategorisationRuleRowsCompanion.insert({
    this.id = const Value.absent(),
    required String pattern,
    required int envelopeId,
    this.priority = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : pattern = Value(pattern),
       envelopeId = Value(envelopeId);
  static Insertable<CategorisationRuleRow> custom({
    Expression<int>? id,
    Expression<String>? pattern,
    Expression<int>? envelopeId,
    Expression<int>? priority,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pattern != null) 'pattern': pattern,
      if (envelopeId != null) 'envelope_id': envelopeId,
      if (priority != null) 'priority': priority,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CategorisationRuleRowsCompanion copyWith({
    Value<int>? id,
    Value<String>? pattern,
    Value<int>? envelopeId,
    Value<int>? priority,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
  }) {
    return CategorisationRuleRowsCompanion(
      id: id ?? this.id,
      pattern: pattern ?? this.pattern,
      envelopeId: envelopeId ?? this.envelopeId,
      priority: priority ?? this.priority,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pattern.present) {
      map['pattern'] = Variable<String>(pattern.value);
    }
    if (envelopeId.present) {
      map['envelope_id'] = Variable<int>(envelopeId.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategorisationRuleRowsCompanion(')
          ..write('id: $id, ')
          ..write('pattern: $pattern, ')
          ..write('envelopeId: $envelopeId, ')
          ..write('priority: $priority, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AppSettingRowsTable extends AppSettingRows
    with TableInfo<$AppSettingRowsTable, AppSettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingRowsTable createAlias(String alias) {
    return $AppSettingRowsTable(attachedDatabase, alias);
  }
}

class AppSettingRow extends DataClass implements Insertable<AppSettingRow> {
  final String key;
  final String value;
  const AppSettingRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingRowsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingRowsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSettingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSettingRow copyWith({String? key, String? value}) =>
      AppSettingRow(key: key ?? this.key, value: value ?? this.value);
  AppSettingRow copyWithCompanion(AppSettingRowsCompanion data) {
    return AppSettingRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingRow &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingRowsCompanion extends UpdateCompanion<AppSettingRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingRowsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingRowsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSettingRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingRowsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingRowsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingRowsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AccountRowsTable accountRows = $AccountRowsTable(this);
  late final $EnvelopeGroupRowsTable envelopeGroupRows =
      $EnvelopeGroupRowsTable(this);
  late final $EnvelopeRowsTable envelopeRows = $EnvelopeRowsTable(this);
  late final $MovementRowsTable movementRows = $MovementRowsTable(this);
  late final $EnvelopeAllocationRowsTable envelopeAllocationRows =
      $EnvelopeAllocationRowsTable(this);
  late final $EnvelopeTransferRowsTable envelopeTransferRows =
      $EnvelopeTransferRowsTable(this);
  late final $CategorisationRuleRowsTable categorisationRuleRows =
      $CategorisationRuleRowsTable(this);
  late final $AppSettingRowsTable appSettingRows = $AppSettingRowsTable(this);
  late final Index idxAccountsArchived = Index(
    'idx_accounts_archived',
    'CREATE INDEX idx_accounts_archived ON accounts (archived)',
  );
  late final Index idxMovementsDateEnvelope = Index(
    'idx_movements_date_envelope',
    'CREATE INDEX idx_movements_date_envelope ON movements (date, envelope_id)',
  );
  late final Index idxMovementsAccount = Index(
    'idx_movements_account',
    'CREATE INDEX idx_movements_account ON movements (account_id)',
  );
  late final Index idxRulesActivePriority = Index(
    'idx_rules_active_priority',
    'CREATE INDEX idx_rules_active_priority ON categorisation_rules (is_active, priority)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    accountRows,
    envelopeGroupRows,
    envelopeRows,
    movementRows,
    envelopeAllocationRows,
    envelopeTransferRows,
    categorisationRuleRows,
    appSettingRows,
    idxAccountsArchived,
    idxMovementsDateEnvelope,
    idxMovementsAccount,
    idxRulesActivePriority,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'envelopes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('movements', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'accounts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('movements', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'envelopes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('envelope_allocations', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'envelopes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('envelope_transfers', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'envelopes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('envelope_transfers', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'envelopes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('categorisation_rules', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$AccountRowsTableCreateCompanionBuilder =
    AccountRowsCompanion Function({
      Value<int> id,
      required String name,
      required String type,
      required int openingBalanceCents,
      required int balanceCents,
      Value<bool> archived,
      Value<DateTime> createdAt,
    });
typedef $$AccountRowsTableUpdateCompanionBuilder =
    AccountRowsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> type,
      Value<int> openingBalanceCents,
      Value<int> balanceCents,
      Value<bool> archived,
      Value<DateTime> createdAt,
    });

class $$AccountRowsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountRowsTable> {
  $$AccountRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get openingBalanceCents => $composableBuilder(
    column: $table.openingBalanceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get balanceCents => $composableBuilder(
    column: $table.balanceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AccountRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountRowsTable> {
  $$AccountRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get openingBalanceCents => $composableBuilder(
    column: $table.openingBalanceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get balanceCents => $composableBuilder(
    column: $table.balanceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountRowsTable> {
  $$AccountRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get openingBalanceCents => $composableBuilder(
    column: $table.openingBalanceCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get balanceCents => $composableBuilder(
    column: $table.balanceCents,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AccountRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountRowsTable,
          AccountRow,
          $$AccountRowsTableFilterComposer,
          $$AccountRowsTableOrderingComposer,
          $$AccountRowsTableAnnotationComposer,
          $$AccountRowsTableCreateCompanionBuilder,
          $$AccountRowsTableUpdateCompanionBuilder,
          (
            AccountRow,
            BaseReferences<_$AppDatabase, $AccountRowsTable, AccountRow>,
          ),
          AccountRow,
          PrefetchHooks Function()
        > {
  $$AccountRowsTableTableManager(_$AppDatabase db, $AccountRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> openingBalanceCents = const Value.absent(),
                Value<int> balanceCents = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AccountRowsCompanion(
                id: id,
                name: name,
                type: type,
                openingBalanceCents: openingBalanceCents,
                balanceCents: balanceCents,
                archived: archived,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String type,
                required int openingBalanceCents,
                required int balanceCents,
                Value<bool> archived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AccountRowsCompanion.insert(
                id: id,
                name: name,
                type: type,
                openingBalanceCents: openingBalanceCents,
                balanceCents: balanceCents,
                archived: archived,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AccountRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountRowsTable,
      AccountRow,
      $$AccountRowsTableFilterComposer,
      $$AccountRowsTableOrderingComposer,
      $$AccountRowsTableAnnotationComposer,
      $$AccountRowsTableCreateCompanionBuilder,
      $$AccountRowsTableUpdateCompanionBuilder,
      (
        AccountRow,
        BaseReferences<_$AppDatabase, $AccountRowsTable, AccountRow>,
      ),
      AccountRow,
      PrefetchHooks Function()
    >;
typedef $$EnvelopeGroupRowsTableCreateCompanionBuilder =
    EnvelopeGroupRowsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> colorHex,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
    });
typedef $$EnvelopeGroupRowsTableUpdateCompanionBuilder =
    EnvelopeGroupRowsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> colorHex,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
    });

final class $$EnvelopeGroupRowsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $EnvelopeGroupRowsTable,
          EnvelopeGroupRow
        > {
  $$EnvelopeGroupRowsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$EnvelopeRowsTable, List<EnvelopeRow>>
  _envelopeRowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.envelopeRows,
    aliasName: 'envelope_groups__id__envelopes__group_id',
  );

  $$EnvelopeRowsTableProcessedTableManager get envelopeRowsRefs {
    final manager = $$EnvelopeRowsTableTableManager(
      $_db,
      $_db.envelopeRows,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_envelopeRowsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EnvelopeGroupRowsTableFilterComposer
    extends Composer<_$AppDatabase, $EnvelopeGroupRowsTable> {
  $$EnvelopeGroupRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> envelopeRowsRefs(
    Expression<bool> Function($$EnvelopeRowsTableFilterComposer f) f,
  ) {
    final $$EnvelopeRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.envelopeRows,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvelopeRowsTableFilterComposer(
            $db: $db,
            $table: $db.envelopeRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EnvelopeGroupRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $EnvelopeGroupRowsTable> {
  $$EnvelopeGroupRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EnvelopeGroupRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EnvelopeGroupRowsTable> {
  $$EnvelopeGroupRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> envelopeRowsRefs<T extends Object>(
    Expression<T> Function($$EnvelopeRowsTableAnnotationComposer a) f,
  ) {
    final $$EnvelopeRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.envelopeRows,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvelopeRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.envelopeRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EnvelopeGroupRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EnvelopeGroupRowsTable,
          EnvelopeGroupRow,
          $$EnvelopeGroupRowsTableFilterComposer,
          $$EnvelopeGroupRowsTableOrderingComposer,
          $$EnvelopeGroupRowsTableAnnotationComposer,
          $$EnvelopeGroupRowsTableCreateCompanionBuilder,
          $$EnvelopeGroupRowsTableUpdateCompanionBuilder,
          (EnvelopeGroupRow, $$EnvelopeGroupRowsTableReferences),
          EnvelopeGroupRow,
          PrefetchHooks Function({bool envelopeRowsRefs})
        > {
  $$EnvelopeGroupRowsTableTableManager(
    _$AppDatabase db,
    $EnvelopeGroupRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EnvelopeGroupRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EnvelopeGroupRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EnvelopeGroupRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> colorHex = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => EnvelopeGroupRowsCompanion(
                id: id,
                name: name,
                colorHex: colorHex,
                sortOrder: sortOrder,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> colorHex = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => EnvelopeGroupRowsCompanion.insert(
                id: id,
                name: name,
                colorHex: colorHex,
                sortOrder: sortOrder,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EnvelopeGroupRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({envelopeRowsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (envelopeRowsRefs) db.envelopeRows],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (envelopeRowsRefs)
                    await $_getPrefetchedData<
                      EnvelopeGroupRow,
                      $EnvelopeGroupRowsTable,
                      EnvelopeRow
                    >(
                      currentTable: table,
                      referencedTable: $$EnvelopeGroupRowsTableReferences
                          ._envelopeRowsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$EnvelopeGroupRowsTableReferences(
                            db,
                            table,
                            p0,
                          ).envelopeRowsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.groupId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$EnvelopeGroupRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EnvelopeGroupRowsTable,
      EnvelopeGroupRow,
      $$EnvelopeGroupRowsTableFilterComposer,
      $$EnvelopeGroupRowsTableOrderingComposer,
      $$EnvelopeGroupRowsTableAnnotationComposer,
      $$EnvelopeGroupRowsTableCreateCompanionBuilder,
      $$EnvelopeGroupRowsTableUpdateCompanionBuilder,
      (EnvelopeGroupRow, $$EnvelopeGroupRowsTableReferences),
      EnvelopeGroupRow,
      PrefetchHooks Function({bool envelopeRowsRefs})
    >;
typedef $$EnvelopeRowsTableCreateCompanionBuilder =
    EnvelopeRowsCompanion Function({
      Value<int> id,
      required int groupId,
      required String name,
      Value<int> sortOrder,
      Value<bool> archived,
      Value<DateTime> createdAt,
    });
typedef $$EnvelopeRowsTableUpdateCompanionBuilder =
    EnvelopeRowsCompanion Function({
      Value<int> id,
      Value<int> groupId,
      Value<String> name,
      Value<int> sortOrder,
      Value<bool> archived,
      Value<DateTime> createdAt,
    });

final class $$EnvelopeRowsTableReferences
    extends BaseReferences<_$AppDatabase, $EnvelopeRowsTable, EnvelopeRow> {
  $$EnvelopeRowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EnvelopeGroupRowsTable _groupIdTable(_$AppDatabase db) => db
      .envelopeGroupRows
      .createAlias('envelopes__group_id__envelope_groups__id');

  $$EnvelopeGroupRowsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<int>('group_id')!;

    final manager = $$EnvelopeGroupRowsTableTableManager(
      $_db,
      $_db.envelopeGroupRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MovementRowsTable, List<MovementRow>>
  _movementRowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.movementRows,
    aliasName: 'envelopes__id__movements__envelope_id',
  );

  $$MovementRowsTableProcessedTableManager get movementRowsRefs {
    final manager = $$MovementRowsTableTableManager(
      $_db,
      $_db.movementRows,
    ).filter((f) => f.envelopeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_movementRowsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $EnvelopeAllocationRowsTable,
    List<EnvelopeAllocationRow>
  >
  _envelopeAllocationRowsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.envelopeAllocationRows,
        aliasName: 'envelopes__id__envelope_allocations__envelope_id',
      );

  $$EnvelopeAllocationRowsTableProcessedTableManager
  get envelopeAllocationRowsRefs {
    final manager = $$EnvelopeAllocationRowsTableTableManager(
      $_db,
      $_db.envelopeAllocationRows,
    ).filter((f) => f.envelopeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _envelopeAllocationRowsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $CategorisationRuleRowsTable,
    List<CategorisationRuleRow>
  >
  _categorisationRuleRowsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.categorisationRuleRows,
        aliasName: 'envelopes__id__categorisation_rules__envelope_id',
      );

  $$CategorisationRuleRowsTableProcessedTableManager
  get categorisationRuleRowsRefs {
    final manager = $$CategorisationRuleRowsTableTableManager(
      $_db,
      $_db.categorisationRuleRows,
    ).filter((f) => f.envelopeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _categorisationRuleRowsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EnvelopeRowsTableFilterComposer
    extends Composer<_$AppDatabase, $EnvelopeRowsTable> {
  $$EnvelopeRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EnvelopeGroupRowsTableFilterComposer get groupId {
    final $$EnvelopeGroupRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.envelopeGroupRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvelopeGroupRowsTableFilterComposer(
            $db: $db,
            $table: $db.envelopeGroupRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> movementRowsRefs(
    Expression<bool> Function($$MovementRowsTableFilterComposer f) f,
  ) {
    final $$MovementRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movementRows,
      getReferencedColumn: (t) => t.envelopeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovementRowsTableFilterComposer(
            $db: $db,
            $table: $db.movementRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> envelopeAllocationRowsRefs(
    Expression<bool> Function($$EnvelopeAllocationRowsTableFilterComposer f) f,
  ) {
    final $$EnvelopeAllocationRowsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.envelopeAllocationRows,
          getReferencedColumn: (t) => t.envelopeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EnvelopeAllocationRowsTableFilterComposer(
                $db: $db,
                $table: $db.envelopeAllocationRows,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> categorisationRuleRowsRefs(
    Expression<bool> Function($$CategorisationRuleRowsTableFilterComposer f) f,
  ) {
    final $$CategorisationRuleRowsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.categorisationRuleRows,
          getReferencedColumn: (t) => t.envelopeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CategorisationRuleRowsTableFilterComposer(
                $db: $db,
                $table: $db.categorisationRuleRows,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$EnvelopeRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $EnvelopeRowsTable> {
  $$EnvelopeRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EnvelopeGroupRowsTableOrderingComposer get groupId {
    final $$EnvelopeGroupRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.envelopeGroupRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvelopeGroupRowsTableOrderingComposer(
            $db: $db,
            $table: $db.envelopeGroupRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EnvelopeRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EnvelopeRowsTable> {
  $$EnvelopeRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$EnvelopeGroupRowsTableAnnotationComposer get groupId {
    final $$EnvelopeGroupRowsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.groupId,
          referencedTable: $db.envelopeGroupRows,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EnvelopeGroupRowsTableAnnotationComposer(
                $db: $db,
                $table: $db.envelopeGroupRows,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> movementRowsRefs<T extends Object>(
    Expression<T> Function($$MovementRowsTableAnnotationComposer a) f,
  ) {
    final $$MovementRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movementRows,
      getReferencedColumn: (t) => t.envelopeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovementRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.movementRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> envelopeAllocationRowsRefs<T extends Object>(
    Expression<T> Function($$EnvelopeAllocationRowsTableAnnotationComposer a) f,
  ) {
    final $$EnvelopeAllocationRowsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.envelopeAllocationRows,
          getReferencedColumn: (t) => t.envelopeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EnvelopeAllocationRowsTableAnnotationComposer(
                $db: $db,
                $table: $db.envelopeAllocationRows,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> categorisationRuleRowsRefs<T extends Object>(
    Expression<T> Function($$CategorisationRuleRowsTableAnnotationComposer a) f,
  ) {
    final $$CategorisationRuleRowsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.categorisationRuleRows,
          getReferencedColumn: (t) => t.envelopeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CategorisationRuleRowsTableAnnotationComposer(
                $db: $db,
                $table: $db.categorisationRuleRows,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$EnvelopeRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EnvelopeRowsTable,
          EnvelopeRow,
          $$EnvelopeRowsTableFilterComposer,
          $$EnvelopeRowsTableOrderingComposer,
          $$EnvelopeRowsTableAnnotationComposer,
          $$EnvelopeRowsTableCreateCompanionBuilder,
          $$EnvelopeRowsTableUpdateCompanionBuilder,
          (EnvelopeRow, $$EnvelopeRowsTableReferences),
          EnvelopeRow,
          PrefetchHooks Function({
            bool groupId,
            bool movementRowsRefs,
            bool envelopeAllocationRowsRefs,
            bool categorisationRuleRowsRefs,
          })
        > {
  $$EnvelopeRowsTableTableManager(_$AppDatabase db, $EnvelopeRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EnvelopeRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EnvelopeRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EnvelopeRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> groupId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => EnvelopeRowsCompanion(
                id: id,
                groupId: groupId,
                name: name,
                sortOrder: sortOrder,
                archived: archived,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int groupId,
                required String name,
                Value<int> sortOrder = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => EnvelopeRowsCompanion.insert(
                id: id,
                groupId: groupId,
                name: name,
                sortOrder: sortOrder,
                archived: archived,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EnvelopeRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                groupId = false,
                movementRowsRefs = false,
                envelopeAllocationRowsRefs = false,
                categorisationRuleRowsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (movementRowsRefs) db.movementRows,
                    if (envelopeAllocationRowsRefs) db.envelopeAllocationRows,
                    if (categorisationRuleRowsRefs) db.categorisationRuleRows,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (groupId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.groupId,
                                    referencedTable:
                                        $$EnvelopeRowsTableReferences
                                            ._groupIdTable(db),
                                    referencedColumn:
                                        $$EnvelopeRowsTableReferences
                                            ._groupIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (movementRowsRefs)
                        await $_getPrefetchedData<
                          EnvelopeRow,
                          $EnvelopeRowsTable,
                          MovementRow
                        >(
                          currentTable: table,
                          referencedTable: $$EnvelopeRowsTableReferences
                              ._movementRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EnvelopeRowsTableReferences(
                                db,
                                table,
                                p0,
                              ).movementRowsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.envelopeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (envelopeAllocationRowsRefs)
                        await $_getPrefetchedData<
                          EnvelopeRow,
                          $EnvelopeRowsTable,
                          EnvelopeAllocationRow
                        >(
                          currentTable: table,
                          referencedTable: $$EnvelopeRowsTableReferences
                              ._envelopeAllocationRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EnvelopeRowsTableReferences(
                                db,
                                table,
                                p0,
                              ).envelopeAllocationRowsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.envelopeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (categorisationRuleRowsRefs)
                        await $_getPrefetchedData<
                          EnvelopeRow,
                          $EnvelopeRowsTable,
                          CategorisationRuleRow
                        >(
                          currentTable: table,
                          referencedTable: $$EnvelopeRowsTableReferences
                              ._categorisationRuleRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EnvelopeRowsTableReferences(
                                db,
                                table,
                                p0,
                              ).categorisationRuleRowsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.envelopeId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$EnvelopeRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EnvelopeRowsTable,
      EnvelopeRow,
      $$EnvelopeRowsTableFilterComposer,
      $$EnvelopeRowsTableOrderingComposer,
      $$EnvelopeRowsTableAnnotationComposer,
      $$EnvelopeRowsTableCreateCompanionBuilder,
      $$EnvelopeRowsTableUpdateCompanionBuilder,
      (EnvelopeRow, $$EnvelopeRowsTableReferences),
      EnvelopeRow,
      PrefetchHooks Function({
        bool groupId,
        bool movementRowsRefs,
        bool envelopeAllocationRowsRefs,
        bool categorisationRuleRowsRefs,
      })
    >;
typedef $$MovementRowsTableCreateCompanionBuilder =
    MovementRowsCompanion Function({
      Value<int> id,
      required int accountId,
      Value<int?> envelopeId,
      required String type,
      required int amountCents,
      required String description,
      required DateTime date,
      Value<int?> transferAccountId,
      Value<DateTime> createdAt,
    });
typedef $$MovementRowsTableUpdateCompanionBuilder =
    MovementRowsCompanion Function({
      Value<int> id,
      Value<int> accountId,
      Value<int?> envelopeId,
      Value<String> type,
      Value<int> amountCents,
      Value<String> description,
      Value<DateTime> date,
      Value<int?> transferAccountId,
      Value<DateTime> createdAt,
    });

final class $$MovementRowsTableReferences
    extends BaseReferences<_$AppDatabase, $MovementRowsTable, MovementRow> {
  $$MovementRowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountRowsTable _accountIdTable(_$AppDatabase db) =>
      db.accountRows.createAlias('movements__account_id__accounts__id');

  $$AccountRowsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$AccountRowsTableTableManager(
      $_db,
      $_db.accountRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EnvelopeRowsTable _envelopeIdTable(_$AppDatabase db) =>
      db.envelopeRows.createAlias('movements__envelope_id__envelopes__id');

  $$EnvelopeRowsTableProcessedTableManager? get envelopeId {
    final $_column = $_itemColumn<int>('envelope_id');
    if ($_column == null) return null;
    final manager = $$EnvelopeRowsTableTableManager(
      $_db,
      $_db.envelopeRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_envelopeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AccountRowsTable _transferAccountIdTable(_$AppDatabase db) => db
      .accountRows
      .createAlias('movements__transfer_account_id__accounts__id');

  $$AccountRowsTableProcessedTableManager? get transferAccountId {
    final $_column = $_itemColumn<int>('transfer_account_id');
    if ($_column == null) return null;
    final manager = $$AccountRowsTableTableManager(
      $_db,
      $_db.accountRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transferAccountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MovementRowsTableFilterComposer
    extends Composer<_$AppDatabase, $MovementRowsTable> {
  $$MovementRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountRowsTableFilterComposer get accountId {
    final $$AccountRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountRowsTableFilterComposer(
            $db: $db,
            $table: $db.accountRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EnvelopeRowsTableFilterComposer get envelopeId {
    final $$EnvelopeRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.envelopeId,
      referencedTable: $db.envelopeRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvelopeRowsTableFilterComposer(
            $db: $db,
            $table: $db.envelopeRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountRowsTableFilterComposer get transferAccountId {
    final $$AccountRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transferAccountId,
      referencedTable: $db.accountRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountRowsTableFilterComposer(
            $db: $db,
            $table: $db.accountRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovementRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $MovementRowsTable> {
  $$MovementRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountRowsTableOrderingComposer get accountId {
    final $$AccountRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountRowsTableOrderingComposer(
            $db: $db,
            $table: $db.accountRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EnvelopeRowsTableOrderingComposer get envelopeId {
    final $$EnvelopeRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.envelopeId,
      referencedTable: $db.envelopeRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvelopeRowsTableOrderingComposer(
            $db: $db,
            $table: $db.envelopeRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountRowsTableOrderingComposer get transferAccountId {
    final $$AccountRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transferAccountId,
      referencedTable: $db.accountRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountRowsTableOrderingComposer(
            $db: $db,
            $table: $db.accountRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovementRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MovementRowsTable> {
  $$MovementRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$AccountRowsTableAnnotationComposer get accountId {
    final $$AccountRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.accountRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EnvelopeRowsTableAnnotationComposer get envelopeId {
    final $$EnvelopeRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.envelopeId,
      referencedTable: $db.envelopeRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvelopeRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.envelopeRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountRowsTableAnnotationComposer get transferAccountId {
    final $$AccountRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transferAccountId,
      referencedTable: $db.accountRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.accountRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovementRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MovementRowsTable,
          MovementRow,
          $$MovementRowsTableFilterComposer,
          $$MovementRowsTableOrderingComposer,
          $$MovementRowsTableAnnotationComposer,
          $$MovementRowsTableCreateCompanionBuilder,
          $$MovementRowsTableUpdateCompanionBuilder,
          (MovementRow, $$MovementRowsTableReferences),
          MovementRow,
          PrefetchHooks Function({
            bool accountId,
            bool envelopeId,
            bool transferAccountId,
          })
        > {
  $$MovementRowsTableTableManager(_$AppDatabase db, $MovementRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MovementRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MovementRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MovementRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<int?> envelopeId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int?> transferAccountId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MovementRowsCompanion(
                id: id,
                accountId: accountId,
                envelopeId: envelopeId,
                type: type,
                amountCents: amountCents,
                description: description,
                date: date,
                transferAccountId: transferAccountId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int accountId,
                Value<int?> envelopeId = const Value.absent(),
                required String type,
                required int amountCents,
                required String description,
                required DateTime date,
                Value<int?> transferAccountId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MovementRowsCompanion.insert(
                id: id,
                accountId: accountId,
                envelopeId: envelopeId,
                type: type,
                amountCents: amountCents,
                description: description,
                date: date,
                transferAccountId: transferAccountId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MovementRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                accountId = false,
                envelopeId = false,
                transferAccountId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (accountId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.accountId,
                                    referencedTable:
                                        $$MovementRowsTableReferences
                                            ._accountIdTable(db),
                                    referencedColumn:
                                        $$MovementRowsTableReferences
                                            ._accountIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (envelopeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.envelopeId,
                                    referencedTable:
                                        $$MovementRowsTableReferences
                                            ._envelopeIdTable(db),
                                    referencedColumn:
                                        $$MovementRowsTableReferences
                                            ._envelopeIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (transferAccountId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.transferAccountId,
                                    referencedTable:
                                        $$MovementRowsTableReferences
                                            ._transferAccountIdTable(db),
                                    referencedColumn:
                                        $$MovementRowsTableReferences
                                            ._transferAccountIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$MovementRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MovementRowsTable,
      MovementRow,
      $$MovementRowsTableFilterComposer,
      $$MovementRowsTableOrderingComposer,
      $$MovementRowsTableAnnotationComposer,
      $$MovementRowsTableCreateCompanionBuilder,
      $$MovementRowsTableUpdateCompanionBuilder,
      (MovementRow, $$MovementRowsTableReferences),
      MovementRow,
      PrefetchHooks Function({
        bool accountId,
        bool envelopeId,
        bool transferAccountId,
      })
    >;
typedef $$EnvelopeAllocationRowsTableCreateCompanionBuilder =
    EnvelopeAllocationRowsCompanion Function({
      Value<int> id,
      required int envelopeId,
      required String month,
      Value<int> assignedCents,
      Value<int> spentCents,
      Value<DateTime> createdAt,
    });
typedef $$EnvelopeAllocationRowsTableUpdateCompanionBuilder =
    EnvelopeAllocationRowsCompanion Function({
      Value<int> id,
      Value<int> envelopeId,
      Value<String> month,
      Value<int> assignedCents,
      Value<int> spentCents,
      Value<DateTime> createdAt,
    });

final class $$EnvelopeAllocationRowsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $EnvelopeAllocationRowsTable,
          EnvelopeAllocationRow
        > {
  $$EnvelopeAllocationRowsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EnvelopeRowsTable _envelopeIdTable(_$AppDatabase db) => db
      .envelopeRows
      .createAlias('envelope_allocations__envelope_id__envelopes__id');

  $$EnvelopeRowsTableProcessedTableManager get envelopeId {
    final $_column = $_itemColumn<int>('envelope_id')!;

    final manager = $$EnvelopeRowsTableTableManager(
      $_db,
      $_db.envelopeRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_envelopeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EnvelopeAllocationRowsTableFilterComposer
    extends Composer<_$AppDatabase, $EnvelopeAllocationRowsTable> {
  $$EnvelopeAllocationRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get assignedCents => $composableBuilder(
    column: $table.assignedCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get spentCents => $composableBuilder(
    column: $table.spentCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EnvelopeRowsTableFilterComposer get envelopeId {
    final $$EnvelopeRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.envelopeId,
      referencedTable: $db.envelopeRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvelopeRowsTableFilterComposer(
            $db: $db,
            $table: $db.envelopeRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EnvelopeAllocationRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $EnvelopeAllocationRowsTable> {
  $$EnvelopeAllocationRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get assignedCents => $composableBuilder(
    column: $table.assignedCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get spentCents => $composableBuilder(
    column: $table.spentCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EnvelopeRowsTableOrderingComposer get envelopeId {
    final $$EnvelopeRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.envelopeId,
      referencedTable: $db.envelopeRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvelopeRowsTableOrderingComposer(
            $db: $db,
            $table: $db.envelopeRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EnvelopeAllocationRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EnvelopeAllocationRowsTable> {
  $$EnvelopeAllocationRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get assignedCents => $composableBuilder(
    column: $table.assignedCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get spentCents => $composableBuilder(
    column: $table.spentCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$EnvelopeRowsTableAnnotationComposer get envelopeId {
    final $$EnvelopeRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.envelopeId,
      referencedTable: $db.envelopeRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvelopeRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.envelopeRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EnvelopeAllocationRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EnvelopeAllocationRowsTable,
          EnvelopeAllocationRow,
          $$EnvelopeAllocationRowsTableFilterComposer,
          $$EnvelopeAllocationRowsTableOrderingComposer,
          $$EnvelopeAllocationRowsTableAnnotationComposer,
          $$EnvelopeAllocationRowsTableCreateCompanionBuilder,
          $$EnvelopeAllocationRowsTableUpdateCompanionBuilder,
          (EnvelopeAllocationRow, $$EnvelopeAllocationRowsTableReferences),
          EnvelopeAllocationRow,
          PrefetchHooks Function({bool envelopeId})
        > {
  $$EnvelopeAllocationRowsTableTableManager(
    _$AppDatabase db,
    $EnvelopeAllocationRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EnvelopeAllocationRowsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$EnvelopeAllocationRowsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$EnvelopeAllocationRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> envelopeId = const Value.absent(),
                Value<String> month = const Value.absent(),
                Value<int> assignedCents = const Value.absent(),
                Value<int> spentCents = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => EnvelopeAllocationRowsCompanion(
                id: id,
                envelopeId: envelopeId,
                month: month,
                assignedCents: assignedCents,
                spentCents: spentCents,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int envelopeId,
                required String month,
                Value<int> assignedCents = const Value.absent(),
                Value<int> spentCents = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => EnvelopeAllocationRowsCompanion.insert(
                id: id,
                envelopeId: envelopeId,
                month: month,
                assignedCents: assignedCents,
                spentCents: spentCents,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EnvelopeAllocationRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({envelopeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (envelopeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.envelopeId,
                                referencedTable:
                                    $$EnvelopeAllocationRowsTableReferences
                                        ._envelopeIdTable(db),
                                referencedColumn:
                                    $$EnvelopeAllocationRowsTableReferences
                                        ._envelopeIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EnvelopeAllocationRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EnvelopeAllocationRowsTable,
      EnvelopeAllocationRow,
      $$EnvelopeAllocationRowsTableFilterComposer,
      $$EnvelopeAllocationRowsTableOrderingComposer,
      $$EnvelopeAllocationRowsTableAnnotationComposer,
      $$EnvelopeAllocationRowsTableCreateCompanionBuilder,
      $$EnvelopeAllocationRowsTableUpdateCompanionBuilder,
      (EnvelopeAllocationRow, $$EnvelopeAllocationRowsTableReferences),
      EnvelopeAllocationRow,
      PrefetchHooks Function({bool envelopeId})
    >;
typedef $$EnvelopeTransferRowsTableCreateCompanionBuilder =
    EnvelopeTransferRowsCompanion Function({
      Value<int> id,
      required String month,
      required int fromEnvelopeId,
      required int toEnvelopeId,
      required int amountCents,
      Value<String?> note,
      Value<DateTime> createdAt,
    });
typedef $$EnvelopeTransferRowsTableUpdateCompanionBuilder =
    EnvelopeTransferRowsCompanion Function({
      Value<int> id,
      Value<String> month,
      Value<int> fromEnvelopeId,
      Value<int> toEnvelopeId,
      Value<int> amountCents,
      Value<String?> note,
      Value<DateTime> createdAt,
    });

final class $$EnvelopeTransferRowsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $EnvelopeTransferRowsTable,
          EnvelopeTransferRow
        > {
  $$EnvelopeTransferRowsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EnvelopeRowsTable _fromEnvelopeIdTable(_$AppDatabase db) => db
      .envelopeRows
      .createAlias('envelope_transfers__from_envelope_id__envelopes__id');

  $$EnvelopeRowsTableProcessedTableManager get fromEnvelopeId {
    final $_column = $_itemColumn<int>('from_envelope_id')!;

    final manager = $$EnvelopeRowsTableTableManager(
      $_db,
      $_db.envelopeRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fromEnvelopeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EnvelopeRowsTable _toEnvelopeIdTable(_$AppDatabase db) => db
      .envelopeRows
      .createAlias('envelope_transfers__to_envelope_id__envelopes__id');

  $$EnvelopeRowsTableProcessedTableManager get toEnvelopeId {
    final $_column = $_itemColumn<int>('to_envelope_id')!;

    final manager = $$EnvelopeRowsTableTableManager(
      $_db,
      $_db.envelopeRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_toEnvelopeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EnvelopeTransferRowsTableFilterComposer
    extends Composer<_$AppDatabase, $EnvelopeTransferRowsTable> {
  $$EnvelopeTransferRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EnvelopeRowsTableFilterComposer get fromEnvelopeId {
    final $$EnvelopeRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromEnvelopeId,
      referencedTable: $db.envelopeRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvelopeRowsTableFilterComposer(
            $db: $db,
            $table: $db.envelopeRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EnvelopeRowsTableFilterComposer get toEnvelopeId {
    final $$EnvelopeRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toEnvelopeId,
      referencedTable: $db.envelopeRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvelopeRowsTableFilterComposer(
            $db: $db,
            $table: $db.envelopeRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EnvelopeTransferRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $EnvelopeTransferRowsTable> {
  $$EnvelopeTransferRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EnvelopeRowsTableOrderingComposer get fromEnvelopeId {
    final $$EnvelopeRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromEnvelopeId,
      referencedTable: $db.envelopeRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvelopeRowsTableOrderingComposer(
            $db: $db,
            $table: $db.envelopeRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EnvelopeRowsTableOrderingComposer get toEnvelopeId {
    final $$EnvelopeRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toEnvelopeId,
      referencedTable: $db.envelopeRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvelopeRowsTableOrderingComposer(
            $db: $db,
            $table: $db.envelopeRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EnvelopeTransferRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EnvelopeTransferRowsTable> {
  $$EnvelopeTransferRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$EnvelopeRowsTableAnnotationComposer get fromEnvelopeId {
    final $$EnvelopeRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromEnvelopeId,
      referencedTable: $db.envelopeRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvelopeRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.envelopeRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EnvelopeRowsTableAnnotationComposer get toEnvelopeId {
    final $$EnvelopeRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toEnvelopeId,
      referencedTable: $db.envelopeRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvelopeRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.envelopeRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EnvelopeTransferRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EnvelopeTransferRowsTable,
          EnvelopeTransferRow,
          $$EnvelopeTransferRowsTableFilterComposer,
          $$EnvelopeTransferRowsTableOrderingComposer,
          $$EnvelopeTransferRowsTableAnnotationComposer,
          $$EnvelopeTransferRowsTableCreateCompanionBuilder,
          $$EnvelopeTransferRowsTableUpdateCompanionBuilder,
          (EnvelopeTransferRow, $$EnvelopeTransferRowsTableReferences),
          EnvelopeTransferRow,
          PrefetchHooks Function({bool fromEnvelopeId, bool toEnvelopeId})
        > {
  $$EnvelopeTransferRowsTableTableManager(
    _$AppDatabase db,
    $EnvelopeTransferRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EnvelopeTransferRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EnvelopeTransferRowsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$EnvelopeTransferRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> month = const Value.absent(),
                Value<int> fromEnvelopeId = const Value.absent(),
                Value<int> toEnvelopeId = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => EnvelopeTransferRowsCompanion(
                id: id,
                month: month,
                fromEnvelopeId: fromEnvelopeId,
                toEnvelopeId: toEnvelopeId,
                amountCents: amountCents,
                note: note,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String month,
                required int fromEnvelopeId,
                required int toEnvelopeId,
                required int amountCents,
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => EnvelopeTransferRowsCompanion.insert(
                id: id,
                month: month,
                fromEnvelopeId: fromEnvelopeId,
                toEnvelopeId: toEnvelopeId,
                amountCents: amountCents,
                note: note,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EnvelopeTransferRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({fromEnvelopeId = false, toEnvelopeId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (fromEnvelopeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.fromEnvelopeId,
                                    referencedTable:
                                        $$EnvelopeTransferRowsTableReferences
                                            ._fromEnvelopeIdTable(db),
                                    referencedColumn:
                                        $$EnvelopeTransferRowsTableReferences
                                            ._fromEnvelopeIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (toEnvelopeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.toEnvelopeId,
                                    referencedTable:
                                        $$EnvelopeTransferRowsTableReferences
                                            ._toEnvelopeIdTable(db),
                                    referencedColumn:
                                        $$EnvelopeTransferRowsTableReferences
                                            ._toEnvelopeIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$EnvelopeTransferRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EnvelopeTransferRowsTable,
      EnvelopeTransferRow,
      $$EnvelopeTransferRowsTableFilterComposer,
      $$EnvelopeTransferRowsTableOrderingComposer,
      $$EnvelopeTransferRowsTableAnnotationComposer,
      $$EnvelopeTransferRowsTableCreateCompanionBuilder,
      $$EnvelopeTransferRowsTableUpdateCompanionBuilder,
      (EnvelopeTransferRow, $$EnvelopeTransferRowsTableReferences),
      EnvelopeTransferRow,
      PrefetchHooks Function({bool fromEnvelopeId, bool toEnvelopeId})
    >;
typedef $$CategorisationRuleRowsTableCreateCompanionBuilder =
    CategorisationRuleRowsCompanion Function({
      Value<int> id,
      required String pattern,
      required int envelopeId,
      Value<int> priority,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });
typedef $$CategorisationRuleRowsTableUpdateCompanionBuilder =
    CategorisationRuleRowsCompanion Function({
      Value<int> id,
      Value<String> pattern,
      Value<int> envelopeId,
      Value<int> priority,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });

final class $$CategorisationRuleRowsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CategorisationRuleRowsTable,
          CategorisationRuleRow
        > {
  $$CategorisationRuleRowsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EnvelopeRowsTable _envelopeIdTable(_$AppDatabase db) => db
      .envelopeRows
      .createAlias('categorisation_rules__envelope_id__envelopes__id');

  $$EnvelopeRowsTableProcessedTableManager get envelopeId {
    final $_column = $_itemColumn<int>('envelope_id')!;

    final manager = $$EnvelopeRowsTableTableManager(
      $_db,
      $_db.envelopeRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_envelopeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CategorisationRuleRowsTableFilterComposer
    extends Composer<_$AppDatabase, $CategorisationRuleRowsTable> {
  $$CategorisationRuleRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pattern => $composableBuilder(
    column: $table.pattern,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EnvelopeRowsTableFilterComposer get envelopeId {
    final $$EnvelopeRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.envelopeId,
      referencedTable: $db.envelopeRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvelopeRowsTableFilterComposer(
            $db: $db,
            $table: $db.envelopeRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CategorisationRuleRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $CategorisationRuleRowsTable> {
  $$CategorisationRuleRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pattern => $composableBuilder(
    column: $table.pattern,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EnvelopeRowsTableOrderingComposer get envelopeId {
    final $$EnvelopeRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.envelopeId,
      referencedTable: $db.envelopeRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvelopeRowsTableOrderingComposer(
            $db: $db,
            $table: $db.envelopeRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CategorisationRuleRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategorisationRuleRowsTable> {
  $$CategorisationRuleRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get pattern =>
      $composableBuilder(column: $table.pattern, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$EnvelopeRowsTableAnnotationComposer get envelopeId {
    final $$EnvelopeRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.envelopeId,
      referencedTable: $db.envelopeRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvelopeRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.envelopeRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CategorisationRuleRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategorisationRuleRowsTable,
          CategorisationRuleRow,
          $$CategorisationRuleRowsTableFilterComposer,
          $$CategorisationRuleRowsTableOrderingComposer,
          $$CategorisationRuleRowsTableAnnotationComposer,
          $$CategorisationRuleRowsTableCreateCompanionBuilder,
          $$CategorisationRuleRowsTableUpdateCompanionBuilder,
          (CategorisationRuleRow, $$CategorisationRuleRowsTableReferences),
          CategorisationRuleRow,
          PrefetchHooks Function({bool envelopeId})
        > {
  $$CategorisationRuleRowsTableTableManager(
    _$AppDatabase db,
    $CategorisationRuleRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategorisationRuleRowsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CategorisationRuleRowsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CategorisationRuleRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> pattern = const Value.absent(),
                Value<int> envelopeId = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CategorisationRuleRowsCompanion(
                id: id,
                pattern: pattern,
                envelopeId: envelopeId,
                priority: priority,
                isActive: isActive,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String pattern,
                required int envelopeId,
                Value<int> priority = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CategorisationRuleRowsCompanion.insert(
                id: id,
                pattern: pattern,
                envelopeId: envelopeId,
                priority: priority,
                isActive: isActive,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategorisationRuleRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({envelopeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (envelopeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.envelopeId,
                                referencedTable:
                                    $$CategorisationRuleRowsTableReferences
                                        ._envelopeIdTable(db),
                                referencedColumn:
                                    $$CategorisationRuleRowsTableReferences
                                        ._envelopeIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CategorisationRuleRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategorisationRuleRowsTable,
      CategorisationRuleRow,
      $$CategorisationRuleRowsTableFilterComposer,
      $$CategorisationRuleRowsTableOrderingComposer,
      $$CategorisationRuleRowsTableAnnotationComposer,
      $$CategorisationRuleRowsTableCreateCompanionBuilder,
      $$CategorisationRuleRowsTableUpdateCompanionBuilder,
      (CategorisationRuleRow, $$CategorisationRuleRowsTableReferences),
      CategorisationRuleRow,
      PrefetchHooks Function({bool envelopeId})
    >;
typedef $$AppSettingRowsTableCreateCompanionBuilder =
    AppSettingRowsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingRowsTableUpdateCompanionBuilder =
    AppSettingRowsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingRowsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingRowsTable> {
  $$AppSettingRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingRowsTable> {
  $$AppSettingRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingRowsTable> {
  $$AppSettingRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingRowsTable,
          AppSettingRow,
          $$AppSettingRowsTableFilterComposer,
          $$AppSettingRowsTableOrderingComposer,
          $$AppSettingRowsTableAnnotationComposer,
          $$AppSettingRowsTableCreateCompanionBuilder,
          $$AppSettingRowsTableUpdateCompanionBuilder,
          (
            AppSettingRow,
            BaseReferences<_$AppDatabase, $AppSettingRowsTable, AppSettingRow>,
          ),
          AppSettingRow,
          PrefetchHooks Function()
        > {
  $$AppSettingRowsTableTableManager(
    _$AppDatabase db,
    $AppSettingRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) =>
                  AppSettingRowsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingRowsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingRowsTable,
      AppSettingRow,
      $$AppSettingRowsTableFilterComposer,
      $$AppSettingRowsTableOrderingComposer,
      $$AppSettingRowsTableAnnotationComposer,
      $$AppSettingRowsTableCreateCompanionBuilder,
      $$AppSettingRowsTableUpdateCompanionBuilder,
      (
        AppSettingRow,
        BaseReferences<_$AppDatabase, $AppSettingRowsTable, AppSettingRow>,
      ),
      AppSettingRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AccountRowsTableTableManager get accountRows =>
      $$AccountRowsTableTableManager(_db, _db.accountRows);
  $$EnvelopeGroupRowsTableTableManager get envelopeGroupRows =>
      $$EnvelopeGroupRowsTableTableManager(_db, _db.envelopeGroupRows);
  $$EnvelopeRowsTableTableManager get envelopeRows =>
      $$EnvelopeRowsTableTableManager(_db, _db.envelopeRows);
  $$MovementRowsTableTableManager get movementRows =>
      $$MovementRowsTableTableManager(_db, _db.movementRows);
  $$EnvelopeAllocationRowsTableTableManager get envelopeAllocationRows =>
      $$EnvelopeAllocationRowsTableTableManager(
        _db,
        _db.envelopeAllocationRows,
      );
  $$EnvelopeTransferRowsTableTableManager get envelopeTransferRows =>
      $$EnvelopeTransferRowsTableTableManager(_db, _db.envelopeTransferRows);
  $$CategorisationRuleRowsTableTableManager get categorisationRuleRows =>
      $$CategorisationRuleRowsTableTableManager(
        _db,
        _db.categorisationRuleRows,
      );
  $$AppSettingRowsTableTableManager get appSettingRows =>
      $$AppSettingRowsTableTableManager(_db, _db.appSettingRows);
}
