import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/money/money.dart';
import '../../../core/ui/money_text.dart';
import '../domain/envelope.dart';

Future<void> showAssignSheet(BuildContext context, {int? initialEnvelopeId}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => AssignSheet(initialEnvelopeId: initialEnvelopeId),
  );
}

class AssignSheet extends ConsumerStatefulWidget {
  const AssignSheet({super.key, this.initialEnvelopeId});

  final int? initialEnvelopeId;

  @override
  ConsumerState<AssignSheet> createState() => _AssignSheetState();
}

class _AssignSheetState extends ConsumerState<AssignSheet> {
  final _controller = TextEditingController();
  int? _envelopeId;
  String? _error;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _envelopeId = widget.initialEnvelopeId;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save(List<EnvelopeBudget> budgets) async {
    final cents = parseCents(_controller.text);
    if (cents == null || cents <= 0) {
      setState(() => _error = 'Ingresa un monto mayor que cero.');
      return;
    }
    final envelopeId = _envelopeId ?? budgets.first.envelopeId;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(envelopesRepositoryProvider)
          .assign(
            month: ref.read(selectedMonthProvider),
            envelopeId: envelopeId,
            deltaCents: cents,
          );
      ref.read(dataRevisionProvider.notifier).bump();
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      Navigator.of(context).pop();
      messenger.showSnackBar(
        SnackBar(content: Text('Asignaste ${formatCents(cents)}.')),
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
    final toAssign = ref.watch(toAssignProvider).value ?? 0;
    final selectedId = _envelopeId ?? budgets.firstOrNull?.envelopeId;
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
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Asignar a un sobre',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                'Por asignar: ',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              MoneyText(
                toAssign,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (budgets.isEmpty)
            const Text('Primero crea un sobre.')
          else ...[
            DropdownButtonFormField<int>(
              initialValue: selectedId,
              decoration: const InputDecoration(labelText: 'Sobre'),
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
              onChanged: (value) => setState(() => _envelopeId = value),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
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
                  : const Text('Asignar'),
            ),
          ],
        ],
      ),
    );
  }
}
