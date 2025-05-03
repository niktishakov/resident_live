//@GeneratedMicroModule;DataPackageModule;package:data/injection.config.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:data/data.dart' as _i437;
import 'package:data/src/service/geolocator/geolocator.service.dart' as _i24;
import 'package:data/src/service/local_notification/local_notification.service.dart'
    as _i324;
import 'package:data/src/service/logger/logger.service.dart' as _i717;
import 'package:data/src/service/share/share.service.dart' as _i848;
import 'package:data/src/service/workmanager/background_loggger.dart' as _i849;
import 'package:data/src/service/workmanager/workmanager.service.dart'
    as _i1022;
import 'package:injectable/injectable.dart' as _i526;

class DataPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.factory<_i24.GeolocationService>(() => _i24.GeolocationService());
    gh.factory<_i848.ShareService>(() => _i848.ShareService());
    gh.singleton<_i849.BackgroundLogger>(() => _i849.BackgroundLogger());
    gh.singletonAsync<_i717.LoggerService>(() {
      final i = _i717.LoggerService();
      return i.init().then((_) => i);
    });
    gh.singletonAsync<_i324.LocalNotificationService>(() async =>
        _i324.LocalNotificationService(
            await gh.getAsync<_i717.LoggerService>()));
    gh.factory<_i1022.WorkmanagerService>(
        () => _i1022.WorkmanagerService(gh<_i437.LoggerService>()));
  }
}
