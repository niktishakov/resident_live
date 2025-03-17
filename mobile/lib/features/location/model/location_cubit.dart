import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:resident_live/shared/lib/ai.logger.dart';
import 'package:resident_live/shared/lib/services/geolocator.service.dart';

import 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit(this._locationService)
      : super(LocationState(
          position: Position.fromMap({'latitude': 0.0, 'longitude': 0.0}),
          placemark: Placemark(),
        ),);

  final GeolocationService _locationService;
  static final AiLogger _logger = AiLogger('LocationCubit');

  Future<void> initialize() async {
    try {
      await _locationService.requestPermissions();
      final result = _locationService.initialize();
      if (result == null) {
        emit(state.copyWith(isInitialized: true));
        _locationService.positionStream?.listen(_updatePosition);
      } else {
        emit(state.failure(result));
      }
    } catch (e) {
      _logger.error(e);
      emit(state.failure(e.toString()));
    }
  }

  Future<void> updateLocation() async {
    try {
      final position = _locationService.currentPosition;
      if (position != null) {
        await _updatePosition(position);
      } else {
        _logger.error('Failed to update location - current position is null');
        emit(state.failure('Current position is null'));
      }
    } catch (e) {
      _logger.error('Error updating location: $e');
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
        emit(state.copyWith(position: position, placemark: placemark));
      }
    } catch (e) {
      _logger.error(e);
      emit(state.failure(e.toString()));
    }
  }

  void reset() => emit(state.reset());
}
