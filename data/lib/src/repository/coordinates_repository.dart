import 'package:domain/domain.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

@Injectable(as: ICoordinatesRepository)
class CoordinatesRepository implements ICoordinatesRepository {
  @override
  Future<bool> requestPermission() async {
    final permission = await Permission.locationWhenInUse.request();
    return permission.isGranted;
  }

  @override
  Future<CoordinatesValueObject> getCoordinates() async {
    final position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    );
    return CoordinatesValueObject(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }
}
