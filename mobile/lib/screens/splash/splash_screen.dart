import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:resident_live/app/navigation/screen_names.dart';
import 'package:resident_live/shared/shared.dart';
import 'package:resident_live/features/features.dart';

part 'record.animation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();
    _authCubit = context.read<AuthCubit>();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(Duration(seconds: 3));
    if (!mounted) return;

    final state = context.read<CountriesCubit>().state;
    if (state.countries.isNotEmpty) {
      await _checkAndAuthenticate();
    } else {
      context.goNamed(ScreenNames.onboarding);
    }
  }

  Future<void> _checkAndAuthenticate() async {
    final authResult = await _authCubit.authenticateOnStartup();
    if (!mounted) return;

    if (authResult) {
      _navigateToHome();
    } else {
      _showPasscodeAuthentication();
    }
  }

  void _navigateToHome() {
    context.goNamed(ScreenNames.home);
  }

  void _showPasscodeAuthentication() async {
    bool result = await _authCubit.authenticateWithPasscode();
    if (result) {
      _navigateToHome();
    } else {
      _showErrorDialog("Authentication failed. Please try again.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Authentication Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                _showPasscodeAuthentication(); // Show passcode authentication after error
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is BiometricAuthenticationError ||
            state is BiometricAuthenticationFailed ||
            state is BiometricAuthenticationExhausted) {
          _showPasscodeAuthentication();
        } else if (state is PasscodeAuthenticationFailed ||
            state is PasscodeAuthenticationFailed) {
          _showErrorDialog("Authentication failed. Please try again.");
        }
      },
      child: ColoredBox(
        color: context.theme.scaffoldBackgroundColor,
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              RecordingAnimation(),
              Center(child: AppAssetImage(AppAssets.person, width: 45))
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
                      .fade(delay: 500.ms, duration: 800.ms)),
            ],
          ),
        ),
      ),
    );
  }
}
