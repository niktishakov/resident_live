import "package:flutter/material.dart";
import "package:resident_live/shared/shared.dart";

class StatItemWidget extends StatelessWidget {
  const StatItemWidget({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.body12.copyWith(color: theme.textSecondary)),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.body14.copyWith(color: theme.textPrimary, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
