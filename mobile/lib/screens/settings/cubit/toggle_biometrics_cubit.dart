import "package:domain/domain.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:injectable/injectable.dart";

@lazySingleton
class ToggleBiometricsCubit extends Cubit<bool> {
  ToggleBiometricsCubit({
    required bool enabled,
    required this.toggleBiometrics,
    required this.authByBiometrics,
    required this.isBiometricsSupported,
    required this.stopAuthentication,
    required this.isBiometricsEnabled,
  }) : super(enabled);

  final ToggleBiometricsUsecase toggleBiometrics;
  final AuthByBiometricsUsecase authByBiometrics;
  final StopAuthenticationUsecase stopAuthentication;
  final IsBiometricsSupportedUsecase isBiometricsSupported;
  final IsBiometricsEnabledUsecase isBiometricsEnabled;

  Future<void> action(String userId) async {
    final isSupported = await isBiometricsSupported.call();
    if (!isSupported) return;

    final isEnabled = await isBiometricsEnabled.call(userId);
    if (!isEnabled) return;

    final result = await toggleBiometrics.call(userId);
    emit(result);
  }
}
