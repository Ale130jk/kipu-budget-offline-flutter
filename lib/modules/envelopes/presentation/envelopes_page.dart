import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers.dart';
import '../../../../core/money/money.dart';
import '../../../../core/time/months.dart';
import '../../../../core/ui/app_colors.dart';
import '../../../../core/ui/dialogs.dart';
import '../../../../core/ui/money_text.dart';
import '../../../../core/ui/snacks.dart';
import '../domain/envelope.dart';
import 'assign_sheet.dart';
import 'move_sheet.dart';

class EnvelopesPage extends ConsumerWidget {
  const EnvelopesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = ref.watch(selectedMonthProvider);
    final budgets = ref.watch(monthBudgetsProvider);
    final toAssign = ref.watch(toAssignProvider).value ?? 0;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobres'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.add_circle_outline),
            onSelected: (value) {
              if (value == 'group') {
                _createGroup(context, ref);
              } else {
                _createEnvelope(context, ref);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'envelope', child: Text('Nuevo sobre')),
              PopupMenuItem(value: 'group', child: Text('Nuevo grupo')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
        children: [
          _MonthSelector(month: month),
          const SizedBox(height: 12),
          _ToAssignHero(toAssignCents: toAssign),
          const SizedBox(height: 20),
          budgets.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => _ErrorCard(message: error.toString()),
            data: (rows) {
              if (rows.isEmpty) {
                return _EmptyEnvelopes(
                  onCreate: () => _createGroup(context, ref),
                );
              }
              final grouped = <String, List<EnvelopeBudget>>{};
              for (final row in rows) {
                grouped.putIfAbsent(row.groupName, () => []).add(row);
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final entry in grouped.entries) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Text(
                        entry.key.toUpperCase(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w700,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    for (final budget in entry.value)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _EnvelopeCard(
                          budget: budget,
                          month: month,
                          onAssign: () => showAssignSheet(
                            context,
                            initialEnvelopeId: budget.envelopeId,
                          ),
                          onMoveFrom: () => showMoveSheet(
                            context,
                            fromEnvelopeId: budget.envelopeId,
                          ),
                          onCover: () => showMoveSheet(
                            context,
                            toEnvelopeId: budget.envelopeId,
                          ),
                        ),
                      ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _createGroup(BuildContext context, WidgetRef ref) async {
    final name = await showTextDialog(
      context,
      title: 'Nuevo grupo',
      label: 'Nombre del grupo',
      confirmLabel: 'Crear grupo',
    );
    if (name == null || !context.mounted) return;
    try {
      await ref.read(envelopesRepositoryProvider).createGroup(name);
      if (context.mounted) showInfoSnack(context, 'Grupo creado.');
    } on Object catch (error) {
      if (context.mounted) showErrorSnack(context, error);
    }
  }

  Future<void> _createEnvelope(BuildContext context, WidgetRef ref) async {
    final groups = ref.read(groupsProvider).value ?? const [];
    if (groups.isEmpty) {
      showInfoSnack(context, 'Crea primero un grupo de sobres.');
      return;
    }
    final result = await showDialog<({int groupId, String name})>(
      context: context,
      builder: (context) => _NewEnvelopeDialog(groups: groups),
    );
    if (result == null || !context.mounted) return;
    try {
      await ref
          .read(envelopesRepositoryProvider)
          .createEnvelope(groupId: result.groupId, name: result.name);
      if (context.mounted) showInfoSnack(context, 'Sobre creado.');
    } on Object catch (error) {
      if (context.mounted) showErrorSnack(context, error);
    }
  }
}

class _MonthSelector extends ConsumerWidget {
  const _MonthSelector({required this.month});

  final String month;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(selectedMonthProvider.notifier);
    return Row(
      children: [
        IconButton(
          onPressed: controller.previous,
          icon: const Icon(Icons.chevron_left),
          tooltip: 'Mes anterior',
        ),
        Expanded(
          child: GestureDetector(
            onTap: controller.reset,
            child: Text(
              monthLabel(month),
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        IconButton(
          onPressed: controller.next,
          icon: const Icon(Icons.chevron_right),
          tooltip: 'Mes siguiente',
        ),
      ],
    );
  }
}

class _ToAssignHero extends StatelessWidget {
  const _ToAssignHero({required this.toAssignCents});

  final int toAssignCents;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primary,
            Color.lerp(scheme.primary, Colors.black, 0.35)!,
          ],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Por asignar',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 6),
                MoneyText(
                  toAssignCents,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Base cero: asigna cada ingreso a un sobre.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton(
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, 44),
              backgroundColor: Colors.white,
              foregroundColor: scheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            onPressed: () => showAssignSheet(context),
            child: const Text('Asignar'),
          ),
        ],
      ),
    );
  }
}

class _EnvelopeCard extends StatelessWidget {
  const _EnvelopeCard({
    required this.budget,
    required this.month,
    required this.onAssign,
    required this.onMoveFrom,
    required this.onCover,
  });

  final EnvelopeBudget budget;
  final String month;
  final VoidCallback onAssign;
  final VoidCallback onMoveFrom;
  final VoidCallback onCover;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = envelopeColor(
      context,
      overage: budget.isOverage,
      warning: budget.isWarning,
    );
    return Dismissible(
      key: ValueKey('envelope-${budget.envelopeId}'),
      direction: DismissDirection.startToEnd,
      confirmDismiss: (_) async {
        onMoveFrom();
        return false;
      },
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(Icons.swap_horiz, color: theme.colorScheme.onPrimaryContainer),
            const SizedBox(width: 8),
            Text(
              'Mover',
              style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
            ),
          ],
        ),
      ),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onAssign,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        budget.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    MoneyText(
                      budget.availableCents,
                      color: color,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Gastado ${formatCents(budget.spentCents)} de '
                  '${formatCents(budget.assignedCents)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: budget.progress,
                    minHeight: 6,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
                if (budget.isOverage) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.error_outline, size: 16, color: color),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Sobregiro de ${formatCents(-budget.availableCents)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: onCover,
                        child: const Text('Cubrir'),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyEnvelopes extends StatelessWidget {
  const _EmptyEnvelopes({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 40,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            const Text('Aún no tienes sobres.'),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: onCreate,
              child: const Text('Crear primer grupo'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text('No se pudieron cargar los sobres.\n$message'),
      ),
    );
  }
}

class _NewEnvelopeDialog extends StatefulWidget {
  const _NewEnvelopeDialog({required this.groups});

  final List<EnvelopeGroup> groups;

  @override
  State<_NewEnvelopeDialog> createState() => _NewEnvelopeDialogState();
}

class _NewEnvelopeDialogState extends State<_NewEnvelopeDialog> {
  late int _groupId = widget.groups.first.id;
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nuevo sobre'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<int>(
            initialValue: _groupId,
            decoration: const InputDecoration(labelText: 'Grupo'),
            items: [
              for (final group in widget.groups)
                DropdownMenuItem(value: group.id, child: Text(group.name)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _groupId = value);
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            autofocus: true,
            maxLength: 80,
            decoration: InputDecoration(
              labelText: 'Nombre del sobre',
              errorText: _error,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            final name = _controller.text.trim();
            if (name.isEmpty) {
              setState(() => _error = 'Este campo es obligatorio.');
              return;
            }
            Navigator.of(context).pop((groupId: _groupId, name: name));
          },
          child: const Text('Crear'),
        ),
      ],
    );
  }
}
