import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:resident_live/features/features.dart';
import 'package:resident_live/shared/shared.dart';

import '../../app/navigation/screen_names.dart';

class AllowGeoView extends StatelessWidget {
  const AllowGeoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            "Allow location access to accurately track your tax residency status",
            textAlign: TextAlign.center,
          ).animate().fade(
                duration: 1.seconds,
              ),
        ),
        Gap(8),
        Icon(
          CupertinoIcons.location_solid,
          size: 40,
          color: context.theme.primaryColor,
        ),
        Gap(32),
        PrimaryButton(
          onPressed: () => find<LocationCubit>(context).initialize(),
          textColor: Colors.white,
          label: "Allow Track Location",
        )
            .animate()
            .fade(delay: 1.seconds, duration: 500.ms)
            .animate(onPlay: (controller) => controller.repeat())
            .shimmer(duration: 1.seconds, delay: 1.seconds),
        Gap(8),
        PrimaryButton(
          backgroundColor: context.theme.colorScheme.tertiary.withOpacity(0.5),
          onPressed: () => context.goNamed(ScreenNames.home),
          label: "Ignore",
          textColor: context.theme.colorScheme.onTertiary,
        ).animate().fade(delay: 1.seconds, duration: 500.ms),
      ],
    );
  }
}
