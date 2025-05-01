import "package:domain/domain.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:gap/gap.dart";
import "package:google_fonts/google_fonts.dart";
import "package:resident_live/features/features.dart";
import "package:resident_live/screens/screens.dart";
import "package:resident_live/shared/shared.dart";

class FocusOnView extends StatelessWidget {
  const FocusOnView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountriesCubit, CountriesState>(
      builder: (context, countriesState) {
        return BlocBuilder<GetStartedCubit, GetStartedState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text.rich(
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      height: 30 / 24,
                      fontWeight: FontWeight.w600,
                    ),
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: "Focus on one country to\n",
                        ),
                        TextSpan(
                          text: "effectively",
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            height: 30 / 24,
                            fontWeight: FontWeight.w600,
                            color: context.theme.colorScheme.primary,
                          ),
                        ),
                        const TextSpan(
                          text: " track tax\nresidency",
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(32),
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Column(
                    children: List.generate(countriesState.countries.length * 2 - 1, (index) {
                      if (index.isOdd) {
                        // This is a separator
                        return Container(
                          height: 1,
                          color: const Color(0xff8E8E8E),
                        );
                      }
                      // This is a country item
                      final countryIndex = index ~/ 2;
                      return CountryProgressBar(
                        country: countriesState.countries.entries.elementAt(countryIndex).value,
                        isSelected: countryIndex == state.focusedCountryIndex,
                        onTap: () => context.read<GetStartedCubit>().setFocusedCountry(countryIndex),
                      );
                    }),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class CountryProgressBar extends StatelessWidget {
  const CountryProgressBar({
    required this.country,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final CountryEntity country;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff1B1B1B), Color(0xff292929)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Stack(
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: country.daysSpent / 183),
              duration: const Duration(milliseconds: 1300),
              curve: Curves.fastOutSlowIn,
              builder: (context, value, child) {
                return FractionallySizedBox(
                  widthFactor: value,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: isSelected ? 1 : 0),
                    duration: const Duration(milliseconds: 300),
                    builder: (context, selectionValue, child) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.lerp(
                                const Color(0xffD9D9D9).withValues(alpha: 0.2),
                                const Color(0xff50B5FF),
                                selectionValue,
                              )!,
                              Color.lerp(
                                const Color(0xff737373).withValues(alpha: 0.1),
                                const Color(0xff50B5FF).withValues(alpha: 0.5),
                                selectionValue,
                              )!,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  country.name,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
