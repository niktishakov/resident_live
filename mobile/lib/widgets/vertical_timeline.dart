import "package:flutter/material.dart";
import "package:gap/gap.dart";

import "package:resident_live/shared/shared.dart";
import "package:resident_live/widgets/month_range.dart";

class VerticalTimeline extends StatefulWidget {
  const VerticalTimeline({super.key});

  @override
  VerticalTimelineState createState() => VerticalTimelineState();
}

class VerticalTimelineState extends State<VerticalTimeline> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Grabber(),
          Row(
            children: [
              const Spacer(),
              RlCloseButton(
                color: context.theme.colorScheme.secondary.withValues(alpha: 0.5),
              ),
              const Gap(16),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Your activity for the last 12 months",
              style: context.theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Expanded(
            child: DateScalePicker(),
          ),
        ],
      ),
    );
  }
}

class ScalePainter extends CustomPainter {
  ScalePainter(this.minValue, this.maxValue, this.currentValue);
  final double minValue;
  final double maxValue;
  final double currentValue;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
    );

    for (var i = minValue.round(); i <= maxValue.round(); i += 10) {
      final y = size.height - (i - minValue) / (maxValue - minValue) * size.height;

      if (i % 10 == 0) {
        canvas.drawLine(
          Offset(size.width - 20, y),
          Offset(size.width, y),
          paint,
        );
        textPainter.text = TextSpan(
          text: "$i",
          style: TextStyle(
            color: i == currentValue.round() ? Colors.black : Colors.grey,
            fontSize: 14,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            size.width - 25 - textPainter.width,
            y - textPainter.height / 2,
          ),
        );
      } else {
        canvas.drawLine(
          Offset(size.width - 10, y),
          Offset(size.width, y),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
