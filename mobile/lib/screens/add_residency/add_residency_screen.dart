import 'package:country_list_pick/support/code_countries_en.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:resident_live/screens/home/ui/widgets/rl.navigation_bar.dart';
import 'package:resident_live/screens/onboarding/ui/pages/countries.page.dart';
import 'package:resident_live/screens/onboarding/ui/pages/stay_period.page.dart';

import '../../app/navigation/screen_names.dart';
import '../../shared/lib/constants.dart';

class AddCountryResidencyScreen extends StatefulWidget {
  @override
  _AddCountryResidencyScreenState createState() =>
      _AddCountryResidencyScreenState();
}

class _AddCountryResidencyScreenState extends State<AddCountryResidencyScreen> {
  String? selectedCountry;
  List<DateTimeRange> activities = [];
  late PageController controller;

  @override
  void initState() {
    controller = PageController();
    super.initState();
  }

  final List<String> countries =
      countriesEnglish.map((e) => e['name'] as String).toList();

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
          title: "Add Residency",
        ),
      ),
      body: SafeArea(
        child: Material(
          child: PageView.builder(
            controller: controller,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (value) {
              if (value == 2) {
                // context.goNamed(ScreenNames.allowLocation);
              }
            },
            itemCount: 3,
            itemBuilder: (c, i) {
              switch (i) {
                case 0:
                  return EnterCountriesPage(onNextPage);
                case 1:
                  return EnterStayDurationPage(onNextPage: () {
                    context.goNamed(ScreenNames.home);
                  });
                default:
                  return EnterCountriesPage(onNextPage);
              }
            },
          ),
        ),
      ),
    );
  }
}
