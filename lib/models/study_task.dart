
/// Data model for a Study Planner task.
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

  // Basic task information used by the home screen.
  String title;
  String subject;
  String due;
  double progress;
  bool isDone;
  bool isSaved;

  // Additional information used by the detail screen.
  String description;
  String priority;
  final List<ChecklistItem> checklistItems;
}

/// One item in the task's session checklist.
class ChecklistItem {
  ChecklistItem({
    required this.title,
    this.isDone = false,
  });

  String title;
  bool isDone;
}
