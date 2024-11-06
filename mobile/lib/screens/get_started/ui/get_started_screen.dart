import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:resident_live/shared/shared.dart';
import 'package:resident_live/widgets/widgets.dart';
import 'package:soft_edge_blur/soft_edge_blur.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeBorder(
        stops: [0, 0.1],
        child: Container(
          height: context.mediaQuery.size.height,
          child: ListView(
            padding: EdgeInsets.symmetric(
                horizontal: 30, vertical: context.mediaQuery.padding.top),
            children: [
              Gap(32),
              FocusOnView(),
              Gap(32),
              AllowGeoView(),
              Gap(32),
              GetStartedView(),
              Gap(context.mediaQuery.padding.bottom),
            ],
          ),
        ),
      ),
    );
  }
}
