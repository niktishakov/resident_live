import "package:domain/domain.dart";
import "package:injectable/injectable.dart";
import "package:resident_live/screens/trips/model/trip_model.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_cubit.dart";

@injectable
class SaveTripCubit extends ResourceCubit<Result<TripEntity>, TripModel> {
  SaveTripCubit(TripRepository repository)
    : super(([trip]) => repository.addTrip(trip!.toEntity()), loadOnInit: false);
}
