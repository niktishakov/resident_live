import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:resident_live/core/extensions/context.extension.dart';
import 'package:resident_live/presentation/widgets/rl.close_button.dart';

import 'grabber.dart';
import 'month_range.dart';

class VerticalTimeline extends StatefulWidget {
  @override
  _VerticalTimelineState createState() => _VerticalTimelineState();
}

class _VerticalTimelineState extends State<VerticalTimeline> {
  double _currentValue = 170;
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
                  color: context.theme.colorScheme.secondary.withOpacity(0.5)),
              Gap(16)
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Your activity for the last 12 months",
                style: context.theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                )),
          ),
          Expanded(
            child: DateScalePicker(),
          ),
        ],
      ),
    );
  }

  Widget _buildScale() {
    return Container(
      width: 60,
      child: CustomPaint(
        painter: ScalePainter(_minValue, _maxValue, _currentValue),
      ),
    );
  }

  Widget _buildSlider() {
    return RotatedBox(
      quarterTurns: 3,
      child: Container(
        width: 300,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Slider(
              value: _currentValue,
              min: _minValue,
              max: _maxValue,
              onChanged: (value) {
                setState(() {
                  _currentValue = value;
                });
              },
            ),
            Positioned(
              left:
                  (_currentValue - _minValue) / (_maxValue - _minValue) * 300 -
                      30,
              child: RotatedBox(
                quarterTurns: 1,
                child: _buildValueIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueIndicator() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${_currentValue.round()}',
            style: TextStyle(
                fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('CM',
                    style: TextStyle(fontSize: 12, color: Colors.blue)),
              ),
              SizedBox(width: 4),
              Text('FT', style: TextStyle(fontSize: 12, color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}

class ScalePainter extends CustomPainter {
  final double minValue;
  final double maxValue;
  final double currentValue;

  ScalePainter(this.minValue, this.maxValue, this.currentValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
    );

    for (int i = minValue.round(); i <= maxValue.round(); i += 10) {
      final y =
          size.height - (i - minValue) / (maxValue - minValue) * size.height;

      if (i % 10 == 0) {
        canvas.drawLine(
            Offset(size.width - 20, y), Offset(size.width, y), paint);
        textPainter.text = TextSpan(
          text: '$i',
          style: TextStyle(
              color: i == currentValue.round() ? Colors.black : Colors.grey,
              fontSize: 14),
        );
        textPainter.layout();
        textPainter.paint(
            canvas,
            Offset(size.width - 25 - textPainter.width,
                y - textPainter.height / 2));
      } else {
        canvas.drawLine(
            Offset(size.width - 10, y), Offset(size.width, y), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
