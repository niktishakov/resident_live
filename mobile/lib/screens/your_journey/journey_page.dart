import "package:domain/domain.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:gap/gap.dart";
import "package:resident_live/app/injection.dart";
import "package:resident_live/screens/splash/cubit/get_user_cubit.dart";
import "package:resident_live/screens/your_journey/widgets/country_disabler.dart";
import "package:resident_live/screens/your_journey/widgets/header.dart";
import "package:resident_live/screens/your_journey/widgets/journey_calendar.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_cubit.dart";
import "package:resident_live/shared/lib/utils/colors_utils.dart";
import "package:resident_live/shared/shared.dart";

class ResidencyJourneyScreen extends StatefulWidget {
  const ResidencyJourneyScreen({super.key, this.initialDate});
  final DateTime? initialDate;

  @override
  State<ResidencyJourneyScreen> createState() => _ResidencyJourneyScreenState();
}

class _ResidencyJourneyScreenState extends State<ResidencyJourneyScreen> {
  late DateTime _currentMonth;
  final List<String> _disabledCountries = [];

  @override
  void initState() {
    super.initState();
    _currentMonth = widget.initialDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetUserCubit, ResourceState<UserEntity>>(
      bloc: getIt<GetUserCubit>(),
      builder: (context, state) {
        final countryPeriods = mapStayPeriodsToDateTimeRanges(state.data?.countries ?? {});
        final countryCodes = state.data?.countryCodes ?? [];
        final focusedCountryCode = state.data?.focusedCountryCode;
        final countryColors = getCountryColors(countryCodes);

        final visibleCountries = countryCodes
            .where(
              (countryCode) => !_disabledCountries.contains(countryCode),
            )
            .toSet();

        return Scaffold(
          body: Column(
            children: [
              const Grabber(),
              const Gap(16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Header(),
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
                          currentMonth: _currentMonth,
                          countryPeriods: countryPeriods,
                          visibleCountries: visibleCountries,
                          countryColors: countryColors,
                          onMonthChanged: (newMonth) {
                            setState(() {
                              _currentMonth = newMonth;
                            });
                          },
                        ),
                      ),
                      const Gap(16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: CountryDisabler(
                          countryCodes: countryCodes,
                          colors: countryColors,
                          focusedCountryCode: focusedCountryCode,
                          currentMonth: _currentMonth,
                          countryPeriods: countryPeriods,
                          disabledCountries: _disabledCountries,
                          toggleCountry: ({
                            required countryCode,
                            required isDisabled,
                          }) {
                            setState(() {
                              if (!isDisabled) {
                                _disabledCountries.add(countryCode);
                              } else {
                                _disabledCountries.remove(countryCode);
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

  Map<String, List<DateTimeRange>> mapStayPeriodsToDateTimeRanges(
    Map<String, List<StayPeriodValueObject>> countries,
  ) {
    return Map.fromEntries(
      countries.entries.map(
        (entry) {
          final periods = entry.value
              .map(
                (period) => DateTimeRange(
                  start: period.startDate,
                  end: period.endDate,
                ),
              )
              .toList();
          return MapEntry(entry.key, periods);
        },
      ),
    );
  }
}
