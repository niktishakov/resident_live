import "package:data/src/data_source/storage/trip_storage.dart";
import "package:domain/domain.dart";
import "package:injectable/injectable.dart";
import "package:rxdart/rxdart.dart";

@LazySingleton(as: TripRepository)
class TripRepositoryImpl implements TripRepository {
  TripRepositoryImpl(this._storage) {
    final initialTrips = _storage.getTrips();
    print("🚀 TripRepository init with ${initialTrips.length} trips");
    _tripsSubject = BehaviorSubject<List<TripEntity>>.seeded(initialTrips);
  }

  final TripStorage _storage;
  late final BehaviorSubject<List<TripEntity>> _tripsSubject;

  @override
  Future<Result<List<TripEntity>>> getTrips() async {
    final trips = _storage.getTrips();
    return Result.success(trips);
  }

  @override
  Stream<List<TripEntity>> getTripsStream() {
    print("🔄 getTripsStream called, current: ${_tripsSubject.value.length} trips");
    return _tripsSubject.stream;
  }

  @override
  Future<Result<TripEntity>> addTrip(TripEntity trip) async {
    print("➕ Adding trip: ${trip.id}");
    await _storage.createTrip(trip);
    final updatedTrips = _storage.getTrips();
    print("📝 Updated trips count: ${updatedTrips.length}");
    _tripsSubject.add(updatedTrips);
    return Result.success(trip);
  }

  @override
  Future<Result<String>> deleteTrip(String id) async {
    print("❌ Deleting trip: $id");
    await _storage.deleteTrip(id);
    final updatedTrips = _storage.getTrips();
    print("📝 Updated trips count after delete: ${updatedTrips.length}");
    _tripsSubject.add(updatedTrips);
    return Result.success(id);
  }

  @override
  Future<Result<TripEntity>> updateTrip(TripEntity trip) async {
    print("✏️ Updating trip: ${trip.id}");
    await _storage.updateTrip(trip);
    final updatedTrips = _storage.getTrips();
    print("📝 Updated trips count after update: ${updatedTrips.length}");
    _tripsSubject.add(updatedTrips);
    return Result.success(trip);
  }

  void dispose() {
    _tripsSubject.close();
  }

  @override
  Future<void> clearAllData() {
    return _storage.clearAll();
  }
}
