import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/time/dates.dart';
import '../../../core/ui/app_colors.dart';
import '../../../core/ui/money_text.dart';
import '../domain/movement.dart';

class MovementsPage extends ConsumerStatefulWidget {
  const MovementsPage({super.key});

  @override
  ConsumerState<MovementsPage> createState() => _MovementsPageState();
}

class _MovementsPageState extends ConsumerState<MovementsPage> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.text = ref.read(movementFilterProvider).query;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(movementFilterProvider.notifier).setQuery(value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(movementFilterProvider);
    final movements = ref.watch(visibleMovementsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Movimientos')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Buscar por descripción, cuenta o sobre',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      ),
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _filterChip(context, 'Todos', MovementFilterKind.all, filter),
                const SizedBox(width: 8),
                _filterChip(context, 'Hoy', MovementFilterKind.today, filter),
                const SizedBox(width: 8),
                _filterChip(
                  context,
                  'Este mes',
                  MovementFilterKind.thisMonth,
                  filter,
                ),
                const SizedBox(width: 8),
                _filterChip(
                  context,
                  'Sobregiros',
                  MovementFilterKind.overage,
                  filter,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: movements.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('No se pudieron cargar los movimientos.\n$error'),
                ),
              ),
              data: (rows) {
                if (rows.isEmpty) {
                  return const _EmptyMovements();
                }
                return _GroupedMovements(rows: rows);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(
    BuildContext context,
    String label,
    MovementFilterKind kind,
    MovementFilter filter,
  ) {
    return ChoiceChip(
      label: Text(label),
      selected: filter.kind == kind,
      onSelected: (_) {
        ref.read(movementFilterProvider.notifier).setKind(kind);
      },
    );
  }
}

class _GroupedMovements extends StatelessWidget {
  const _GroupedMovements({required this.rows});

  final List<MovementView> rows;

  @override
  Widget build(BuildContext context) {
    final grouped = <DateTime, List<MovementView>>{};
    for (final row in rows) {
      final date = DateTime(
        row.movement.date.year,
        row.movement.date.month,
        row.movement.date.day,
      );
      grouped.putIfAbsent(date, () => []).add(row);
    }
    final days = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
      children: [
        for (final day in days) ...[
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 6),
            child: Text(
              friendlyDayLabel(day),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Card(
            child: Column(
              children: [
                for (var index = 0; index < grouped[day]!.length; index++) ...[
                  _MovementTile(row: grouped[day]![index]),
                  if (index < grouped[day]!.length - 1)
                    Divider(
                      height: 1,
                      indent: 64,
                      color: Theme.of(
                        context,
                      ).colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _MovementTile extends StatelessWidget {
  const _MovementTile({required this.row});

  final MovementView row;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final movement = row.movement;
    final isIncome = movement.type == MovementType.income;
    final isTransfer = movement.type == MovementType.transfer;
    final color = isIncome
        ? positiveColor(context)
        : theme.colorScheme.onSurfaceVariant;
    final subtitle = isTransfer
        ? '${row.accountName} a ${row.transferAccountName ?? 'otra cuenta'}'
        : [
            row.accountName,
            if (row.envelopeName != null) row.envelopeName!,
          ].join(' · ');
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: isIncome
            ? positiveColor(context).withValues(alpha: 0.14)
            : theme.colorScheme.surfaceContainerHighest,
        foregroundColor: isIncome
            ? positiveColor(context)
            : theme.colorScheme.onSurfaceVariant,
        child: Icon(
          isTransfer
              ? Icons.swap_horiz
              : isIncome
              ? Icons.south_west
              : Icons.north_east,
          size: 20,
        ),
      ),
      title: Text(
        movement.description,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: MoneyText(
        movement.amountCents,
        showPlus: isIncome,
        color: color,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _EmptyMovements extends StatelessWidget {
  const _EmptyMovements();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 44,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 12),
          const Text('Sin movimientos para este filtro.'),
          const SizedBox(height: 4),
          Text(
            'Usa el botón + para registrar uno.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
