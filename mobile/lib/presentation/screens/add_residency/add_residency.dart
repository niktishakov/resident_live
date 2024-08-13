import 'package:country_list_pick/country_list_pick.dart';
import 'package:country_list_pick/support/code_countries_en.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            // Country Selection
            CupertinoButton(
              child: Text(selectedCountry ?? "Select a country"),
              onPressed: () => _showCountryPicker(context),
            ),
            SizedBox(height: 20),

            // Activity Input
            Text("Enter your activities for the last 12 months:",
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            ...activities.map((activity) => Text(
                "${activity.start.toIso8601String()} - ${activity.end.toIso8601String()}")),
            CupertinoButton(
              child: Text("Add Activity"),
              onPressed: () => _addActivity(context),
            ),
            SizedBox(height: 20),

            // Submit Button
            CupertinoButton.filled(
              child: Text("Submit"),
              onPressed: selectedCountry != null && activities.isNotEmpty
                  ? _submitResidency
                  : null,
            ),
          ],
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
