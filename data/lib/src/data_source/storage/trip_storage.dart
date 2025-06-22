import "package:data/src/mapper/trip_mapper.dart";
import "package:data/src/model/local/trip/trip_model.dart";
import "package:domain/domain.dart";
import "package:hive/hive.dart";
import "package:injectable/injectable.dart";

@injectable
class TripStorage {
  TripStorage(this._storage);
  final Box<TripHiveModel> _storage;

  Future<void> createTrip(TripEntity trip) async {
    if (_storage.isOpen == false) {
      throw Exception("Trip storage is not open");
    }
    await _storage.put(trip.id, trip.toModel());
  }

  List<TripEntity> getTrips() {
    return _storage.values.map((trip) => trip.toEntity()).toList();
  }

  Future<void> updateTrip(TripEntity trip) {
    return _storage.put(trip.id, trip.toModel());
  }

  Future<void> deleteTrip(String id) {
    return _storage.delete(id);
  }
}
