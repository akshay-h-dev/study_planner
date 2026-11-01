import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/notification_service.dart';

const Color _purple = Color(0xFF4827E8);

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _notificationsEnabled = true;
  bool _loading = true;
  bool _sendingTest = false;

  final List<String> _activities = const [
    'Study Sessions',
    'Assignments',
    'Exam Preparation',
    'Revision',
  ];

  final List<String> _reminderTimes = const [
    'Morning',
    'Afternoon',
    'Evening',
  ];

  final Set<String> _selectedActivities = {};
  final Set<String> _selectedTimes = {};

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    await NotificationService.initialize();
  }

  /// Load notification preferences saved on this device.
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _notificationsEnabled =
          prefs.getBool('notifications_enabled') ?? true;

      _selectedActivities.addAll(
        prefs.getStringList('notification_activities') ?? [],
      );

      _selectedTimes.addAll(
        prefs.getStringList('notification_times') ?? [],
      );

      _loading = false;
    });
  }

  /// Persist the current notification settings.
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      'notifications_enabled',
      _notificationsEnabled,
    );

    await prefs.setStringList(
      'notification_activities',
      _selectedActivities.toList(),
    );

    await prefs.setStringList(
      'notification_times',
      _selectedTimes.toList(),
    );
  }

  Future<void> _setNotificationsEnabled(bool value) async {
    setState(() {
      _notificationsEnabled = value;
    });

    await _saveSettings();
  }

  Future<void> _toggleActivity(String activity, bool selected) async {
    setState(() {
      if (selected) {
        _selectedActivities.add(activity);
      } else {
        _selectedActivities.remove(activity);
      }
    });

    await _saveSettings();
  }

  Future<void> _toggleTime(String time, bool selected) async {
    setState(() {
      if (selected) {
        _selectedTimes.add(time);
      } else {
        _selectedTimes.remove(time);
      }
    });

    await _saveSettings();
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Request permission and trigger a real test notification.
  Future<void> _sendTestNotification() async {
    if (!_notificationsEnabled) {
      _showMessage('Please enable notifications first.');
      return;
    }

    setState(() {
      _sendingTest = true;
    });

    try {
      final permissionGranted =
          await NotificationService.requestPermission();

      if (!permissionGranted) {
        _showMessage(
          'Notification permission was not granted. '
          'Please allow notifications in your device or browser settings.',
        );
        return;
      }

      final sent = await NotificationService.showTestNotification();

      if (sent) {
        _showMessage('Test notification triggered successfully.');
      } else {
        _showMessage('Could not display the test notification.');
      }
    } catch (error) {
      _showMessage('Notification error: $error');
    } finally {
      if (mounted) {
        setState(() {
          _sendingTest = false;
        });
      }
    }
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _selectionChips({
    required List<String> items,
    required Set<String> selectedItems,
    required Future<void> Function(String, bool) onSelected,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        final selected = selectedItems.contains(item);

        return FilterChip(
          label: Text(item),
          selected: selected,
          selectedColor: const Color(0xFFE8E3FF),
          checkmarkColor: _purple,
          onSelected: (value) => onSelected(item, value),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: _purple,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Card(
                      child: SwitchListTile(
                        secondary: const Icon(
                          Icons.notifications_active_outlined,
                          color: _purple,
                        ),
                        title: const Text(
                          'Enable Notifications',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          _notificationsEnabled
                              ? 'Study reminders are enabled'
                              : 'Study reminders are disabled',
                        ),
                        value: _notificationsEnabled,
                        activeColor: _purple,
                        onChanged: _setNotificationsEnabled,
                      ),
                    ),

                    _sectionTitle('Select Study Activities'),

                    const Text(
                      'Choose the study activities you want to '
                      'receive reminders about.',
                    ),

                    const SizedBox(height: 10),

                    _selectionChips(
                      items: _activities,
                      selectedItems: _selectedActivities,
                      onSelected: _toggleActivity,
                    ),

                    _sectionTitle('Reminder Times'),

                    const Text(
                      'Choose when you prefer to receive reminders.',
                    ),

                    const SizedBox(height: 10),

                    _selectionChips(
                      items: _reminderTimes,
                      selectedItems: _selectedTimes,
                      onSelected: _toggleTime,
                    ),

                    const SizedBox(height: 28),

                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: _purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                      onPressed:
                          _sendingTest ? null : _sendTestNotification,
                      icon: _sendingTest
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.notifications_active),
                      label: Text(
                        _sendingTest
                            ? 'Sending test...'
                            : 'Send Test Notification',
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Use this button to check that notifications '
                      'are working. It does not wait for a scheduled '
                      'reminder time.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}