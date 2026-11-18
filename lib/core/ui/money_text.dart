import 'package:flutter/material.dart';

import '../money/money.dart';

/// Amounts always use tabular figures so columns line up while animating.
class MoneyText extends StatelessWidget {
  const MoneyText(
    this.cents, {
    super.key,
    this.style,
    this.color,
    this.showPlus = false,
  });

  final int cents;
  final TextStyle? style;
  final Color? color;
  final bool showPlus;

  @override
  Widget build(BuildContext context) {
    final base = style ?? Theme.of(context).textTheme.titleMedium!;
    final text = showPlus && cents > 0
        ? '+${formatCents(cents)}'
        : formatCents(cents);
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: base.copyWith(
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}
