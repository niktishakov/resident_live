part of "../find_countries_page.dart";

class SelectedCountriesList extends StatefulWidget {
  const SelectedCountriesList({super.key});

  @override
  State<SelectedCountriesList> createState() => _SelectedCountriesListState();
}

class _SelectedCountriesListState extends State<SelectedCountriesList> {
  final ScrollController _controller = ScrollController();
  int _previousItemCount = 0;
  late StreamSubscription<OnboardingState> _subscription;

  @override
  void initState() {
    super.initState();

    // Подписываемся на изменения состояния куба
    _subscription = getIt<OnboardingCubit>().stream.listen((state) {
      // Если количество стран увеличилось
      if (state.selectedCountries.length > _previousItemCount) {
        _scrollToEnd();
      }
      _previousItemCount = state.selectedCountries.length;
    });

    // Инициализируем начальное значение
    _previousItemCount = getIt<OnboardingCubit>().state.selectedCountries.length;
  }

  @override
  void dispose() {
    _subscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.hasClients) {
        _controller.animateTo(
          _controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
        );
      }
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
            final country = CountryCode.fromCountryCode(
              state.selectedCountries[index],
            ).localize(context);

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
                          country.toCountryStringOnly(),
                          style: theme.body12.copyWith(color: theme.textPrimaryOnColor),
                        ),
                        const Gap(4),
                        Icon(Icons.close, size: 18, color: theme.iconPrimaryOnColor),
                      ],
                    ),
                  ).animate().fade(duration: 250.ms, delay: 100.ms).scaleY(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
