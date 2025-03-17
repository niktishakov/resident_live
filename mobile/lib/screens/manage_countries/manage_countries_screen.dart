import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:resident_live/generated/codegen_loader.g.dart';
import 'package:resident_live/shared/shared.dart';

import '../../widgets/find_countries/ui/find_countries_page.dart';
import '../onboarding/ui/pages/stay_period.page.dart';

class ManageCountriesScreen extends StatefulWidget {
  @override
  _ManageCountriesScreenState createState() => _ManageCountriesScreenState();
}

class _ManageCountriesScreenState extends State<ManageCountriesScreen> {
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
          title: LocaleKeys.where_have_you_been_manageYourResidences.tr(),
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
                  return EnterStayDurationPage(onNextPage: () {
                    context.goNamed(ScreenNames.home);
                  },);
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
