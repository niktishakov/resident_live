import "package:flutter/material.dart";
import "package:resident_live/shared/shared.dart";

class TripCardBadge extends StatelessWidget {
  const TripCardBadge({
    required this.text,
    required this.alignment,
    super.key,
    this.onTap,
    this.leading,
  });

  final Widget? leading;
  final String text;
  final AlignmentGeometry alignment;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    return Positioned.fill(
      child: GestureDetector(
        onTap: onTap,
        child: Align(
          alignment: alignment,
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leading != null) ...[leading!, context.hBox8],
                Text(
                  text,
                  style: theme.body14.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
