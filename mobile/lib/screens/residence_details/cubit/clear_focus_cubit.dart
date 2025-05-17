import "package:domain/domain.dart";
import "package:injectable/injectable.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_cubit.dart";

@lazySingleton
class ClearFocusCubit extends VoidResourceCubit<UserEntity> {
  ClearFocusCubit(IUserRepository repository)
      : super(
          () => repository.focusOnCountry(""),
          loadOnInit: false,
        );
}
