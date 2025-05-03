import "package:collection/collection.dart";
import "package:domain/domain.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:gap/gap.dart";
import "package:resident_live/localization/generated/l10n/l10n.dart";
import "package:resident_live/shared/lib/service/vibration_service.dart";
import "package:resident_live/shared/shared.dart";

class TimelineSlider extends StatefulWidget {
  const TimelineSlider({
    required this.min,
    required this.max,
    required this.initialStart,
    required this.initialEnd,
    required this.color,
    required this.startDate,
    required this.endDate,
    required this.periods,
    required this.onAddPeriodPressed,
    required this.countryColors,
    super.key,
    this.height = 80.5,
  });

  final double min;
  final double max;
  final double initialStart;
  final double initialEnd;
  final Color color;
  final DateTime startDate;
  final DateTime endDate;
  final double height;
  final List<StayPeriodValueObject> periods;
  final bool Function(RangeValues) onAddPeriodPressed;
  final Map<String, Color> countryColors;

  @override
  TimelineSliderState createState() => TimelineSliderState();
}

class TimelineSliderState extends State<TimelineSlider> with TickerProviderStateMixin {
  late double _startValue;
  late double _endValue;
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;
  bool _isDraggingLeft = false;
  bool _isDraggingRight = false;
  late AnimationController _leftHandleController;
  late AnimationController _rightHandleController;
  late Animation<double> _leftHandleScale;
  late Animation<double> _rightHandleScale;

  @override
  void initState() {
    super.initState();
    _startValue = widget.initialStart;
    _endValue = widget.initialEnd;

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(_shimmerController);

    // Initialize handle animations
    _leftHandleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _rightHandleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _leftHandleScale = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(
      CurvedAnimation(
        parent: _leftHandleController,
        curve: Curves.easeOutCubic,
      ),
    );

    _rightHandleScale = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(
      CurvedAnimation(
        parent: _rightHandleController,
        curve: Curves.easeOutCubic,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _updateDefaultRangeValues();
    });
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _leftHandleController.dispose();
    _rightHandleController.dispose();
    super.dispose();
  }

  bool comparePeriods(List<StayPeriodValueObject> periods, List<StayPeriodValueObject> other) {
    if (periods.length != other.length) return false;

    for (var i = 0; i < periods.length; i++) {
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
    return getMonths(context)[date.month - 1].substring(0, 2);
  }

  List<String> _getMonthLabels() {
    final totalDays = widget.endDate.difference(widget.startDate).inDays;
    const labelCount = 12;
    final labels = <String>[];

    for (var i = 0; i <= labelCount; i++) {
      final date = widget.startDate.add(Duration(days: i * totalDays ~/ labelCount));
      labels.add(_formatDate(date));
    }

    return labels;
  }

  Widget _buildMonths(BuildContext context, double timelineWidth) {
    final startDate = _getDateFromValue(_startValue);
    final endDate = _getDateFromValue(_endValue);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          onPressed: () => _showDatePicker(context, true),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: widget.color),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            startDate.toMMMDDYYYY(),
            style: TextStyle(color: widget.color),
          ),
        ),
        const Gap(16),
        OutlinedButton(
          onPressed: () => _showDatePicker(context, false),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: widget.color),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            endDate.toMMMDDYYYY(),
            style: TextStyle(color: widget.color),
          ),
        ),
      ],
    );
  }

  void _showDatePicker(BuildContext context, bool isStart) {
    final title = isStart ? S.of(context).addStayPeriodPeriodFrom : S.of(context).addStayPeriodPeriodTo;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final initialDate = isStart ? _getDateFromValue(_startValue) : _getDateFromValue(_endValue);

        return Container(
          height: 300,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(S.of(context).commonCancel),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: context.theme.colorScheme.onSurface,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(S.of(context).commonDone),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: initialDate,
                  minimumDate: widget.startDate,
                  maximumDate: widget.endDate,
                  onDateTimeChanged: (newDate) {
                    final days = widget.endDate.difference(newDate).inDays.toDouble();
                    final newValue = widget.max - days;

                    if (isStart) {
                      if (isRangeAvailable(RangeValues(newValue, _endValue))) {
                        setState(() => _startValue = newValue);
                      }
                    } else {
                      if (isRangeAvailable(
                        RangeValues(_startValue, newValue),
                      )) {
                        setState(() => _endValue = newValue);
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool isRangeAvailable(RangeValues values) {
    final start = _getDateFromValue(values.start);
    final end = _getDateFromValue(values.end);

    for (final segment in widget.periods) {
      // If start or end date of new segment lies within an existing segment, return false
      if (!(end.isBefore(segment.startDate) || start.isAfter(segment.endDate))) {
        return false;
      }
    }
    return true;
  }

  void _updateDefaultRangeValues() {
    // Initialize to cover the entire period
    var currentRange = const RangeValues(0, 365);
    final periods = widget.periods;
    final endDate = DateTime.now();
    final startDate = endDate.subtract(const Duration(days: 365));

    // Sort periods by startDate to make sure they are in chronological order
    periods.sort((a, b) => a.startDate.compareTo(b.startDate));

    for (var i = 0; i < periods.length - 1; i++) {
      final gapStart = periods[i].endDate.add(
            const Duration(days: 1),
          ); // the day after the current segment's end
      final gapEnd = periods[i + 1].startDate.subtract(
            const Duration(days: 1),
          ); // the day before the next segment's start

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

    // the last case is when there are no empty days left, set the zero range
    if (periods.isNotEmpty && currentRange.start == 0 && currentRange.end == 365) {
      currentRange = const RangeValues(0, 1);
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
        final fadeOutTween = Tween<double>(begin: 1.0, end: 1.0).animate(animation);
        final fadeInTween = Tween<double>(begin: 0, end: 1.0).animate(animation);

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

  void _onPanStart(DragStartDetails details) {
    final renderBox = context.findRenderObject()! as RenderBox;
    final position = renderBox.globalToLocal(details.globalPosition);
    final value = (position.dx / renderBox.size.width) * (widget.max - widget.min) + widget.min;

    if ((value - _startValue).abs() < 10) {
      _isDraggingLeft = true;
      _leftHandleController.forward();
    } else if ((value - _endValue).abs() < 10) {
      _isDraggingRight = true;
      _rightHandleController.forward();
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (_isDraggingLeft) {
      _leftHandleController.reverse();
    }
    if (_isDraggingRight) {
      _rightHandleController.reverse();
    }
    _isDraggingLeft = false;
    _isDraggingRight = false;
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color;
    return AnimatedBuilder(
      animation: Listenable.merge(
        [_shimmerAnimation, _leftHandleScale, _rightHandleScale],
      ),
      builder: (context, child) {
        return GestureDetector(
          onPanStart: _onPanStart,
          onPanEnd: _onPanEnd,
          onPanUpdate: (details) {
            final renderBox = context.findRenderObject()! as RenderBox;
            final position = renderBox.globalToLocal(details.globalPosition);
            final newValue = (position.dx / renderBox.size.width) * (widget.max - widget.min) + widget.min;

            if (_isDraggingLeft) {
              final newStartValue = newValue.clamp(widget.min, _endValue - 1);
              if (isRangeAvailable(RangeValues(newStartValue, _endValue))) {
                VibrationService.instance.light();
                setState(() => _startValue = newStartValue);
              }
            } else if (_isDraggingRight) {
              final newEndValue = newValue.clamp(_startValue + 1, widget.max);
              if (isRangeAvailable(RangeValues(_startValue, newEndValue))) {
                VibrationService.instance.light();
                setState(() => _endValue = newEndValue);
              }
            }
          },
          child: LayoutBuilder(
            builder: (context, ctrx) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildMonths(context, MediaQuery.of(context).size.width),
                  const Gap(10),
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
                                strokeWidth: 20,
                                min: widget.min,
                                max: widget.max,
                                start: _startValue,
                                end: _endValue,
                                color: widget.color,
                                periods: widget.periods,
                                countryColors: widget.countryColors,
                                shimmerValue: _shimmerAnimation.value,
                                isDragging: _isDraggingLeft || _isDraggingRight,
                                leftHandleScale: _leftHandleScale.value,
                                rightHandleScale: _rightHandleScale.value,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Gap(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ..._getMonthLabels().mapIndexed(
                        (index, e) => Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(e),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(16),
                  PrimaryButton(
                    vibrate: false,
                    backgroundColor: color,
                    enabled: isRangeAvailable(RangeValues(_startValue, _endValue)),
                    onPressed: () {
                      final result = widget.onAddPeriodPressed(
                        RangeValues(_startValue, _endValue),
                      );
                      if (result) {
                        _updateDefaultRangeValues();
                      }
                    },
                    fontSize: 16,
                    label: S.of(context).addStayPeriodAddStayPeriod,
                  ).animate().fade(delay: 150.ms),
                ],
              );
            },
          ),
        );
      },
    );
  }

  DateTime _getDateFromValue(double value) {
    // Assuming `min` and `max` represent a range of days
    return DateTime.now().subtract(Duration(days: (widget.max - value).toInt()));
  }
}

class _SliderPainter extends CustomPainter {
  _SliderPainter({
    required this.min,
    required this.max,
    required this.start,
    required this.end,
    required this.color,
    required this.periods,
    required this.countryColors,
    required this.shimmerValue,
    required this.isDragging,
    required this.leftHandleScale,
    required this.rightHandleScale,
    required this.strokeWidth,
  });
  static const double handleWidth = 16.0;

  final double min;
  final double max;
  final double start;
  final double end;
  final Color color;
  final List<StayPeriodValueObject> periods;
  final Map<String, Color> countryColors;
  final double strokeWidth;
  final double shimmerValue;
  final bool isDragging;
  final double leftHandleScale;
  final double rightHandleScale;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    const widthOffset = 0.0;

    // Draw background track
    paint.color = const Color(0xff50B5FF);
    canvas.drawLine(
      Offset(widthOffset, size.height / 2),
      Offset(size.width - widthOffset, size.height / 2),
      paint,
    );

    // Draw existing periods to country color
    for (final period in periods) {
      final startX = _getXPosition(period.startDate, size.width);
      final endX = _getXPosition(period.endDate, size.width);

      // paint.color = countryColors[period.country]!;
      paint.color = Colors.greenAccent;

      final periodRect = Rect.fromPoints(
        Offset(startX, (size.height - strokeWidth) / 2),
        Offset(endX, (size.height + strokeWidth) / 2),
      );
      canvas.drawRect(periodRect, paint);
    }

    // Draw current selection with animated waves or fixed shape
    final startX = (start - min) / (max - min) * size.width;
    final endX = (end - min) / (max - min) * size.width;

    paint.color = color;
    paint.style = PaintingStyle.fill;

    final selectedPath = Path();
    final verticalOffset = (size.height - strokeWidth) / 2;

    // Always draw rectangular shape
    selectedPath.addRect(
      Rect.fromPoints(
        Offset(startX, verticalOffset),
        Offset(endX, verticalOffset + strokeWidth),
      ),
    );

    canvas.drawPath(selectedPath, paint);

    // Draw shimmer effect
    paint
      ..color = Colors.white.withValues(alpha: 0.4)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const spacing = 8.0;
    final offsetX = shimmerValue * spacing;

    final shimmerPath = Path();
    for (var x = -size.width + offsetX; x < size.width * 2; x += spacing) {
      shimmerPath.moveTo(x, strokeWidth * 2);
      shimmerPath.lineTo(x + strokeWidth / 2, -strokeWidth);
    }

    canvas.save();
    canvas.clipPath(selectedPath);
    canvas.drawPath(shimmerPath, paint);
    canvas.restore();

    // Draw handles
    final handlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    // Update handle drawing with circles and white border
    void drawHandle(double x, double scale) {
      canvas.save();
      canvas.translate(x, size.height / 2);
      canvas.scale(scale);
      canvas.translate(-x, -size.height / 2);

      // Draw shadow
      canvas.drawCircle(
        Offset(x, size.height / 2),
        handleWidth,
        Paint()
          ..color = Colors.black.withValues(alpha: 0.1)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      );

      // Draw white border
      canvas.drawCircle(
        Offset(x, size.height / 2),
        handleWidth,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0,
      );

      // Draw handle
      canvas.drawCircle(
        Offset(x, size.height / 2),
        handleWidth,
        handlePaint,
      );

      canvas.restore();
    }

    drawHandle(startX, leftHandleScale);
    drawHandle(endX, rightHandleScale);
  }

  double _getXPosition(DateTime date, double width) {
    final now = DateTime.now();
    final daysFromNow = now.difference(date).inDays;
    return ((max - daysFromNow) - min) / (max - min) * width;
  }

  @override
  bool shouldRepaint(covariant _SliderPainter oldDelegate) {
    return oldDelegate.min != min || oldDelegate.max != max || oldDelegate.start != start || oldDelegate.end != end || oldDelegate.color != color || oldDelegate.shimmerValue != shimmerValue || oldDelegate.isDragging != isDragging || oldDelegate.leftHandleScale != leftHandleScale || oldDelegate.rightHandleScale != rightHandleScale || !const ListEquality().equals(oldDelegate.periods, periods);
  }
}

extension DateTimeFormatting on DateTime {
  String toMMDDString(BuildContext context) {
    return '${getMonths(context)[month - 1].substring(0, 3)} ${day.toString().padLeft(2, '0')}';
  }
}
