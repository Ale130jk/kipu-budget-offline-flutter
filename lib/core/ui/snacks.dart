import 'package:flutter/material.dart';

import '../domain/domain_exception.dart';

void showErrorSnack(BuildContext context, Object error) {
  final message = error is DomainException
      ? error.message
      : 'Algo salió mal. Inténtalo de nuevo.';
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Theme.of(context).colorScheme.error,
    ),
  );
}

void showInfoSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
