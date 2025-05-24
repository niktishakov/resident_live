import "package:domain/domain.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:injectable/injectable.dart";

part "get_started_cubit.freezed.dart";
part "get_started_cubit.g.dart";

@freezed
class GetStartedState with _$GetStartedState {
  const factory GetStartedState({
    @Default(-1) int focusedCountryIndex,
    @Default(false) bool isGeoPermissionAllowed,
    @Default(false) bool isGetStartedTriggered,
    @Default("") String focusedCountryError,
    @Default("") String getPlacemarkError,
  }) = _GetStartedState;

  factory GetStartedState.fromJson(dynamic json) => _$GetStartedStateFromJson(json);
}

@lazySingleton
class GetStartedCubit extends Cubit<GetStartedState> {
  GetStartedCubit(
    this._requestGeoPermissionUsecase,
    this._getCoordinatesUsecase,
    this._getPlacemarkUsecase,
    this._syncCountriesFromGeoUsecase,
  ) : super(const GetStartedState());

  final RequestGeoPermissionUsecase _requestGeoPermissionUsecase;
  final GetCoordinatesUsecase _getCoordinatesUsecase;
  final GetPlacemarkUsecase _getPlacemarkUsecase;
  final SyncCountriesFromGeoUseCase _syncCountriesFromGeoUsecase;

  void setFocusedCountry(int index) {
    emit(state.copyWith(focusedCountryIndex: index));
  }

  Future<void> triggerGeoPermission() async {
    try {
      print("triggerGeoPermission");
      final isPermissionAllowed = await _requestGeoPermissionUsecase.call();
      if (!isPermissionAllowed) {
        emit(state.copyWith(focusedCountryError: "Permission not allowed"));
        return;
      }
      final coordinates = await _getCoordinatesUsecase.call();
      final placemark = await _getPlacemarkUsecase.call(coordinates);
      await _syncCountriesFromGeoUsecase.call(placemark: placemark);
      print("triggerGeoPermission success");
      emit(state.copyWith(isGeoPermissionAllowed: true));
    } catch (e) {
      print("triggerGeoPermission error: $e");
      emit(state.copyWith(focusedCountryError: e.toString()));
    }
  }

  void triggerGetStarted() {
    emit(state.copyWith(isGetStartedTriggered: true));
  }

  void reset() {
    emit(
      state.copyWith(
        isGeoPermissionAllowed: false,
        isGetStartedTriggered: false,
        focusedCountryIndex: -1,
      ),
    );
  }
}
