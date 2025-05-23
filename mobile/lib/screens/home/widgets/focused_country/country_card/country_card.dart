part of "../focused_country_page_view.dart";

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
                          child: SetFocusButton(countryCode: countryCode),
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
