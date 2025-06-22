import "package:data/src/data_source/storage/trip_storage.dart";
import "package:domain/domain.dart";
import "package:injectable/injectable.dart";

@Injectable(as: TripRepository)
class TripRepositoryImpl implements TripRepository {
  TripRepositoryImpl(this._storage);
  final TripStorage _storage;

  @override
  Result<List<TripEntity>> getTrips() {
    final trips = _storage.getTrips();
    return Result.success(trips);
  }

  @override
  Future<Result> addTrip(TripEntity trip) async {
    await _storage.createTrip(trip);
    return Result.success(trip);
  }

  @override
  Future<Result> deleteTrip(String id) async {
    await _storage.deleteTrip(id);
    return Result.success(id);
  }

  @override
  Future<Result> updateTrip(TripEntity trip) async {
    await _storage.updateTrip(trip);
    return Result.success(trip);
  }
}
