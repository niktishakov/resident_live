import "package:domain/src/repository/user_repository.dart";

import "package:injectable/injectable.dart";

@injectable
class ToggleBiometricsUsecase {
  ToggleBiometricsUsecase(this._userRepository);
  final IUserRepository _userRepository;

  Future<bool> call(String userId) {
    return _userRepository.toggleBiometrics();
  }
}
