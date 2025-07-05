import "package:flutter/material.dart";
import "package:resident_live/shared/shared.dart";

class WarningText extends StatelessWidget {
  const WarningText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        "You will hit the residence limit of June 04",
        style: theme.body12.copyWith(color: theme.bgWarning),
      ),
    );
  }
}
