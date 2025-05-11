import "package:domain/domain.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_cubit.dart";

class ClearFocusCubit extends VoidResourceCubit<UserEntity> {
  ClearFocusCubit(IUserRepository repository)
      : super(
          () => repository.focusOnCountry(""),
          loadOnInit: false,
        );
}
