import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../shared/shared.dart';
import 'month_range.dart';

class VerticalTimeline extends StatefulWidget {
  @override
  _VerticalTimelineState createState() => _VerticalTimelineState();
}

class _VerticalTimelineState extends State<VerticalTimeline> {
  final double _currentValue = 170;
  final double _minValue = 150;
  final double _maxValue = 190;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Grabber(),
          Row(
            children: [
              Spacer(),
              RlCloseButton(
                  color: context.theme.colorScheme.secondary.withOpacity(0.5),),
              Gap(16),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Your activity for the last 12 months',
                style: context.theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),),
          ),
          Expanded(
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
      final y =
          size.height - (i - minValue) / (maxValue - minValue) * size.height;

      if (i % 10 == 0) {
        canvas.drawLine(
            Offset(size.width - 20, y), Offset(size.width, y), paint,);
        textPainter.text = TextSpan(
          text: '$i',
          style: TextStyle(
              color: i == currentValue.round() ? Colors.black : Colors.grey,
              fontSize: 14,),
        );
        textPainter.layout();
        textPainter.paint(
            canvas,
            Offset(size.width - 25 - textPainter.width,
                y - textPainter.height / 2,),);
      } else {
        canvas.drawLine(
            Offset(size.width - 10, y), Offset(size.width, y), paint,);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
