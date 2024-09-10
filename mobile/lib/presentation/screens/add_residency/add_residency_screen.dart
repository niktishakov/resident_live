import 'package:country_list_pick/country_list_pick.dart';
import 'package:country_list_pick/support/code_countries_en.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:resident_live/core/extensions/context.extension.dart';
import 'package:resident_live/data/data.dart';
import 'package:resident_live/presentation/screens/home/widgets/rl.navigation_bar.dart';
import 'package:resident_live/presentation/screens/onboarding/pages/countries.page.dart';
import 'package:resident_live/presentation/screens/onboarding/pages/stay_period.page.dart';

import '../../../core/constants.dart';
import '../../../core/shared_state/shared_state_cubit.dart';
import '../../../data/residence.model.dart';
import '../../navigation/screen_names.dart';

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

  void _showCountryPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: countries
              .map((country) => CupertinoActionSheetAction(
                    child: Text(country),
                    onPressed: () {
                      setState(() => selectedCountry = country);
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
          cancelButton: CupertinoActionSheetAction(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
        );
      },
    );
  }

  void _addActivity(BuildContext context) async {
    DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (result != null) {
      setState(() => activities.add(result));
    }
  }

  void _submitResidency() {
    if (selectedCountry == null) return;

    int totalDays =
        activities.fold(0, (sum, activity) => sum + activity.duration.inDays);

    final newResidence = ResidenceModel(
      countryName: selectedCountry!,
      daysSpent: totalDays,
      periods: [
        ActivitySegment(
          country: selectedCountry!,
          startDate: activities
              .map((a) => a.start)
              .reduce((a, b) => a.isBefore(b) ? a : b),
          endDate: activities
              .map((a) => a.end)
              .reduce((a, b) => a.isAfter(b) ? a : b),
        )
      ],
      isoCountryCode: selectedCountry!.substring(
          0, 2), // Simplified; use a proper country code mapping in real app
    );

    context.read<SharedStateCubit>().addResidency(newResidence);
    Navigator.pop(context);
  }
}
