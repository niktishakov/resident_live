import "package:domain/domain.dart";
import "package:injectable/injectable.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_cubit.dart";

@injectable
class DeleteTripCubit extends ResourceCubit<Result<void>, String> {
  DeleteTripCubit(TripRepository tripRepository)
    : super(([tripId]) => Future.value(tripRepository.deleteTrip(tripId!)), loadOnInit: false);
}
