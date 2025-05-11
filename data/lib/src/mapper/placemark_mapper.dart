import "package:domain/domain.dart";
import "package:geocoding/geocoding.dart";

extension PlacemarkMapper on Placemark {
  PlacemarkValueObject toEntity() => PlacemarkValueObject(
        name: name ?? "",
        countryCode: isoCountryCode ?? "",
      );
}
