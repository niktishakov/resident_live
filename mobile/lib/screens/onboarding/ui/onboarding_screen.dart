import "package:country_list_pick/country_list_pick.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:resident_live/screens/onboarding/ui/pages/stay_period.page.dart";
import "package:resident_live/shared/shared.dart";
import "package:resident_live/widgets/find_countries/ui/find_countries_page.dart";

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  CountryCode? countryCode;
  bool get show => countryCode != null;
  final controller = PageController();

  void onNextPage() => controller.nextPage(
        duration: kDefaultDuration,
        curve: Curves.easeIn,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PageView.builder(
          controller: controller,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (c, i) {
            switch (i) {
              case 0:
                return FindCountriesPage(onNextPage);
              case 1:
                return EnterStayDurationPage(
                  onNextPage: () {
                    context.pushNamed(ScreenNames.getStarted);
                  },
                );

              default:
                return FindCountriesPage(onNextPage);
            }
          },
        ),
      ),
    );
  }
}
