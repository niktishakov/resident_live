import "package:freezed_annotation/freezed_annotation.dart";

part "coordinates_value_object.g.dart";
part "coordinates_value_object.freezed.dart";

@freezed
class CoordinatesValueObject with _$CoordinatesValueObject {
  const factory CoordinatesValueObject({
    required double latitude,
    required double longitude,
  }) = _CoordinatesValueObject;

  factory CoordinatesValueObject.fromJson(Map<String, dynamic> json) => _$CoordinatesValueObjectFromJson(json);
}
