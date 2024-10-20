import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geocoding/geocoding.dart';

import 'package:collection/collection.dart';

import '../../../domain/domain.dart';

part 'countries_state.g.dart';
part 'countries_state.freezed.dart';

@freezed
class CountriesState with _$CountriesState {
  const factory CountriesState({
    required Map<String, CountryEntity> countries,
    CountryEntity? focusedCountry,
  }) = _CountriesState;

  const CountriesState._();

  factory CountriesState.fromJson(Map<String, dynamic> json) =>
      _$CountriesStateFromJson(json);

  factory CountriesState.initial() =>
      CountriesState(countries: {}, focusedCountry: null);

  CountryEntity getCountryByName(String name) {
    return _getCountry(
        countries.values.firstWhereOrNull((e) => e.name == name), name);
  }

  CountryEntity getCountryByPlacemark(Placemark country) {
    return _getCountry(
      countries[country.isoCountryCode],
      country.isoCountryCode ?? 'Unknown',
      country.country ?? 'Unknown',
    );
  }

  CountryEntity _getCountry(
    CountryEntity? countryResidence,
    String code, [
    String name = 'Unknown',
  ]) {
    return countryResidence ?? CountryEntity.initial(code, name);
  }

  CountriesState reset() => copyWith(countries: {}, focusedCountry: null);
}
