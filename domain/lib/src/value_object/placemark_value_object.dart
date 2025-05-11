import "package:freezed_annotation/freezed_annotation.dart";

part "placemark_value_object.g.dart";
part "placemark_value_object.freezed.dart";

@freezed
class PlacemarkValueObject with _$PlacemarkValueObject {
  const factory PlacemarkValueObject({
    required String name,
    required String countryCode,
  }) = _PlacemarkValueObject;

  factory PlacemarkValueObject.fromJson(Map<String, dynamic> json) => _$PlacemarkValueObjectFromJson(json);
}
