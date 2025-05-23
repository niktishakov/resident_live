part of "../focused_country_page_view.dart";

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
    final value = isResident ? 183 : daysSpent;
    final progress = (value / 183).clamp(0, 1.0);
    // final progress = 1.0;

    return LayoutBuilder(
      builder: (context, ctrx) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$daysSpent/183 ${S.of(context).homeDays}",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: context.theme.colorScheme.secondary.withValues(alpha: 0.5),
              ),
            ),
            const Gap(2),
            Text(
              "${(value / 183 * 100).round()}%",
              style: GoogleFonts.poppins(
                fontSize: 64,
                fontWeight: FontWeight.w500,
                color: context.theme.colorScheme.secondary,
                height: 57 / 64,
              ),
            ),
            const Gap(16),
            Container(
              width: ctrx.maxWidth,
              height: 62,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
              ),
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
