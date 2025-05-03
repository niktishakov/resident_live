import "package:data/data.dart";
import "package:get_it/get_it.dart";
import "package:injectable/injectable.dart";
import "package:resident_live/app/injection.config.config.dart";

final getIt = GetIt.instance;

@InjectableInit(
  externalPackageModulesBefore: [
    ExternalModule(DataPackageModule),
  ],
)
Future<void> configureDependencies() => getIt.init();
