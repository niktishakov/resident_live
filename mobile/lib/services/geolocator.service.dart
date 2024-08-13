import 'package:geolocator/geolocator.dart';

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

  // Method to initialize the position stream
  void initialize() {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).asBroadcastStream();
  }

  // Method to request location permissions and get current position

  Future<void> requestPermissions() async {
    bool serviceEnabled;

    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When permissions are granted, get the current position
    _currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // Getter for the current position
  Position? get currentPosition => _currentPosition;

  // Getter for the position stream
  Stream<Position>? get positionStream => _positionStream;
}
