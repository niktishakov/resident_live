import "package:flutter/material.dart";
import "package:resident_live/generated/l10n/l10n.dart";

import "package:resident_live/shared/shared.dart";

enum ProgressDirection { up, down }

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    required this.completionPercentage,
    super.key,
    this.radius = 100.0,
    this.strokeWidth = 5.0,
    this.label,
    this.doneLabel,
    this.direction = ProgressDirection.up,
    this.duration = const Duration(milliseconds: 1600),
    this.backgroundColor,
    this.valueColor,
  });

  final double completionPercentage;
  final String? label;
  final String? doneLabel;
  final double radius;
  final double strokeWidth;
  final ProgressDirection direction;
  final Duration duration;
  final Color? backgroundColor;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final label = this.label ?? S.of(context).commonProgress;
    final doneLabel = this.doneLabel ?? S.of(context).commonDone;
    final beginValue = direction == ProgressDirection.up ? 0.0 : completionPercentage + 0.1;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: radius, // Adjust the size as needed
              height: radius, // Adjust the size as needed
              child: TweenAnimationBuilder<double>(
                curve: Curves.fastOutSlowIn,
                onEnd: () {
                  if (completionPercentage == 1.0) {
                    VibrationService.instance.success(strong: true);
                  }
                },
                tween: Tween<double>(begin: beginValue, end: completionPercentage),
                duration: duration, // Adjust the duration as needed
                builder: (context, value, child) {
                  return CircularProgressIndicator(
                    value: value,
                    strokeWidth: strokeWidth,
                    strokeCap: StrokeCap.round,
                    backgroundColor: backgroundColor,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      valueColor ?? (direction == ProgressDirection.up ? Colors.greenAccent : Colors.redAccent),
                    ),
                  );
                },
              ),
            ),
            TweenAnimationBuilder<double>(
              curve: Curves.fastEaseInToSlowEaseOut,
              tween: Tween<double>(begin: beginValue, end: completionPercentage),
              duration: duration, // Adjust the duration as needed
              builder: (context, value, child) {
                return Text(
                  "${(value * 100).toStringAsFixed(1)}%",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ],
        ),
        SizedBox(height: strokeWidth),
        TweenAnimationBuilder<double>(
          curve: Curves.fastOutSlowIn,
          tween: Tween<double>(begin: beginValue, end: completionPercentage),
          duration: duration, // Adjust the duration as needed
          builder: (context, value, child) {
            return AnimatedTextTransition(
              texts: [
                Text(
                  label,
                  style: TextStyle(
                    color: context.theme.colorScheme.secondary.withValues(alpha: 0.6),
                  ),
                ),
                Text(
                  doneLabel,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
              index: value == 1.0 ? 1 : 0,
            );
          },
        ),
      ],
    );
  }
}
