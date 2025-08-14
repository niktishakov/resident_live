import "package:flutter/cupertino.dart";
import "package:gap/gap.dart";

import "package:resident_live/shared/shared.dart";

class TodayButton extends StatelessWidget {
  const TodayButton({required this.onTap, super.key, this.style, this.iconSize = 22});
  final TextStyle? style;
  final double iconSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(8);
    return BouncingButton(
      onPressed: onTap,
      vibrate: false,
      borderRadius: borderRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          border: Border.all(color: context.theme.colorScheme.secondary, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.calendar, size: iconSize),
            const Gap(6),
            Text(
              DateTime.now().toMMMDDYYYY(),
              style:
                  style ??
                  context.theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.0,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
