import "package:domain/src/core/result.dart";
import "package:domain/src/entity/trip/trip_entity.dart";

abstract class TripRepository {
  Result<List<TripEntity>> getTrips();
  Future<Result> addTrip(TripEntity trip);
  Future<Result> updateTrip(TripEntity trip);
  Future<Result> deleteTrip(String id);
}
