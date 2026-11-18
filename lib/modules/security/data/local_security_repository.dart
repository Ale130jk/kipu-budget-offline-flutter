import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:local_auth/local_auth.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../../core/domain/domain_exception.dart';
import '../../core_db/core_db.dart';
import '../domain/security_repository.dart';

const _biometricKey = 'biometric_enabled';
const _sqliteHeader = 'SQLite format 3\u0000';

const _tables = [
  'accounts',
  'envelope_groups',
  'envelopes',
  'categorisation_rules',
  'envelope_allocations',
  'envelope_transfers',
  'movements',
  'app_settings',
];

const _deleteOrder = [
  'movements',
  'envelope_transfers',
  'envelope_allocations',
  'categorisation_rules',
  'envelopes',
  'envelope_groups',
  'accounts',
  'app_settings',
];

class LocalSecurityRepository implements SecurityRepository {
  LocalSecurityRepository(
    this._db, {
    LocalAuthentication? authentication,
    Directory? workingDirectory,
  }) : _authentication = authentication ?? LocalAuthentication(),
       _workingDirectory = workingDirectory;

  final AppDatabase _db;
  final LocalAuthentication _authentication;
  final Directory? _workingDirectory;

  @override
  Future<bool> isBiometricEnabled() async {
    return await _readSetting(_biometricKey) == 'true';
  }

  @override
  Future<bool> canUseBiometrics() async {
    try {
      return await _authentication.isDeviceSupported();
    } on Object {
      return false;
    }
  }

  @override
  Future<void> setBiometricEnabled(bool enabled) async {
    if (enabled) {
      if (!await canUseBiometrics()) {
        throw const DomainException(
          'Este dispositivo no tiene biometría configurada.',
        );
      }
      if (!await authenticate()) {
        throw const DomainException(
          'No se pudo verificar tu identidad. La protección sigue desactivada.',
        );
      }
    }
    await _db
        .into(_db.appSettingRows)
        .insertOnConflictUpdate(
          AppSettingRowsCompanion.insert(
            key: _biometricKey,
            value: enabled ? 'true' : 'false',
          ),
        );
  }

  @override
  Future<bool> authenticate() async {
    try {
      return await _authentication.authenticate(
        localizedReason: 'Desbloquea KipuBudget',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } on LocalAuthException {
      return false;
    }
  }

  @override
  Future<Uint8List> exportBackup() async {
    final directory = _workingDirectory ?? await getTemporaryDirectory();
    await directory.create(recursive: true);
    final file = File(p.join(directory.path, 'kipu_budget_snapshot.sqlite'));
    if (await file.exists()) {
      await file.delete();
    }
    final escaped = file.path.replaceAll("'", "''");
    // VACUUM INTO produces a consistent copy while the app keeps writing.
    await _db.customStatement("VACUUM INTO '$escaped'");
    final bytes = await file.readAsBytes();
    await file.delete();
    return bytes;
  }

  @override
  Future<void> restoreBackup(Uint8List bytes) async {
    if (bytes.length < 16 ||
        utf8.decode(bytes.sublist(0, 16), allowMalformed: true) !=
            _sqliteHeader) {
      throw const DomainException(
        'El archivo no es un respaldo de KipuBudget.',
      );
    }
    final directory = _workingDirectory ?? await getTemporaryDirectory();
    await directory.create(recursive: true);
    final file = File(
      p.join(
        directory.path,
        'kipu_budget_restore_${DateTime.now().microsecondsSinceEpoch}.sqlite',
      ),
    );
    await file.writeAsBytes(bytes, flush: true);
    var attached = false;
    try {
      await _db.customStatement('ATTACH DATABASE ? AS backup', [file.path]);
      attached = true;
      final version = await _db
          .customSelect('PRAGMA backup.user_version')
          .getSingle();
      if (version.read<int>('user_version') != _db.schemaVersion) {
        throw const DomainException(
          'El respaldo pertenece a otra versión de la aplicación.',
        );
      }
      final names = await _db
          .customSelect(
            "SELECT name FROM backup.sqlite_master "
            "WHERE type = 'table' AND name IN (${_tables.map((t) => "'$t'").join(',')})",
          )
          .get();
      if (names.length != _tables.length) {
        throw const DomainException('El respaldo está incompleto.');
      }
      await _db.customStatement('PRAGMA foreign_keys = OFF');
      try {
        await _db.transaction(() async {
          for (final table in _deleteOrder) {
            await _db.customUpdate(
              'DELETE FROM $table',
              updates: {_tableByName(table)},
            );
          }
          for (final table in _tables) {
            await _db.customUpdate(
              'INSERT INTO $table SELECT * FROM backup.$table',
              updates: {_tableByName(table)},
            );
          }
          final violations = await _db
              .customSelect('PRAGMA foreign_key_check')
              .get();
          if (violations.isNotEmpty) {
            throw const DomainException(
              'El respaldo tiene referencias rotas y no se restauró.',
            );
          }
        });
      } finally {
        await _db.customStatement('PRAGMA foreign_keys = ON');
      }
    } finally {
      if (attached) {
        await _db.customStatement('DETACH DATABASE backup');
      }
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  @override
  String backupFileName([DateTime? now]) {
    final time = now ?? DateTime.now();
    final stamp =
        '${time.year}${_two(time.month)}${_two(time.day)}_'
        '${_two(time.hour)}${_two(time.minute)}';
    return 'kipu_budget_backup_$stamp.sqlite';
  }

  Future<String?> _readSetting(String key) async {
    final row = await (_db.select(
      _db.appSettingRows,
    )..where((table) => table.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  ResultSetImplementation _tableByName(String name) {
    return switch (name) {
      'accounts' => _db.accountRows,
      'envelope_groups' => _db.envelopeGroupRows,
      'envelopes' => _db.envelopeRows,
      'categorisation_rules' => _db.categorisationRuleRows,
      'envelope_allocations' => _db.envelopeAllocationRows,
      'envelope_transfers' => _db.envelopeTransferRows,
      'movements' => _db.movementRows,
      'app_settings' => _db.appSettingRows,
      _ => throw StateError('Unknown table $name'),
    };
  }

  String _two(int value) => value.toString().padLeft(2, '0');
}
