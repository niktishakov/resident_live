import "package:domain/domain.dart";
import "package:injectable/injectable.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_cubit.dart";

@singleton
class CreateUserCubit extends VoidResourceCubit<UserEntity> {
  CreateUserCubit(IUserRepository repository)
      : super(
          () => repository.createUser(),
          loadOnInit: false,
        );
}
