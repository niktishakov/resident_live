import "package:domain/domain.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:injectable/injectable.dart";
import "package:resident_live/screens/trips/model/trip_model.dart";

part "add_trip_cubit.freezed.dart";

@freezed
class AddTripState with _$AddTripState {
  const factory AddTripState({
    required TripModel trip,
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    @Default("") String error,
    @Default("") String validationError,
    @Default(false) bool isEditMode, // Add edit mode flag
  }) = _AddTripState;
}

@injectable
class AddTripCubit extends Cubit<AddTripState> {
  AddTripCubit(this._tripRepository)
    : super(
        AddTripState(
          trip: TripModel(
            countryCode: "",
            fromDate: DateTime.now(),
            toDate: DateTime.now().add(const Duration(days: 7)),
            backgroundUrl: null,
          ),
        ),
      );
  final TripRepository _tripRepository;

  void initializeWithTrip(TripEntity? existingTrip) {
    if (existingTrip != null) {
      emit(state.copyWith(trip: TripModel.fromEntity(existingTrip), isEditMode: true));
    }
  }

  Future<void> updateTripModel(TripModel trip) async {
    emit(state.copyWith(trip: trip, validationError: trip.validationError ?? ""));
  }

  bool canProceedToValidation() {
    final isValid = state.trip.isValid;
    if (!isValid) {
      emit(state.copyWith(validationError: state.trip.validationError ?? ""));
    }
    return isValid;
  }

  Future<void> saveTrip(TripModel trip) async {
    if (!trip.isValid) {
      emit(state.copyWith(validationError: trip.validationError ?? "Invalid trip data"));
      return;
    }

    emit(state.copyWith(isLoading: true, validationError: "", error: ""));

    final result = state.isEditMode
        ? await _tripRepository.updateTrip(trip.toEntity())
        : await _tripRepository.addTrip(trip.toEntity());

    result.when(
      success: (trip) => emit(state.copyWith(isSuccess: true, isLoading: false)),
      failure: (error) => emit(state.copyWith(error: error, isSuccess: false, isLoading: false)),
    );
  }

  // Keep the old method for backward compatibility
  Future<void> addTrip(TripModel trip) async => saveTrip(trip);

  void clearErrors() {
    emit(state.copyWith(validationError: "", error: ""));
  }
}
