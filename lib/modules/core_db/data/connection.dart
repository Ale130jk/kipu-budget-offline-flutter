import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

const databaseFileName = 'kipu_budget.sqlite';

/// Opens the on-disk SQLite database in a background isolate.
///
/// Tests bypass this and use `NativeDatabase.memory()` directly.
LazyDatabase openDatabaseConnection({String? directoryPath}) {
  return LazyDatabase(() async {
    final directory = directoryPath != null
        ? Directory(directoryPath)
        : await getApplicationSupportDirectory();
    await directory.create(recursive: true);
    final file = File(p.join(directory.path, databaseFileName));
    return NativeDatabase.createInBackground(file);
  });
}
