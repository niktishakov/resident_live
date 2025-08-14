import "package:domain/src/core/result.dart";
import "package:domain/src/entity/trip/trip_entity.dart";

abstract class TripRepository {
  Future<Result<List<TripEntity>>> getTrips();
  Stream<List<TripEntity>> getTripsStream();
  Future<Result<TripEntity>> addTrip(TripEntity trip);
  Future<Result<TripEntity>> updateTrip(TripEntity trip);
  Future<Result<String>> deleteTrip(String id);
  Future<void> clearAllData();
}
