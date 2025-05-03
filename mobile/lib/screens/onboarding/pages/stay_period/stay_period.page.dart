import "package:country_list_pick/support/code_countries_en.dart";
import "package:domain/domain.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:gap/gap.dart";
import "package:resident_live/features/features.dart";
import "package:resident_live/localization/generated/l10n/l10n.dart";
import "package:resident_live/screens/onboarding/cubit/onboarding_cubit.dart";
import "package:resident_live/screens/onboarding/pages/add_periods/add_periods.page.dart";
import "package:resident_live/screens/onboarding/pages/stay_period/widgets/activity_timeline.dart";
import "package:resident_live/shared/lib/utils/get_country_name.dart";
import "package:resident_live/shared/shared.dart";

class CountryStayInfo {
  CountryStayInfo({
    required this.totalDays,
    required this.segments,
  });
  final int totalDays;
  final List<StayPeriodValueObject> segments;
}

class EnterStayDurationPage extends StatefulWidget {
  const EnterStayDurationPage({
    required this.onNextPage,
    super.key,
  });
  final VoidCallback onNextPage;

  @override
  EnterStayDurationPageState createState() => EnterStayDurationPageState();
}

class EnterStayDurationPageState extends State<EnterStayDurationPage> {
  Map<String, CountryStayInfo> _totalDaysByCountry = {};
  late List<String> countries;

  @override
  void initState() {
    countries = context.read<OnboardingCubit>().state.selectedCountries.map(getCountryName).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FadeBorder(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                S.of(context).addStayPeriodTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ).animate().fade(
                  duration: 1.seconds,
                ),
            const Gap(16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                S.of(context).addStayPeriodDescription,
                style: context.theme.textTheme.bodyMedium,
              ).animate().fade(
                    duration: 1.seconds,
                    delay: 300.ms,
                  ),
            ),
            ActivityTimeline(
              countries: countries,
              addRanges: (p0) async {
                final result = await Navigator.of(context).push<List<StayPeriodValueObject>>(
                  CupertinoPageRoute(
                    builder: (_) => AddPeriodsPage(
                      countries: countries,
                      segments: p0,
                    ),
                  ),
                );
                return result ?? [];
              },
              onSegmentsChanged: (segments) {
                setState(() {
                  _totalDaysByCountry = _calcTotalDaysByCountry(segments);
                });
              },
            ).animate().fade(delay: 1000.ms),
            const Spacer(),
            _buildButton(context),
          ],
        ),
      ),
    );
  }

  void _onContinue() {
    final residences = _totalDaysByCountry.map((key, value) {
      final countryDetails = countriesEnglish.firstWhere((e) => getCountryName(e["code"] as String) == key);

      return MapEntry(
        countryDetails["code"] as String,
        CountryEntity(
          name: key,
          periods: value.segments,
          isoCode: countryDetails["code"] as String,
        ),
      );
    });
    context.read<CountriesCubit>().updateCountries(residences);
    widget.onNextPage();
  }

  Widget _buildButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Center(
        child: _totalDaysByCountry.isEmpty
            ? null
            : PrimaryButton(
                onPressed: _onContinue,
                fontSize: 20,
                label: S.of(context).commonContinue,
              ).animate().fade(delay: 500.ms),
      ),
    ).animate().fade(delay: 1300.ms);
  }

  Map<String, CountryStayInfo> _calcTotalDaysByCountry(List<StayPeriodValueObject> segments) {
    final countryDays = <String, CountryStayInfo>{};

    for (final period in segments) {
      final country = period.country;
      final range = DateTimeRange(start: period.startDate, end: period.endDate);
      final days = range.duration.inDays;

      if (countryDays.containsKey(country)) {
        final existingInfo = countryDays[country]!;
        final updatedSegments = List<StayPeriodValueObject>.from(existingInfo.segments)..add(period);

        countryDays[country] = CountryStayInfo(
          totalDays: existingInfo.totalDays + days,
          segments: updatedSegments,
        );
      } else {
        countryDays[country] = CountryStayInfo(
          totalDays: days,
          segments: [period],
        );
      }
    }

    return countryDays;
  }
}
