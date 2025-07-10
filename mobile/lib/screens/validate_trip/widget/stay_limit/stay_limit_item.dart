import "package:flutter/material.dart";
import "package:resident_live/screens/validate_trip/widget/stay_limit/progress_bar.dart";
import "package:resident_live/screens/validate_trip/widget/stay_limit/stay_limit_data.dart";
import "package:resident_live/screens/validate_trip/widget/stay_limit/stay_limit_header.dart";
import "package:resident_live/screens/validate_trip/widget/stay_limit/warning_text.dart";
import "package:resident_live/shared/shared.dart" hide ProgressBar;

class StayLimitItem extends StatelessWidget {
  const StayLimitItem({required this.limit, super.key});

  final StayLimitData limit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StayLimitHeader(limit: limit),
          const SizedBox(height: 8),
          ProgressBar(limit: limit),
          if (limit.isWarning) ...[context.vBox8, WarningText(limit: limit)],
        ],
      ),
    );
  }
}
