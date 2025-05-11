import "package:domain/domain.dart";
import "package:geolocator/geolocator.dart";

extension CoordinatesMapper on Position {
  CoordinatesValueObject toEntity() => CoordinatesValueObject(
        latitude: latitude,
        longitude: longitude,
      );
}
