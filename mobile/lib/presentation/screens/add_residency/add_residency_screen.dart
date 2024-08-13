import 'package:country_list_pick/country_list_pick.dart';
import 'package:country_list_pick/support/code_countries_en.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resident_live/core/extensions/context.extension.dart';
import 'package:resident_live/presentation/screens/onboarding/pages/enter_stay_duration.page.dart';

import '../../../core/shared_state/shared_state_cubit.dart';
import '../../../data/country_residence.model.dart';

class AddCountryResidencyScreen extends StatefulWidget {
  @override
  _AddCountryResidencyScreenState createState() =>
      _AddCountryResidencyScreenState();
}

class _AddCountryResidencyScreenState extends State<AddCountryResidencyScreen> {
  String? selectedCountry;
  List<DateTimeRange> activities = [];

  final List<String> countries =
      countriesEnglish.map((e) => e['name'] as String).toList();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Add Country Residency"),
      ),
      child: SafeArea(
        child: Material(
          child: EnterStayDurationPage(
            onNextPage: () {},
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

    CountryResidenceModel newResidence = CountryResidenceModel(
      countryName: selectedCountry!,
      daysSpent: totalDays,
      isResident:
          totalDays > 183, // Simple logic for residency, adjust as needed
      startDate: activities
          .map((a) => a.start)
          .reduce((a, b) => a.isBefore(b) ? a : b),
      endDate:
          activities.map((a) => a.end).reduce((a, b) => a.isAfter(b) ? a : b),
      isoCountryCode: selectedCountry!.substring(
          0, 2), // Simplified; use a proper country code mapping in real app
    );

    context.read<SharedStateCubit>().addResidency(newResidence);
    Navigator.pop(context);
  }
}
