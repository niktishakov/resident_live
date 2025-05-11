import "package:domain/domain.dart";
import "package:injectable/injectable.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_cubit.dart";

@singleton
class GetUserCubit extends ResourceCubit<UserEntity, String> {
  GetUserCubit(IUserRepository repository)
      : super(
          ([userId]) => repository.getUser(),
        );
}
