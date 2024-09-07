import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:resident_live/core/ai.logger.dart';
import 'package:resident_live/services/geolocator.service.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit(this._locationService) : super(LocationInitial()) {
    _initCompleter = Completer();
  }

  final GeolocationService _locationService;
  static final AiLogger _logger = AiLogger('LocationCubit');
  late Completer<void> _initCompleter;

  Future<void> initialize() async {
    try {
      await _locationService.requestPermissions();
      final result = _locationService.initialize();
      if (result == null) {
        _initCompleter.complete();
        _locationService.positionStream?.listen(_updatePosition);
        emit(LocationReady());
      } else {
        _initCompleter.completeError(result);
        emit(LocationError(result));
      }
    } catch (e) {
      _logger.error(e);
      _initCompleter.completeError(e);
      emit(LocationError(e.toString()));
    }
  }

  Future<void> updateLocation() async {
    try {
      await _initCompleter.future;
      final position = _locationService.currentPosition;
      if (position != null) {
        await _updatePosition(position);
      } else {
        _logger.error("Failed to update location - current position is null");
        emit(LocationError("Current position is null"));
      }
    } catch (e) {
      _logger.error("Error updating location: $e");
      emit(LocationError(e.toString()));
    }
  }

  Future<void> _updatePosition(Position position) async {
    try {
      final coordinates = await GeocodingPlatform.instance
          ?.placemarkFromCoordinates(position.latitude, position.longitude);
      final addresses = coordinates ?? [];

      if (addresses.isNotEmpty) {
        final placemark = addresses.first;
        emit(LocationUpdated(position: position, placemark: placemark));
      }
    } catch (e) {
      _logger.error(e);
      emit(LocationError(e.toString()));
    }
  }
}

abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationReady extends LocationState {}

class LocationUpdated extends LocationState {
  final Position position;
  final Placemark placemark;

  LocationUpdated({required this.position, required this.placemark});
}

class LocationError extends LocationState {
  final String error;

  LocationError(this.error);
}
