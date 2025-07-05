import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:resident_live/shared/shared.dart";

class ActionButtonWidget extends StatelessWidget {
  const ActionButtonWidget({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isSecondary = false,
    this.isDanger = false,
    super.key,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isSecondary;
  final bool isDanger;

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    Color backgroundColor;
    Color textColor;
    Color iconColor;

    if (isDanger) {
      backgroundColor = Colors.red.withValues(alpha: 0.1);
      textColor = Colors.red;
      iconColor = Colors.red;
    } else if (isSecondary) {
      backgroundColor = Colors.transparent;
      textColor = theme.textSecondary;
      iconColor = theme.textSecondary;
    } else {
      backgroundColor = theme.bgAccent;
      textColor = Colors.white;
      iconColor = Colors.white;
    }

    return CupertinoButton(
      onPressed: onTap,
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: isSecondary
              ? Border.all(color: theme.borderPrimary.withValues(alpha: 0.2))
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 16),
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.body14.copyWith(color: textColor, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
