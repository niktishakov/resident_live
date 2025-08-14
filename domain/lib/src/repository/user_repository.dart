import "package:domain/domain.dart";

abstract interface class IUserRepository {
  Future<UserEntity> createUser();
  Future<UserEntity> getUser();
  Future<bool> toggleBiometrics();
  Future<UserEntity> focusOnCountry(String countryCode);
  Future<UserEntity> updateStayPeriods(List<StayPeriodValueObject> stayPeriods);
  Future<void> clearAllData();
}
