import "package:data/data.dart";
import "package:data/src/service/logger.service.dart";
import "package:data/src/service/workmanager/background_loggger.dart";
import "package:data/src/service/workmanager/constants.dart";
import "package:data/src/service/workmanager/workmanager.errors.dart";
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

class WorkmanagerService {
  WorkmanagerService._();
  static WorkmanagerService? _instance;
  static WorkmanagerService get instance {
    if (_instance == null) {
      throw WorkmanagerNotInitializedError();
    }
    return _instance ?? (throw WorkmanagerInstanceError());
  }

  static Future<WorkmanagerService> initialize() async {
    _logger.info("Initializing WorkmanagerService");
    if (_instance != null) {
      _logger.info("Instance already exists, returning existing instance");
      return _instance ?? (throw WorkmanagerInstanceError());
    }

    _logger.info("Creating new WorkmanagerService instance");
    instance.geolocationService = GeolocationService();
    await instance._initialize();
    _instance = instance;

    _logger.info("WorkmanagerService initialization completed");
    return instance;
  }

  late final GeolocationService geolocationService;

  static final _logger = LoggerService("WorkmanagerService");

  bool isReady = false;

  Future<void> _initialize() async {
    _logger.info("Starting internal initialization");
    try {
      await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
      await Workmanager().registerPeriodicTask(
        WorkmanagerConstants.iOSBackgroundAppRefresh,
        WorkmanagerConstants.iOSBackgroundAppRefresh,
        initialDelay: const Duration(seconds: 10),
        inputData: const <String, dynamic>{},
      );
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
      await Workmanager().registerPeriodicTask(
        WorkmanagerConstants.iOSBackgroundAppRefresh,
        WorkmanagerConstants.iOSBackgroundAppRefresh,
        initialDelay: const Duration(seconds: 10),
        inputData: const <String, dynamic>{},
      );
      _logger.info("Periodic task registered successfully");
    } catch (e) {
      _logger.error("Failed to register periodic task: $e");
      rethrow;
    }
  }
}
