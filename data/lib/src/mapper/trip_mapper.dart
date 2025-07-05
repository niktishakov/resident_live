import "package:data/src/model/local/trip/trip_model.dart";
import "package:domain/domain.dart";

extension TripHiveModelMapper on TripHiveModel {
  TripEntity toEntity() => TripEntity(
    id: id,
    countryCode: countryCode,
    fromDate: fromDate,
    toDate: toDate,
    backgroundUrl: backgroundUrl,
  );
}

extension TripEntityMapper on TripEntity {
  TripHiveModel toModel() => TripHiveModel(
    id: id,
    countryCode: countryCode,
    fromDate: fromDate,
    toDate: toDate,
    backgroundUrl: backgroundUrl,
  );
}
