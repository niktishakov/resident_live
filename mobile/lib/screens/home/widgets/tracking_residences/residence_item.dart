part of "tracking_residences.dart";

class _ResidenceItem extends StatelessWidget {
  const _ResidenceItem({
    required this.countryCode,
    required this.stayPeriods,
  });

  final String countryCode;
  final List<StayPeriodValueObject> stayPeriods;

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xff3C3C3C);
    const valueColor = Color(0xff8E8E8E);
    final daysSpent = stayPeriods.fold(0, (a, b) => a + b.days);
    final country = CountryCode.fromCountryCode(countryCode);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                country.name ?? "",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  Text(
                    maxLines: 2,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: context.theme.colorScheme.tertiary.withValues(alpha: 0.5),
                    ),
                    "$daysSpent / 183 ${S.of(context).homeDays}",
                  ),
                ],
              ),
            ],
          ),
          const Gap(6),
          TweenAnimationBuilder(
            duration: 2.seconds,
            tween: Tween<double>(
              begin: 1.0,
              end: (daysSpent / 183).clamp(0.0, 1.0),
            ),
            curve: Curves.fastEaseInToSlowEaseOut,
            builder: (context, v, child) {
              return LinearProgressIndicator(
                minHeight: 8,
                borderRadius: BorderRadius.circular(8),
                value: v,
                backgroundColor: backgroundColor,
                valueColor: const AlwaysStoppedAnimation(valueColor),
              ).animate().shimmer(
                duration: 1.seconds,
                delay: 1.seconds,
                stops: [1.0, 0.5, 0.0],
              );
            },
          ),
        ],
      ),
    );
  }
}
