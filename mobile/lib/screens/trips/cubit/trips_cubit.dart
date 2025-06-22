import "package:domain/domain.dart";
import "package:injectable/injectable.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_cubit.dart";

@lazySingleton
class TripsCubit extends VoidResourceCubit<Result<List<TripEntity>>> {
  TripsCubit(TripRepository tripRepository)
    : super(([_]) => Future.value(tripRepository.getTrips()));
}
