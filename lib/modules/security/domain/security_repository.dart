import 'dart:typed_data';

/// Public seam of the security module.
abstract interface class SecurityRepository {
  Future<bool> isBiometricEnabled();

  Future<bool> canUseBiometrics();

  /// Enabling requires a successful biometric check.
  Future<void> setBiometricEnabled(bool enabled);

  Future<bool> authenticate();

  Future<Uint8List> exportBackup();

  /// Replaces every table with the backup contents in one SQL transaction.
  /// Throws [DomainException] when the file is not a compatible backup.
  Future<void> restoreBackup(Uint8List bytes);

  String backupFileName([DateTime? now]);
}
