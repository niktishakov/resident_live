part of "../find_countries_page.dart";

class SelectedCountriesList extends StatefulWidget {
  const SelectedCountriesList({super.key});

  @override
  State<SelectedCountriesList> createState() => _SelectedCountriesListState();
}

class _SelectedCountriesListState extends State<SelectedCountriesList> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollToEnd);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    return BlocBuilder<OnboardingCubit, OnboardingState>(
      bloc: getIt<OnboardingCubit>(),
      builder: (context, state) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          controller: _controller,
          scrollDirection: Axis.horizontal,
          itemCount: state.selectedCountries.length,
          itemBuilder: (context, index) {
            final country = CountryCode.fromCountryCode(state.selectedCountries[index]);

            return GestureDetector(
              onTap: () {
                getIt<OnboardingCubit>().removeCountry(country.code);
              },
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    getIt<OnboardingCubit>().removeCountry(country.code);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.bgSecondary,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          country.name ?? "Unknown",
                          style: theme.body12.copyWith(
                            color: theme.textPrimaryOnColor,
                          ),
                        ),
                        const Gap(4),
                        Icon(
                          Icons.close,
                          size: 18,
                          color: theme.iconPrimaryOnColor,
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fade(
                        duration: 250.ms,
                        delay: 100.ms,
                      )
                      .scaleY(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
