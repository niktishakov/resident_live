import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:collection/collection.dart';
import 'package:resident_live/shared/shared.dart';

import '../../../domain/domain.dart';

class TimelineSlider extends StatefulWidget {
  TimelineSlider({
    required this.min,
    required this.max,
    required this.initialStart,
    required this.initialEnd,
    required this.color,
    required this.startDate,
    required this.endDate,
    this.height = 80.5,
    required this.periods,
    required this.onAddPeriodPressed,
  });

  final double min;
  final double max;
  final double initialStart;
  final double initialEnd;
  final Color color;
  final DateTime startDate;
  final DateTime endDate;
  final double height;
  final List<StayPeriod> periods;
  final bool Function(RangeValues) onAddPeriodPressed;

  @override
  _TimelineSliderState createState() => _TimelineSliderState();
}

class _TimelineSliderState extends State<TimelineSlider> {
  late double _startValue;
  late double _endValue;

  @override
  void initState() {
    super.initState();
    _startValue = widget.initialStart;
    _endValue = widget.initialEnd;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _updateDefaultRangeValues();
    });
  }

  bool comparePeriods(List<StayPeriod> periods, List<StayPeriod> other) {
    if (periods.length != other.length) return false;

    for (int i = 0; i < periods.length; i++) {
      if (periods[i] != other[i]) return false;
    }

    return true;
  }

  @override
  void didUpdateWidget(covariant TimelineSlider oldWidget) {
    if (oldWidget.color != widget.color) return;
    // if (!comparePeriods(widget.periods, oldWidget.periods)) {
    _updateDefaultRangeValues();
    // }
    super.didUpdateWidget(oldWidget);
  }

  String _formatDate(DateTime date) {
    return '${kMonths[date.month - 1].substring(0, 2)}';
  }

  List<String> _getMonthLabels() {
    final totalDays = widget.endDate.difference(widget.startDate).inDays;
    const labelCount = 12;
    final labels = <String>[];

    for (var i = 0; i <= labelCount; i++) {
      final date =
          widget.startDate.add(Duration(days: i * totalDays ~/ labelCount));
      labels.add(_formatDate(date));
    }

    return labels;
  }

  Widget _buildMonths(BuildContext context, double timelineWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ..._getMonthLabels()
            .mapIndexed((index, e) => Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(e),
                  ],
                ))
            .toList(),
      ],
    );
  }

  bool isRangeAvailable(RangeValues values) {
    DateTime start = _getDateFromValue(values.start);
    DateTime end = _getDateFromValue(values.end);

    for (var segment in widget.periods) {
      // If start or end date of new segment lies within an existing segment, return false
      if (!(end.isBefore(segment.startDate) ||
          start.isAfter(segment.endDate))) {
        return false;
      }
    }
    return true;
  }

  void _updateDefaultRangeValues() {
    // Initialize to cover the entire period
    var currentRange = RangeValues(0, 365);
    final periods = widget.periods;
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: 365));

    // Sort periods by startDate to make sure they are in chronological order
    periods.sort((a, b) => a.startDate.compareTo(b.startDate));

    for (int i = 0; i < periods.length - 1; i++) {
      DateTime gapStart = periods[i]
          .endDate
          .add(Duration(days: 1)); // the day after the current segment's end
      DateTime gapEnd = periods[i + 1].startDate.subtract(
          Duration(days: 1)); // the day before the next segment's start

      if (gapEnd.isAfter(gapStart)) {
        // Set the range to fit entirely within the first gap
        currentRange = RangeValues(
          gapStart.difference(startDate).inDays.toDouble(),
          gapEnd.difference(startDate).inDays.toDouble(),
        );
        break;
      }
    }

    // Handle the case where there is a gap before the first segment
    if (periods.isNotEmpty) {
      final firstSegmentStart = periods.first.startDate;
      if (firstSegmentStart.isAfter(startDate)) {
        currentRange = RangeValues(
          startDate.difference(startDate).inDays.toDouble(),
          firstSegmentStart.difference(startDate).inDays.toDouble(),
        );
      }
    }

    // Handle the case where there is a gap after the last segment
    if (periods.isNotEmpty) {
      final lastPeriodEnd = periods.last.endDate.add(2.days);
      if (lastPeriodEnd.isBefore(endDate)) {
        currentRange = RangeValues(
          lastPeriodEnd.difference(startDate).inDays.toDouble(),
          endDate.difference(startDate).inDays.toDouble(),
        );
      }
    }

    setState(() {
      _startValue = currentRange.start;
      _endValue = currentRange.end;
    });
  }

  Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        // Define separate animations for fading in and fading out
        final fadeOutTween =
            Tween<double>(begin: 1.0, end: 1.0).animate(animation);
        final fadeInTween =
            Tween<double>(begin: 0, end: 1.0).animate(animation);

        // Stack both widgets to animate them in parallel
        return Stack(
          children: [
            // The widget that's being transitioned from
            FadeTransition(
              opacity: fadeOutTween,
              child: fromHeroContext.widget,
            ),
            // The widget that's being transitioned to
            FadeTransition(
              opacity: fadeInTween,
              child: toHeroContext.widget,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final periods = widget.periods;
    final color = widget.color;
    return GestureDetector(
      onPanUpdate: (details) {
        final renderBox = context.findRenderObject() as RenderBox;
        final position = renderBox.globalToLocal(details.globalPosition);
        final newValue =
            (position.dx / renderBox.size.width) * (widget.max - widget.min) +
                widget.min;

        if ((newValue - _startValue).abs() < (_endValue - newValue).abs()) {
          // Left thumb is being moved
          final newStartValue = newValue.clamp(widget.min, _endValue - 1);
          if ((newStartValue - _startValue).abs() >= 1 &&
              isRangeAvailable(RangeValues(newStartValue, _endValue))) {
            VibrationService.instance.light();
            setState(() => _startValue = newStartValue);
          }
        } else {
          // Right thumb is being moved
          final newEndValue = newValue.clamp(_startValue + 1, widget.max);
          if ((newEndValue - _endValue).abs() >= 1 &&
              isRangeAvailable(RangeValues(_startValue, newEndValue))) {
            VibrationService.instance.light();

            setState(() => _endValue = newEndValue);
          }
        }
      },
      child: LayoutBuilder(
        builder: (context, ctrx) {
          final textOffset =
              10.0; // Adjust this value to move text closer or further from the edges
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Hero(
                tag: "timeline",
                transitionOnUserGestures: true,
                flightShuttleBuilder: _flightShuttleBuilder,
                createRectTween: (begin, end) {
                  return RectTween(begin: begin, end: end);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Material(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          size: Size(ctrx.maxWidth, widget.height),
                          painter: _SliderPainter(
                            min: widget.min,
                            max: widget.max,
                            start: _startValue,
                            end: _endValue,
                            color: widget.color,
                          ),
                        ),
                        Positioned(
                          left: _getPosition(_startValue, widget.min,
                                  widget.max, ctrx.maxWidth) +
                              textOffset,
                          top: 10,
                          child: Text(
                            _getDateFromValue(_startValue).toMMMDDString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: context.theme.scaffoldBackgroundColor),
                          ),
                        ),
                        Positioned(
                          right: ctrx.maxWidth -
                              _getPosition(_endValue, widget.min, widget.max,
                                  ctrx.maxWidth) +
                              textOffset,
                          bottom: 10,
                          child: Text(
                            _getDateFromValue(_endValue).toMMMDDString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: context.theme.scaffoldBackgroundColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Gap(10),
              _buildMonths(context, MediaQuery.of(context).size.width),
              Gap(16),
              PrimaryButton(
                vibrate: false,
                backgroundColor: color,
                enabled: isRangeAvailable(RangeValues(_startValue, _endValue)),
                onPressed: () {
                  final result = widget
                      .onAddPeriodPressed(RangeValues(_startValue, _endValue));
                  if (result) {
                    _updateDefaultRangeValues();
                  }
                },
                fontSize: 16,
                label: 'Add Period',
              ).animate().fade(delay: 150.ms),
            ],
          );
        },
      ),
    );
  }

  double _getPosition(double value, double min, double max, double width) {
    return (value - min) / (max - min) * width;
  }

  DateTime _getDateFromValue(double value) {
    // Assuming `min` and `max` represent a range of days
    return DateTime.now()
        .subtract(Duration(days: (widget.max - value).toInt()));
  }
}

class _SliderPainter extends CustomPainter {
  _SliderPainter({
    required this.min,
    required this.max,
    required this.start,
    required this.end,
    required this.color,
    this.strokeWidth = 80.0,
  });
  final double min;
  final double max;
  final double start;
  final double end;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[200]!
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final widthOffset = strokeWidth / 2;

    canvas.drawLine(
      Offset(widthOffset, size.height / 2),
      Offset(size.width - widthOffset, size.height / 2),
      paint,
    );

    paint.color = color;

    final startX = (start - min) / (max - min) * size.width + widthOffset;
    final endX = (end - min) / (max - min) * size.width - widthOffset;

    canvas.drawLine(
      Offset(startX, size.height / 2),
      Offset(endX, size.height / 2),
      paint,
    );

    paint.color = color;
    paint.style = PaintingStyle.fill;

    canvas.drawCircle(Offset(startX, size.height / 2), widthOffset, paint);
    canvas.drawCircle(Offset(endX, size.height / 2), widthOffset, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
