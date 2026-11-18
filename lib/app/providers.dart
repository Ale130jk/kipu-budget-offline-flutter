import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/time/months.dart';
import '../modules/accounts/data/drift_accounts_repository.dart';
import '../modules/accounts/domain/account.dart';
import '../modules/accounts/domain/accounts_repository.dart';
import '../modules/core_db/core_db.dart';
import '../modules/envelopes/data/drift_envelopes_repository.dart';
import '../modules/envelopes/domain/envelope.dart';
import '../modules/envelopes/domain/envelopes_repository.dart';
import '../modules/reports/data/drift_reports_repository.dart';
import '../modules/reports/domain/monthly_report.dart';
import '../modules/reports/domain/reports_repository.dart';
import '../modules/security/data/local_security_repository.dart';
import '../modules/security/domain/security_repository.dart';
import '../modules/transactions/data/drift_transactions_repository.dart';
import '../modules/transactions/domain/movement.dart';
import '../modules/transactions/domain/transactions_repository.dart';

/// Composition root: the only place that knows every module implementation.
final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase(openDatabaseConnection());
  ref.onDispose(database.close);
  return database;
});

final accountsRepositoryProvider = Provider<AccountsRepository>((ref) {
  return DriftAccountsRepository(ref.watch(databaseProvider));
});

final envelopesRepositoryProvider = Provider<EnvelopesRepository>((ref) {
  return DriftEnvelopesRepository(ref.watch(databaseProvider));
});

final transactionsRepositoryProvider = Provider<TransactionsRepository>((ref) {
  return DriftTransactionsRepository(ref.watch(databaseProvider));
});

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  return DriftReportsRepository(ref.watch(databaseProvider));
});

final securityRepositoryProvider = Provider<SecurityRepository>((ref) {
  return LocalSecurityRepository(ref.watch(databaseProvider));
});

/// Bumped after writes that do not flow through a Drift stream (reports).
class DataRevision extends Notifier<int> {
  @override
  int build() => 0;

  void bump() => state++;
}

final dataRevisionProvider = NotifierProvider<DataRevision, int>(
  DataRevision.new,
);

class SelectedMonthController extends Notifier<String> {
  @override
  String build() => currentMonthKey();

  void previous() => state = shiftMonth(state, -1);

  void next() => state = shiftMonth(state, 1);

  void reset() => state = currentMonthKey();
}

final selectedMonthProvider = NotifierProvider<SelectedMonthController, String>(
  SelectedMonthController.new,
);

enum MovementFilterKind { all, today, thisMonth, overage }

class MovementFilter {
  const MovementFilter({this.query = '', this.kind = MovementFilterKind.all});

  final String query;
  final MovementFilterKind kind;

  MovementFilter copyWith({String? query, MovementFilterKind? kind}) {
    return MovementFilter(query: query ?? this.query, kind: kind ?? this.kind);
  }
}

class MovementFilterController extends Notifier<MovementFilter> {
  @override
  MovementFilter build() => const MovementFilter();

  void setQuery(String query) => state = state.copyWith(query: query);

  void setKind(MovementFilterKind kind) => state = state.copyWith(kind: kind);
}

final movementFilterProvider =
    NotifierProvider<MovementFilterController, MovementFilter>(
      MovementFilterController.new,
    );

final accountsProvider = StreamProvider<List<Account>>((ref) {
  return ref.watch(accountsRepositoryProvider).watchAccounts();
});

final groupsProvider = StreamProvider<List<EnvelopeGroup>>((ref) {
  return ref.watch(envelopesRepositoryProvider).watchGroups();
});

final monthBudgetsProvider = StreamProvider<List<EnvelopeBudget>>((ref) {
  final month = ref.watch(selectedMonthProvider);
  return ref.watch(envelopesRepositoryProvider).watchMonth(month);
});

final toAssignProvider = StreamProvider<int>((ref) {
  return ref.watch(envelopesRepositoryProvider).watchToAssign();
});

final currentMonthBudgetsProvider = StreamProvider<List<EnvelopeBudget>>((ref) {
  return ref.watch(envelopesRepositoryProvider).watchMonth(currentMonthKey());
});

final overageEnvelopeIdsProvider = Provider<Set<int>>((ref) {
  final budgets = ref.watch(currentMonthBudgetsProvider).value ?? const [];
  return {
    for (final budget in budgets)
      if (budget.isOverage) budget.envelopeId,
  };
});

final movementsProvider = StreamProvider<List<MovementView>>((ref) {
  final filter = ref.watch(movementFilterProvider);
  // shortcut: the "Hoy"/"Este mes" windows are captured when the provider is
  // built; a date rollover while the app stays open needs a filter change.
  final now = DateTime.now();
  DateTime? from;
  DateTime? to;
  switch (filter.kind) {
    case MovementFilterKind.all:
      break;
    case MovementFilterKind.today:
      from = DateTime(now.year, now.month, now.day);
      to = DateTime(now.year, now.month, now.day + 1);
    case MovementFilterKind.thisMonth:
      from = monthStart(currentMonthKey());
      to = monthEnd(currentMonthKey());
    case MovementFilterKind.overage:
      from = monthStart(currentMonthKey());
      to = monthEnd(currentMonthKey());
  }
  return ref
      .watch(transactionsRepositoryProvider)
      .watchMovements(from: from, to: to, query: filter.query);
});

final visibleMovementsProvider = Provider<AsyncValue<List<MovementView>>>((
  ref,
) {
  final movements = ref.watch(movementsProvider);
  if (ref.watch(movementFilterProvider).kind != MovementFilterKind.overage) {
    return movements;
  }
  final overageIds = ref.watch(overageEnvelopeIdsProvider);
  return movements.whenData(
    (rows) => rows
        .where(
          (row) =>
              row.movement.envelopeId != null &&
              overageIds.contains(row.movement.envelopeId),
        )
        .toList(growable: false),
  );
});

final rulesProvider = StreamProvider<List<CategorisationRule>>((ref) {
  return ref.watch(transactionsRepositoryProvider).watchRules();
});

final monthlyReportProvider = FutureProvider<MonthlyReport>((ref) {
  ref.watch(dataRevisionProvider);
  final month = ref.watch(selectedMonthProvider);
  return ref.watch(reportsRepositoryProvider).buildMonthlyReport(month);
});

final cashFlowProvider = FutureProvider<List<MonthlyCashFlow>>((ref) {
  ref.watch(dataRevisionProvider);
  final month = ref.watch(selectedMonthProvider);
  return ref.watch(reportsRepositoryProvider).monthlyCashFlow(endMonth: month);
});

final biometricEnabledProvider = FutureProvider<bool>((ref) {
  return ref.watch(securityRepositoryProvider).isBiometricEnabled();
});

final biometricSupportedProvider = FutureProvider<bool>((ref) {
  return ref.watch(securityRepositoryProvider).canUseBiometrics();
});
