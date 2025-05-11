import "package:domain/domain.dart";

import "package:injectable/injectable.dart";

@injectable
class UpdateStayPeriodsUsecase {
  UpdateStayPeriodsUsecase(this._userRepository);
  final IUserRepository _userRepository;

  Future<UserEntity> call(List<StayPeriodValueObject> stayPeriods) {
    return _userRepository.updateStayPeriods(stayPeriods);
  }
}
