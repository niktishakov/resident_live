import UIKit
import Flutter
import workmanager
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  /// Registers all pubspec-referenced Flutter plugins in the given registry.  
  static func registerPlugins(with registry: FlutterPluginRegistry) {
    GeneratedPluginRegistrant.register(with: registry)
  }


  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Request notification permissions
    UNUserNotificationCenter.current().requestAuthorization(
      options: [.alert, .sound, .badge]
    ) { granted, error in
      print("Notification permission granted: \(granted)")
    }

    WorkmanagerPlugin.setPluginRegistrantCallback { registry in  
        // The following code will be called upon WorkmanagerPlugin's registration.
        // Note : all of the app's plugins may not be required in this context ;
        // instead of using GeneratedPluginRegistrant.register(with: registry),
        // you may want to register only specific plugins.
        AppDelegate.registerPlugins(with: registry)
    }

    // Register background task to run every 15 minutes (900 seconds)
    // Note: iOS may adjust this timing based on device usage patterns
    WorkmanagerPlugin.registerPeriodicTask(
      withIdentifier: "be.tramckrijte.workmanagerExample.iOSBackgroundAppRefresh", 
      frequency: NSNumber(value: 15 * 60)
    )


    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

// Handle notifications when app is in foreground
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    // Show notification with alert, sound, and badge even if app is in foreground
    completionHandler([.alert, .sound, .badge])
  }

  // Handle notification interaction when app is in background
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    completionHandler()
  }
}
