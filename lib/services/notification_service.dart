import 'notification_service_stub.dart'
    if (dart.library.html) 'notification_service_web.dart'
    if (dart.library.io) 'notification_service_android.dart' as platform;

/// A small platform-specific notification interface.
class NotificationService {
  static Future<void> initialize() => platform.initialize();

  static Future<bool> requestPermission() =>
      platform.requestPermission();

  static Future<bool> showTestNotification() =>
      platform.showTestNotification();
}