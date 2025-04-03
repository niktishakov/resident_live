import 'package:resident_live/shared/lib/utils/log_utils.dart';
import 'package:resident_live/shared/shared.dart';
import 'package:workmanager/workmanager.dart';
import 'constants.dart';
import 'workmanager.errors.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await LogUtils.writeToLog('Native called background task: $task');
      await LogUtils.writeToLog('Task input data: $inputData');
      await LogUtils.writeToLog(
          'Initializing GeolocationService for background task');

      GeolocationService.instance.initialize();

      await LogUtils.writeToLog('Updating background position');

      await GeolocationService.instance.updateBackgroundPosition();

      await LogUtils.writeToLog(
          'Background location task completed successfully');
    } catch (e) {
      await LogUtils.writeToLog('Background location task failed: $e', 'ERROR');

      return Future.value(false);
    }

    return Future.value(true);
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
    _logger.info('Initializing WorkmanagerService');
    if (_instance != null) {
      _logger.info('Instance already exists, returning existing instance');
      return _instance ?? (throw WorkmanagerInstanceError());
    }

    _logger.info('Creating new WorkmanagerService instance');
    final instance = WorkmanagerService._();
    instance.geolocationService = GeolocationService.instance;
    await instance._initialize();
    _instance = instance;

    _logger.info('WorkmanagerService initialization completed');
    return instance;
  }

  late final GeolocationService geolocationService;

  static final _logger = AiLogger('WorkmanagerService');

  bool isReady = false;

  Future<void> _initialize() async {
    _logger.info('Starting internal initialization');
    try {
      await Workmanager().initialize(
        callbackDispatcher,
        isInDebugMode: true,
      );
      await Workmanager().registerPeriodicTask(
        WorkmanagerConstants.iOSBackgroundAppRefresh,
        WorkmanagerConstants.iOSBackgroundAppRefresh,
        initialDelay: const Duration(seconds: 10),
        inputData: const <String, dynamic>{},
      );
      isReady = true;
      _logger.info('Internal initialization completed successfully');
    } catch (e) {
      _logger.error('Workmanager initialization failed: $e');
      rethrow;
    }
  }

  Future<void> registerPeriodicTask() async {
    _logger.info('Attempting to register periodic task');
    if (!isReady) {
      _logger.error('WorkmanagerService not ready');
      throw WorkmanagerNotReadyError();
    }

    try {
      _logger.info(
        'Registering periodic task: ${WorkmanagerConstants.iOSBackgroundAppRefresh}',
      );
      await Workmanager().registerPeriodicTask(
        WorkmanagerConstants.iOSBackgroundAppRefresh,
        WorkmanagerConstants.iOSBackgroundAppRefresh,
        initialDelay: const Duration(seconds: 10),
        inputData: const <String, dynamic>{},
      );
      _logger.info('Periodic task registered successfully');
    } catch (e) {
      _logger.error('Failed to register periodic task: $e');
      rethrow;
    }
  }
}
