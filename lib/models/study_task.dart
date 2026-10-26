/// Data model for a Study Planner task, including JSON serialization
/// for local persistence.
class StudyTask {
  StudyTask({
    required this.title,
    required this.subject,
    required this.due,
    required this.progress,
    this.isDone = false,
    this.isSaved = false,
    this.description = '',
    this.priority = 'Medium priority',
    List<ChecklistItem>? checklistItems,
  }) : checklistItems = checklistItems ?? <ChecklistItem>[];

  String title;
  String subject;
  String due;
  double progress;
  bool isDone;
  bool isSaved;
  String description;
  String priority;
  final List<ChecklistItem> checklistItems;

  /// Converts a task and its checklist into JSON-compatible values.
  Map<String, dynamic> toJson() => {
        'title': title,
        'subject': subject,
        'due': due,
        'progress': progress,
        'isDone': isDone,
        'isSaved': isSaved,
        'description': description,
        'priority': priority,
        'checklistItems': checklistItems.map((item) => item.toJson()).toList(),
      };

  /// Restores a task, applying defaults for optional fields in older data.
  factory StudyTask.fromJson(Map<String, dynamic> json) {
    final rawChecklist = json['checklistItems'];
    final checklist = rawChecklist is List
        ? rawChecklist
            .whereType<Map>()
            .map((item) => ChecklistItem.fromJson(
                  Map<String, dynamic>.from(item),
                ))
            .toList()
        : <ChecklistItem>[];

    final rawProgress = json['progress'];
    final progress = rawProgress is num ? rawProgress.toDouble() : 0.0;

    return StudyTask(
      title: json['title'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      due: json['due'] as String? ?? '',
      progress: progress.clamp(0.0, 1.0).toDouble(),
      isDone: json['isDone'] as bool? ?? false,
      isSaved: json['isSaved'] as bool? ?? false,
      description: json['description'] as String? ?? '',
      priority: json['priority'] as String? ?? 'Medium priority',
      checklistItems: checklist,
    );
  }
}

/// One item in the task's session checklist.
class ChecklistItem {
  ChecklistItem({
    required this.title,
    this.isDone = false,
  });

  String title;
  bool isDone;

  Map<String, dynamic> toJson() => {
        'title': title,
        'isDone': isDone,
      };

  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
      title: json['title'] as String? ?? '',
      isDone: json['isDone'] as bool? ?? false,
    );
  }
}
