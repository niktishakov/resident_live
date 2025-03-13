import 'package:geolocator/geolocator.dart';
import 'package:resident_live/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GeolocationService {
  GeolocationService() {
    _initializeStream();
  }

  String? _initializeStream() {
    try {
      _positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).asBroadcastStream();

      if (_positionStream == null) {
        _logger.error('Position Stream is null');
        return 'Failed to initialize geolocator stream';
      }

      return null;
    } catch (e) {
      _logger.error('Failed to initialize geolocator stream: $e');
      return e.toString();
    }
  }

  // Remove singleton-related code
  Position? _currentPosition;
  Stream<Position>? _positionStream;
  static final _logger = AiLogger('GeolocationService');

  // Constants for storage
  static const String LAST_POSITION_KEY = 'last_position';
  static const String LAST_UPDATE_TIME_KEY = 'last_update_time';

  // Initialize method now just handles permissions
  Future<String?> initialize() async {
    try {
      await requestPermissions();
    } catch (e) {
      _logger.error('Failed to initialize geolocator service: $e');
      return e.toString();
    }
    return null;
  }

  // Method to request location permissions and get current position
  Future<void> requestPermissions() async {
    bool serviceEnabled;

    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _logger.error('Location services are disabled.');
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _logger.error('Location permissions are denied');
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _logger.error('Location permissions are permanently denied');
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.',);
    }

    // When permissions are granted, get the current position
    _currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _logger.info('Current position: $_currentPosition');
  }

  // Getter for the current position
  Position? get currentPosition => _currentPosition;

  // Getter for the position stream
  Stream<Position>? get positionStream => _positionStream;

  // Add method for background position update
  Future<void> updateBackgroundPosition() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _currentPosition = position;
      _logger.info('Background position update: $position');

      // Store position and timestamp in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(LAST_POSITION_KEY, position.toJson().toString());
      await prefs.setInt(
          LAST_UPDATE_TIME_KEY, DateTime.now().millisecondsSinceEpoch,);
    } catch (e) {
      _logger.error('Background position update failed: $e');
    }
  }

  // Add method to retrieve last stored position
  Future<Position?> getLastStoredPosition() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final positionStr = prefs.getString(LAST_POSITION_KEY);
      if (positionStr != null) {
        _logger.info('Last stored position: $positionStr');
        return Position.fromMap(json.decode(positionStr));
      }
    } catch (e) {
      _logger.error('Failed to get stored position: $e');
    }
    return null;
  }

  // Add method to get current position that we'll use in background tasks
  Future<Position> getCurrentPosition() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _currentPosition = position;
      return position;
    } catch (e) {
      _logger.error('Failed to get current position: $e');
      rethrow;
    }
  }
}
