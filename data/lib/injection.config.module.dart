//@GeneratedMicroModule;DataPackageModule;package:data/injection.config.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:data/data.dart' as _i437;
import 'package:data/src/data_source/api/unsplash/unsplash_api.dart' as _i1050;
import 'package:data/src/data_source/sdk/device_info/device_info.service.dart'
    as _i457;
import 'package:data/src/data_source/sdk/geolocator/geolocator.service.dart'
    as _i754;
import 'package:data/src/data_source/sdk/local_notification/local_notification.service.dart'
    as _i837;
import 'package:data/src/data_source/sdk/logger/logger.service.dart' as _i245;
import 'package:data/src/data_source/sdk/share/share.service.dart' as _i221;
import 'package:data/src/data_source/sdk/workmanager/background_loggger.dart'
    as _i806;
import 'package:data/src/data_source/sdk/workmanager/workmanager.service.dart'
    as _i687;
import 'package:data/src/data_source/storage/language_storage.dart' as _i268;
import 'package:data/src/data_source/storage/user_storage.dart' as _i86;
import 'package:data/src/model/local/user/user_model.dart' as _i680;
import 'package:data/src/module/hive_module.dart' as _i618;
import 'package:data/src/module/shared_preferences_module.dart' as _i789;
import 'package:data/src/module/unsplash_dio_module.dart' as _i228;
import 'package:data/src/repository/auth_repository.dart' as _i687;
import 'package:data/src/repository/coordinates_repository.dart' as _i709;
import 'package:data/src/repository/language_repository.dart' as _i787;
import 'package:data/src/repository/photo_repository.dart' as _i763;
import 'package:data/src/repository/placemark_repository.dart' as _i566;
import 'package:data/src/repository/user_repository.dart' as _i640;
import 'package:domain/domain.dart' as _i494;
import 'package:hive/hive.dart' as _i979;
import 'package:injectable/injectable.dart' as _i526;
import 'package:local_auth/local_auth.dart' as _i152;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

class DataPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) async {
    final sharedPrefsModule = _$SharedPrefsModule();
    final hiveModule = _$HiveModule();
    final unsplashDioModule = _$UnsplashDioModule();
    gh.factory<_i754.GeolocationService>(() => _i754.GeolocationService());
    gh.factory<_i221.ShareService>(() => _i221.ShareService());
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => sharedPrefsModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i806.BackgroundLogger>(() => _i806.BackgroundLogger());
    gh.singletonAsync<_i245.LoggerService>(() {
      final i = _i245.LoggerService();
      return i.init().then((_) => i);
    });
    gh.singletonAsync<_i457.DeviceInfoService>(
        () => _i457.DeviceInfoService.create());
    await gh.singletonAsync<_i979.Box<_i680.UserHiveModel>>(
      () => hiveModule.userBox,
      preResolve: true,
    );
    gh.singleton<_i152.LocalAuthentication>(
        () => hiveModule.localAuthentication);
    gh.lazySingleton<_i228.UnsplashDio>(() => unsplashDioModule.dio());
    gh.singleton<_i687.WorkmanagerService>(
        () => _i687.WorkmanagerService(gh<_i437.LoggerService>()));
    gh.factory<_i86.UserStorage>(
        () => _i86.UserStorage(gh<_i979.Box<_i437.UserHiveModel>>()));
    gh.factory<_i494.IAuthRepostory>(
        () => _i687.AuthRepository(gh<_i152.LocalAuthentication>()));
    gh.factory<_i494.IPlacemarkRepository>(() => _i566.PlacemarkRepository());
    gh.factory<_i494.ICoordinatesRepository>(
        () => _i709.CoordinatesRepository());
    gh.singletonAsync<_i837.LocalNotificationService>(() async =>
        _i837.LocalNotificationService(
            await gh.getAsync<_i245.LoggerService>()));
    gh.factory<_i1050.UnsplashApi>(
        () => _i1050.UnsplashApiImpl(gh<_i228.UnsplashDio>()));
    gh.factory<_i268.ILanguageStorage>(
        () => _i268.LanguageStorageImpl(gh<_i460.SharedPreferences>()));
    gh.factory<_i494.IUserRepository>(() => _i640.UserRepository(
          gh<_i86.UserStorage>(),
          gh<_i437.DeviceInfoService>(),
        ));
    gh.factory<_i494.ILanguageRepository>(
        () => _i787.LanguageRepository(gh<_i268.ILanguageStorage>()));
    gh.factory<_i494.PhotoRepository>(
        () => _i763.PhotoRepositoryImpl(gh<_i1050.UnsplashApi>()));
  }
}

class _$SharedPrefsModule extends _i789.SharedPrefsModule {}

class _$HiveModule extends _i618.HiveModule {}

class _$UnsplashDioModule extends _i228.UnsplashDioModule {}
