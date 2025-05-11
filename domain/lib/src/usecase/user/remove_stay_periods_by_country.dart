import "package:domain/domain.dart";

import "package:injectable/injectable.dart";

@injectable
class RemoveStayPeriodsByCountryUsecase {
  RemoveStayPeriodsByCountryUsecase(this._userRepository);
  final IUserRepository _userRepository;

  Future<UserEntity> call(String countryCode) async {
    final user = await _userRepository.getUser();
    final stayPeriods = user.stayPeriods;
    final updatedStayPeriods = stayPeriods.where((period) => period.countryCode != countryCode).toList();
    return _userRepository.updateStayPeriods(updatedStayPeriods);
  }
}
