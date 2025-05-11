import "package:domain/domain.dart";

import "package:injectable/injectable.dart";

@injectable
class SyncCountriesFromGeoUseCase {
  SyncCountriesFromGeoUseCase(this._userRepository);
  final IUserRepository _userRepository;

  Future<UserEntity> call({
    required PlacemarkValueObject? placemark,
  }) async {
    final now = DateTime.now();
    final user = await _userRepository.getUser();
    final stayPeriods = user.stayPeriods;

    if (placemark == null) {
      return user;
    }

    if (stayPeriods.isEmpty) {
      final firstStayPeriod = StayPeriodValueObject(
        startDate: now,
        endDate: now,
        countryCode: placemark.countryCode,
      );

      final updatedUser = await _userRepository.updateStayPeriods(
        [firstStayPeriod],
      );
      return updatedUser;
    }

    // Extend the last period if the same country
    final lastStayPeriod = user.stayPeriods.last;
    if (lastStayPeriod.countryCode == placemark.countryCode) {
      final updatedUser = await _userRepository.updateStayPeriods(
        [...stayPeriods.take(stayPeriods.length - 1), lastStayPeriod.copyWith(endDate: now)],
      );
      return updatedUser;
    }

    final newStayPeriod = StayPeriodValueObject(
      startDate: lastStayPeriod.endDate,
      endDate: now,
      countryCode: placemark.countryCode,
    );
    final updatedUser = await _userRepository.updateStayPeriods(
      [...stayPeriods, newStayPeriod],
    );
    return updatedUser;
  }
}
