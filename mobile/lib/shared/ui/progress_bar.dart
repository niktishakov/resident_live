import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:resident_live/generated/codegen_loader.g.dart';

import '../shared.dart';

enum ProgressDirection { up, down }

class ProgressBar extends StatelessWidget {
  ProgressBar({
    required this.completionPercentage,
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
    final label = this.label ?? LocaleKeys.common_progress.tr();
    final doneLabel = this.doneLabel ?? LocaleKeys.common_done.tr();
    final beginValue =
        direction == ProgressDirection.up ? 0.0 : completionPercentage + 0.1;
    final _backgroundColor = backgroundColor ?? context.theme.primaryColor;
    final _valueColor = valueColor ??
        (direction == ProgressDirection.up
            ? Colors.greenAccent
            : Colors.redAccent);

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: radius, // Adjust the size as needed
              height: radius, // Adjust the size as needed
              child: TweenAnimationBuilder<double>(
                curve: Curves.fastOutSlowIn,
                onEnd: () {
                  if (completionPercentage == 1.0) {
                    VibrationService.instance.success(strong: true);
                  }
                },
                tween:
                    Tween<double>(begin: beginValue, end: completionPercentage),
                duration: duration, // Adjust the duration as needed
                builder: (context, value, child) {
                  return CircularProgressIndicator(
                    value: value,
                    strokeWidth: strokeWidth,
                    strokeCap: StrokeCap.round,
                    backgroundColor: _backgroundColor,
                    valueColor: AlwaysStoppedAnimation<Color>(_valueColor),
                  );
                },
              ),
            ),
            TweenAnimationBuilder<double>(
              curve: Curves.fastEaseInToSlowEaseOut,
              tween:
                  Tween<double>(begin: beginValue, end: completionPercentage),
              duration: duration, // Adjust the duration as needed
              builder: (context, value, child) {
                return Text(
                  '${(value * 100).toStringAsFixed(1)}%',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                Text(label,
                    style: TextStyle(
                        color: context.theme.colorScheme.secondary
                            .withOpacity(0.6),),),
                Text(doneLabel, style: TextStyle(fontWeight: FontWeight.w600)),
              ],
              index: value == 1.0 ? 1 : 0,
            );
          },
        ),
      ],
    );
  }
}
