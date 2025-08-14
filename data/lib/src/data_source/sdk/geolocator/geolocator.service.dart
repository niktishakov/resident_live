import "package:geolocator/geolocator.dart";
import "package:injectable/injectable.dart";

@injectable
class GeolocationService {
  GeolocationService();

  Future getCurrentLocation() async {
    try {
      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!isServiceEnabled) {
        throw Exception("Location services are disabled");
      }

      final permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception("Location permission not granted: $permission");
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      return position;
    } catch (e, stack) {
      print("[BG] ERROR in getCurrentLocation: $e\n$stack");
      rethrow;
    }
  }
}
