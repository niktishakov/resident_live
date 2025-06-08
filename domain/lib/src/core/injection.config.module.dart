//@GeneratedMicroModule;DomainPackageModule;package:domain/src/core/injection.config.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:domain/domain.dart' as _i494;
import 'package:domain/src/repository/auth_repository.dart' as _i722;
import 'package:domain/src/repository/language_repository.dart' as _i351;
import 'package:domain/src/repository/user_repository.dart' as _i868;
import 'package:domain/src/usecase/auth/auth_by_biometrics_usecase.dart'
    as _i1071;
import 'package:domain/src/usecase/auth/is_biometrics_supported_usecase.dart'
    as _i804;
import 'package:domain/src/usecase/auth/stop_authentication_usecase.dart'
    as _i750;
import 'package:domain/src/usecase/coordinates/get_coordinates_usecase.dart'
    as _i306;
import 'package:domain/src/usecase/coordinates/request_permission_usecase.dart'
    as _i1045;
import 'package:domain/src/usecase/language/change_language_usecase.dart'
    as _i663;
import 'package:domain/src/usecase/photo/get_photo_by_query_usecase.dart'
    as _i458;
import 'package:domain/src/usecase/placemark/get_placemark_usecase.dart'
    as _i825;
import 'package:domain/src/usecase/user/create_user.dart' as _i936;
import 'package:domain/src/usecase/user/get_focused_country_code.dart' as _i563;
import 'package:domain/src/usecase/user/get_is_biometrics_enabled.dart'
    as _i924;
import 'package:domain/src/usecase/user/remove_stay_periods_by_country.dart'
    as _i692;
import 'package:domain/src/usecase/user/sync_countries_from_placemark.dart'
    as _i687;
import 'package:domain/src/usecase/user/toggle_biometrics.dart' as _i291;
import 'package:domain/src/usecase/user/update_stay_periods.dart' as _i718;
import 'package:injectable/injectable.dart' as _i526;

class DomainPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.factory<_i804.IsBiometricsSupportedUsecase>(
        () => _i804.IsBiometricsSupportedUsecase(gh<_i722.IAuthRepostory>()));
    gh.factory<_i750.StopAuthenticationUsecase>(
        () => _i750.StopAuthenticationUsecase(gh<_i722.IAuthRepostory>()));
    gh.factory<_i1071.AuthByBiometricsUsecase>(
        () => _i1071.AuthByBiometricsUsecase(gh<_i722.IAuthRepostory>()));
    gh.factory<_i1045.RequestGeoPermissionUsecase>(() =>
        _i1045.RequestGeoPermissionUsecase(gh<_i494.ICoordinatesRepository>()));
    gh.factory<_i306.GetCoordinatesUsecase>(
        () => _i306.GetCoordinatesUsecase(gh<_i494.ICoordinatesRepository>()));
    gh.factory<_i663.ChangeLanguageUsecase>(
        () => _i663.ChangeLanguageUsecase(gh<_i351.ILanguageRepository>()));
    gh.factory<_i291.ToggleBiometricsUsecase>(
        () => _i291.ToggleBiometricsUsecase(gh<_i868.IUserRepository>()));
    gh.factory<_i936.CreateUserUsecase>(
        () => _i936.CreateUserUsecase(gh<_i494.IUserRepository>()));
    gh.factory<_i692.RemoveStayPeriodsByCountryUsecase>(() =>
        _i692.RemoveStayPeriodsByCountryUsecase(gh<_i494.IUserRepository>()));
    gh.factory<_i718.UpdateStayPeriodsUsecase>(
        () => _i718.UpdateStayPeriodsUsecase(gh<_i494.IUserRepository>()));
    gh.factory<_i924.IsBiometricsEnabledUsecase>(
        () => _i924.IsBiometricsEnabledUsecase(gh<_i868.IUserRepository>()));
    gh.factory<_i563.GetFocusedCountryCodeUsecase>(
        () => _i563.GetFocusedCountryCodeUsecase(gh<_i494.IUserRepository>()));
    gh.factory<_i687.SyncCountriesFromGeoUseCase>(
        () => _i687.SyncCountriesFromGeoUseCase(gh<_i494.IUserRepository>()));
    gh.factory<_i458.GetPhotoByQueryUsecase>(
        () => _i458.GetPhotoByQueryUsecase(gh<_i494.PhotoRepository>()));
    gh.factory<_i825.GetPlacemarkUsecase>(
        () => _i825.GetPlacemarkUsecase(gh<_i494.IPlacemarkRepository>()));
  }
}
