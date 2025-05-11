import "package:domain/src/repository/auth_repository.dart";

import "package:injectable/injectable.dart";

@injectable
class AuthByBiometricsUsecase {
  AuthByBiometricsUsecase(this._authRepository);
  final IAuthRepostory _authRepository;

  Future<bool> call({
    required String localizedReason,
    bool? stickyAuth,
    bool? biometricOnly,
  }) {
    return _authRepository.authenticateByBiometrics(
      localizedReason: localizedReason,
      stickyAuth: stickyAuth,
      biometricOnly: biometricOnly,
    );
  }
}
