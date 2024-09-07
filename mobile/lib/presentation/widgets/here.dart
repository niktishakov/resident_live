import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:resident_live/core/extensions/context.extension.dart';

class Here extends StatelessWidget {
  const Here({super.key, this.shorter = false});
  final bool shorter;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!shorter)
          Text("Here",
              style: context.theme.textTheme.labelMedium
                  ?.copyWith(color: context.theme.colorScheme.secondary)),
        Gap(2),
        Icon(
          CupertinoIcons.circle_filled,
          color: Colors.red,
          size: 16,
        )
            .animate(onPlay: (controller) => controller.repeat())
            .fadeIn(duration: 300.ms, delay: 200.ms)
            .then() // Starts the next animation after the previous ends
            .fadeOut(duration: 300.ms, delay: 1000.ms),
      ],
    );
  }
}
