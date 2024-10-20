part of 'auth.cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class BiometricSupportChecked extends AuthState {
  final bool isSupported;

  const BiometricSupportChecked({required this.isSupported});

  @override
  List<Object> get props => [isSupported];
}

class BiometricAuthToggled extends AuthState {
  final bool isEnabled;

  const BiometricAuthToggled({required this.isEnabled});

  @override
  List<Object> get props => [isEnabled];
}

class BiometricAuthChecked extends AuthState {
  final bool isEnabled;

  const BiometricAuthChecked({required this.isEnabled});

  @override
  List<Object> get props => [isEnabled];
}

class BiometricAuthenticationComplete extends AuthState {
  final bool isAuthenticated;

  const BiometricAuthenticationComplete({required this.isAuthenticated});

  @override
  List<Object> get props => [isAuthenticated];
}

class BiometricAuthenticationError extends AuthState {
  final String error;

  const BiometricAuthenticationError({required this.error});

  @override
  List<Object> get props => [error];
}

class BiometricAuthenticationFailed extends AuthState {
  final int attempts;

  const BiometricAuthenticationFailed({required this.attempts});

  @override
  List<Object> get props => [attempts];
}

class BiometricAuthenticationExhausted extends AuthState {}

class PasscodeAuthenticationComplete extends AuthState {
  final bool isAuthenticated;

  const PasscodeAuthenticationComplete({required this.isAuthenticated});

  @override
  List<Object> get props => [isAuthenticated];
}

class PasscodeAuthenticationFailed extends AuthState {}
