import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/money/money.dart';
import '../domain/envelope.dart';

Future<void> showMoveSheet(
  BuildContext context, {
  int? fromEnvelopeId,
  int? toEnvelopeId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) =>
        MoveSheet(fromEnvelopeId: fromEnvelopeId, toEnvelopeId: toEnvelopeId),
  );
}

class MoveSheet extends ConsumerStatefulWidget {
  const MoveSheet({super.key, this.fromEnvelopeId, this.toEnvelopeId});

  final int? fromEnvelopeId;
  final int? toEnvelopeId;

  @override
  ConsumerState<MoveSheet> createState() => _MoveSheetState();
}

class _MoveSheetState extends ConsumerState<MoveSheet> {
  final _controller = TextEditingController();
  int? _fromId;
  int? _toId;
  String? _error;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _fromId = widget.fromEnvelopeId;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Resolves the visible "Hacia" selection, including the implicit default
  /// used when the sheet opens from a "Cubrir" action.
  int _targetFor(List<EnvelopeBudget> budgets, int fromId) {
    final targets = budgets
        .where((budget) => budget.envelopeId != fromId)
        .toList(growable: false);
    final selected = _toId;
    if (selected != null &&
        targets.any((budget) => budget.envelopeId == selected)) {
      return selected;
    }
    final preferred = widget.toEnvelopeId;
    if (preferred != null &&
        targets.any((budget) => budget.envelopeId == preferred)) {
      return preferred;
    }
    return targets.first.envelopeId;
  }

  Future<void> _save(List<EnvelopeBudget> budgets) async {
    final fromId = _fromId ?? budgets.first.envelopeId;
    final targetId = _targetFor(budgets, fromId);
    final cents = parseCents(_controller.text);
    if (targetId == fromId) {
      setState(() => _error = 'Elige dos sobres distintos.');
      return;
    }
    if (cents == null || cents <= 0) {
      setState(() => _error = 'Ingresa un monto mayor que cero.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(envelopesRepositoryProvider)
          .moveBetweenEnvelopes(
            month: ref.read(selectedMonthProvider),
            fromEnvelopeId: fromId,
            toEnvelopeId: targetId,
            amountCents: cents,
          );
      ref.read(dataRevisionProvider.notifier).bump();
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      Navigator.of(context).pop();
      messenger.showSnackBar(
        SnackBar(content: Text('Moviste ${formatCents(cents)}.')),
      );
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final budgets = ref.watch(monthBudgetsProvider).value ?? const [];
    if (budgets.length < 2) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Necesitas al menos dos sobres para mover dinero.'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Entendido'),
            ),
          ],
        ),
      );
    }
    final fromId = _fromId ?? budgets.first.envelopeId;
    final fromBudget = budgets.firstWhere(
      (budget) => budget.envelopeId == fromId,
      orElse: () => budgets.first,
    );
    final targets = budgets
        .where((budget) => budget.envelopeId != fromId)
        .toList(growable: false);
    final targetId = _targetFor(budgets, fromId);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.toEnvelopeId == null
                ? 'Mover entre sobres'
                : 'Cubrir sobregiro',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            initialValue: fromId,
            decoration: const InputDecoration(labelText: 'Desde'),
            items: [
              for (final budget in budgets)
                DropdownMenuItem(
                  value: budget.envelopeId,
                  child: Text(
                    '${budget.name} · ${formatCents(budget.availableCents)}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
            onChanged: (value) => setState(() {
              _fromId = value;
              if (_toId == value) _toId = null;
            }),
          ),
          const SizedBox(height: 8),
          Text(
            'Disponible: ${formatCents(fromBudget.availableCents)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            initialValue: targetId,
            decoration: const InputDecoration(labelText: 'Hacia'),
            items: [
              for (final budget in targets)
                DropdownMenuItem(
                  value: budget.envelopeId,
                  child: Text(budget.name, overflow: TextOverflow.ellipsis),
                ),
            ],
            onChanged: (value) => setState(() => _toId = value),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            autofocus: widget.toEnvelopeId != null,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
            ],
            decoration: InputDecoration(
              prefixText: '$kCurrencySymbol ',
              hintText: '0.00',
              errorText: _error,
            ),
            onSubmitted: (_) => _save(budgets),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _saving ? null : () => _save(budgets),
            child: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Mover dinero'),
          ),
        ],
      ),
    );
  }
}
