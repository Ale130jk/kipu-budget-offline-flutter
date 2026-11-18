class EnvelopeGroup {
  const EnvelopeGroup({
    required this.id,
    required this.name,
    required this.colorHex,
    required this.sortOrder,
  });

  final int id;
  final String name;
  final String? colorHex;
  final int sortOrder;
}

class EnvelopeBudget {
  const EnvelopeBudget({
    required this.envelopeId,
    required this.groupId,
    required this.groupName,
    required this.name,
    required this.assignedCents,
    required this.spentCents,
  });

  final int envelopeId;
  final int groupId;
  final String groupName;
  final String name;
  final int assignedCents;
  final int spentCents;

  int get availableCents => assignedCents - spentCents;

  bool get isOverage => availableCents < 0;

  bool get isWarning {
    if (assignedCents <= 0 || isOverage) return false;
    return spentCents * 100 >= assignedCents * 80;
  }

  double get progress {
    if (assignedCents <= 0) return 0;
    return (spentCents / assignedCents).clamp(0, 1);
  }
}
