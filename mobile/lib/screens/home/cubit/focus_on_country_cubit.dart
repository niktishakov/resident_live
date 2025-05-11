import "package:domain/domain.dart";
import "package:injectable/injectable.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_cubit.dart";

@lazySingleton
class FocusOnCountryCubit extends ResourceCubit<UserEntity, String> {
  FocusOnCountryCubit(IUserRepository repository)
      : super(
          ([countryCode]) => repository.focusOnCountry(countryCode!),
          loadOnInit: false,
        );
}
