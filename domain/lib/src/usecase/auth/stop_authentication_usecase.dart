import "package:domain/src/repository/auth_repository.dart";

import "package:injectable/injectable.dart";

@injectable
class StopAuthenticationUsecase {
  StopAuthenticationUsecase(this._authRepository);
  final IAuthRepostory _authRepository;

  Future<bool> call() {
    return _authRepository.stopAuthentication();
  }
}
