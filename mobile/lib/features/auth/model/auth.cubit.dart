import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth.state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial()) {
    _init();
  }

  final LocalAuthentication _localAuth = LocalAuthentication();
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const int _maxBiometricAttempts = 2;
  int _biometricAttempts = 0;

  Future<void> _init() async {
    await checkBiometricSupport();
    await checkBiometricEnabled();
  }

  Future<void> checkBiometricSupport() async {
    final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
    final bool isDeviceSupported = await _localAuth.isDeviceSupported();
    final isSupported = canCheckBiometrics && isDeviceSupported;
    emit(BiometricSupportChecked(isSupported: isSupported));
  }

  Future<void> checkBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isEnabled = prefs.getBool(_biometricEnabledKey) ?? false;
    emit(BiometricAuthChecked(isEnabled: isEnabled));
  }

  Future<void> toggleBiometricAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final bool currentStatus = prefs.getBool(_biometricEnabledKey) ?? false;
    await prefs.setBool(_biometricEnabledKey, !currentStatus);
    emit(BiometricAuthChecked(isEnabled: !currentStatus));
  }

  Future<bool> authenticateOnStartup() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isEnabled = prefs.getBool(_biometricEnabledKey) ?? false;

    if (!isEnabled) {
      return true; // No need to authenticate, proceed with navigation
    }

    while (_biometricAttempts < _maxBiometricAttempts) {
      try {
        final bool isAuthenticated = await _localAuth.authenticate(
          localizedReason: 'Authenticate to access the app',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );
        if (isAuthenticated) {
          emit(BiometricAuthenticationComplete(isAuthenticated: true));
          return true;
        } else {
          _biometricAttempts++;
          emit(BiometricAuthenticationFailed(attempts: _biometricAttempts));
        }
      } catch (e) {
        emit(BiometricAuthenticationError(error: e.toString()));
        return false;
      }
    }

    emit(BiometricAuthenticationExhausted());
    return false;
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

      if (didAuthenticate) {
        emit(PasscodeAuthenticationComplete(isAuthenticated: true));
        return true;
      } else {
        emit(PasscodeAuthenticationFailed());
        return false;
      }
    } catch (e) {
      emit(PasscodeAuthenticationFailed());
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
        emit(BiometricAuthenticationError(error: 'Authentication failed'));
      }
    } catch (e) {
      emit(BiometricAuthenticationError(error: e.toString()));
    }
  }

  void resetAuthenticationAttempts() {
    _biometricAttempts = 0;
    emit(AuthInitial());
  }
}
