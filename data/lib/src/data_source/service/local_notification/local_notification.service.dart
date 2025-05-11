import "package:data/src/data_source/service/logger/logger.service.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:injectable/injectable.dart";

@Singleton()
class LocalNotificationService {
  LocalNotificationService(this._logger);
  final LoggerService _logger;

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    try {
      await requestPermissions();

      const androidSettings = AndroidInitializationSettings("@mipmap/ic_launcher");

      const iosSettings = DarwinInitializationSettings(requestAlertPermission: true, requestBadgePermission: true, requestSoundPermission: true);

      const settings = InitializationSettings(android: androidSettings, iOS: iosSettings);

      await _notificationsPlugin.initialize(settings);

      _logger.info("Local Push Notification Service initialized.");
    } catch (e) {
      _logger.error("Failed to initialize local push notification service: $e");
    }
  }

  Future<void> requestPermissions() async {
    try {
      final granted = await _notificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);

      if (granted != null && granted == true) {
        _logger.info("Local push notification permission granted");
      } else {
        _logger.warning("Local push notification permission denied");
      }
    } catch (e) {
      _logger.error("Failed to request local push notification permissions: $e");
    }
  }
}
