import 'package:flutter/material.dart';
import 'package:resident_live/core/extensions/context.extension.dart';
import 'package:resident_live/presentation/screens/residence_details/widgets/animated_text_transition.dart';
import 'package:resident_live/services/vibration_service.dart';

enum ProgressDirection { up, down }

class ProgressBar extends StatelessWidget {
  final double completionPercentage;

  ProgressBar({
    required this.completionPercentage,
    this.radius = 100.0,
    this.strokeWidth = 5.0,
    this.label = 'Progress',
    this.doneLabel = 'Done',
    this.direction = ProgressDirection.up,
    this.duration = const Duration(milliseconds: 1600),
  });

  final String label;
  final String doneLabel;
  final double radius;
  final double strokeWidth;
  final ProgressDirection direction;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final beginValue =
        direction == ProgressDirection.up ? 0.0 : completionPercentage + 0.1;
    final valueColor = direction == ProgressDirection.up
        ? Colors.greenAccent
        : Colors.redAccent;

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
                    backgroundColor: context.theme.primaryColor,
                    valueColor: AlwaysStoppedAnimation<Color>(valueColor),
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
                  "${(value * 100).toStringAsFixed(1)}%",
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
                            .withOpacity(0.6))),
                Text(doneLabel, style: TextStyle(fontWeight: FontWeight.w600))
              ],
              index: value == 1.0 ? 1 : 0,
            );
          },
        )
      ],
    );
  }
}
