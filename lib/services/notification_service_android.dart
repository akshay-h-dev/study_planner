import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin _plugin =
    FlutterLocalNotificationsPlugin();

/// Initialize local notifications on Android.
Future<void> initialize() async {
  const initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  );

  await _plugin.initialize(
  settings: initializationSettings,
);
}

/// Request notification permission on Android versions that require it.
Future<bool> requestPermission() async {
  final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();

  // On older Android versions, this permission may not be required.
  final granted = await androidPlugin?.requestNotificationsPermission();
  return granted ?? true;
}

/// Display a real Android test notification.
Future<bool> showTestNotification() async {
  const notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'study_planner_reminders',
      'Study Planner reminders',
      channelDescription: 'Notifications for Study Planner reminders',
      importance: Importance.max,
      priority: Priority.high,
    ),
  );

  await _plugin.show(
    id: 0,
    title: 'Study Planner test notification',
    body: 'Your test notification is working!',
    notificationDetails: notificationDetails,
  );

  return true;
}