import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    const initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      iOS: initializationSettingsIOS,
    );

    await _notifications.initialize(initializationSettings);
    _initialized = true;
  }

  static Future<void> showLocationUpdateNotification({
    required String title,
    required String body,
  }) async {
    if (!_initialized) await initialize();

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      iOS: iosDetails,
    );

    await _notifications.show(
      DateTime.now().millisecond, // unique ID
      title,
      body,
      details,
    );
  }
}
