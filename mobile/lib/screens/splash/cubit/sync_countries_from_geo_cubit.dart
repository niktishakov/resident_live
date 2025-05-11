import "package:domain/domain.dart";
import "package:injectable/injectable.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_cubit.dart";

@singleton
class SyncCountriesFromGeoCubit extends ResourceCubit<UserEntity, PlacemarkValueObject?> {
  SyncCountriesFromGeoCubit(SyncCountriesFromGeoUseCase usecase)
      : super(
          ([placemark]) => usecase.call(placemark: placemark),
          loadOnInit: false,
        );
}
