import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth.state.dart';

class AuthCubit extends HydratedCubit<AuthState> {
  AuthCubit() : super(const AuthState()) {
    _init();
  }
  final LocalAuthentication _localAuth = LocalAuthentication();
  static const String _biometricEnabledKey = 'biometric_enabled';

  Future<void> _init() async {
    await checkBiometricSupport();
    await checkBiometricEnabled();
    await updateBiometricType();
  }

  Future<void> checkBiometricSupport() async {
    final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
    final bool isDeviceSupported = await _localAuth.isDeviceSupported();
    final isSupported = canCheckBiometrics && isDeviceSupported;
    emit(state.copyWith(isSupported: isSupported));
  }

  Future<void> checkBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isEnabled = prefs.getBool(_biometricEnabledKey) ?? false;
    emit(state.copyWith(isEnabled: isEnabled));
  }

  Future<void> updateBiometricType() async {
    final availableBiometrics = await _localAuth.getAvailableBiometrics();
    final biometricType = availableBiometrics.contains(BiometricType.face)
        ? BiometricType.face
        : availableBiometrics.contains(BiometricType.fingerprint)
            ? BiometricType.fingerprint
            : null;
    emit(state.copyWith(biometricType: biometricType));
  }

  Future<void> toggleBiometricAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final bool newStatus = !state.isEnabled;
    await prefs.setBool(_biometricEnabledKey, newStatus);
    emit(state.copyWith(isEnabled: newStatus));
  }

  Future<bool> authenticateOnStartup() async {
    if (!state.isEnabled) {
      emit(state.copyWith(isAuthenticated: true));
      return true;
    }

    try {
      final bool isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to access the app',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
      emit(state.copyWith(isAuthenticated: isAuthenticated, error: null));
      return isAuthenticated;
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
      return false;
    }
  }

  Future<bool> authenticateWithPasscode() async {
    try {
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please enter your passcode',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      emit(state.copyWith(isAuthenticated: didAuthenticate, error: null));
      return didAuthenticate;
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
      return false;
    }
  }

  Future<void> authenticateAndToggle() async {
    try {
      final bool isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to enable Face ID access',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      if (isAuthenticated) {
        await toggleBiometricAuth();
      } else {
        emit(state.copyWith(error: 'Authentication failed'));
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void resetAuthenticationAttempts() {
    emit(state.copyWith(isAuthenticated: false, error: null));
  }

  String get biometricTitle {
    switch (state.biometricType) {
      case BiometricType.face:
        return 'Face ID';
      case BiometricType.fingerprint:
        return 'Touch ID';
      default:
        return 'Biometric';
    }
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) => AuthState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(AuthState state) => state.toJson();
}
