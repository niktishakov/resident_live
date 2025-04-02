import "package:geocoding/geocoding.dart";
import "package:hydrated_bloc/hydrated_bloc.dart";
import "package:resident_live/domain/domain.dart";
import "package:resident_live/features/countries/model/countries_state.dart";
import "package:resident_live/shared/lib/ai.logger.dart";
import "package:resident_live/shared/shared.dart";

class CountriesCubit extends HydratedCubit<CountriesState> {
  CountriesCubit() : super(CountriesState.initial());

  static final AiLogger _logger = AiLogger("CountriesCubit");

  Future<void> syncCountriesByGeo(Placemark? placemark) async {
    if (placemark != null) {
      final countryCode = placemark.isoCountryCode;
      final countryName = placemark.country;

      if (countryCode == null || countryName == null) {
        _logger.error("Invalid placemark data - missing country code or name");
        return;
      }
      final lastVisitedCountry = state.findLastVisitedCountry();

      // Same country case
      if (lastVisitedCountry.isoCode == countryCode) {
        final periods = List<StayPeriod>.from(lastVisitedCountry.periods);
        final updatedPeriod =
            periods.removeLast().copyWith(endDate: DateTime.now());
        final updatedPeriods = [...periods, updatedPeriod];

        _logger.info("Still in $countryName - updating stay period end date");

        emit(state.copyWith(countries: {
          ...state.countries,
          lastVisitedCountry.isoCode:
              lastVisitedCountry.copyWith(periods: updatedPeriods),
        },),);
      }
      // New country case
      else {
        final newPeriod = StayPeriod(
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          country: countryCode,
        );

        final currentCountry = state.countries[countryCode] ??
            CountryEntity(
              isoCode: countryCode,
              name: countryName,
              periods: [],
            );

        final updatedPeriods = [...currentCountry.periods, newPeriod];
        final updatedCountry = currentCountry.copyWith(periods: updatedPeriods);

        _logger.info("Moved to new country: $countryName");

        emit(
          state.copyWith(
            countries: {
              ...state.countries,
              countryCode: updatedCountry,
            },
          ),
        );
      }
    } else {
      _logger.info("No location data - extending current stay period");

      final lastVisitedCountry = state.findLastVisitedCountry();
      final periods = List<StayPeriod>.from(lastVisitedCountry.periods);
      final updatedPeriod =
          periods.removeLast().copyWith(endDate: DateTime.now());
      final updatedPeriods = [...periods, updatedPeriod];
      emit(state.copyWith(countries: {
        ...state.countries,
        lastVisitedCountry.isoCode:
            lastVisitedCountry.copyWith(periods: updatedPeriods),
      },),);
    }
  }

  void reorderCountry(int oldIndex, int newIndex) {
    final countries =
        List<MapEntry<String, CountryEntity>>.from(state.countries.entries);

    final movedCountry = countries.removeAt(oldIndex);

    countries.insert(newIndex, movedCountry);

    emit(state.copyWith(
      countries: countries
          .asMap()
          .map((index, country) => MapEntry(country.key, country.value)),
    ),);
  }

  void addCountry(CountryEntity countryResidence) {
    emit(state.copyWith(
      countries: {
        ...state.countries,
        countryResidence.isoCode: countryResidence,
      },
    ),);
  }

  void removeCountry(String isoCode) {
    final countries = Map<String, CountryEntity>.from(state.countries);
    final removedCountry = countries.remove(isoCode);
    emit(state.copyWith(countries: countries));

    if (removedCountry == null) {
      _logger
          .error("Tried to remove non existing country with isoCode: $isoCode");
    }

    if (removedCountry?.isoCode == state.focusedCountry?.isoCode) {
      emit(state.copyWith(
          focusedCountryId: countries.values.firstOrNull?.isoCode,),);
    }
  }

  void updateCountry(CountryEntity updatedCountry) {
    final countries = Map<String, CountryEntity>.from(state.countries);
    countries[updatedCountry.isoCode] = updatedCountry;
    emit(state.copyWith(countries: countries));
  }

  void updateCountries(Map<String, CountryEntity> countries) {
    emit(state.copyWith(countries: countries));
  }

  void setFocusedCountryByIsoCode(String isoCode) {
    if (state.focusedCountry?.isoCode == isoCode) {
      emit(
          state.copyWith(focusedCountryId: null),); // Unfocus if already focused
    } else {
      final focusedCountry = state.countries[isoCode];
      if (focusedCountry == null) {
        _logger.error("Cannot focus on country: $isoCode");
        return;
      }

      emit(state.copyWith(focusedCountryId: focusedCountry.isoCode));
    }
  }

  void setFocusedCountry(CountryEntity country) {
    emit(state.copyWith(focusedCountryId: country.isoCode));
  }

  void reset() => emit(state.reset());

  @override
  CountriesState? fromJson(Map<String, dynamic> json) {
    try {
      return CountriesState.fromJson(json);
    } catch (e) {
      _logger.error("Error deserializing CountriesState: $e");
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(CountriesState state) {
    try {
      return state.toJson();
    } catch (e) {
      _logger.error("Error serializing CountriesState: $e");
      return null;
    }
  }
}
