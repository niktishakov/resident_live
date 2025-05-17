import "package:domain/domain.dart";
import "package:flutter/cupertino.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:gap/gap.dart";
import "package:resident_live/app/injection.config.dart";
import "package:resident_live/localization/generated/l10n/l10n.dart";
import "package:resident_live/screens/onboarding/cubit/onboarding_cubit.dart";
import "package:resident_live/screens/onboarding/pages/add_periods/add_periods.page.dart";
import "package:resident_live/screens/onboarding/pages/add_stay_periods/cubit/update_countries_cubit.dart";
import "package:resident_live/screens/onboarding/pages/add_stay_periods/widgets/activity_timeline.dart";
import "package:resident_live/screens/splash/cubit/get_user_cubit.dart";
import "package:resident_live/shared/shared.dart";

class AddStayPeriodsPage extends StatefulWidget {
  const AddStayPeriodsPage({
    required this.onNextPage,
    super.key,
  });
  final VoidCallback onNextPage;

  @override
  AddStayPeriodsPageState createState() => AddStayPeriodsPageState();
}

class AddStayPeriodsPageState extends State<AddStayPeriodsPage> {
  List<StayPeriodValueObject> _stayPeriods = [];
  late List<String> countryNames;

  @override
  void initState() {
    countryNames = getIt<OnboardingCubit>().state.selectedCountries;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;
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
                style: theme.title26,
              ),
            ).animate().fade(
                  duration: 1.seconds,
                ),
            const Gap(16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                S.of(context).addStayPeriodDescription,
                style: theme.body14,
              ).animate().fade(
                    duration: 1.seconds,
                    delay: 300.ms,
                  ),
            ),
            ActivityTimeline(
              countries: countryNames,
              addRanges: (p0) async {
                final result = await Navigator.of(context).push<List<StayPeriodValueObject>>(
                  CupertinoPageRoute(
                    builder: (_) => AddPeriodsPage(
                      countries: countryNames,
                      segments: p0,
                    ),
                  ),
                );
                return result ?? [];
              },
              onSegmentsChanged: (segments) {
                setState(() => _stayPeriods = segments);
              },
            ).animate().fade(delay: 1000.ms),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: _stayPeriods.isEmpty
                    ? null
                    : PrimaryButton(
                        onPressed: _onContinue,
                        fontSize: 20,
                        label: S.of(context).commonContinue,
                      ).animate().fade(delay: 500.ms),
              ),
            ).animate().fade(delay: 1300.ms),
          ],
        ),
      ),
    );
  }

  Future<void> _onContinue() async {
    await getIt<UpdateCountriesCubit>().loadResource(_stayPeriods);
    await getIt<GetUserCubit>().loadResource();
    widget.onNextPage();
  }
}
