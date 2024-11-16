import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:resident_live/shared/shared.dart';

class JourneyCalendar extends StatefulWidget {
  final DateTime currentMonth;
  final Map<String, List<DateTimeRange>> countryPeriods; // Periods by country
  final Set<String> visibleCountries; // Currently visible countries
  final Map<String, Color> countryColors; // Colors for each country

  const JourneyCalendar({
    super.key,
    required this.currentMonth,
    required this.countryPeriods,
    required this.visibleCountries,
    required this.countryColors,
  });

  @override
  State<JourneyCalendar> createState() => _JourneyCalendarState();
}

class _JourneyCalendarState extends State<JourneyCalendar> {
  late DateTime _displayedMonth;
  late DateTime _nextMonth;
  bool _isAnimating = false;
  int _slideDirection = 0; // -1 for left, 1 for right
  double _dragStart = 0;
  static const double _swipeThreshold = 50;

  @override
  void initState() {
    super.initState();
    _displayedMonth = widget.currentMonth;
    _nextMonth = widget.currentMonth;
  }

  void _navigateMonth(int monthDelta) {
    setState(() {
      _isAnimating = true;
      _slideDirection = monthDelta > 0 ? 1 : -1;
      _nextMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + monthDelta,
        1,
      );
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
      child: CustomPaint(
        painter: CalendarPainter(
          currentMonth: month,
          countryPeriods: widget.countryPeriods,
          visibleCountries: widget.visibleCountries,
          countryColors: widget.countryColors,
        ),
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 0.85,
          ),
          itemCount: 42, // 6 weeks * 7 days
          itemBuilder: (context, index) {
            final date = _getDateForIndex(index, month); // Update this method
            final isToday = date.isToday;

            return Container(
              margin: EdgeInsets.all(4),
              decoration: isToday
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: context.rlTheme.bgAccent.withOpacity(0.2),
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
                        ? context.rlTheme.textAccent
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
}

class CalendarPainter extends CustomPainter {
  CalendarPainter({
    required this.currentMonth,
    required this.countryPeriods,
    required this.visibleCountries,
    required this.countryColors,
  });

  final DateTime currentMonth;
  final Map<String, List<DateTimeRange>> countryPeriods;
  final Set<String> visibleCountries;
  final Map<String, Color> countryColors;

  @override
  void paint(Canvas canvas, Size size) {
    final cellWidth = size.width / 7;
    final cellHeight = size.height / 6;
    const circleRadius = 5.0;

    final firstVisibleDate = _getFirstVisibleDate();

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

      for (final period in periods) {
        final startDate = period.start;
        final endDate = period.end;

        final startRow = _getRowForDate(startDate, firstVisibleDate);
        final endRow = _getRowForDate(endDate, firstVisibleDate);

        for (var row = startRow; row <= endRow; row++) {
          if (row < 0 || row >= 6) continue;

          final y = row * (cellHeight - 4) + (cellHeight * 0.8);
          final path = Path();

          // Calculate x positions for current row
          double rowStartX, rowEndX;

          if (row == startRow) {
            rowStartX = _getXPositionForDate(startDate, cellWidth);
          } else {
            rowStartX = cellWidth / 4;
          }

          if (row == endRow) {
            rowEndX = _getXPositionForDate(endDate, cellWidth);
          } else {
            rowEndX = size.width - cellWidth / 4;
          }

          // Draw line for the row
          path.moveTo(rowStartX, y);
          path.lineTo(rowEndX, y);
          canvas.drawPath(path, linePaint);

          // Draw circles at both ends of the line segment
          canvas.drawCircle(Offset(rowStartX, y), circleRadius, circlePaint);
          canvas.drawCircle(Offset(rowEndX, y), circleRadius, circlePaint);
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
    return (dayOfWeek * cellWidth) + (cellWidth / 2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
