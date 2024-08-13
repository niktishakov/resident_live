import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../navigation/screen_names.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  CountryCode? countryCode;
  bool get show => countryCode != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Choose Your Country Residence").animate().fade(
                  duration: 1.seconds,
                ),
            CountryListPick(
              appBar: AppBar(),
              initialSelection: null,
              onChanged: (value) => setState(() => countryCode = value),
            ).animate().fade(
                  duration: 1.seconds,
                  delay: 500.ms,
                ),
            Gap(40),
            if (show) ...[
              CupertinoButton.filled(
                onPressed: () => context.goNamed(ScreenNames.allowLocation),
                child: Text("Continue"),
              ).animate().fade(duration: 500.ms),
            ],
          ],
        ),
      ),
    );
  }

  _showDropdown() {
    return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text('Select Item'),
          actions: ['One', 'Two', 'Three'].map((String item) {
            return CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(item),
            );
          }).toList(),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
            isDefaultAction: true,
          ),
        );
      },
    );
  }
}
