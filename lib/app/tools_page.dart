import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../core/domain/domain_exception.dart';
import '../core/money/money.dart';
import '../core/time/months.dart';
import '../core/ui/money_text.dart';
import '../core/ui/snacks.dart';
import '../modules/accounts/domain/account.dart';
import '../modules/envelopes/domain/envelope.dart';
import '../modules/transactions/domain/movement.dart';
import 'providers.dart';

class ToolsPage extends ConsumerStatefulWidget {
  const ToolsPage({super.key});

  @override
  ConsumerState<ToolsPage> createState() => _ToolsPageState();
}

class _ToolsPageState extends ConsumerState<ToolsPage> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() action, {String? success}) async {
    if (_busy || !mounted) return;
    setState(() => _busy = true);
    try {
      await action();
      if (mounted && success != null) showInfoSnack(context, success);
    } on Object catch (error) {
      if (mounted) showErrorSnack(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _addAccount() async {
    final draft = await showDialog<_AccountDraft>(
      context: context,
      builder: (context) => const _AccountDialog(),
    );
    if (draft == null) return;
    await _run(() async {
      await ref
          .read(accountsRepositoryProvider)
          .createAccount(
            name: draft.name,
            type: draft.type,
            openingBalanceCents: draft.openingBalanceCents,
          );
      ref.read(dataRevisionProvider.notifier).bump();
    }, success: 'Cuenta creada.');
  }

  Future<void> _toggleArchive(Account account) async {
    await _run(() async {
      await ref
          .read(accountsRepositoryProvider)
          .setArchived(account.id, !account.archived);
      ref.read(dataRevisionProvider.notifier).bump();
    }, success: account.archived ? 'Cuenta reactivada.' : 'Cuenta archivada.');
  }

  Future<void> _transfer(List<Account> accounts) async {
    final active = accounts.where((account) => !account.archived).toList();
    if (active.length < 2) {
      showInfoSnack(context, 'Necesitas dos cuentas activas para transferir.');
      return;
    }
    final draft = await showDialog<_AccountTransfer>(
      context: context,
      builder: (context) => _TransferDialog(accounts: active),
    );
    if (draft == null) return;
    await _run(() async {
      await ref
          .read(transactionsRepositoryProvider)
          .recordTransfer(
            fromAccountId: draft.fromAccountId,
            toAccountId: draft.toAccountId,
            amountCents: draft.amountCents,
            description: draft.description,
            date: DateTime.now(),
          );
      ref.read(dataRevisionProvider.notifier).bump();
    }, success: 'Transferencia registrada.');
  }

  Future<void> _editRule(CategorisationRule? rule) async {
    final budgets = ref.read(currentMonthBudgetsProvider).value ?? const [];
    if (budgets.isEmpty) {
      showInfoSnack(context, 'Crea un sobre antes de definir reglas.');
      return;
    }
    final draft = await showDialog<_RuleDraft>(
      context: context,
      builder: (context) => _RuleDialog(budgets: budgets, rule: rule),
    );
    if (draft == null) return;
    await _run(() async {
      await ref
          .read(transactionsRepositoryProvider)
          .saveRule(
            id: rule?.id,
            pattern: draft.pattern,
            envelopeId: draft.envelopeId,
            priority: draft.priority,
            isActive: draft.isActive,
          );
      ref.read(dataRevisionProvider.notifier).bump();
    }, success: rule == null ? 'Regla creada.' : 'Regla actualizada.');
  }

  Future<void> _toggleRule(CategorisationRule rule) async {
    await _run(() async {
      await ref
          .read(transactionsRepositoryProvider)
          .saveRule(
            id: rule.id,
            pattern: rule.pattern,
            envelopeId: rule.envelopeId,
            priority: rule.priority,
            isActive: !rule.isActive,
          );
    }, success: rule.isActive ? 'Regla desactivada.' : 'Regla activada.');
  }

  Future<void> _deleteRule(CategorisationRule rule) async {
    final confirmed = await _confirm(
      context,
      title: '¿Eliminar regla?',
      message:
          'La regla "${rule.pattern}" dejará de sugerir un sobre al registrar gastos.',
      confirmLabel: 'Eliminar',
    );
    if (!confirmed) return;
    await _run(() async {
      await ref.read(transactionsRepositoryProvider).deleteRule(rule.id);
    }, success: 'Regla eliminada.');
  }

  Future<void> _toggleBiometric(bool enabled) async {
    await _run(
      () async {
        await ref.read(securityRepositoryProvider).setBiometricEnabled(enabled);
        ref.invalidate(biometricEnabledProvider);
      },
      success: enabled
          ? 'Protección biométrica activada.'
          : 'Protección biométrica desactivada.',
    );
  }

  Future<void> _exportBackup() async {
    await _run(() async {
      final security = ref.read(securityRepositoryProvider);
      final bytes = await security.exportBackup();
      if (!mounted) return;
      await _shareBytes(
        bytes: bytes,
        fileName: security.backupFileName(),
        mimeType: 'application/x-sqlite3',
        text: 'Respaldo local de KipuBudget.',
      );
    });
  }

  Future<void> _restoreBackup() async {
    final picked = await FilePicker.pickFile(
      dialogTitle: 'Elegir respaldo de KipuBudget',
      type: FileType.custom,
      allowedExtensions: const ['sqlite', 'sqlite3', 'db'],
    );
    if (picked == null) return;
    final Uint8List bytes;
    try {
      bytes = await picked.readAsBytes();
    } on Object {
      if (mounted) {
        showErrorSnack(
          context,
          const DomainException('No se pudo leer el archivo elegido.'),
        );
      }
      return;
    }
    if (!mounted) return;
    final confirmed = await _confirm(
      context,
      title: '¿Restaurar este respaldo?',
      message:
          'Se reemplazan todas las cuentas, sobres, movimientos y ajustes guardados en este dispositivo. No se puede deshacer.',
      confirmLabel: 'Reemplazar datos',
      destructive: true,
    );
    if (!confirmed) return;
    await _run(() async {
      await ref.read(securityRepositoryProvider).restoreBackup(bytes);
      ref.invalidate(accountsProvider);
      ref.invalidate(groupsProvider);
      ref.invalidate(monthBudgetsProvider);
      ref.invalidate(currentMonthBudgetsProvider);
      ref.invalidate(toAssignProvider);
      ref.invalidate(movementsProvider);
      ref.invalidate(rulesProvider);
      ref.invalidate(biometricEnabledProvider);
      ref.read(dataRevisionProvider.notifier).bump();
    }, success: 'Respaldo restaurado.');
  }

  Future<void> _previewPdf() async {
    await _run(() async {
      final month = ref.read(selectedMonthProvider);
      final bytes = await ref.read(reportsRepositoryProvider).exportPdf(month);
      await Printing.layoutPdf(onLayout: (_) => bytes);
    });
  }

  Future<void> _sharePdf() async {
    await _run(() async {
      final month = ref.read(selectedMonthProvider);
      final bytes = await ref.read(reportsRepositoryProvider).exportPdf(month);
      if (!mounted) return;
      await _shareBytes(
        bytes: bytes,
        fileName: 'kipu_budget_$month.pdf',
        mimeType: 'application/pdf',
        text: 'Reporte mensual de KipuBudget.',
      );
    });
  }

  Future<void> _previewExcel() async {
    await _run(() async {
      final month = ref.read(selectedMonthProvider);
      final bytes = await ref
          .read(reportsRepositoryProvider)
          .exportExcel(month);
      if (!mounted) return;
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) => _ExcelPreviewSheet(bytes: bytes),
      );
    });
  }

  Future<void> _shareExcel() async {
    await _run(() async {
      final month = ref.read(selectedMonthProvider);
      final bytes = await ref
          .read(reportsRepositoryProvider)
          .exportExcel(month);
      if (!mounted) return;
      await _shareBytes(
        bytes: bytes,
        fileName: 'kipu_budget_$month.xlsx',
        mimeType:
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        text: 'Reporte mensual de KipuBudget.',
      );
    });
  }

  Future<void> _shareBytes({
    required Uint8List bytes,
    required String fileName,
    required String mimeType,
    String? text,
  }) async {
    final size = MediaQuery.sizeOf(context);
    final origin = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: 1,
      height: 1,
    );
    final directory = await getTemporaryDirectory();
    final file = File(p.join(directory.path, fileName));
    await file.writeAsBytes(bytes, flush: true);
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: mimeType)],
        text: text,
        sharePositionOrigin: origin,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(accountsProvider);
    final rules = ref.watch(rulesProvider);
    final budgets = ref.watch(currentMonthBudgetsProvider).value ?? const [];
    final envelopeNames = {
      for (final budget in budgets) budget.envelopeId: budget.name,
    };
    final biometricEnabled = ref.watch(biometricEnabledProvider).value ?? false;
    final biometricSupported =
        ref.watch(biometricSupportedProvider).value ?? false;
    final month = ref.watch(selectedMonthProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Herramientas')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        children: [
          if (_busy) const LinearProgressIndicator(minHeight: 3),
          _SectionHeader(
            title: 'Cuentas',
            actionLabel: 'Añadir',
            onAction: _busy ? null : _addAccount,
          ),
          accounts.when(
            loading: () => const _LoadingCard(),
            error: (error, _) =>
                _ErrorCard('No se pudieron cargar las cuentas.'),
            data: (rows) => _AccountsCard(
              accounts: rows,
              busy: _busy,
              onTransfer: () => _transfer(rows),
              onToggleArchive: _toggleArchive,
            ),
          ),
          const SizedBox(height: 24),
          _SectionHeader(
            title: 'Reglas de categorización',
            actionLabel: 'Añadir',
            onAction: _busy || budgets.isEmpty ? null : () => _editRule(null),
          ),
          rules.when(
            loading: () => const _LoadingCard(),
            error: (error, _) =>
                _ErrorCard('No se pudieron cargar las reglas.'),
            data: (rows) => _RulesCard(
              rules: rows,
              envelopeNames: envelopeNames,
              onEdit: _editRule,
              onToggle: _toggleRule,
              onDelete: _deleteRule,
            ),
          ),
          const SizedBox(height: 24),
          const _SectionHeader(title: 'Seguridad'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.fingerprint_rounded),
                  title: const Text('Bloqueo biométrico'),
                  subtitle: Text(
                    biometricSupported
                        ? 'Pide huella, rostro o credencial del dispositivo.'
                        : 'Este dispositivo no tiene biometría disponible.',
                  ),
                  value: biometricEnabled,
                  onChanged: _busy || !biometricSupported
                      ? null
                      : _toggleBiometric,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _SectionHeader(title: 'Informes · ${monthLabel(month)}'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf_outlined),
                  title: const Text('Vista previa del PDF'),
                  subtitle: const Text(
                    'Revisa el reporte antes de compartirlo.',
                  ),
                  enabled: !_busy,
                  onTap: _previewPdf,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.ios_share_rounded),
                  title: const Text('Compartir PDF'),
                  enabled: !_busy,
                  onTap: _sharePdf,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.table_chart_outlined),
                  title: const Text('Vista previa del Excel'),
                  subtitle: const Text(
                    'Revisa las hojas antes de compartirlas.',
                  ),
                  enabled: !_busy,
                  onTap: _previewExcel,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.ios_share_rounded),
                  title: const Text('Compartir Excel'),
                  subtitle: const Text('Una hoja por sección del reporte.'),
                  enabled: !_busy,
                  onTap: _shareExcel,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const _SectionHeader(title: 'Respaldo local'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.save_alt_rounded),
                  title: const Text('Exportar respaldo'),
                  subtitle: const Text('Copia consistente de toda la base.'),
                  enabled: !_busy,
                  onTap: _exportBackup,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.restore_rounded,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  title: Text(
                    'Restaurar respaldo',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  subtitle: const Text(
                    'Reemplaza todos los datos de este dispositivo.',
                  ),
                  enabled: !_busy,
                  onTap: _restoreBackup,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'KipuBudget guarda todo en SQLite, en este dispositivo. '
            'Sin cuentas, sin servidores, sin conexión obligatoria.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.actionLabel, this.onAction});

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (actionLabel != null)
            TextButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(actionLabel!),
            ),
        ],
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          message,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}

class _AccountsCard extends StatelessWidget {
  const _AccountsCard({
    required this.accounts,
    required this.busy,
    required this.onTransfer,
    required this.onToggleArchive,
  });

  final List<Account> accounts;
  final bool busy;
  final VoidCallback onTransfer;
  final Future<void> Function(Account account) onToggleArchive;

  @override
  Widget build(BuildContext context) {
    final active = accounts.where((account) => !account.archived).toList();
    final archived = accounts.where((account) => account.archived).toList();
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Column(
        children: [
          if (active.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No hay cuentas activas.'),
            ),
          for (final account in active) ...[
            ListTile(
              leading: CircleAvatar(
                backgroundColor: scheme.primaryContainer,
                child: Icon(
                  _accountIcon(account.type),
                  color: scheme.onPrimaryContainer,
                ),
              ),
              title: Text(account.name),
              subtitle: Text(account.type.label),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MoneyText(
                    account.balanceCents,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  PopupMenuButton<String>(
                    enabled: !busy,
                    onSelected: (value) {
                      switch (value) {
                        case 'archive':
                          onToggleArchive(account);
                        case 'transfer':
                          onTransfer();
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'transfer',
                        child: Text('Transferir entre cuentas'),
                      ),
                      const PopupMenuItem(
                        value: 'archive',
                        child: Text('Archivar cuenta'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
          ],
          if (archived.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Archivadas',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            for (final account in archived)
              ListTile(
                leading: Icon(
                  _accountIcon(account.type),
                  color: scheme.onSurfaceVariant,
                ),
                title: Text(
                  account.name,
                  style: TextStyle(color: scheme.onSurfaceVariant),
                ),
                subtitle: Text('${account.type.label} · archivada'),
                trailing: TextButton(
                  onPressed: busy ? null : () => onToggleArchive(account),
                  child: const Text('Reactivar'),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

IconData _accountIcon(AccountType type) {
  return switch (type) {
    AccountType.cash => Icons.payments_outlined,
    AccountType.debit => Icons.account_balance_outlined,
    AccountType.credit => Icons.credit_card_rounded,
    AccountType.savings => Icons.savings_outlined,
  };
}

class _RulesCard extends StatelessWidget {
  const _RulesCard({
    required this.rules,
    required this.envelopeNames,
    required this.onEdit,
    required this.onToggle,
    required this.onDelete,
  });

  final List<CategorisationRule> rules;
  final Map<int, String> envelopeNames;
  final Future<void> Function(CategorisationRule? rule) onEdit;
  final Future<void> Function(CategorisationRule rule) onToggle;
  final Future<void> Function(CategorisationRule rule) onDelete;

  @override
  Widget build(BuildContext context) {
    if (rules.isEmpty) {
      return const Card(
        child: ListTile(
          leading: Icon(Icons.auto_awesome_outlined),
          title: Text('Sin reglas todavía'),
          subtitle: Text(
            'Ejemplo: si la descripción contiene "supermercado", sugiere Comida.',
          ),
        ),
      );
    }
    return Card(
      child: Column(
        children: [
          for (final rule in rules) ...[
            ListTile(
              leading: Icon(
                Icons.auto_awesome_outlined,
                color: rule.isActive
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              title: Text(
                '“${rule.pattern}”',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: rule.isActive
                      ? null
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              subtitle: Text(
                '${envelopeNames[rule.envelopeId] ?? 'Sobre eliminado'} · prioridad ${rule.priority}',
              ),
              onTap: () => onEdit(rule),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'toggle':
                      onToggle(rule);
                    case 'edit':
                      onEdit(rule);
                    case 'delete':
                      onDelete(rule);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'toggle',
                    child: Text(rule.isActive ? 'Desactivar' : 'Activar'),
                  ),
                  const PopupMenuItem(value: 'edit', child: Text('Editar')),
                  const PopupMenuItem(value: 'delete', child: Text('Eliminar')),
                ],
              ),
            ),
            if (rule != rules.last) const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}

class _AccountDraft {
  const _AccountDraft({
    required this.name,
    required this.type,
    required this.openingBalanceCents,
  });

  final String name;
  final AccountType type;
  final int openingBalanceCents;
}

class _AccountDialog extends StatefulWidget {
  const _AccountDialog();

  @override
  State<_AccountDialog> createState() => _AccountDialogState();
}

class _AccountDialogState extends State<_AccountDialog> {
  final _name = TextEditingController();
  final _opening = TextEditingController(text: '0');
  AccountType _type = AccountType.cash;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _opening.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _name.text.trim();
    final cents = parseCents(_opening.text) ?? 0;
    if (name.isEmpty) {
      setState(() => _error = 'El nombre es obligatorio.');
      return;
    }
    if (cents < 0) {
      setState(() => _error = 'El saldo inicial no puede ser negativo.');
      return;
    }
    Navigator.of(
      context,
    ).pop(_AccountDraft(name: name, type: _type, openingBalanceCents: cents));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nueva cuenta'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _name,
            autofocus: true,
            maxLength: 40,
            decoration: const InputDecoration(labelText: 'Nombre'),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<AccountType>(
            initialValue: _type,
            decoration: const InputDecoration(labelText: 'Tipo'),
            items: [
              for (final type in AccountType.values)
                DropdownMenuItem(value: type, child: Text(type.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _type = value);
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _opening,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Saldo inicial',
              prefixText: '$kCurrencySymbol ',
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 10),
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Crear')),
      ],
    );
  }
}

class _AccountTransfer {
  const _AccountTransfer({
    required this.fromAccountId,
    required this.toAccountId,
    required this.amountCents,
    required this.description,
  });

  final int fromAccountId;
  final int toAccountId;
  final int amountCents;
  final String description;
}

class _TransferDialog extends StatefulWidget {
  const _TransferDialog({required this.accounts});

  final List<Account> accounts;

  @override
  State<_TransferDialog> createState() => _TransferDialogState();
}

class _TransferDialogState extends State<_TransferDialog> {
  final _amount = TextEditingController();
  final _description = TextEditingController();
  late int _fromId = widget.accounts.first.id;
  late int _toId = widget.accounts[1].id;
  String? _error;

  @override
  void dispose() {
    _amount.dispose();
    _description.dispose();
    super.dispose();
  }

  void _submit() {
    final cents = parseCents(_amount.text);
    if (_fromId == _toId) {
      setState(() => _error = 'Elige dos cuentas distintas.');
      return;
    }
    if (cents == null || cents <= 0) {
      setState(() => _error = 'Ingresa un monto mayor que cero.');
      return;
    }
    final description = _description.text.trim();
    Navigator.of(context).pop(
      _AccountTransfer(
        fromAccountId: _fromId,
        toAccountId: _toId,
        amountCents: cents,
        description: description.isEmpty ? 'Transferencia' : description,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Transferir entre cuentas'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<int>(
            initialValue: _fromId,
            decoration: const InputDecoration(labelText: 'Desde'),
            items: [
              for (final account in widget.accounts)
                DropdownMenuItem(value: account.id, child: Text(account.name)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _fromId = value);
            },
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<int>(
            initialValue: _toId,
            decoration: const InputDecoration(labelText: 'Hacia'),
            items: [
              for (final account in widget.accounts)
                DropdownMenuItem(value: account.id, child: Text(account.name)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _toId = value);
            },
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _amount,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Monto',
              prefixText: '$kCurrencySymbol ',
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _description,
            maxLength: 60,
            decoration: const InputDecoration(labelText: 'Descripción'),
          ),
          if (_error != null)
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Transferir')),
      ],
    );
  }
}

class _RuleDraft {
  const _RuleDraft({
    required this.pattern,
    required this.envelopeId,
    required this.priority,
    required this.isActive,
  });

  final String pattern;
  final int envelopeId;
  final int priority;
  final bool isActive;
}

class _RuleDialog extends StatefulWidget {
  const _RuleDialog({required this.budgets, this.rule});

  final List<EnvelopeBudget> budgets;
  final CategorisationRule? rule;

  @override
  State<_RuleDialog> createState() => _RuleDialogState();
}

class _RuleDialogState extends State<_RuleDialog> {
  late final _pattern = TextEditingController(text: widget.rule?.pattern ?? '');
  late final _priority = TextEditingController(
    text: (widget.rule?.priority ?? 0).toString(),
  );
  late int _envelopeId = _initialEnvelopeId();
  late bool _isActive = widget.rule?.isActive ?? true;
  String? _error;

  int _initialEnvelopeId() {
    final rule = widget.rule;
    if (rule != null &&
        widget.budgets.any((budget) => budget.envelopeId == rule.envelopeId)) {
      return rule.envelopeId;
    }
    return widget.budgets.first.envelopeId;
  }

  @override
  void dispose() {
    _pattern.dispose();
    _priority.dispose();
    super.dispose();
  }

  void _submit() {
    final pattern = _pattern.text.trim();
    final priority = int.tryParse(_priority.text.trim()) ?? 0;
    if (pattern.isEmpty) {
      setState(() => _error = 'La palabra clave es obligatoria.');
      return;
    }
    Navigator.of(context).pop(
      _RuleDraft(
        pattern: pattern,
        envelopeId: _envelopeId,
        priority: priority,
        isActive: _isActive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.rule == null ? 'Nueva regla' : 'Editar regla'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _pattern,
              autofocus: true,
              maxLength: 40,
              decoration: const InputDecoration(
                labelText: 'Si la descripción contiene…',
                hintText: 'supermercado',
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              initialValue: _envelopeId,
              decoration: const InputDecoration(labelText: 'Sugerir sobre'),
              items: [
                for (final budget in widget.budgets)
                  DropdownMenuItem(
                    value: budget.envelopeId,
                    child: Text('${budget.groupName} · ${budget.name}'),
                  ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _envelopeId = value);
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _priority,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Prioridad',
                helperText: 'Menor número se evalúa primero.',
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Activa'),
              value: _isActive,
              onChanged: (value) => setState(() => _isActive = value),
            ),
            if (_error != null)
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(widget.rule == null ? 'Crear' : 'Guardar'),
        ),
      ],
    );
  }
}

Future<bool> _confirm(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  bool destructive = false,
}) async {
  final scheme = Theme.of(context).colorScheme;
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: destructive
              ? FilledButton.styleFrom(
                  backgroundColor: scheme.error,
                  foregroundColor: scheme.onError,
                )
              : null,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}

class _ExcelPreviewSheet extends StatefulWidget {
  const _ExcelPreviewSheet({required this.bytes});

  final Uint8List bytes;

  @override
  State<_ExcelPreviewSheet> createState() => _ExcelPreviewSheetState();
}

class _ExcelPreviewSheetState extends State<_ExcelPreviewSheet> {
  late final Excel _workbook = Excel.decodeBytes(widget.bytes);

  @override
  Widget build(BuildContext context) {
    final sheets = _workbook.tables.keys.toList(growable: false);
    final theme = Theme.of(context);
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.82,
      child: sheets.isEmpty
          ? const Center(child: Text('El reporte no contiene hojas.'))
          : DefaultTabController(
              length: sheets.length,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 8, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Vista previa del Excel',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                          tooltip: 'Cerrar',
                        ),
                      ],
                    ),
                  ),
                  TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    tabs: [for (final name in sheets) Tab(text: name)],
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: TabBarView(
                      children: [
                        for (final name in sheets)
                          _ExcelSheetView(rows: _workbook.tables[name]!.rows),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _ExcelSheetView extends StatelessWidget {
  const _ExcelSheetView({required this.rows});

  final List<List<Data?>> rows;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return const Center(child: Text('Hoja vacía.'));
    }
    var columns = 1;
    for (final row in rows) {
      if (row.length > columns) columns = row.length;
    }
    final scheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: columns * 152.0,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: rows.length,
          itemBuilder: (context, index) {
            final row = rows[index];
            final isHeader = index == 0;
            return Container(
              color: isHeader
                  ? scheme.surfaceContainerHighest.withValues(alpha: 0.6)
                  : null,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  for (var column = 0; column < columns; column++)
                    SizedBox(
                      width: 152,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          column < row.length
                              ? row[column]?.value?.toString() ?? ''
                              : '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontWeight: isHeader
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                              ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
