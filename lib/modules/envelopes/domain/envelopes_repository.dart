import 'envelope.dart';

/// Public seam of the envelopes module (zero-based budgeting).
abstract interface class EnvelopesRepository {
  Stream<List<EnvelopeGroup>> watchGroups();

  /// Budget execution for one `YYYY-MM` period.
  Stream<List<EnvelopeBudget>> watchMonth(String month);

  /// Money received but not assigned to any envelope yet.
  Stream<int> watchToAssign();

  Future<int> createGroup(String name);

  Future<int> createEnvelope({required int groupId, required String name});

  /// Positive delta assigns money, negative delta returns it to the pool.
  Future<void> assign({
    required String month,
    required int envelopeId,
    required int deltaCents,
  });

  /// Covers an overage or rebalances money between envelopes.
  Future<void> moveBetweenEnvelopes({
    required String month,
    required int fromEnvelopeId,
    required int toEnvelopeId,
    required int amountCents,
    String? note,
  });
}
