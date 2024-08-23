import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:resident_live/core/extensions/context.extension.dart';
import 'package:resident_live/services/vibration_service.dart';

class ProgressBar extends StatelessWidget {
  final double completionPercentage;

  ProgressBar({
    required this.completionPercentage,
    this.radius = 100.0,
    this.strokeWidth = 5.0,
  });

  final double radius;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
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
                  VibrationService.instance.success();
                },
                tween: Tween<double>(begin: 0, end: completionPercentage),
                duration: Duration(
                    milliseconds: 1600), // Adjust the duration as needed
                builder: (context, value, child) {
                  return CircularProgressIndicator(
                    value: value,
                    strokeWidth: strokeWidth,
                    strokeCap: StrokeCap.round,
                    backgroundColor: context.theme.primaryColor,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                  );
                },
              ),
            ),
            TweenAnimationBuilder<double>(
              curve: Curves.fastOutSlowIn,
              tween: Tween<double>(begin: 0, end: completionPercentage),
              duration:
                  Duration(milliseconds: 1600), // Adjust the duration as needed
              builder: (context, value, child) {
                return Text(
                  "${(completionPercentage * 100).toStringAsFixed(1)}%",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                );
              },
            ),
          ],
        ),
        SizedBox(height: strokeWidth),
        Text("Progress", style: context.theme.textTheme.labelMedium)
            .animate()
            .fade(duration: 1.seconds),
      ],
    );
  }
}
