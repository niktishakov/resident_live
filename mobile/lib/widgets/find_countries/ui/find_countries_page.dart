import "package:country_list_pick/support/code_countries_en.dart";

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:gap/gap.dart";
import "package:resident_live/features/features.dart";
import "package:resident_live/generated/l10n/l10n.dart";
import "package:resident_live/screens/onboarding/model/onboarding_cubit.dart";
import "package:resident_live/shared/shared.dart";

class FindCountriesPage extends StatefulWidget {
  const FindCountriesPage(this.onNextPage, {super.key});
  final VoidCallback onNextPage;

  @override
  _FindCountriesPageState createState() => _FindCountriesPageState();
}

class _FindCountriesPageState extends State<FindCountriesPage> {
  String searchQuery = "";
  ScrollController controller = ScrollController();
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    final sharedState = context.read<CountriesCubit>().state;
    sharedState.countries.forEach((key, value) {
      context.read<OnboardingCubit>().addCountry(value.isoCode);
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCountries =
        context.watch<OnboardingCubit>().state.selectedCountries;
    // Filter the countries to exclude the ones already selected
    final List filteredCountries = countriesEnglish
        .where(
          (country) =>
              !selectedCountries.contains(country["name"]) &&
              getCountryName(country["code"])
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()),
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
                style: context.theme.textTheme.headlineSmall,
              ).animate().fade(
                    duration: 1.seconds,
                  ),
            ),
            const Gap(24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                S.of(context).whereHaveYouBeenSelectCountries,
                style: context.theme.textTheme.bodyMedium,
              ).animate().fade(
                    duration: 1.seconds,
                    delay: 300.ms,
                  ),
            ),
            const Gap(24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CupertinoSearchTextField(
                controller: _textController,
                style: context.theme.textTheme.bodyLarge,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                placeholder: S.of(context).whereHaveYouBeenSearchCountries,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ).animate().fade(
                    delay: 1000.ms,
                  ),
            ),
            if (filteredCountries.isEmpty)
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Text(
                    S.of(context).whereHaveYouBeenNoResultsFound,
                    style: context.theme.textTheme.bodyLarge,
                  ),
                  // .animate()
                  // .fade(
                  //   duration: 500.seconds,
                  // ),
                ),
              )
            else
              Expanded(
                child: FadeBorder(
                  gradient: const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.transparent, Colors.white],
                    stops: [0.0, 0.1],
                  ),
                  child: ListView.builder(
                    itemCount: filteredCountries.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      final String originName =
                          filteredCountries[index]["name"] ?? "Unknown";
                      final originCode =
                          filteredCountries[index]["code"] ?? "Unknown";
                      final localizedName = getCountryName(originCode);
                      return SizedBox(
                        height: 44,
                        child: CupertinoButton(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          onPressed: () {
                            context
                                .read<OnboardingCubit>()
                                .addCountry(originCode);
                            _textController.text = "";
                            setState(() => searchQuery = "");
                            // Wait for the next frame to ensure the list is updated
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              controller.animateTo(
                                controller.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.fastOutSlowIn,
                              );
                            });
                          },
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  localizedName,
                                  style: context.theme.textTheme.bodyLarge,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ).animate().fade(
                    duration: 300.ms,
                    delay: 1100.ms,
                  ),
            SizedBox(
              height: selectedCountries.isNotEmpty ? 50 : 0,
              child: Center(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  itemCount: selectedCountries.length,
                  itemBuilder: (context, index) {
                    final country = selectedCountries[index];
                    final localizedName = getCountryName(country);
                    return GestureDetector(
                      onTap: () {
                        context.read<OnboardingCubit>().removeCountry(country);
                      },
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            context
                                .read<OnboardingCubit>()
                                .removeCountry(country);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: context.theme.colorScheme.tertiary,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  localizedName,
                                  style: context.theme.textTheme.bodyMedium!
                                      .copyWith(
                                    color: context.theme.colorScheme.onTertiary,
                                  ),
                                ),
                                const Gap(4),
                                Icon(
                                  Icons.close,
                                  size: 18,
                                  color: context.theme.colorScheme.onTertiary,
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
                ),
              ),
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
  }
}
