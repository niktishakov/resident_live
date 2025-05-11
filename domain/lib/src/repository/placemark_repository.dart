import "package:domain/domain.dart";

abstract interface class IPlacemarkRepository {
  Future<PlacemarkValueObject?> getPlacemark(CoordinatesValueObject coordinates);
}
