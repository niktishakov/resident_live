import "package:data/injection.config.module.dart";
import "package:get_it/get_it.dart";
import "package:injectable/injectable.dart";

final getIt = GetIt.instance;

@InjectableInit(
  preferRelativeImports: true,
  externalPackageModulesBefore: [
    ExternalModule(DataPackageModule, scope: "data"),
  ],
)
void configureDependencies() => getIt.init();
