import "package:domain/src/repository/user_repository.dart";

import "package:injectable/injectable.dart";

@injectable
class IsBiometricsEnabledUsecase {
  IsBiometricsEnabledUsecase(this._userRepository);
  final IUserRepository _userRepository;

  Future<bool> call(String userId) async {
    final user = await _userRepository.getUser();
    return user.isBiometricsEnabled;
  }
}
