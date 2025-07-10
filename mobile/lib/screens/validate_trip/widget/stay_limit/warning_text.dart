import "package:flutter/cupertino.dart";
import "package:resident_live/screens/validate_trip/widget/stay_limit/stay_limit_data.dart";
import "package:resident_live/shared/shared.dart";

class WarningText extends StatelessWidget {
  const WarningText({required this.limit, super.key});

  final StayLimitData limit;

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    // Calculate when limit will be hit
    final today = DateTime.now();
    final daysUntilLimit = limit.maxDays - limit.futureDays;
    final limitDate = today.add(Duration(days: daysUntilLimit));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: theme.bgWarning.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(CupertinoIcons.exclamationmark_triangle_fill, size: 20, color: theme.bgWarning),
          context.hBox4,
          Text(
            "You will hit the residence limit of ${limitDate.toMMMDDString()}",
            style: theme.body12.copyWith(color: theme.bgWarning),
          ),
        ],
      ),
    );
  }
}
