import 'package:country_list_pick/support/code_countries_en.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:resident_live/generated/codegen_loader.g.dart';
import 'package:resident_live/shared/shared.dart';

import '../../../../domain/domain.dart';
import '../../../../features/features.dart';
import '../../../../widgets/activity_timeline.dart';
import '../../model/onboarding_cubit.dart';
import 'add_periods.page.dart';

class EnterStayDurationPage extends StatefulWidget {

  const EnterStayDurationPage({
    required this.onNextPage,
    Key? key,
  }) : super(key: key);
  final VoidCallback onNextPage;

  @override
  _EnterStayDurationPageState createState() => _EnterStayDurationPageState();
}

class _EnterStayDurationPageState extends State<EnterStayDurationPage> {
  Map<String, dynamic> _totalDaysByCountry = {};
  late List<String> countries;

  @override
  void initState() {
    countries = context
        .read<OnboardingCubit>()
        .state
        .selectedCountries
        .map(getCountryName)
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FadeBorder(
      child: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Gap(32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(LocaleKeys.add_stay_period_title.tr(),
                style: Theme.of(context).textTheme.headlineSmall,),
          ).animate().fade(
                duration: 1.seconds,
              ),
          Gap(16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(LocaleKeys.add_stay_period_description.tr(),
                    style: context.theme.textTheme.bodyMedium,)
                .animate()
                .fade(
                  duration: 1.seconds,
                  delay: 300.ms,
                ),
          ),
          ActivityTimeline(
            countries: countries,
            addRanges: (p0) async {
              final result = await Navigator.of(context).push<List<StayPeriod>>(
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
          Spacer(),
          _buildButton(context),
        ],),
      ),
    );
  }

  void _onContinue() {
    final residences = _totalDaysByCountry.map((key, value) {
      final countryDetails = countriesEnglish
          .firstWhere((e) => getCountryName(e['code'] as String) == key);

      print(value);

      return MapEntry(
          countryDetails['code'] as String,
          CountryEntity(
            name: key,
            periods: value['segments'] as List<StayPeriod>,
            isoCode: countryDetails['code'] as String,
          ),);
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
                label: LocaleKeys.common_continue.tr(),
              ).animate().fade(delay: 500.ms),
      ),
    ).animate().fade(delay: 1300.ms);
  }

  Map<String, dynamic> _calcTotalDaysByCountry(List<StayPeriod> segments) {
    final countryDays = <String, dynamic>{};

    for (var period in segments) {
      final country = period.country;
      final range = DateTimeRange(start: period.startDate, end: period.endDate);
      final days = range.duration.inDays;

      if (countryDays.containsKey(country)) {
        final existingSegments =
            List<StayPeriod>.from(countryDays[country]!['segments']);
        existingSegments.add(period);
        countryDays[country] = {
          'value': countryDays[country]!['value'] + days,
          'segments': existingSegments,
        };
      } else {
        countryDays[country] = {
          'value': days,
          'segments': [period],
        };
      }
    }

    return countryDays;
  }
}
