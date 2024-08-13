import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:resident_live/core/extensions/context.extension.dart';
import 'package:resident_live/core/shared_state/shared_state_cubit.dart';

import '../../navigation/screen_names.dart';

class AllowLocationScreen extends StatefulWidget {
  const AllowLocationScreen({super.key});

  @override
  State<AllowLocationScreen> createState() => _AllowLocationScreenState();
}

class _AllowLocationScreenState extends State<AllowLocationScreen> {
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
              Text(
                "Allow Location to effectivelly use this app",
                textAlign: TextAlign.center,
              ).animate().fade(
                    duration: 1.seconds,
                  ),
              Gap(40),
              CupertinoButton.filled(
                onPressed: () =>
                    context.read<SharedStateCubit>().initializeLocation(),
                child: Text("Allow Track Location",
                    style: context.theme.textTheme.labelLarge),
              ).animate().fade(delay: 1.seconds, duration: 500.ms),
            ],
          ),
        ),
      ),
    );
  }
}
