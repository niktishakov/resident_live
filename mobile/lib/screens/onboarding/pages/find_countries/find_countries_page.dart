import "package:country_code_picker/country_code_picker.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:gap/gap.dart";
import "package:resident_live/app/injection.config.dart";
import "package:resident_live/localization/generated/l10n/l10n.dart";
import "package:resident_live/screens/onboarding/cubit/onboarding_cubit.dart";
import "package:resident_live/shared/shared.dart";

part "widgets/search_field.dart";
part "widgets/all_countries_list.dart";
part "widgets/selected_countries_list.dart";

class FindCountriesPage extends StatefulWidget {
  const FindCountriesPage(this.onNextPage, {super.key});
  final VoidCallback onNextPage;

  @override
  FindCountriesPageState createState() => FindCountriesPageState();
}

class FindCountriesPageState extends State<FindCountriesPage> {
  final TextEditingController _textController = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;

    return BlocBuilder<OnboardingCubit, OnboardingState>(
      bloc: getIt<OnboardingCubit>(),
      builder: (context, state) {
        final selectedCountries = state.selectedCountries;
        final filteredCountries = kCountries.where((e) => !selectedCountries.contains(e.code)).toList();

        final filteredCountriesWithSearchQuery = filteredCountries
            .where(
              (e) => e.name?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false,
            )
            .toList();

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    S.of(context).whereHaveYouBeenTitle,
                    style: theme.title26,
                  ).animate().fade(duration: 1.seconds),
                ),
                const Gap(24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    S.of(context).whereHaveYouBeenSelectCountries,
                    style: theme.body16,
                  ).animate().fade(
                        duration: 1.seconds,
                        delay: 300.ms,
                      ),
                ),
                const Gap(16),
                SearchField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  controller: _textController,
                ),
                if (filteredCountriesWithSearchQuery.isEmpty)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Text(
                        S.of(context).whereHaveYouBeenNoResultsFound,
                        style: context.theme.textTheme.bodyLarge,
                      ),
                    ),
                  )
                else
                  AllCountriesList(
                    countries: filteredCountriesWithSearchQuery,
                    onCountryTapped: (country) {
                      getIt<OnboardingCubit>().addCountry(country.code);
                      setState(() {
                        _searchQuery = "";
                        _textController.text = "";
                      });
                    },
                  ),
                SizedBox(
                  height: selectedCountries.isNotEmpty ? 50 : 0,
                  child: const Center(child: SelectedCountriesList()),
                ),
                if (selectedCountries.isNotEmpty) ...[
                  const Gap(8),
                  Center(
                    child: PrimaryButton(
                      onPressed: selectedCountries.isNotEmpty
                          ? () {
                              FocusScope.of(context).unfocus();
                              widget.onNextPage();
                            }
                          : null,
                      label: S.of(context).commonContinue,
                    ).animate().fade(delay: 300.ms).shimmer(delay: 5.seconds),
                  ),
                  const Gap(8),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
