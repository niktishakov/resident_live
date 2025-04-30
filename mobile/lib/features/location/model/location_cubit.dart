import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:geocoding/geocoding.dart";
import "package:geolocator/geolocator.dart";
import "package:resident_live/shared/lib/ai.logger.dart";
import "package:resident_live/shared/lib/services/geolocator.service.dart";

part "location_cubit.freezed.dart";
part "location_cubit.g.dart";

@freezed
class LocationState with _$LocationState {
  const factory LocationState({
    @JsonKey(includeFromJson: false, includeToJson: false) Position? position,
    @JsonKey(includeFromJson: false, includeToJson: false) Placemark? placemark,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(false)
    bool isInitialized,
    @Default("") String error,
  }) = _LocationState;

  factory LocationState.fromJson(Map<String, dynamic> json) =>
      _$LocationStateFromJson(json);

  const LocationState._();

  LocationState reset() => copyWith(position: null, placemark: null);
  LocationState failure(String error) => copyWith(error: error);

  bool isCurrentResidence(String isoCode) {
    return placemark?.isoCountryCode == isoCode;
  }
}

class LocationCubit extends Cubit<LocationState> {
  LocationCubit(this._locationService)
      : super(
          LocationState(
            position: Position.fromMap({"latitude": 0.0, "longitude": 0.0}),
            placemark: const Placemark(),
          ),
        );

  final GeolocationService _locationService;
  static final AiLogger _logger = AiLogger("LocationCubit");

  Future<void> initialize(BuildContext context) async {
    try {
      final position = await _locationService.getCurrentLocation();
      await _updatePosition(position);
        } catch (e) {
      _logger.error(e);
      emit(state.failure(e.toString()));
    }
  }

  Future<void> updateLocation() async {
    try {
      final position = await _locationService.getCurrentLocation();
      await _updatePosition(position);
        } catch (e) {
      _logger.error("Error updating location: $e");
      emit(state.failure(e.toString()));
    }
  }

  Future<void> _updatePosition(Position position) async {
    try {
      final coordinates = await GeocodingPlatform.instance
          ?.placemarkFromCoordinates(position.latitude, position.longitude);

      final addresses = coordinates ?? [];

      if (addresses.isNotEmpty) {
        final placemark = addresses.first;
        emit(
          state.copyWith(
            position: position,
            placemark: placemark,
            isInitialized: true,
          ),
        );
      }
    } catch (e) {
      _logger.error(e);
      emit(state.failure(e.toString()));
    }
  }

  void reset() => emit(state.reset());
}
