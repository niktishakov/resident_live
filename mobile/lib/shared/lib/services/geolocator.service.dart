import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class GeolocationService {
  GeolocationService._();

  static final GeolocationService _instance = GeolocationService._();
  static GeolocationService get instance => _instance;

  Future<Position> getCurrentLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('Location services are disabled');
    }

    final permission = await Permission.locationWhenInUse.request();
    if (!permission.isGranted) {
      throw Exception('Location permission denied');
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
