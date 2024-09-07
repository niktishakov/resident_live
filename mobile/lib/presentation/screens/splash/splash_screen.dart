import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:resident_live/core/assets/asset_image.dart';
import 'package:resident_live/core/assets/assets.dart';
import 'package:resident_live/core/constants.dart';
import 'package:resident_live/core/extensions/context.extension.dart';
import 'package:resident_live/presentation/navigation/screen_names.dart';
import 'package:resident_live/presentation/screens/splash/record.animation.dart';

import '../../../core/shared_state/shared_state_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 4), () {
      final sharedState = context.read<SharedStateCubit>();
      if (sharedState.state.currentPosition != null) {
        context.read<SharedStateCubit>().refreshState();
        context.goNamed(ScreenNames.home);
        return;
      }
      context.goNamed(ScreenNames.onboarding);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.theme.scaffoldBackgroundColor,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            RecordingAnimation(),
            Center(child: CoreAssetImage(CoreAssets.person, width: 45))
                .animate()
                .fade(
                  duration: 500.ms,
                  delay: 3.seconds,
                ),
            Positioned(
                bottom: MediaQuery.of(context).size.width * 0.5,
                child: Text("Resident Live",
                        style: Theme.of(context).textTheme.headlineLarge)
                    .animate()
                    .fade(delay: 1.seconds, duration: 800.ms)),
          ],
        ),
      ),
    );
  }
}
