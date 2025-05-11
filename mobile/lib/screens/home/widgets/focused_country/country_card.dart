part of "focused_country_page_view.dart";

class CountryCard extends StatelessWidget {
  const CountryCard({
    required this.countryCode,
    required this.isHere,
    required this.isFocused,
    required this.onTap,
    super.key,
  });

  final String countryCode;
  final bool isHere;
  final bool isFocused;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetUserCubit, ResourceState<UserEntity>>(
      bloc: getIt<GetUserCubit>(),
      builder: (context, state) {
        final isResident = state.data?.isResidentIn(countryCode) ?? false;
        final daysSpent = state.data?.daysSpentIn(countryCode) ?? 0;
        final country = CountryCode.fromCountryCode(countryCode);

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onTap(countryCode),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Row(
                      children: [
                        SizedBox(
                          width: constraints.maxWidth * 0.5,
                          child: SetFocusButton(
                            countryCode: countryCode,
                            isFocused: isFocused,
                          ),
                        ),
                        const Spacer(),
                        if (isHere) const Here(),
                      ],
                    );
                  },
                ),
                Text(
                  country.name ?? "",
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                _buildProgressIndicator(context, countryCode, isResident, daysSpent),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressIndicator(
    BuildContext context,
    String countryCode,
    bool isResident,
    int daysSpent,
  ) {
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
