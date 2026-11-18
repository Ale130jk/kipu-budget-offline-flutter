import 'package:drift/native.dart';
import 'package:kipu_budget/modules/accounts/data/drift_accounts_repository.dart';
import 'package:kipu_budget/modules/envelopes/data/drift_envelopes_repository.dart';
import 'package:kipu_budget/modules/core_db/core_db.dart';
import 'package:kipu_budget/modules/reports/data/drift_reports_repository.dart';
import 'package:kipu_budget/modules/transactions/data/drift_transactions_repository.dart';

class TestEnv {
  TestEnv._(this.db);

  final AppDatabase db;
  late final DriftAccountsRepository accounts;
  late final DriftEnvelopesRepository envelopes;
  late final DriftTransactionsRepository transactions;
  late final DriftReportsRepository reports;

  static Future<TestEnv> create() async {
    final env = TestEnv._(AppDatabase(NativeDatabase.memory()));
    // Force beforeOpen so PRAGMA foreign_keys is applied before assertions.
    await env.db.customSelect('SELECT 1').get();
    env.accounts = DriftAccountsRepository(env.db);
    env.envelopes = DriftEnvelopesRepository(env.db);
    env.transactions = DriftTransactionsRepository(env.db);
    env.reports = DriftReportsRepository(env.db);
    return env;
  }

  Future<void> dispose() => db.close();
}
