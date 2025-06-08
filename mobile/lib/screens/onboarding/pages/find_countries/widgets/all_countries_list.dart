part of "../find_countries_page.dart";

class AllCountriesList extends StatelessWidget {
  const AllCountriesList({required this.countries, required this.onCountryTapped, super.key});

  final List<CountryCode> countries;
  final void Function(CountryCode) onCountryTapped;

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;
    return Expanded(
      child: FadeBorder(
        bidirectional: true,
        child: ListView.builder(
          itemCount: countries.length,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          itemBuilder: (context, index) {
            final country = countries[index].localize(context);
            final countryName = country.name ?? "Unknown";

            return SizedBox(
              height: 44,
              child: CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                onPressed: () => onCountryTapped(country),
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        countryName,
                        style: theme.body16.copyWith(color: theme.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ).animate().fade(duration: 300.ms, delay: 1100.ms);
  }
}
