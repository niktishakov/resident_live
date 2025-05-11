//@GeneratedMicroModule;DataPackageModule;package:data/injection.config.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:data/data.dart' as _i437;
import 'package:data/src/data_source/service/device_info/device_info.service.dart'
    as _i271;
import 'package:data/src/data_source/service/geolocator/geolocator.service.dart'
    as _i268;
import 'package:data/src/data_source/service/local_notification/local_notification.service.dart'
    as _i480;
import 'package:data/src/data_source/service/logger/logger.service.dart' as _i2;
import 'package:data/src/data_source/service/share/share.service.dart' as _i586;
import 'package:data/src/data_source/service/workmanager/background_loggger.dart'
    as _i202;
import 'package:data/src/data_source/service/workmanager/workmanager.service.dart'
    as _i143;
import 'package:data/src/data_source/storage/user_storage.dart' as _i86;
import 'package:data/src/model/user/user_model.dart' as _i32;
import 'package:data/src/modules/data_module.dart' as _i989;
import 'package:data/src/repository/auth_repository.dart' as _i687;
import 'package:data/src/repository/coordinates_repository.dart' as _i709;
import 'package:data/src/repository/placemark_repository.dart' as _i566;
import 'package:data/src/repository/user_repository.dart' as _i640;
import 'package:domain/domain.dart' as _i494;
import 'package:hive/hive.dart' as _i979;
import 'package:injectable/injectable.dart' as _i526;
import 'package:local_auth/local_auth.dart' as _i152;

class DataPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) async {
    final dataModule = _$DataModule();
    gh.factory<_i268.GeolocationService>(() => _i268.GeolocationService());
    gh.factory<_i586.ShareService>(() => _i586.ShareService());
    gh.singleton<_i202.BackgroundLogger>(() => _i202.BackgroundLogger());
    gh.singletonAsync<_i2.LoggerService>(() {
      final i = _i2.LoggerService();
      return i.init().then((_) => i);
    });
    gh.singletonAsync<_i271.DeviceInfoService>(
        () => _i271.DeviceInfoService.create());
    await gh.singletonAsync<_i979.Box<_i32.UserHiveModel>>(
      () => dataModule.userBox,
      preResolve: true,
    );
    gh.singleton<_i152.LocalAuthentication>(
        () => dataModule.localAuthentication);
    gh.factory<_i494.IAuthRepostory>(
        () => _i687.AuthRepository(gh<_i152.LocalAuthentication>()));
    gh.factory<_i494.IPlacemarkRepository>(() => _i566.PlacemarkRepository());
    gh.factory<_i494.ICoordinatesRepository>(
        () => _i709.CoordinatesRepository());
    gh.factory<_i143.WorkmanagerService>(
        () => _i143.WorkmanagerService(gh<_i437.LoggerService>()));
    gh.singletonAsync<_i480.LocalNotificationService>(() async =>
        _i480.LocalNotificationService(await gh.getAsync<_i2.LoggerService>()));
    gh.factory<_i86.UserStorage>(
        () => _i86.UserStorage(gh<_i979.Box<_i437.UserHiveModel>>()));
    gh.factory<_i494.IUserRepository>(() => _i640.UserRepository(
          gh<_i86.UserStorage>(),
          gh<_i437.DeviceInfoService>(),
        ));
  }
}

class _$DataModule extends _i989.DataModule {}
