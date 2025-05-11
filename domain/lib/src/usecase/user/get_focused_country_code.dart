import "package:domain/domain.dart";

import "package:injectable/injectable.dart";

@injectable
class GetFocusedCountryCodeUsecase {
  GetFocusedCountryCodeUsecase(this._userRepository);
  final IUserRepository _userRepository;

  Future<String> call(String userId) async {
    final user = await _userRepository.getUser();
    return user.focusedCountryCode;
  }
}
