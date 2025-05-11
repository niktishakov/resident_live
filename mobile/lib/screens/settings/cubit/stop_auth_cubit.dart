import "package:domain/domain.dart";
import "package:injectable/injectable.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_cubit.dart";

@lazySingleton
class StopAuthCubit extends VoidResourceCubit<bool> {
  StopAuthCubit(StopAuthenticationUsecase usecase)
      : super(
          ([reason]) => usecase.call(),
          loadOnInit: false,
        );
}
