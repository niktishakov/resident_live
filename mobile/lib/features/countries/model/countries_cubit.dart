import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:resident_live/shared/lib/ai.logger.dart';

import '../../../domain/domain.dart';
import 'countries_state.dart';

class CountriesCubit extends HydratedCubit<CountriesState> {
  CountriesCubit() : super(CountriesState.initial());

  static final AiLogger _logger = AiLogger('CountriesCubit');

  void addCountry(CountryEntity countryResidence) {
    emit(state.copyWith(
      countries: {
        ...state.countries,
        countryResidence.isoCode: countryResidence,
      },
    ));
  }

  void removeCountry(String isoCode) {
    final countries = Map<String, CountryEntity>.from(state.countries);
    countries.remove(isoCode);
    emit(state.copyWith(countries: countries));
  }

  void updateCountry(CountryEntity updatedCountry) {
    final countries = Map<String, CountryEntity>.from(state.countries);
    countries[updatedCountry.isoCode] = updatedCountry;
    emit(state.copyWith(countries: countries));
  }

  void updateCountries(Map<String, CountryEntity> countries) {
    emit(state.copyWith(countries: countries));
  }

  void reset() => emit(state.reset());

  @override
  CountriesState? fromJson(Map<String, dynamic> json) {
    try {
      return CountriesState.fromJson(json);
    } catch (e) {
      _logger.error('Error deserializing CountriesState: $e');
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(CountriesState state) {
    try {
      return state.toJson();
    } catch (e) {
      _logger.error('Error serializing CountriesState: $e');
      return null;
    }
  }
}
