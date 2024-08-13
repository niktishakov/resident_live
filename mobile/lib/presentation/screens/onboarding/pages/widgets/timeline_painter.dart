import 'package:flutter/material.dart';

import 'activity_timeline.dart';

class TimelinePainter extends CustomPainter {
  TimelinePainter({
    required this.segments,
    required this.startDate,
    required this.endDate,
    required this.onSegmentPressed,
    required this.countries,
  }) {
    for (var country in countries) {
      countryColors[country] = Colors.primaries
          .firstWhere((color) => color.computeLuminance() > 0.5)
          .withOpacity(0.5);
    }
  }
  final List<ActivitySegment> segments;
  final DateTime startDate;
  final DateTime endDate;
  final VoidCallback onSegmentPressed;
  final List<String> countries;
  final Map<String, Color> countryColors = {};

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = size.height / 2
      ..strokeCap = StrokeCap.round;

    // Draw background timeline
    paint.color = Colors.grey[300]!;
    canvas.drawLine(
        Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);

    // Draw segments
    for (var segment in segments) {
      final startX = _getXPosition(segment.startDate, size);
      final endX = _getXPosition(segment.endDate, size);

      paint.color = countryColors[segment.country] ?? Colors.grey;
      canvas.drawLine(Offset(startX, size.height / 2),
          Offset(endX, size.height / 2), paint);

      // Draw country code
      _drawText(canvas, segment.country, (startX + endX) / 2,
          size.height / 2 - 25, Colors.white);
    }

    // Draw date labels
    _drawDateLabels(canvas, size);
  }

  void _drawDateLabels(Canvas canvas, Size size) {
    final totalDays = endDate.difference(startDate).inDays;
    final labelCount = 12; // Number of labels to show

    for (int i = 0; i <= labelCount; i++) {
      final x = i * size.width / labelCount;
      final date = startDate.add(Duration(days: (i * totalDays ~/ labelCount)));
      _drawText(canvas, _formatDate(date), x, size.height - 15, Colors.black);
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]}';
  }

  void _drawText(Canvas canvas, String text, double x, double y, Color color) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
          color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(x - textPainter.width / 2, y));
  }

  double _getXPosition(DateTime date, Size size) {
    final totalDays = endDate.difference(startDate).inDays;
    final daysSinceStart = date.difference(startDate).inDays;
    return size.width * daysSinceStart / totalDays;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
