import "package:data/src/mapper/placemark_mapper.dart";
import "package:domain/domain.dart";
import "package:geocoding/geocoding.dart";
import "package:injectable/injectable.dart";

@Injectable(as: IPlacemarkRepository)
class PlacemarkRepository implements IPlacemarkRepository {
  @override
  Future<PlacemarkValueObject?> getPlacemark(CoordinatesValueObject coordinates) async {
    final placemarks = await GeocodingPlatform.instance?.placemarkFromCoordinates(
      coordinates.latitude,
      coordinates.longitude,
    );

    return placemarks?.firstOrNull?.toEntity();
  }
}
