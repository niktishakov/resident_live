import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:resident_live/core/extensions/context.extension.dart';
import 'package:resident_live/core/extensions/datetime_extension.dart';

class TodayButton extends StatelessWidget {
  const TodayButton({super.key, this.style, this.iconSize = 26});
  final TextStyle? style;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        children: [
          Icon(CupertinoIcons.calendar, size: iconSize),
          Gap(4),
          Text(
            "${DateTime.now().toMMMDDYYYY()}",
            style: style ??
                context.theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
