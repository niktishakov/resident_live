import "package:domain/domain.dart";
import "package:injectable/injectable.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_cubit.dart";

@lazySingleton
class AuthByBiometricsCubit extends VoidResourceCubit<bool> {
  AuthByBiometricsCubit(AuthByBiometricsUsecase usecase)
      : super(
          ([reason]) => usecase.call(localizedReason: reason),
          loadOnInit: false,
        );
}
