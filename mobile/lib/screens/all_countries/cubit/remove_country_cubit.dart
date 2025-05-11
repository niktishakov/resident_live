import "package:domain/domain.dart";
import "package:injectable/injectable.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_cubit.dart";

@singleton
class RemoveCountryCubit extends ResourceCubit<UserEntity, String> {
  RemoveCountryCubit(RemoveStayPeriodsByCountryUsecase usecase)
      : super(
          ([countryCode]) => usecase.call(countryCode!),
          loadOnInit: false,
        );
}
