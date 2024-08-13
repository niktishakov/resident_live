import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:resident_live/core/assets/asset_image.dart';
import 'package:resident_live/core/assets/assets.dart';
import 'package:resident_live/core/constants.dart';
import 'package:resident_live/presentation/navigation/screen_names.dart';

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
      color: Colors.white,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
            ).animate().scale(
                  duration: 1.seconds,
                  curve: Curves.decelerate,
                  delay: 500.ms,
                ),
            Center(child: CoreAssetImage(CoreAssets.person, width: 50))
                .animate()
                .fade(
                  duration: 500.ms,
                  delay: 2.seconds,
                ),
            Positioned(
                bottom: MediaQuery.of(context).size.width * 0.5,
                child: Text("Resident Live",
                        style: Theme.of(context).textTheme.headlineLarge)
                    .animate()
                    .fade(delay: 500.ms, duration: 1.seconds)),
          ],
        ),
      ),
    );
  }
}
