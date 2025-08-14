import "package:flutter/cupertino.dart";
import "package:flutter_animate/flutter_animate.dart";
// ignore: library_prefixes
import "package:modal_bottom_sheet/modal_bottom_sheet.dart" as CupertinoScaffold;
import "package:resident_live/screens/residence_details/widgets/calendar_buttons/today_button.dart";
import "package:resident_live/screens/residence_details/widgets/calendar_buttons/update_button.dart";
import "package:resident_live/screens/your_journey/journey_page.dart";

class CalendarButtons extends StatelessWidget {
  const CalendarButtons({required this.statusUpdateAt, super.key});
  final DateTime statusUpdateAt;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TodayButton(
          onTap: () {
            _showUpdateModal(context, DateTime.now());
          },
        ).animate(delay: 300.ms).fadeIn(),
        const Spacer(),
        UpdateButton(
          onTap: () {
            _showUpdateModal(context, statusUpdateAt);
          },
          date: statusUpdateAt,
        ).animate(delay: 500.ms).fadeIn(),
      ],
    );
  }

  void _showUpdateModal(BuildContext context, DateTime date) {
    CupertinoScaffold.showCupertinoModalBottomSheet(
      useRootNavigator: true,
      context: context,
      duration: 300.ms,
      animationCurve: Curves.fastEaseInToSlowEaseOut,
      builder: (context) {
        return ResidencyJourneyScreen(initialDate: date);
      },
    );
  }
}
