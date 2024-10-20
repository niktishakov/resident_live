import 'package:flutter/material.dart';
import 'package:resident_live/widgets/widgets.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            FocusOnView(),
            AllowGeoView(),
            GetStartedView(),
          ],
        ),
      ),
    );
  }
}
