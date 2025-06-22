import "package:freezed_annotation/freezed_annotation.dart";

part "trip_entity.g.dart";
part "trip_entity.freezed.dart";

@freezed
class TripEntity with _$TripEntity {
  const factory TripEntity({
    required String id,
    required String countryCode,
    required DateTime fromDate,
    required DateTime toDate,
  }) = _TripEntity;

  const TripEntity._();
  factory TripEntity.fromJson(Map<String, dynamic> json) => _$TripEntityFromJson(json);

  int get days => toDate.difference(fromDate).inDays;
}
