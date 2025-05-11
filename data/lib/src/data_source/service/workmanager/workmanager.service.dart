import "package:data/data.dart";
import "package:data/src/data_source/service/workmanager/background_loggger.dart";
import "package:data/src/data_source/service/workmanager/constants.dart";
import "package:data/src/data_source/service/workmanager/workmanager.errors.dart";
import "package:injectable/injectable.dart";
import "package:workmanager/workmanager.dart";

@pragma("vm:entry-point")
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      final logger = BackgroundLogger();
      try {
        logger.debug("Native called background task: $task");
        logger.debug("Task input data: $inputData");
        logger.debug("Initializing GeolocationService for background task");

        final position = await GeolocationService().getCurrentLocation();
        // 1. положить новые координаты в shared_preferences в конце списка
        // 2. при запуске приложения вызывать юзкейс sync_countries_from_background_process_usecase

        logger.debug("Updating background position: ${position.toJson()}");
        logger.debug("Background location task completed successfully");
      } catch (e) {
        logger.error("Background location task failed: $e");
        return Future.value(false);
      }

      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  });
}

@injectable
class WorkmanagerService {
  WorkmanagerService(this._logger);
  final LoggerService _logger;
  bool isReady = false;

  Future<void> initialize() async {
    _logger.info("Starting internal initialization");
    try {
      await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
      await Workmanager().registerPeriodicTask(WorkmanagerConstants.iOSBackgroundAppRefresh, WorkmanagerConstants.iOSBackgroundAppRefresh,
          initialDelay: const Duration(seconds: 10), inputData: const <String, dynamic>{});
      isReady = true;
      _logger.info("Internal initialization completed successfully");
    } catch (e) {
      _logger.error("Workmanager initialization failed: $e");
      rethrow;
    }
  }

  Future<void> registerPeriodicTask() async {
    _logger.info("Attempting to register periodic task");
    if (!isReady) {
      _logger.error("WorkmanagerService not ready");
      throw WorkmanagerNotReadyError();
    }

    try {
      _logger.info("Registering periodic task: ${WorkmanagerConstants.iOSBackgroundAppRefresh}");
      await Workmanager().registerPeriodicTask(WorkmanagerConstants.iOSBackgroundAppRefresh, WorkmanagerConstants.iOSBackgroundAppRefresh,
          initialDelay: const Duration(seconds: 10), inputData: const <String, dynamic>{});
      _logger.info("Periodic task registered successfully");
    } catch (e) {
      _logger.error("Failed to register periodic task: $e");
      rethrow;
    }
  }
}
