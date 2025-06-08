import "package:domain/domain.dart";
import "package:injectable/injectable.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_cubit.dart";

@injectable
class GetUserCubit extends VoidResourceCubit<UserEntity> {
  GetUserCubit(IUserRepository repository) : super(() => repository.getUser());
}
