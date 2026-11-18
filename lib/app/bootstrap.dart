import '../modules/accounts/domain/account.dart';
import '../modules/accounts/domain/accounts_repository.dart';
import '../modules/envelopes/domain/envelopes_repository.dart';

/// First-run data so the app never opens with an unusable empty state.
Future<void> seedStarterData(
  AccountsRepository accounts,
  EnvelopesRepository envelopes,
) async {
  final existingAccounts = await accounts.watchAccounts().first;
  if (existingAccounts.isEmpty) {
    await accounts.createAccount(
      name: 'Efectivo',
      type: AccountType.cash,
      openingBalanceCents: 0,
    );
    await accounts.createAccount(
      name: 'Débito',
      type: AccountType.debit,
      openingBalanceCents: 0,
    );
    await accounts.createAccount(
      name: 'Ahorro',
      type: AccountType.savings,
      openingBalanceCents: 0,
    );
  }

  final existingGroups = await envelopes.watchGroups().first;
  if (existingGroups.isEmpty) {
    final housing = await envelopes.createGroup('Vivienda');
    await envelopes.createEnvelope(groupId: housing, name: 'Alquiler');
    await envelopes.createEnvelope(groupId: housing, name: 'Servicios');

    final daily = await envelopes.createGroup('Vida diaria');
    await envelopes.createEnvelope(groupId: daily, name: 'Comida');
    await envelopes.createEnvelope(groupId: daily, name: 'Transporte');

    final savings = await envelopes.createGroup('Ahorro');
    await envelopes.createEnvelope(
      groupId: savings,
      name: 'Fondo de emergencia',
    );
  }
}
