import 'package:country_list_pick/support/code_countries_en.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:resident_live/core/extensions/context.extension.dart';
import 'package:resident_live/presentation/widgets/bouncing_button.dart';
import 'package:resident_live/presentation/widgets/fade_border.dart';

import '../../../../core/constants.dart';
import '../cubit/onboarding_cubit.dart';

class EnterCountriesPage extends StatefulWidget {
  const EnterCountriesPage(this.onNextPage, {super.key});
  final VoidCallback onNextPage;

  @override
  _EnterCountriesPageState createState() => _EnterCountriesPageState();
}

class _EnterCountriesPageState extends State<EnterCountriesPage> {
  String searchQuery = "";
  ScrollController controller = ScrollController();

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
                itemColor: Colors.black87,
                placeholder: "Search countries",
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ).animate().fade(
                    delay: 1300.ms,
                  ),
            ),
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
                  duration: 1.seconds,
                  delay: 1400.ms,
                ),
            Container(
              height: 50,
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
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    country,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  Gap(4),
                                  Icon(Icons.close, size: 18),
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
                child: BouncingButton(
                  borderRadius: kBorderRadius,
                  onPressed: selectedCountries.isNotEmpty
                      ? (_) => widget.onNextPage()
                      : null,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: kBorderRadius,
                      color: Colors.blueAccent,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 64.0, vertical: 8),
                      child: Text("Continue",
                          style: context.theme.textTheme.labelLarge
                              ?.copyWith(fontSize: 20, color: Colors.white)),
                    ),
                  ).animate().fade(delay: 500.ms),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
