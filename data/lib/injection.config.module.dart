//@GeneratedMicroModule;DataPackageModule;package:data/injection.config.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:data/src/service/geolocator.service.dart' as _i757;
import 'package:data/src/service/logger.service.dart';
import 'package:data/src/service/pushNotification.service.dart';
import 'package:data/src/service/share.service.dart' as _i456;
import 'package:data/src/service/workmanager/background_loggger.dart' as _i849;
import 'package:injectable/injectable.dart' as _i526;

class DataPackageModule extends _i526.MicroPackageModule {
  // initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.factory<_i757.GeolocationService>(() => _i757.GeolocationService());
    gh.factory<_i456.ShareService>(() => _i456.ShareService());
    gh.singleton<_i849.BackgroundLogger>(() => _i849.BackgroundLogger());
    gh.singleton<PushNotificationService>(() => PushNotificationService());
    gh.singletonAsync<LoggerService>(() {
      final i = LoggerService(gh<String>());
      return i.init().then((_) => i);
    });
  }
}
