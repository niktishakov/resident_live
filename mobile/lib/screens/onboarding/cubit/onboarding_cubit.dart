import "package:flutter_bloc/flutter_bloc.dart";
import "package:injectable/injectable.dart";

class OnboardingState {
  OnboardingState({
    this.selectedCountries = const [],
  });

  List<String> selectedCountries;

  OnboardingState copyWith(List<String>? selectedCountries) {
    return OnboardingState(
      selectedCountries: selectedCountries ?? this.selectedCountries,
    );
  }
}

@lazySingleton
class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingState());

  void addCountry(String? country) {
    if (country == null) return;

    if (!state.selectedCountries.contains(country)) {
      emit(state.copyWith([...state.selectedCountries, country]));
    }
  }

  void removeCountry(String? country) {
    if (country == null) return;

    if (state.selectedCountries.contains(country)) {
      final countries = [...state.selectedCountries];
      countries.remove(country);
      emit(state.copyWith(countries));
    }
  }

  void reset() {
    emit(state.copyWith([]));
  }
}
