part of "../countries_page_view.dart";

class CountryCard extends StatelessWidget {
  const CountryCard({
    required this.countryCode,
    required this.isHere,
    required this.onTap,
    super.key,
  });

  final String countryCode;
  final bool isHere;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;
    return BlocBuilder<GetUserCubit, ResourceState<UserEntity>>(
      builder: (context, state) {
        final isResident = state.data?.isResidentIn(countryCode) ?? false;
        final daysSpent = state.data?.daysSpentIn(countryCode) ?? 0;
        final country = CountryCode.fromCountryCode(countryCode).localize(context);

        final countryName = country.name ?? "";

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
                          child: SetFocusButton(countryCode: countryCode),
                        ),
                        const Spacer(),
                        if (isHere) const Here(),
                      ],
                    );
                  },
                ),
                AutoSizeText(
                  countryName,
                  style: theme.title32Semi.copyWith(color: theme.textPrimary),
                  maxLines: 2,
                  minFontSize: 18,
                  maxFontSize: 32,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                CountryProgressIndicator(
                  countryCode: countryCode,
                  isResident: isResident,
                  daysSpent: daysSpent,
                  isHere: isHere,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
