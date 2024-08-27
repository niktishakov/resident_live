import 'package:flutter/material.dart';
import 'package:resident_live/core/extensions/context.extension.dart';
import 'package:resident_live/core/extensions/datetime_extension.dart';

class TodayButton extends StatelessWidget {
  const TodayButton({super.key, this.style});
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text(
        "Today ${DateTime.now().toMMMDDYYYY()}",
        style: style ??
            context.theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
