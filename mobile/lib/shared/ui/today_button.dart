import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';

import '../shared.dart';

class TodayButton extends StatelessWidget {
  const TodayButton({
    super.key,
    this.style,
    this.iconSize = 22,
    required this.onTap,
  });
  final TextStyle? style;
  final double iconSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final _borderRadius = BorderRadius.circular(8);
    return BouncingButton(
      onPressed: (_) => onTap(),
      vibrate: false,
      borderRadius: _borderRadius,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: _borderRadius,
          border:
              Border.all(color: context.theme.colorScheme.secondary, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.calendar, size: iconSize),
            Gap(6),
            Text(
              '${DateTime.now().toMMMDDYYYY()}',
              style: style ??
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
