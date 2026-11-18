import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../money/money.dart';

/// Small reusable amount prompt for assignment, transfers and opening balances.
Future<int?> showAmountDialog(
  BuildContext context, {
  required String title,
  String? message,
  int? initialCents,
  bool allowZero = false,
  String confirmLabel = 'Confirmar',
}) {
  return showDialog<int>(
    context: context,
    builder: (context) => _AmountDialog(
      title: title,
      message: message,
      initialCents: initialCents,
      allowZero: allowZero,
      confirmLabel: confirmLabel,
    ),
  );
}

class _AmountDialog extends StatefulWidget {
  const _AmountDialog({
    required this.title,
    required this.message,
    required this.initialCents,
    required this.allowZero,
    required this.confirmLabel,
  });

  final String title;
  final String? message;
  final int? initialCents;
  final bool allowZero;
  final String confirmLabel;

  @override
  State<_AmountDialog> createState() => _AmountDialogState();
}

class _AmountDialogState extends State<_AmountDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialCents == null
        ? ''
        : (widget.initialCents! / 100).toStringAsFixed(2),
  );
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final cents = parseCents(_controller.text);
    if (cents == null || (!widget.allowZero && cents <= 0)) {
      setState(() => _error = 'Ingresa un monto válido.');
      return;
    }
    Navigator.of(context).pop(cents);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.message != null) ...[
            Text(widget.message!),
            const SizedBox(height: 12),
          ],
          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
            ],
            decoration: InputDecoration(
              prefixText: '$kCurrencySymbol ',
              hintText: '0.00',
              errorText: _error,
            ),
            onSubmitted: (_) => _submit(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _submit, child: Text(widget.confirmLabel)),
      ],
    );
  }
}

Future<String?> showTextDialog(
  BuildContext context, {
  required String title,
  String label = 'Nombre',
  String? initialValue,
  String confirmLabel = 'Guardar',
}) {
  return showDialog<String>(
    context: context,
    builder: (context) => _TextDialog(
      title: title,
      label: label,
      initialValue: initialValue,
      confirmLabel: confirmLabel,
    ),
  );
}

class _TextDialog extends StatefulWidget {
  const _TextDialog({
    required this.title,
    required this.label,
    required this.initialValue,
    required this.confirmLabel,
  });

  final String title;
  final String label;
  final String? initialValue;
  final String confirmLabel;

  @override
  State<_TextDialog> createState() => _TextDialogState();
}

class _TextDialogState extends State<_TextDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialValue ?? '',
  );
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value = _controller.text.trim();
    if (value.isEmpty) {
      setState(() => _error = 'Este campo es obligatorio.');
      return;
    }
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLength: 80,
        decoration: InputDecoration(labelText: widget.label, errorText: _error),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _submit, child: Text(widget.confirmLabel)),
      ],
    );
  }
}
