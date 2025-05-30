import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:resident_live/localization/generated/l10n/l10n.dart";
import "package:resident_live/screens/onboarding/pages/add_stay_periods/add_stay_periods_page.dart";
import "package:resident_live/screens/onboarding/pages/find_countries/find_countries_page.dart";
import "package:resident_live/shared/shared.dart";

class ManageCountriesScreen extends StatefulWidget {
  const ManageCountriesScreen({super.key});

  @override
  ManageCountriesScreenState createState() => ManageCountriesScreenState();
}

class ManageCountriesScreenState extends State<ManageCountriesScreen> {
  String? selectedCountry;
  List<DateTimeRange> activities = [];
  late PageController controller;

  @override
  void initState() {
    controller = PageController();
    super.initState();
  }

  void onNextPage() => controller.nextPage(
        duration: kDefaultDuration,
        curve: Curves.easeIn,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: RlCupertinoNavBar(
          title: S.of(context).homeTrackingResidences,
        ),
      ),
      body: SafeArea(
        child: Material(
          child: PageView.builder(
            controller: controller,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            itemBuilder: (c, i) {
              switch (i) {
                case 0:
                  return FindCountriesPage(onNextPage);
                case 1:
                  return AddStayPeriodsPage(
                    onNextPage: () {
                      context.goNamed(ScreenNames.home);
                    },
                  );
                default:
                  return FindCountriesPage(onNextPage);
              }
            },
          ),
        ),
      ),
    );
  }
}
