import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:resident_live/core/extensions/context.extension.dart';
import 'package:resident_live/core/shared_state/shared_state_cubit.dart';
import 'package:resident_live/presentation/widgets/primary_button.dart';

import '../../navigation/screen_names.dart';

class AllowLocationScreen extends StatelessWidget {
  const AllowLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocListener<SharedStateCubit, SharedStateState>(
          listener: (context, state) {
            if (state.currentPosition?.country != null) {
              context.goNamed(ScreenNames.home);
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                onPressed: () =>
                    context.read<SharedStateCubit>().initializeLocation(),
                textColor: Colors.white,
                label: "Allow Track Location",
              )
                  .animate()
                  .fade(delay: 1.seconds, duration: 500.ms)
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(duration: 1.seconds, delay: 1.seconds),
              Gap(8),
              PrimaryButton(
                backgroundColor:
                    context.theme.colorScheme.tertiary.withOpacity(0.5),
                onPressed: () => context.goNamed(ScreenNames.home),
                label: "Ignore",
                textColor: context.theme.colorScheme.onTertiary,
              ).animate().fade(delay: 1.seconds, duration: 500.ms),
            ],
          ),
        ),
      ),
    );
  }
}
