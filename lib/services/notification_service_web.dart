import 'dart:html' as html;

/// Browser notifications do not require plugin initialization.
Future<void> initialize() async {}

/// Ask the browser for notification permission.
Future<bool> requestPermission() async {
  if (html.Notification.permission == 'granted') {
    return true;
  }

  final permission = await html.Notification.requestPermission();
  return permission == 'granted';
}

/// Display a real browser notification.
Future<bool> showTestNotification() async {
  if (html.Notification.permission != 'granted') {
    return false;
  }

  html.Notification(
    'Study Planner test notification',
    body: 'Your test notification is working!',
  );

  return true;
}