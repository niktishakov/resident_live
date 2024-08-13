import 'package:country_list_pick/support/code_countries_en.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:resident_live/core/constants.dart';
import 'package:resident_live/core/extensions/context.extension.dart';
import 'package:resident_live/presentation/screens/onboarding/cubit/onboarding_cubit.dart';
import 'package:resident_live/presentation/widgets/bouncing_button.dart';

import '../../../../core/shared_state/shared_state_cubit.dart';
import '../../../../data/country_residence.model.dart';
import 'widgets/activity_timeline.dart';

class EnterStayDurationPage extends StatefulWidget {
  final VoidCallback onNextPage;

  const EnterStayDurationPage({
    required this.onNextPage,
    Key? key,
  }) : super(key: key);

  @override
  _EnterStayDurationPageState createState() => _EnterStayDurationPageState();
}

class _EnterStayDurationPageState extends State<EnterStayDurationPage> {
  DateTimeRange? selectedRange;
  String? selectedCountry;
  Map<String, int> _totalDaysByCountry = {};
  late List<String> countries;

  @override
  void initState() {
    countries = context.read<OnboardingCubit>().state.selectedCountries;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("Add Your Stay Period",
                  style: Theme.of(context).textTheme.headlineSmall),
            ).animate().fade(
                  duration: 1.seconds,
                ),
            Gap(16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                      'For each country you visited, let us know how many days you stayed.',
                      style: context.theme.textTheme.bodyMedium)
                  .animate()
                  .fade(
                    duration: 1.seconds,
                    delay: 300.ms,
                  ),
            ),
            ActivityTimeline(
              countries: countries,
              onSegmentsChanged: (segments) {
                setState(() {
                  _totalDaysByCountry = _calcTotalDaysByCountry(segments);
                });
              },
            ).animate().fade(delay: 1000.ms),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: BouncingButton(
                  borderRadius: kBorderRadius,
                  onPressed: (_) {
                    _totalDaysByCountry.forEach((key, value) {
                      final countryDetails = countriesEnglish
                          .firstWhere((e) => e['name'] as String == key);

                      context.read<SharedStateCubit>().addResidency(
                            CountryResidenceModel(
                              countryName: key,
                              daysSpent: value,
                              isResident: value > 183,
                              isoCountryCode: countryDetails['code'] as String,
                            ),
                          );
                    });
                    widget.onNextPage();
                  },
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
            ).animate().fade(delay: 1300.ms),
          ],
        ),
      ),
    );
  }

  Map<String, int> _calcTotalDaysByCountry(
    List<ActivitySegment> segments,
  ) {
    final countryDays = <String, int>{};

    for (var period in segments) {
      final country = period.country;
      final range = DateTimeRange(start: period.startDate, end: period.endDate);
      final days = range.duration.inDays;

      if (countryDays.containsKey(country)) {
        countryDays[country] = countryDays[country]! + days;
      } else {
        countryDays[country] = days;
      }
    }

    return countryDays;
  }
}
