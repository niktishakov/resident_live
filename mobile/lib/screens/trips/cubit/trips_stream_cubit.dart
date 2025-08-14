import "dart:async";

import "package:domain/domain.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:injectable/injectable.dart";

@injectable
class TripsStreamCubit extends Cubit<List<TripEntity>> {
  TripsStreamCubit(this._tripRepository) : super([]) {
    _subscription = _tripRepository.getTripsStream().listen(emit);
  }

  final TripRepository _tripRepository;
  StreamSubscription<List<TripEntity>>? _subscription;

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
