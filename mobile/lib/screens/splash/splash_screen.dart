import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resident_live/shared/shared.dart';
import 'package:resident_live/features/features.dart';
import 'dart:ui';


part 'record.animation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

final _logger = AiLogger('SplashScreen');

class _SplashScreenState extends State<SplashScreen> {
  late AuthCubit _authCubit;
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _authCubit = context.read<AuthCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToHome();
    });
    return;
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(Duration(seconds: 1));
    if (!mounted) return;

    final state = find<CountriesCubit>(context).state;

    /// The main reason to go to Home is not empty countries list
    if (state.countries.isNotEmpty) {
      await find<LocationCubit>(context).initialize();
    } else {
      context.goNamed(ScreenNames.onboarding);
    }
  }

  Future<void> _checkAndAuthenticate() async {
    _logger.debug('Check and authenticate');

    setState(() => _isAuthenticating = true);
    final authResult = await _authCubit.authenticateOnStartup();
    if (!mounted) return;
    setState(() => _isAuthenticating = false);

    if (authResult) {
      _navigateToHome();
    } else {
      await _showPasscodeAuthentication();
    }
  }

  void _navigateToHome() {
    _logger.debug('Navigate to home');
    context.goNamed(ScreenNames.home);
  }

  Future<void> _showPasscodeAuthentication() async {
    _logger.debug('Show passcode authentication');
    setState(() => _isAuthenticating = true);
    final passcodeResult = await _authCubit.authenticateWithPasscode();
    if (!mounted) return;
    setState(() => _isAuthenticating = false);

    if (passcodeResult) {
      _navigateToHome();
    } else {
      await AppDialogs.showError(
        context: context,
        title: 'Authentication failed',
        message: 'Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.error != null) {
              ToastService.instance.showToast(
                context,
                message: state.error!,
                status: ToastStatus.failure,
              );
            }
          },
        ),
        BlocListener<LocationCubit, LocationState>(
          listener: (context, state) {
            if (state.placemark != null && state.placemark?.country != null) {
              find<CountriesCubit>(context).syncCountriesByGeo(state.placemark);
              _checkAndAuthenticate();
            } else if (state.error.isNotEmpty) {
              ToastService.instance.showToast(
                context,
                message: state.error,
                status: ToastStatus.failure,
              );
            }
          },
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
                      offset: Offset(35, -35), child: RecordingAnimation(),),
                  Center(child: Icon(CupertinoIcons.person_fill, size: 90)),
                  Transform.translate(
                    offset: Offset(0, 90),
                    child: Text(
                      'Resident Live',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w200,
                        fontSize: 36,
                      ),
                    ),
                  ),
                ],
              ).animate().fade(delay: 300.ms, duration: 600.ms),
            ),
            AnimatedOpacity(
              opacity: _isAuthenticating ? 1.0 : 0.0,
              duration: Duration(milliseconds: 300),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
