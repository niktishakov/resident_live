import "dart:async";

import "package:domain/domain.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:injectable/injectable.dart";

@injectable
class TripsStreamCubit extends Cubit<List<TripEntity>> {
  TripsStreamCubit(this._tripRepository) : super([]) {
    print("🎯 TripsStreamCubit init");
    _subscription = _tripRepository.getTripsStream().listen((trips) {
      print("📡 TripsStreamCubit received ${trips.length} trips");
      emit(trips);
    });
  }

  final TripRepository _tripRepository;
  StreamSubscription<List<TripEntity>>? _subscription;

  @override
  Future<void> close() {
    print("🔚 TripsStreamCubit closing");
    _subscription?.cancel();
    return super.close();
  }
}
