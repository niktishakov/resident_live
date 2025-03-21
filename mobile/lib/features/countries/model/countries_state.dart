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
    String? focusedCountryId,
  }) = _CountriesState;

  const CountriesState._();

  factory CountriesState.fromJson(Map<String, dynamic> json) =>
      _$CountriesStateFromJson(json);

  factory CountriesState.initial() =>
      CountriesState(countries: {}, focusedCountryId: null);

  CountryEntity? get focusedCountry => countries[focusedCountryId];

  CountryEntity getCountryByName(String name) {
    return _getCountry(
        countries.values.firstWhereOrNull((e) => e.name == name), name,);
  }

  CountryEntity findLastVisitedCountry() {
    var lastVisitedCountry = countries.values.first;
    final countriesValues = countries.values;
    for (final country in countriesValues) {
      if (country.periods.last.endDate
          .isAfter(lastVisitedCountry.periods.last.endDate)) {
        lastVisitedCountry = country;
      }
    }

    return lastVisitedCountry;
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

  CountriesState reset() => copyWith(countries: {}, focusedCountryId: null);
}
