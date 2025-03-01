import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:resident_live/generated/codegen_loader.g.dart';
import 'package:resident_live/shared/shared.dart';

class JourneyCalendar extends StatefulWidget {
  static Set<String> visitedMonths = {};

  static void resetVisitedMonths() {
    visitedMonths.clear();
  }

  final DateTime currentMonth;
  final Map<String, List<DateTimeRange>> countryPeriods; // Periods by country
  final Set<String> visibleCountries; // Currently visible countries
  final Map<String, Color> countryColors; // Colors for each country
  final ValueChanged<DateTime> onMonthChanged;

  const JourneyCalendar({
    super.key,
    required this.currentMonth,
    required this.countryPeriods,
    required this.visibleCountries,
    required this.countryColors,
    required this.onMonthChanged,
  });

  @override
  State<JourneyCalendar> createState() => _JourneyCalendarState();
}

class _JourneyCalendarState extends State<JourneyCalendar>
    with SingleTickerProviderStateMixin {
  late DateTime _displayedMonth;
  late DateTime _nextMonth;
  bool _isAnimating = false;
  int _slideDirection = 0; // -1 for left, 1 for right
  double _dragStart = 0;
  static const double _swipeThreshold = 50;
  late AnimationController _lineAnimationController;
  late Animation<double> _lineAnimation;

  @override
  void initState() {
    super.initState();
    _displayedMonth = widget.currentMonth;
    _nextMonth = widget.currentMonth;

    final monthKey = '${_displayedMonth.year}-${_displayedMonth.month}';

    _lineAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _lineAnimation = CurvedAnimation(
      parent: _lineAnimationController,
      curve: Curves.fastOutSlowIn,
    );

    if (!JourneyCalendar.visitedMonths.contains(monthKey)) {
      _lineAnimationController.forward();
      JourneyCalendar.visitedMonths.add(monthKey);
    } else {
      _lineAnimationController.value = 1.0;
    }
  }

  void _navigateMonth(int monthDelta) {
    final nextMonthDate = DateTime(
      _displayedMonth.year,
      _displayedMonth.month + monthDelta,
      1,
    );
    final monthKey = '${nextMonthDate.year}-${nextMonthDate.month}';

    setState(() {
      _isAnimating = true;
      _slideDirection = monthDelta > 0 ? 1 : -1;
      _nextMonth = nextMonthDate;

      if (!JourneyCalendar.visitedMonths.contains(monthKey)) {
        _lineAnimationController.reset();
        _lineAnimationController.forward();
        JourneyCalendar.visitedMonths.add(monthKey);
      } else {
        _lineAnimationController.value = 1.0;
      }

      widget.onMonthChanged(nextMonthDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RlCard(
      gradient: kMainGradient,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Gap(16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            child: _buildHeader(context),
          ),
          Divider(color: Color(0xff121212), thickness: 2),
          ClipRect(
            child: GestureDetector(
              onHorizontalDragStart: (details) {
                if (!_isAnimating) {
                  _dragStart = details.localPosition.dx;
                }
              },
              onHorizontalDragEnd: (details) {
                if (!_isAnimating) {
                  final dragDistance = _dragStart - details.localPosition.dx;
                  if (dragDistance.abs() > _swipeThreshold) {
                    _navigateMonth(dragDistance > 0 ? 1 : -1);
                  }
                }
              },
              child: _buildCalendarGrid(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = context.rlTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(
            CupertinoIcons.chevron_left,
            color: Colors.white,
            size: 24,
          ),
          onPressed: _isAnimating ? null : () => _navigateMonth(-1),
        ),
        Expanded(
          child: Stack(
            children: [
              // Current month sliding out
              TweenAnimationBuilder<double>(
                key: ValueKey('out_${_displayedMonth.toString()}'),
                tween: Tween(
                  begin: 0.0,
                  end: _isAnimating ? (_slideDirection > 0 ? -1.0 : 1.0) : 0.0,
                ),
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(value * 80, 0),
                    child: Opacity(
                      opacity: (1 - value.abs()),
                      child: Center(
                        child: Text(
                          _displayedMonth.toMonthYearString(),
                          style: theme.body20,
                        ),
                      ),
                    ),
                  );
                },
              ),
              // New month sliding in
              if (_isAnimating)
                TweenAnimationBuilder<double>(
                  key: ValueKey('in_${_nextMonth.toString()}'),
                  tween: Tween(
                    begin: _slideDirection > 0 ? 1.0 : -1.0,
                    end: 0.0,
                  ),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastOutSlowIn,
                  onEnd: () {
                    setState(() {
                      _isAnimating = false;
                      _slideDirection = 0;
                      _displayedMonth = _nextMonth;
                    });
                  },
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(value * 80, 0),
                      child: Opacity(
                        opacity: (1 - value.abs()),
                        child: Center(
                          child: Text(
                            _nextMonth.toMonthYearString(),
                            style: theme.body20,
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
        CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(
            CupertinoIcons.chevron_right,
            color: Colors.white,
          ),
          onPressed: _isAnimating ? null : () => _navigateMonth(1),
        ),
      ],
    );
  }

  Widget _buildCalendarGrid(BuildContext context) {
    return Stack(
      children: [
        // Current month sliding out
        TweenAnimationBuilder<double>(
          key: ValueKey('out_${_displayedMonth.toString()}'),
          tween: Tween(
            begin: 0.0,
            end: _isAnimating ? (_slideDirection > 0 ? -1.0 : 1.0) : 0.0,
          ),
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(value * MediaQuery.of(context).size.width, 0),
              child: Opacity(
                opacity: (1 - value.abs()),
                child: _buildCalendarContent(_displayedMonth),
              ),
            );
          },
        ),
        // New month sliding in
        if (_isAnimating)
          TweenAnimationBuilder<double>(
            key: ValueKey('in_${_nextMonth.toString()}'),
            tween: Tween(
              begin: _slideDirection > 0 ? 1.0 : -1.0,
              end: 0.0,
            ),
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            onEnd: () {
              setState(() {
                _displayedMonth = _nextMonth;
                _isAnimating = false;
                _slideDirection = 0;
              });
            },
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(value * MediaQuery.of(context).size.width, 0),
                child: Opacity(
                  opacity: (1 - value.abs()),
                  child: _buildCalendarContent(_nextMonth),
                ),
              );
            },
          ),
      ],
    );
  }

  // Extract calendar content to avoid duplication
  Widget _buildCalendarContent(DateTime month) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Week days row
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var i = 1; i <= 7; i++)
                  SizedBox(
                    width: 40,
                    child: Text(
                      _getWeekDayLabel(i).toUpperCase(),
                      textAlign: TextAlign.center,
                      style:
                          context.rlTheme.body12.copyWith(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
          // Calendar grid
          AnimatedBuilder(
            animation: _lineAnimation,
            builder: (context, child) {
              return CustomPaint(
                painter: CalendarPainter(
                  currentMonth: month,
                  countryPeriods: widget.countryPeriods,
                  visibleCountries: widget.visibleCountries,
                  countryColors: widget.countryColors,
                  progress: _lineAnimation.value,
                ),
                child: child,
              );
            },
            child: GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                crossAxisCount: 7,
                childAspectRatio: 0.9,
              ),
              itemCount: 42, // 6 weeks * 7 days
              itemBuilder: (context, index) {
                final date = _getDateForIndex(index, month);
                final isToday = date.isToday;

                // Get country color for today if it exists
                Color? todayColor;
                if (isToday) {
                  for (final country in widget.visibleCountries) {
                    final periods = widget.countryPeriods[country] ?? [];
                    for (final period in periods) {
                      if (date.isAfter(
                              period.start.subtract(Duration(days: 1))) &&
                          date.isBefore(period.end.add(Duration(days: 1)))) {
                        todayColor = widget.countryColors[country];
                        break;
                      }
                    }
                    if (todayColor != null) break;
                  }
                }

                return Container(
                  margin: EdgeInsets.all(4),
                  decoration: isToday
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: todayColor?.withOpacity(0.2) ??
                              context.rlTheme.bgAccent.withOpacity(0.2),
                        )
                      : null,
                  child: Center(
                    child: Text(
                      '${date.day}',
                      style: TextStyle(
                        fontSize: 18,
                        height: 22 / 18,
                        fontWeight: FontWeight.w500,
                        color: isToday
                            ? _getBrightColor(todayColor) ?? Colors.white
                            : _isCurrentMonth(date, month)
                                ? Colors.white
                                : Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Gap(24),
        ],
      ),
    );
  }

  // Update helper methods to work with the provided month
  DateTime _getDateForIndex(int index, DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final firstDayOffset = firstDayOfMonth.weekday - 1;
    return firstDayOfMonth
        .subtract(Duration(days: firstDayOffset))
        .add(Duration(days: index));
  }

  bool _isCurrentMonth(DateTime date, DateTime month) {
    return date.month == month.month && date.year == month.year;
  }

  // Add this helper method to get weekday labels
  String _getWeekDayLabel(int weekday) {
    switch (weekday) {
      case 1:
        return LocaleKeys.weekdays_monday.tr();
      case 2:
        return LocaleKeys.weekdays_tuesday.tr();
      case 3:
        return LocaleKeys.weekdays_wednesday.tr();
      case 4:
        return LocaleKeys.weekdays_thursday.tr();
      case 5:
        return LocaleKeys.weekdays_friday.tr();
      case 6:
        return LocaleKeys.weekdays_saturday.tr();
      case 7:
        return LocaleKeys.weekdays_sunday.tr();
      default:
        return '';
    }
  }

  Color? _getBrightColor(Color? color) {
    if (color == null) return null;

    final hslColor = HSLColor.fromColor(color);
    // If the color is too dark (lightness < 0.7), increase its lightness
    if (hslColor.lightness < 0.7) {
      return hslColor.withLightness(0.7).toColor();
    }
    return color;
  }

  @override
  void dispose() {
    _lineAnimationController.dispose();
    JourneyCalendar.resetVisitedMonths(); // Reset visited months on dispose
    super.dispose();
  }
}

class CalendarPainter extends CustomPainter {
  CalendarPainter({
    required this.currentMonth,
    required this.countryPeriods,
    required this.visibleCountries,
    required this.countryColors,
    this.progress = 1.0,
  });

  final DateTime currentMonth;
  final Map<String, List<DateTimeRange>> countryPeriods;
  final Set<String> visibleCountries;
  final Map<String, Color> countryColors;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final cellWidth = size.width / 7;
    final cellHeight = size.height / 6;
    const circleRadius = 5.0;

    final firstVisibleDate = _getFirstVisibleDate();
    final today = DateTime.now();

    for (final country in visibleCountries) {
      final periods = countryPeriods[country] ?? [];
      final color = countryColors[country] ?? Colors.grey;

      final linePaint = Paint()
        ..color = color
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      final circlePaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      print("Country: $country");
      for (final period in periods) {
        if (!_isDateRangeVisible(period, currentMonth)) continue;

        final startDate = period.start.subtract(Duration(days: 1));
        final endDate = period.end.subtract(Duration(days: 1));

        final startRow = _getRowForDate(startDate, firstVisibleDate);
        final endRow = _getRowForDate(endDate, firstVisibleDate);

        for (var row = startRow; row <= endRow; row++) {
          if (row < 0 || row >= 6) continue;

          final y = row * cellHeight + (cellHeight * 0.85);

          double rowStartX = _getXPositionForDate(startDate, cellWidth);
          double rowEndX = _getXPositionForDate(endDate, cellWidth);

          print('row: $row, startRow: $startDate, endRow: $endDate');
          if (row != startRow) rowStartX = cellWidth / 2;
          if (row != endRow) rowEndX = size.width - cellWidth / 2;

          final lineLength = rowEndX - rowStartX;
          final animatedEndX = rowStartX + (lineLength * progress);

          if (rowStartX == rowEndX) {
            if (progress > 0) {
              canvas.drawCircle(
                  Offset(rowStartX, y), circleRadius, circlePaint);
            }
          } else {
            final path = Path();
            path.moveTo(rowStartX, y);
            path.lineTo(animatedEndX, y);
            canvas.drawPath(path, linePaint);

            canvas.drawCircle(Offset(rowStartX, y), circleRadius, circlePaint);
            if (progress > 0) {
              canvas.drawCircle(
                  Offset(animatedEndX, y), circleRadius, circlePaint);
            }
          }
        }
      }
    }
  }

  DateTime _getFirstVisibleDate() {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final weekday = firstDayOfMonth.weekday;
    // Adjust to start week from Sunday (weekday 7 is Sunday in DateTime)
    final daysToSubtract = weekday == 7 ? 0 : weekday;
    return firstDayOfMonth.subtract(Duration(days: daysToSubtract));
  }

  int _getRowForDate(DateTime date, DateTime firstVisibleDate) {
    final diff = date.difference(firstVisibleDate).inDays;
    return diff ~/ 7;
  }

  double _getXPositionForDate(DateTime date, double cellWidth) {
    // Adjust for Sunday being 7 in DateTime
    final dayOfWeek = date.weekday == 7 ? 0 : date.weekday;
    // Position at the center of the cell
    return dayOfWeek * cellWidth + (cellWidth / 2);
  }

  bool _isDateRangeVisible(DateTimeRange period, DateTime currentMonth) {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDayOfMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 0);

    // Check if the period overlaps with the current month
    return !(period.end.isBefore(firstDayOfMonth) ||
        period.start.isAfter(lastDayOfMonth));
  }

  @override
  bool shouldRepaint(covariant CalendarPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.currentMonth != currentMonth ||
        oldDelegate.countryPeriods != countryPeriods ||
        oldDelegate.visibleCountries != visibleCountries ||
        oldDelegate.countryColors != countryColors;
  }
}

// Add this extension if you don't have it already
extension DateTimeExtension on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
