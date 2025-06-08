// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:data/data.dart' as _i437;
import 'package:domain/domain.dart' as _i494;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:resident_live/screens/all_countries/cubit/remove_country_cubit.dart'
    as _i295;
import 'package:resident_live/screens/home/cubit/focus_on_country_cubit.dart'
    as _i339;
import 'package:resident_live/screens/home/cubit/home_cubit.dart' as _i866;
import 'package:resident_live/screens/map/cubit/country_bg_cubit.dart' as _i149;
import 'package:resident_live/screens/onboarding/cubit/onboarding_cubit.dart'
    as _i820;
import 'package:resident_live/screens/onboarding/pages/add_stay_periods/cubit/update_countries_cubit.dart'
    as _i444;
import 'package:resident_live/screens/onboarding/pages/get_started/cubit/get_started_cubit.dart'
    as _i74;
import 'package:resident_live/screens/residence_details/cubit/clear_focus_cubit.dart'
    as _i29;
import 'package:resident_live/screens/settings/cubit/auth_by_biometrics_cubit.dart'
    as _i913;
import 'package:resident_live/screens/settings/cubit/is_biometrics_supported_cubit.dart'
    as _i373;
import 'package:resident_live/screens/settings/cubit/stop_auth_cubit.dart'
    as _i656;
import 'package:resident_live/screens/settings/cubit/toggle_biometrics_cubit.dart'
    as _i927;
import 'package:resident_live/screens/splash/cubit/get_user_cubit.dart'
    as _i628;
import 'package:resident_live/screens/splash/cubit/sync_countries_from_geo_cubit.dart'
    as _i311;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    await _i437.DataPackageModule().init(gh);
    await _i494.DomainPackageModule().init(gh);
    gh.lazySingleton<_i820.OnboardingCubit>(() => _i820.OnboardingCubit());
    gh.lazySingleton<_i444.UpdateCountriesCubit>(
        () => _i444.UpdateCountriesCubit(gh<_i494.UpdateStayPeriodsUsecase>()));
    gh.lazySingleton<_i656.StopAuthCubit>(
        () => _i656.StopAuthCubit(gh<_i494.StopAuthenticationUsecase>()));
    gh.lazySingleton<_i913.AuthByBiometricsCubit>(
        () => _i913.AuthByBiometricsCubit(gh<_i494.AuthByBiometricsUsecase>()));
    gh.singleton<_i311.SyncCountriesFromGeoCubit>(() =>
        _i311.SyncCountriesFromGeoCubit(
            gh<_i494.SyncCountriesFromGeoUseCase>()));
    gh.lazySingleton<_i339.FocusOnCountryCubit>(
        () => _i339.FocusOnCountryCubit(gh<_i494.IUserRepository>()));
    gh.lazySingleton<_i29.ClearFocusCubit>(
        () => _i29.ClearFocusCubit(gh<_i494.IUserRepository>()));
    gh.factory<_i628.GetUserCubit>(
        () => _i628.GetUserCubit(gh<_i494.IUserRepository>()));
    gh.factory<_i149.CountryBackgroundCubit>(
        () => _i149.CountryBackgroundCubit(gh<_i494.GetPhotoByQueryUsecase>()));
    gh.lazySingleton<_i927.ToggleBiometricsCubit>(
        () => _i927.ToggleBiometricsCubit(
              toggleBiometrics: gh<_i494.ToggleBiometricsUsecase>(),
              authByBiometrics: gh<_i494.AuthByBiometricsUsecase>(),
              isBiometricsSupported: gh<_i494.IsBiometricsSupportedUsecase>(),
              stopAuthentication: gh<_i494.StopAuthenticationUsecase>(),
              isBiometricsEnabled: gh<_i494.IsBiometricsEnabledUsecase>(),
            ));
    gh.singleton<_i295.RemoveCountryCubit>(() => _i295.RemoveCountryCubit(
        gh<_i494.RemoveStayPeriodsByCountryUsecase>()));
    gh.lazySingleton<_i373.IsBiometricsSupportedCubit>(() =>
        _i373.IsBiometricsSupportedCubit(
            gh<_i494.IsBiometricsSupportedUsecase>()));
    gh.lazySingleton<_i74.GetStartedCubit>(() => _i74.GetStartedCubit(
          gh<_i494.RequestGeoPermissionUsecase>(),
          gh<_i494.GetCoordinatesUsecase>(),
          gh<_i494.GetPlacemarkUsecase>(),
          gh<_i494.SyncCountriesFromGeoUseCase>(),
        ));
    gh.lazySingleton<_i866.HomeCubit>(
        () => _i866.HomeCubit(gh<_i437.LocalNotificationService>()));
    return this;
  }
}
