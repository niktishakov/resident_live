import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:resident_live/app/injection.dart";
import "package:resident_live/screens/onboarding/cubit/onboarding_cubit.dart";
import "package:resident_live/screens/onboarding/pages/get_started/cubit/get_started_cubit.dart";
import "package:resident_live/shared/shared.dart";

class GetStartedView extends StatelessWidget {
  const GetStartedView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.rlTheme;
    return BlocBuilder<GetStartedCubit, GetStartedState>(
      bloc: getIt<GetStartedCubit>(),
      buildWhen:
          (previous, current) => previous.isGeoPermissionAllowed != current.isGeoPermissionAllowed,
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.1),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child:
              !state.isGeoPermissionAllowed
                  ? const SizedBox(key: ValueKey<bool>(false))
                  : Column(
                    key: const ValueKey<bool>(true),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text.rich(
                          style: theme.title24Semi.copyWith(color: theme.textPrimary),
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: "No server-side data\nstorage. Everything\nworks ",
                              ),
                              TextSpan(
                                text: "offline",
                                style: theme.title24Semi.copyWith(color: theme.textAccent),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PrimaryButton(
                                label: "Get Started",
                                gradient: LinearGradient(
                                  colors: [context.theme.primaryColor, const Color(0xff306D99)],
                                ),
                                textStyle: theme.body18M.copyWith(color: theme.textPrimary),
                                onPressed: () {
                                  getIt<OnboardingCubit>().reset();
                                  context.goNamed(ScreenNames.home);
                                },
                              )
                              .animate(onPlay: (c) => c.repeat())
                              .shimmer(duration: 1.seconds, delay: 1.seconds),
                        ],
                      ),
                    ],
                  ).animate().fade(duration: 500.ms),
        );
      },
    );
  }
}
