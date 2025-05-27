import "dart:ui";

import "package:domain/domain.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:get_it/get_it.dart";
import "package:go_router/go_router.dart";
import "package:google_fonts/google_fonts.dart";
import "package:resident_live/app/injection.dart";
import "package:resident_live/screens/settings/cubit/auth_by_biometrics_cubit.dart";
import "package:resident_live/screens/splash/cubit/create_user_cubit.dart";
import "package:resident_live/screens/splash/cubit/get_user_cubit.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_cubit.dart";
import "package:resident_live/shared/lib/service/toast.service.dart";
import "package:resident_live/shared/shared.dart";

part "record.animation.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getIt<GetUserCubit>().loadResource(""); // TODO: add user id
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GetUserCubit, ResourceState<UserEntity>>(
          bloc: getIt<GetUserCubit>(),
          listener: _onGetUserListen,
        ),
        BlocListener<CreateUserCubit, ResourceState<UserEntity>>(
          bloc: getIt<CreateUserCubit>(),
          listener: _onCreateUserListen,
        ),
        BlocListener<AuthByBiometricsCubit, ResourceState<bool>>(
          bloc: getIt<AuthByBiometricsCubit>(),
          listener: _onAuthByBiometricsListen,
        ),
      ],
      child: Scaffold(
        body: Stack(
          children: [
            ColoredBox(
              color: context.theme.scaffoldBackgroundColor,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Transform.translate(
                    offset: const Offset(35, -35),
                    child: const RecordingAnimation(),
                  ),
                  const Center(child: Icon(CupertinoIcons.person_fill, size: 90)),
                  Transform.translate(
                    offset: const Offset(0, 90),
                    child: Text(
                      "Resident Live",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w200, fontSize: 36),
                    ),
                  ),
                ],
              ).animate().fade(delay: 300.ms, duration: 600.ms),
            ),
            BlocBuilder<AuthByBiometricsCubit, ResourceState<bool>>(
              bloc: GetIt.I<AuthByBiometricsCubit>(),
              builder: (context, state) {
                return AnimatedOpacity(
                  opacity: state.maybeMap(loading: (_) => 1.0, orElse: () => 0.0),
                  duration: const Duration(milliseconds: 300),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(color: Colors.transparent),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onCreateUserListen(BuildContext context, ResourceState<UserEntity> state) {
    state.maybeWhen(
      orElse: () {},
      error: (error, stack) {
        ToastService.instance.showToast(
          context,
          message: error ?? "Something went wrong",
          status: ToastStatus.failure,
        );
      },
      data: (user) {
        GetIt.I<GetUserCubit>().loadResource(user.id);
      },
    );
  }

  void _onGetUserListen(BuildContext context, ResourceState<UserEntity> state) {
    state.maybeWhen(
      orElse: () {},
      error: (error, stack) {
        GetIt.I<CreateUserCubit>().loadResource();
      },
      data: (user) {
        final isBiometricsEnabled = user.isBiometricsEnabled;
        if (isBiometricsEnabled) {
          GetIt.I<AuthByBiometricsCubit>().loadResource();
        } else {
          final stayPeriods = user.stayPeriods;
          if (stayPeriods.isEmpty) {
            context.goNamed(ScreenNames.onboarding);
          } else {
            context.goNamed(ScreenNames.home);
          }
        }
      },
    );
  }

  void _onAuthByBiometricsListen(BuildContext context, ResourceState<bool> state) {
    state.maybeWhen(
      orElse: () {},
      error: (error, stack) {
        ToastService.instance.showToast(
          context,
          message: error ?? "Cannot authenticate with biometrics",
          status: ToastStatus.failure,
        );
      },
      data: (result) {
        if (result) {
          context.goNamed(ScreenNames.home);
        } else {
          ToastService.instance.showToast(
            context,
            message: "Failed to authenticate with biometrics",
            status: ToastStatus.failure,
          );
        }
      },
    );
  }
}
