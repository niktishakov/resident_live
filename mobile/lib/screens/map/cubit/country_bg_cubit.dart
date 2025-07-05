import "package:country_code_picker/country_code_picker.dart";
import "package:domain/domain.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:injectable/injectable.dart";

part "country_bg_cubit.freezed.dart";

@freezed
class CountryBackgroundState with _$CountryBackgroundState {
  const factory CountryBackgroundState.initial() = _Initial;
  const factory CountryBackgroundState.loading() = _Loading;
  const factory CountryBackgroundState.loaded(Map<String, String> countryImages) = _Loaded;
  const factory CountryBackgroundState.error(String message) = _Error;
}

@injectable
class CountryBackgroundCubit extends Cubit<CountryBackgroundState> {
  CountryBackgroundCubit(this._getRandomPhoto) : super(const CountryBackgroundState.initial());

  final GetRandomPhotoUsecase _getRandomPhoto;
  final Map<String, String> _cache = {};

  Future<void> loadCountryBackground(String countryCode) async {
    if (_cache.containsKey(countryCode)) {
      emit(CountryBackgroundState.loaded(_cache));
      return;
    }

    try {
      final photo = await _getRandomPhoto.call();
      _cache[countryCode] = photo.regular;
      emit(CountryBackgroundState.loaded(_cache));
    } catch (e) {
      emit(CountryBackgroundState.error(e.toString()));
    }
  }

  Future<void> refreshCountryBackground(String countryCode) async {
    emit(const CountryBackgroundState.loading());

    try {
      final countryName = CountryCode.fromCountryCode(countryCode).name ?? countryCode;
      final photo = await _getRandomPhoto(query: countryName);
      _cache[countryCode] = photo.regular;
      emit(CountryBackgroundState.loaded(_cache));
    } catch (e) {
      emit(CountryBackgroundState.error(e.toString()));
    }
  }

  Future<void> preloadCountryBackgrounds(List<String> countryCodes) async {
    emit(const CountryBackgroundState.loading());

    for (final code in countryCodes) {
      if (!_cache.containsKey(code)) {
        try {
          final countryName = CountryCode.fromCountryCode(code).name ?? code;
          final photo = await _getRandomPhoto(query: countryName);
          _cache[code] = photo.regular;
        } catch (e) {
          // Игнорируем ошибки при предзагрузке
          continue;
        }
      }
    }

    emit(CountryBackgroundState.loaded(_cache));
  }
}
