import 'package:country_list_pick/country_list_pick.dart';
import 'package:country_list_pick/support/code_countries_en.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:resident_live/core/constants.dart';
import 'package:resident_live/core/extensions/context.extension.dart';
import 'package:resident_live/presentation/screens/onboarding/pages/enter_countries.page.dart';

import '../../navigation/screen_names.dart';
import 'pages/enter_stay_duration.page.dart';
import 'pages/review_data.page.dart';

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
          onPageChanged: (value) {
            if (value == 2) {
              context.goNamed(ScreenNames.allowLocation);
            }
          },
          itemCount: 3,
          itemBuilder: (c, i) {
            switch (i) {
              case 0:
                return EnterCountriesPage(onNextPage);
              case 1:
                return EnterStayDurationPage(
                  onNextPage: onNextPage,
                );
              case 2:
                return ReviewDataPage(onNextPage);
              default:
                return EnterCountriesPage(onNextPage);
            }
          },
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
