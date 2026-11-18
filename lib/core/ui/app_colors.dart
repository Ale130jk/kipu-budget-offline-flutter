import 'package:flutter/material.dart';

Color positiveColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF34D399)
      : const Color(0xFF0F766E);
}

Color warningColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFFFBBF24)
      : const Color(0xFFB45309);
}

Color negativeColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFFF87171)
      : const Color(0xFFB91C1C);
}

Color envelopeColor(
  BuildContext context, {
  required bool overage,
  required bool warning,
}) {
  if (overage) return negativeColor(context);
  if (warning) return warningColor(context);
  return positiveColor(context);
}
