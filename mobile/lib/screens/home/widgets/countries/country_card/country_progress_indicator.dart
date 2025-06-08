import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:google_fonts/google_fonts.dart";
import "package:resident_live/gen/translations.g.dart";
import "package:resident_live/shared/shared.dart";

class CountryProgressIndicator extends StatelessWidget {
  const CountryProgressIndicator({
    required this.countryCode,
    required this.isResident,
    required this.daysSpent,
    required this.isHere,
    super.key,
  });

  final String countryCode;
  final bool isResident;
  final int daysSpent;
  final bool isHere;

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;
    final t = context.t;

    final value = isResident ? 183 : daysSpent;
    final progress = (value / 183).clamp(0, 1.0);
    // final progress = 1.0;

    return LayoutBuilder(
      builder: (context, ctrx) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$daysSpent/183 ${context.t.homeDays}",
              style: theme.body14.copyWith(color: theme.textSecondary.withValues(alpha: 0.5)),
            ),
            const Gap(2),
            Text(
              "${(value / 183 * 100).round()}%",
              style: theme.title48.copyWith(
                color: theme.textPrimary,
                fontFamily: kFontFamilySecondary,
                height: 1,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(16),
            Container(
              width: ctrx.maxWidth,
              height: 62,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(24.0)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.0),
                child: DiagonalProgressBar(
                  progress: progress.toDouble(),
                  isAnimationEnabled: isHere,
                ),
              ),
            ),
            const Gap(8),
          ],
        );
      },
    );
  }
}
