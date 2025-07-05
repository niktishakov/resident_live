import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:resident_live/shared/shared.dart";

class TripItemHeader extends StatelessWidget {
  const TripItemHeader({required this.days, required this.isExpanded, super.key});

  final int days;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Spacer(),
        // Duration badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: theme.bgModal.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "$days days",
            style: theme.body12.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 8),
        // Expand/collapse indicator
        AnimatedRotation(
          turns: isExpanded ? 0.5 : 0,
          duration: const Duration(milliseconds: 300),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.bgModal.withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.chevron_down,
                color: Colors.white.withValues(alpha: 0.8),
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
