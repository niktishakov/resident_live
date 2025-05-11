import "package:domain/domain.dart";
import "package:injectable/injectable.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_cubit.dart";

@lazySingleton
class UpdateCountriesCubit extends ResourceCubit<UserEntity, List<StayPeriodValueObject>> {
  UpdateCountriesCubit(UpdateStayPeriodsUsecase repository)
      : super(
          ([stayPeriods]) => repository.call(stayPeriods!),
          loadOnInit: false,
        );
}
