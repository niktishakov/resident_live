import "package:domain/domain.dart";

abstract class ICoordinatesRepository {
  Future<bool> requestPermission();

  Future<CoordinatesValueObject> getCoordinates();
}
