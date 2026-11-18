import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/money/money.dart';
import '../../../core/ui/money_text.dart';
import '../domain/movement.dart';

Future<bool?> showQuickAddSheet(BuildContext context) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => const QuickAddSheet(),
  );
}

class QuickAddSheet extends ConsumerStatefulWidget {
  const QuickAddSheet({super.key});

  @override
  ConsumerState<QuickAddSheet> createState() => _QuickAddSheetState();
}

class _QuickAddSheetState extends ConsumerState<QuickAddSheet> {
  final _description = TextEditingController();
  MovementType _type = MovementType.expense;
  String _amountInput = '';
  int? _accountId;
  int? _envelopeId;
  bool _manualEnvelope = false;
  int? _suggestedEnvelopeId;
  Timer? _suggestTimer;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _suggestTimer?.cancel();
    _description.dispose();
    super.dispose();
  }

  int get _cents => parseCents(_amountInput) ?? 0;

  void _pressKey(String key) {
    setState(() {
      _error = null;
      if (key == 'back') {
        if (_amountInput.isNotEmpty) {
          _amountInput = _amountInput.substring(0, _amountInput.length - 1);
        }
        return;
      }
      if (key == '.') {
        if (!_amountInput.contains('.')) {
          _amountInput = _amountInput.isEmpty ? '0.' : '$_amountInput.';
        }
        return;
      }
      final parts = _amountInput.split('.');
      if (parts.length == 2 && parts[1].length >= 2) return;
      if (_amountInput.length >= 12) return;
      if (_amountInput == '0') {
        _amountInput = key;
      } else {
        _amountInput += key;
      }
    });
  }

  void _onDescriptionChanged(String value) {
    _suggestTimer?.cancel();
    if (_type != MovementType.expense) return;
    _suggestTimer = Timer(const Duration(milliseconds: 250), () async {
      final suggestion = await ref
          .read(transactionsRepositoryProvider)
          .suggestEnvelope(value);
      if (!mounted || _description.text != value) return;
      setState(() {
        _suggestedEnvelopeId = suggestion;
        if (!_manualEnvelope) _envelopeId = suggestion;
      });
    });
  }

  Future<void> _save() async {
    final accounts = ref.read(accountsProvider).value ?? const [];
    if (accounts.isEmpty) {
      setState(() => _error = 'Crea una cuenta en Herramientas.');
      return;
    }
    if (_cents <= 0) {
      setState(() => _error = 'Ingresa un monto mayor que cero.');
      return;
    }
    final accountId = _accountId ?? accounts.first.id;
    final budgets = ref.read(currentMonthBudgetsProvider).value ?? const [];
    final envelopeName = budgets
        .where((budget) => budget.envelopeId == _envelopeId)
        .map((budget) => budget.name)
        .firstOrNull;
    final description = _description.text.trim().isEmpty
        ? (_type == MovementType.income ? 'Ingreso' : envelopeName ?? 'Gasto')
        : _description.text.trim();
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final repository = ref.read(transactionsRepositoryProvider);
      if (_type == MovementType.income) {
        await repository.recordIncome(
          accountId: accountId,
          amountCents: _cents,
          description: description,
          date: DateTime.now(),
        );
      } else {
        await repository.recordExpense(
          accountId: accountId,
          envelopeId: _envelopeId,
          amountCents: _cents,
          description: description,
          date: DateTime.now(),
        );
      }
      ref.read(dataRevisionProvider.notifier).bump();
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      Navigator.of(context).pop(true);
      messenger.showSnackBar(
        SnackBar(content: Text('${_type.label} registrado.')),
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
    final theme = Theme.of(context);
    final accounts = ref.watch(accountsProvider);
    final budgets = ref.watch(currentMonthBudgetsProvider);
    final accountRows = accounts.value ?? const [];
    final budgetRows = budgets.value ?? const [];
    final selectedAccount = _accountId ?? accountRows.firstOrNull?.id;
    final suggested = budgetRows
        .where((budget) => budget.envelopeId == _suggestedEnvelopeId)
        .firstOrNull;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'Registro rápido',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
                tooltip: 'Cerrar',
              ),
            ],
          ),
          SegmentedButton<MovementType>(
            segments: const [
              ButtonSegment(
                value: MovementType.expense,
                label: Text('Gasto'),
                icon: Icon(Icons.north_east),
              ),
              ButtonSegment(
                value: MovementType.income,
                label: Text('Ingreso'),
                icon: Icon(Icons.south_west),
              ),
            ],
            selected: {_type},
            onSelectionChanged: (selection) {
              setState(() {
                _type = selection.first;
                if (_type == MovementType.income) {
                  _envelopeId = null;
                  _suggestedEnvelopeId = null;
                }
              });
            },
          ),
          const SizedBox(height: 14),
          Center(
            child: MoneyText(
              _cents,
              style: theme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: _type == MovementType.income
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _description,
            onChanged: _onDescriptionChanged,
            maxLength: 120,
            decoration: const InputDecoration(
              hintText: 'Descripción (ej. Supermercado)',
              counterText: '',
              prefixIcon: Icon(Icons.edit_note),
            ),
          ),
          if (_type == MovementType.expense && suggested != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Sugerido por regla: ${suggested.name}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Cuenta', style: theme.textTheme.labelMedium),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final account in accountRows)
                ChoiceChip(
                  label: Text(account.name),
                  selected: selectedAccount == account.id,
                  onSelected: (_) => setState(() => _accountId = account.id),
                ),
            ],
          ),
          if (_type == MovementType.expense) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Sobre', style: theme.textTheme.labelMedium),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Sin sobre'),
                  selected: _envelopeId == null,
                  onSelected: (_) => setState(() {
                    _envelopeId = null;
                    _manualEnvelope = true;
                  }),
                ),
                for (final budget in budgetRows.take(8))
                  ChoiceChip(
                    label: Text(budget.name),
                    selected: _envelopeId == budget.envelopeId,
                    onSelected: (_) => setState(() {
                      _envelopeId = budget.envelopeId;
                      _manualEnvelope = true;
                    }),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 14),
          _Keypad(onKey: _pressKey),
          if (_error != null) ...[
            const SizedBox(height: 10),
            Text(
              _error!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
          const SizedBox(height: 14),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    _type == MovementType.income
                        ? 'Registrar ingreso'
                        : 'Registrar gasto',
                  ),
          ),
        ],
      ),
    );
  }
}

class _Keypad extends StatelessWidget {
  const _Keypad({required this.onKey});

  final void Function(String key) onKey;

  @override
  Widget build(BuildContext context) {
    const keys = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '.',
      '0',
      'back',
    ];
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 2.1,
      children: [
        for (final key in keys)
          Material(
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => onKey(key),
              child: Center(
                child: key == 'back'
                    ? const Icon(Icons.backspace_outlined, size: 22)
                    : Text(
                        key,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),
      ],
    );
  }
}
