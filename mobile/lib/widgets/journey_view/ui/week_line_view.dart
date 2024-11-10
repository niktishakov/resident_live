import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:resident_live/shared/shared.dart';
import 'package:resident_live/widgets/journey_view/ui/journey_page.dart';

class WeekLineView extends StatelessWidget {
  WeekLineView({Key? key}) : super(key: key);

  final DateTime _now = DateTime.now();

  List<DateTime> _getDaysOfWeek() {
    final DateTime startOfWeek =
        _now.subtract(Duration(days: _now.weekday - 1));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    final List<DateTime> daysOfWeek = _getDaysOfWeek();

    return LayoutBuilder(
      builder: (context, ctrx) {
        final itemWidth = ctrx.maxWidth / 7;

        return GestureDetector(
          onTap: () async {
            await CupertinoScaffold.showCupertinoModalBottomSheet(
              useRootNavigator: true,
              expand: true,
              context: context,
              duration: 300.ms,
              animationCurve: Curves.fastEaseInToSlowEaseOut,
              // builder: (context) => VerticalTimeline(),
              builder: (context) => ResidencyJourneyScreen(),
            );
          },
          child: SizedBox(
            height: 64,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index) {
                final day = daysOfWeek[index];
                final isToday = day.day == _now.day &&
                    day.month == _now.month &&
                    day.year == _now.year;

                return Container(
                  width: itemWidth,
                  decoration: BoxDecoration(
                    color: isToday
                        ? context.theme.primaryColor.withOpacity(0.2)
                        : null,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('EEE')
                            .format(day)
                            .substring(0, 3)
                            .toUpperCase(),
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: isToday
                                ? context.theme.primaryColor
                                : context.theme.colorScheme.secondary
                                    .withOpacity(0.5)),
                      ),
                      SizedBox(height: 4),
                      Text(
                        day.day.toString(),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: isToday ? context.theme.primaryColor : null,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
