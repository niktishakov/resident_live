import "package:geolocator/geolocator.dart";
import "package:permission_handler/permission_handler.dart";
import 'package:injectable/injectable.dart';

@injectable
class GeolocationService {
  GeolocationService();

  Future<Position> getCurrentLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception("Location services are disabled");
    }

    final permission = await Permission.locationWhenInUse.request();
    if (!permission.isGranted) {
      throw Exception("Location permission denied");
    }

    return Geolocator.getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.high));
  }
}
