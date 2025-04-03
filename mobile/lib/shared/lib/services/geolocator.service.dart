import 'package:geolocator/geolocator.dart';
import 'package:resident_live/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class GeolocationService {
  // Private constructor
  GeolocationService._privateConstructor();

  // The single instance of the service
  static final GeolocationService _instance =
      GeolocationService._privateConstructor();

  // Getter for the instance
  static GeolocationService get instance => _instance;

  // Current position
  Position? _currentPosition;

  // Stream to listen for position updates
  Stream<Position>? _positionStream;

  static final _logger = AiLogger('GeolocationService');

  // Add new fields
  static const String LAST_POSITION_KEY = 'last_position';
  static const String LAST_UPDATE_TIME_KEY = 'last_update_time';

  // Method to initialize the position stream
  String? initialize() {
    try {
      _positionStream = Geolocator.getPositionStream(
        locationSettings: LocationSettings(
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

  // Requesting permissions with dialog
  Future<void> requestPermissions(BuildContext context) async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return Future.error('Location services are disabled.');
    }

    var whenInUseStatus = await Permission.locationWhenInUse.status;
    if (!whenInUseStatus.isGranted) {
      whenInUseStatus = await Permission.locationWhenInUse.request();
      if (!whenInUseStatus.isGranted) {
        return Future.error('Location "When In Use" permission denied');
      }
    }

    // If "When In Use" is granted, show dialog for "Always"
    if (whenInUseStatus.isGranted) {
      bool userAgreed = await showAlwaysPermissionDialog(context);
      if (!userAgreed) {
        return Future.error('User did not agree to "Always" permission');
      }
    }

    // Request "Always" permission
    var alwaysStatus = await Permission.locationAlways.status;
    if (!alwaysStatus.isGranted) {
      alwaysStatus = await Permission.locationAlways.request();
      if (!alwaysStatus.isGranted) {
        return Future.error('Location "Always" permission denied');
      }
    }

    // Save the permission choice to preferences
    await _savePermissionChoice();

    // Get current position after permissions are granted
    _currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // Show dialog before requesting "Always" permission
  Future<bool> showAlwaysPermissionDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Включите 'Всегда'"),
        content: Text(
            "Чтобы отслеживать ваш статус налогового резидента, необходимо разрешить доступ к местоположению 'Всегда'.\n\nВы можете изменить этот параметр позже в настройках."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("Не сейчас"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("Разрешить"),
          ),
        ],
      ),
    );
  }

  // Save permission choice
  Future<void> _savePermissionChoice() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
        'location_allow_once', true); // Save 'Allow Once' choice
  }

  // Check and request permissions on app launch
  Future<void> checkAndRequestPermissionsOnLaunch(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    bool wasAllowOnce = prefs.getBool('location_allow_once') ?? false;

    // If 'Allow Once' was not selected, request permissions
    if (!wasAllowOnce) {
      await requestPermissions(context);
      return;
    }

    // If 'Always' permission is not granted, request it again
    var alwaysStatus = await Permission.locationAlways.status;
    if (!alwaysStatus.isGranted) {
      await requestPermissions(context);
    }
  }

  // Get current position
  Position? get currentPosition => _currentPosition;

  // Stream to get position updates
  Stream<Position>? get positionStream => _positionStream;

  // Update position in the background
  Future<void> updateBackgroundPosition() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    _currentPosition = position;
    _logger.info('Background position update: $position');

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(LAST_POSITION_KEY, json.encode(position.toJson()));
    await prefs.setInt(
      LAST_UPDATE_TIME_KEY,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  // Get last stored position
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
}
