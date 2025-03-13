import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:resident_live/shared/lib/ai.logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    stderr.writeln("The iOS background fetch was triggered");
    AiLogger("WorkmanagerService").debug('Background fetch triggered');
    bool success = true;
    return Future.value(success);
  });
}

class WorkmanagerService {
  static Future<void> initialize() async {
    try {
      await Workmanager().initialize(
        callbackDispatcher,
        isInDebugMode: true,
      );
      AiLogger("WorkmanagerService").debug('Initialized');
    } catch (e) {
      AiLogger("WorkmanagerService").error('Error initializing: $e');
    }
  }

  static Future<void> scheduleBackgroundTask() async {
    const iOSBackgroundAppRefresh =
        'be.tramckrijte.workmanagerExample.iOSBackgroundAppRefresh';

    final status = await Permission.backgroundRefresh.status;
    if (status != PermissionStatus.granted) {
      AiLogger('WorkmanagerService').error('Permission not granted');
      return;
    }

    try {
      await Workmanager().registerPeriodicTask(
        iOSBackgroundAppRefresh,
        iOSBackgroundAppRefresh,
        frequency: const Duration(minutes: 15),
        constraints: Constraints(
          networkType: NetworkType.not_required,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresDeviceIdle: false,
        ),
        backoffPolicy: BackoffPolicy.linear,
        existingWorkPolicy: ExistingWorkPolicy.keep,
      );

      AiLogger("WorkmanagerService").debug('Task scheduled');
    } catch (e) {
      AiLogger("WorkmanagerService").error('Error scheduling task: $e');
    }
  }

  static Future<void> cancelAllTasks() async {
    AiLogger("WorkmanagerService").debug('Cancelling all tasks');
    await Workmanager().cancelAll();
  }

  // Add this method to WorkmanagerService
  static Future<bool> verifyBackgroundTask() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/background_task_log.txt');

      if (!await file.exists()) {
        return false;
      }

      final content = await file.readAsString();
      final lines =
          content.split('\n').where((line) => line.isNotEmpty).toList();

      if (lines.isEmpty) {
        return false;
      }

      final lastExecution =
          DateTime.parse(lines.last.replaceAll('Task executed at: ', ''));

      // Check if the task was executed in the last 20 minutes
      return DateTime.now().difference(lastExecution).inMinutes <= 20;
    } catch (e) {
      AiLogger('WorkmanagerService').error('Verification failed: $e');
      return false;
    }
  }
}
