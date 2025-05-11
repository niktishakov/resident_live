import "package:domain/src/repository/auth_repository.dart";

import "package:injectable/injectable.dart";

@injectable
class IsBiometricsSupportedUsecase {
  IsBiometricsSupportedUsecase(this._authRepository);
  final IAuthRepostory _authRepository;

  Future<bool> call() async {
    return _authRepository.isBiometricsSupported();
  }
}
