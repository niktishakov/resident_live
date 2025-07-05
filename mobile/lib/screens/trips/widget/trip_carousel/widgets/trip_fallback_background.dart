import "package:flutter/material.dart";
import "package:resident_live/shared/shared.dart";

class TripFallbackBackground extends StatelessWidget {
  const TripFallbackBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.bgSecondary.withValues(alpha: 0.8),
            theme.bgSecondary.withValues(alpha: 0.6),
          ],
        ),
      ),
    );
  }
}
