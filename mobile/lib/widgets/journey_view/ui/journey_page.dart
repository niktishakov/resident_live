import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:resident_live/domain/domain.dart';

import '../../../features/features.dart';
import '../../../shared/shared.dart';
import 'widgets/country_disabler.dart';
import 'widgets/header.dart';
import 'widgets/journey_calendar.dart';

class ResidencyJourneyScreen extends StatefulWidget {
  @override
  State<ResidencyJourneyScreen> createState() => _ResidencyJourneyScreenState();
}

class _ResidencyJourneyScreenState extends State<ResidencyJourneyScreen> {
  // Local state to track visible countries
  Set<String> _visibleCountries = {};

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountriesCubit, CountriesState>(
      builder: (context, state) {
        final countryPeriods = _convertToCalendarPeriods(state.countries);
        final countryNames = state.countries.values.map((e) => e.name).toList();

        // Initialize visible countries if empty
        if (_visibleCountries.isEmpty) {
          _visibleCountries = countryNames.toSet();
        }

        final countryColors = getCountryColors(countryNames);

        return Scaffold(
          body: Column(
            children: [
              const Grabber(),
              const Gap(16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: const Header(),
              ),
              const Gap(8),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: JourneyCalendar(
                          currentMonth: DateTime.now(),
                          countryPeriods: countryPeriods,
                          visibleCountries: _visibleCountries,
                          countryColors: countryColors,
                        ),
                      ),
                      const Gap(16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: CountryDisabler(
                          countries: countryNames,
                          colors: countryColors,
                          focusedCountry: state.focusedCountry,
                          disabledCountries: countryNames
                              .where((c) => !_visibleCountries.contains(c))
                              .toList(),
                          onCountrySelected: (country, isEnabled) {
                            print('country: $country, isEnabled: $isEnabled');
                            setState(() {
                              if (isEnabled) {
                                _visibleCountries.add(country);
                              } else {
                                _visibleCountries.remove(country);
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Map<String, List<DateTimeRange>> _convertToCalendarPeriods(
      Map<String, CountryEntity> countries) {
    return Map.fromEntries(
      countries.values.map((country) {
        final periods = country.periods
            .map((period) => DateTimeRange(
                  start: period.startDate,
                  end: period.endDate,
                ))
            .toList();

        return MapEntry(country.name, periods);
      }),
    );
  }
}
