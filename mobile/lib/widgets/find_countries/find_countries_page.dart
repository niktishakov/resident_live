import 'package:country_list_pick/support/code_countries_en.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../features/features.dart';
import '../../shared/shared.dart';
import '../../screens/onboarding/model/onboarding_cubit.dart';

class FindCountriesPage extends StatefulWidget {
  const FindCountriesPage(this.onNextPage, {super.key});
  final VoidCallback onNextPage;

  @override
  _FindCountriesPageState createState() => _FindCountriesPageState();
}

class _FindCountriesPageState extends State<FindCountriesPage> {
  String searchQuery = "";
  ScrollController controller = ScrollController();

  @override
  void initState() {
    final sharedState = context.read<CountriesCubit>().state;
    sharedState.countries.forEach((key, value) {
      context.read<OnboardingCubit>().addCountry(value.name);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCountries =
        context.watch<OnboardingCubit>().state.selectedCountries;
    // Filter the countries to exclude the ones already selected
    List filteredCountries = countriesEnglish
        .where((country) =>
            !selectedCountries.contains(country['name']) &&
            country['name']!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text("Where Have You Been?",
                      style: context.theme.textTheme.headlineSmall)
                  .animate()
                  .fade(
                    duration: 1.seconds,
                  ),
            ),
            Gap(24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                      "Select the countries you’ve visited in the last 12 months.",
                      style: context.theme.textTheme.bodyMedium)
                  .animate()
                  .fade(
                    duration: 1.seconds,
                    delay: 300.ms,
                  ),
            ),
            Gap(24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: CupertinoSearchTextField(
                style: context.theme.textTheme.bodyLarge,
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                placeholder: "Search countries",
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
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Text("No results found",
                        style: context.theme.textTheme.bodyLarge)
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
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      String country = filteredCountries[index]['name']!;
                      return SizedBox(
                        height: 44,
                        child: CupertinoButton(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(country,
                                    style: context.theme.textTheme.bodyLarge),
                              ),
                            ],
                          ),
                          onPressed: () {
                            context.read<OnboardingCubit>().addCountry(country);

                            controller.animateTo(
                              controller.position.maxScrollExtent,
                              duration: kDefaultDuration,
                              curve: Curves.easeInCubic,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ).animate().fade(
                    duration: 300.ms,
                    delay: 1100.ms,
                  ),
            Container(
              height: selectedCountries.isNotEmpty ? 50 : 0,
              child: Center(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  children: [
                    ...selectedCountries.map((country) {
                      return GestureDetector(
                        onTap: () {
                          context
                              .read<OnboardingCubit>()
                              .removeCountry(country);
                        },
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              context
                                  .read<OnboardingCubit>()
                                  .removeCountry(country);
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 8),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: context.theme.colorScheme.tertiary,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    country,
                                    style: context.theme.textTheme.bodyMedium!
                                        .copyWith(
                                      color:
                                          context.theme.colorScheme.onTertiary,
                                    ),
                                  ),
                                  Gap(4),
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
                    }),
                  ],
                ),
              ),
            ),
            if (selectedCountries.isNotEmpty) ...[
              Gap(8),
              Center(
                child: PrimaryButton(
                  onPressed: selectedCountries.isNotEmpty
                      ? () {
                          FocusScope.of(context).unfocus();
                          widget.onNextPage();
                        }
                      : null,
                  label: "Continue",
                ).animate().fade(delay: 300.ms).shimmer(delay: 5.seconds),
              ),
              Gap(8)
            ],
          ],
        ),
      ),
    );
  }
}
