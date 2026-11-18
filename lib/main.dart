import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/bootstrap.dart';
import 'app/providers.dart';
import 'modules/accounts/data/drift_accounts_repository.dart';
import 'modules/core_db/core_db.dart';
import 'modules/envelopes/data/drift_envelopes_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase(openDatabaseConnection());
  try {
    await seedStarterData(
      DriftAccountsRepository(database),
      DriftEnvelopesRepository(database),
    );
  } on Object catch (error, stack) {
    // Seeding is best-effort: an empty database still has a usable UI.
    debugPrint('Starter data skipped: $error\n$stack');
  }
  runApp(
    ProviderScope(
      overrides: [databaseProvider.overrideWithValue(database)],
      child: const KipuBudgetApp(),
    ),
  );
}
