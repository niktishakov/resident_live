import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:resident_live/shared/shared.dart";

class PushNotificationService {
  // Private constructor
  PushNotificationService._privateConstructor();

  // The single instance of the service
  static final PushNotificationService _instance = PushNotificationService._privateConstructor();

  // Getter for the instance
  static PushNotificationService get instance => _instance;

  // Logger instance
  static final _logger = AiLogger("PushNotificationService");

  // Local notifications plugin
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  // Method to initialize local push notifications and request permissions
  Future<void> initialize() async {
    try {
      // Request push notification permissions
      await requestPermissions();

      // Initialize notification settings for Android & iOS
      const androidSettings = AndroidInitializationSettings("@mipmap/ic_launcher");

      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const settings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notificationsPlugin.initialize(settings);

      _logger.info("Local Push Notification Service initialized.");
    } catch (e) {
      _logger.error("Failed to initialize local push notification service: $e");
    }
  }

  // Method to request local push notification permissions
  Future<void> requestPermissions() async {
    try {
      final granted = await _notificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );

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
