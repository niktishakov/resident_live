import "package:domain/domain.dart";
import "package:injectable/injectable.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_cubit.dart";

@lazySingleton
class IsBiometricsSupportedCubit extends VoidResourceCubit<bool> {
  IsBiometricsSupportedCubit(IsBiometricsSupportedUsecase usecase)
      : super(
          () => usecase.call(),
        );
}
