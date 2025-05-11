import "package:domain/domain.dart";

import "package:injectable/injectable.dart";

@injectable
class CreateUserUsecase {
  CreateUserUsecase(this._userRepository);
  final IUserRepository _userRepository;

  Future<UserEntity> call() {
    return _userRepository.createUser();
  }
}
