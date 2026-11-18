import 'account.dart';

/// Public seam of the accounts module.
abstract interface class AccountsRepository {
  Stream<List<Account>> watchAccounts();

  Future<Account> createAccount({
    required String name,
    required AccountType type,
    required int openingBalanceCents,
  });

  Future<void> setArchived(int accountId, bool archived);
}
