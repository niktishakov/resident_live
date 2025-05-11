import "package:domain/domain.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_cubit.dart";

class FocusOnCountryCubit extends ResourceCubit<UserEntity, String> {
  FocusOnCountryCubit(IUserRepository repository)
      : super(
          ([countryCode]) => repository.focusOnCountry(countryCode!),
          loadOnInit: false,
        );
}
