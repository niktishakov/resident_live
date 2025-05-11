import 'package:data/data.dart';
import 'package:data/src/data_source/storage/user_storage.dart';
import 'package:data/src/mapper/user_mapper.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IUserRepository)
class UserRepository implements IUserRepository {
  UserRepository(
    this._storage,
    this._deviceInfoService,
  );
  final UserStorage _storage;
  final DeviceInfoService _deviceInfoService;

  @override
  Future<UserEntity> createUser() async {
    final user = UserHiveModel(
      id: _deviceInfoService.deviceId,
      createdAt: DateTime.now(),
    );

    final result = await _storage.createUser(user);
    return result.toEntity();
  }

  @override
  Future<bool> toggleBiometrics() async {
    final user = _storage.getUser(_deviceInfoService.deviceId);
    if (user == null) {
      throw Exception('User not found');
    }

    user.isBiometricsEnabled = !user.isBiometricsEnabled;
    _storage.updateUser(user);

    return user.isBiometricsEnabled;
  }

  @override
  Future<UserEntity> getUser() async {
    final user = _storage.getUser(_deviceInfoService.deviceId);
    if (user == null) {
      throw Exception('User not found');
    }

    return user.toEntity();
  }

  @override
  Future<UserEntity> focusOnCountry(String countryCode) async {
    final user = _storage.getUser(_deviceInfoService.deviceId);
    if (user == null) {
      throw Exception('User not found');
    }

    user.focusedCountryCode = countryCode;
    _storage.updateUser(user);

    return user.toEntity();
  }

  @override
  Future<UserEntity> updateStayPeriods(
    List<StayPeriodValueObject> stayPeriods,
  ) async {
    final user = _storage.getUser(_deviceInfoService.deviceId)?.toEntity();
    if (user == null) {
      throw Exception('User not found');
    }

    final updatedUser = user.copyWith(stayPeriods: stayPeriods);
    await _storage.updateUser(updatedUser.toModel());

    return updatedUser;
  }
}
