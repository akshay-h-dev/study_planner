import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/study_task.dart';

/// Reads and writes the Study Planner task list on Android and Web.
class LocalStorageService {
  LocalStorageService._();

  static final LocalStorageService instance = LocalStorageService._();

  static const String _tasksKey = 'study_planner_tasks_v1';

  /// Returns null only when this app has never saved a task list.
  /// An empty list means the user saved an intentionally empty task list.
  Future<List<StudyTask>?> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getString(_tasksKey);

    if (encoded == null) return null;

    final decoded = jsonDecode(encoded);
    if (decoded is! List) {
      throw const FormatException('Saved tasks must be a JSON list.');
    }

    return decoded.map<StudyTask>((item) {
      if (item is! Map) {
        throw const FormatException('Each saved task must be a JSON object.');
      }
      return StudyTask.fromJson(Map<String, dynamic>.from(item));
    }).toList();
  }

  Future<void> saveTasks(List<StudyTask> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(tasks.map((task) => task.toJson()).toList());
    final saved = await prefs.setString(_tasksKey, encoded);
    if (!saved) throw StateError('Could not save study tasks locally.');
  }

  Future<void> clearTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tasksKey);
  }
}
