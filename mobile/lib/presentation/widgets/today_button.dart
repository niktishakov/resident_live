import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:resident_live/core/constants.dart';
import 'package:resident_live/core/extensions/context.extension.dart';
import 'package:resident_live/core/extensions/datetime_extension.dart';
import 'package:resident_live/presentation/navigation/router.dart';
import 'package:resident_live/presentation/utils/route_utils.dart';
import 'package:resident_live/presentation/widgets/bouncing_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'vertical_timeline.dart';

class TodayButton extends StatelessWidget {
  const TodayButton({
    super.key,
    this.style,
    this.iconSize = 22,
  });
  final TextStyle? style;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final _borderRadius = BorderRadius.circular(8);
    return BouncingButton(
      onPressed: (_) {
        CupertinoScaffold.showCupertinoModalBottomSheet(
          context: context,
          duration: 400.ms,
          animationCurve: Curves.fastEaseInToSlowEaseOut,
          builder: (context) => VerticalTimeline(),
        );
      },
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
              "${DateTime.now().toMMMDDYYYY()}",
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
