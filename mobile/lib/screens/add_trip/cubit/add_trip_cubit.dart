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
  }) = _AddTripState;
}

@injectable
class AddTripCubit extends Cubit<AddTripState> {
  AddTripCubit(this._tripRepository)
    : super(
        AddTripState(
          trip: TripModel(countryCode: "", fromDate: DateTime.now(), toDate: DateTime.now()),
        ),
      );
  final TripRepository _tripRepository;

  Future<void> updateTripModel(TripModel trip) async {
    emit(state.copyWith(trip: trip));
  }

  Future<void> addTrip(TripModel trip) async {
    emit(state.copyWith(isLoading: true));
    final result = await _tripRepository.addTrip(trip.toEntity());
    result.when(
      success: (trip) => emit(state.copyWith(isLoading: false, isSuccess: true)),
      failure: (error) => emit(state.copyWith(isLoading: false, error: error)),
    );
  }
}
