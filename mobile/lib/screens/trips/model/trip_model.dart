import "package:domain/domain.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "trip_model.freezed.dart";

@freezed
class TripModel with _$TripModel {
  const factory TripModel({
    required String countryCode,
    required DateTime fromDate,
    required DateTime toDate,
  }) = _TripModel;
}

extension TripModelMapper on TripModel {
  TripEntity toEntity() => TripEntity(
    countryCode: countryCode,
    fromDate: fromDate,
    toDate: toDate,
    id: countryCode + DateTime.now().millisecondsSinceEpoch.toString(),
  );

  int get days => toDate.difference(fromDate).inDays;
}
