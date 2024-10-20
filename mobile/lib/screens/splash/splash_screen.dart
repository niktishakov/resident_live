import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:resident_live/app/navigation/screen_names.dart';
import 'package:resident_live/shared/shared.dart';
import 'package:resident_live/features/features.dart';
import 'dart:ui';

part 'record.animation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AuthCubit _authCubit;
  bool _isAuthenticating = false;

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
    setState(() => _isAuthenticating = true);
    final authResult = await _authCubit.authenticateOnStartup();
    if (!mounted) return;
    setState(() => _isAuthenticating = false);

    if (authResult) {
      _navigateToHome();
    } else {
      _showPasscodeAuthentication();
    }
  }

  void _navigateToHome() {
    context.goNamed(ScreenNames.home);
  }

  Future<void> _showPasscodeAuthentication() async {
    setState(() => _isAuthenticating = true);
    final passcodeResult = await _authCubit.authenticateWithPasscode();
    if (!mounted) return;
    setState(() => _isAuthenticating = false);

    if (passcodeResult) {
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
                _authCubit.resetAuthenticationAttempts();
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
        if (state.error != null) {
          _showErrorDialog(state.error!);
        } else if (state.isAuthenticated) {
          _navigateToHome();
        }
      },
      child: Stack(
        children: [
          ColoredBox(
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
    );
  }
}
