import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:resident_live/features/features.dart";

// Define the state
class GetStartedState extends Equatable {
  const GetStartedState({
    this.focusedCountryIndex = -1,
    this.isGeoPermissionAllowed = false,
    this.isGetStartedTriggered = false,
  });
  final int focusedCountryIndex;
  final bool isGeoPermissionAllowed;
  final bool isGetStartedTriggered;

  GetStartedState copyWith({
    int? focusedCountryIndex,
    bool? isGeoPermissionAllowed,
    bool? isGetStartedTriggered,
  }) {
    return GetStartedState(
      focusedCountryIndex: focusedCountryIndex ?? this.focusedCountryIndex,
      isGeoPermissionAllowed:
          isGeoPermissionAllowed ?? this.isGeoPermissionAllowed,
      isGetStartedTriggered:
          isGetStartedTriggered ?? this.isGetStartedTriggered,
    );
  }

  @override
  List<Object?> get props =>
      [focusedCountryIndex, isGeoPermissionAllowed, isGetStartedTriggered];
}

// Define the cubit
class GetStartedCubit extends Cubit<GetStartedState> {

  GetStartedCubit(this._locationCubit) : super(const GetStartedState());
  final LocationCubit _locationCubit;

  void setFocusedCountry(int index) {
    emit(state.copyWith(focusedCountryIndex: index));
  }

  Future<void> requestGeoPermission() async {
    await _locationCubit.initialize();
    emit(
      state.copyWith(
        isGeoPermissionAllowed: _locationCubit.state.isInitialized,
      ),
    );
  }

  void triggerGetStarted() {
    emit(state.copyWith(isGetStartedTriggered: true));
  }

  void reset() {
    emit(state.copyWith(
      isGeoPermissionAllowed: false,
      isGetStartedTriggered: false,
      focusedCountryIndex: -1,
    ),);
  }
}
