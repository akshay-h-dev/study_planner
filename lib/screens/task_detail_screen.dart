import 'package:flutter/material.dart';
import '../models/study_task.dart';

// Colors coordinated with the Study Planner home screen.
const Color _purple = Color(0xFF4827E8);
const Color _ink = Color(0xFF20264D);
const Color _muted = Color(0xFF7B83A8);
const Color _panel = Color(0xFFF7F8FC);
const Color _border = Color(0xFFE1E5F4);

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.onChanged,
    this.onDelete,
  });

  final StudyTask task;
  final VoidCallback onChanged;

  // The home screen should provide this callback to remove the task from its list.
  final VoidCallback? onDelete;

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  StudyTask get task => widget.task;

  int get _completedCount =>
      task.checklistItems.where((item) => item.isDone).length;

  double get _progress {
    if (task.checklistItems.isNotEmpty) {
      return _completedCount / task.checklistItems.length;
    }
    return task.progress.clamp(0.0, 1.0);
  }

  String get _status {
    if (task.isDone || _progress >= 1) return 'Completed';
    if (_progress > 0) return 'In progress';
    return 'Not started';
  }

  void _updateChecklistProgress() {
    if (task.checklistItems.isNotEmpty) {
      task.progress = _progress;
      task.isDone = _progress >= 1;
    }
    widget.onChanged();
  }

  // Edit the task's title, description, subject, due date, priority, and checklist.
  Future<void> _editTask() async {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);
    final subjectController = TextEditingController(text: task.subject);
    final dueController = TextEditingController(text: task.due);
    String selectedPriority = task.priority;

    final checklistControllers = task.checklistItems
        .map((item) => TextEditingController(text: item.title))
        .toList();

    final newChecklistTitles = <String>[];
    final addChecklistController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Task'),
              content: SizedBox(
                width: 440,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Task title',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: descriptionController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: subjectController,
                        decoration: const InputDecoration(
                          labelText: 'Subject',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: dueController,
                        decoration: const InputDecoration(
                          labelText: 'Due date / time',
                          hintText: 'e.g. Today, 4:00 PM',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: <String>[
                          'Low priority',
                          'Medium priority',
                          'High priority',
                        ].contains(selectedPriority)
                            ? selectedPriority
                            : 'Medium priority',
                        decoration: const InputDecoration(
                          labelText: 'Priority',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Low priority',
                            child: Text('Low priority'),
                          ),
                          DropdownMenuItem(
                            value: 'Medium priority',
                            child: Text('Medium priority'),
                          ),
                          DropdownMenuItem(
                            value: 'High priority',
                            child: Text('High priority'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() => selectedPriority = value);
                          }
                        },
                      ),
                      const SizedBox(height: 18),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Session checklist',
                          style: TextStyle(
                            color: _ink,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...List.generate(checklistControllers.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: checklistControllers[index],
                                  decoration: InputDecoration(
                                    labelText: 'Checklist item ${index + 1}',
                                    border: const OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: 'Remove checklist item',
                                onPressed: () {
                                  setDialogState(() {
                                    checklistControllers[index].dispose();
                                    checklistControllers.removeAt(index);
                                  });
                                },
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      ...newChecklistTitles.asMap().entries.map((entry) {
                        return ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text(entry.value),
                          trailing: IconButton(
                            tooltip: 'Remove new item',
                            icon: const Icon(Icons.close),
                            onPressed: () => setDialogState(
                              () => newChecklistTitles.removeAt(entry.key),
                            ),
                          ),
                        );
                      }),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: addChecklistController,
                              decoration: const InputDecoration(
                                labelText: 'New checklist item',
                                border: OutlineInputBorder(),
                              ),
                              onSubmitted: (value) {
                                final trimmed = value.trim();
                                if (trimmed.isEmpty) return;
                                setDialogState(() {
                                  newChecklistTitles.add(trimmed);
                                  addChecklistController.clear();
                                });
                              },
                            ),
                          ),
                          IconButton(
                            tooltip: 'Add checklist item',
                            onPressed: () {
                              final value = addChecklistController.text.trim();
                              if (value.isEmpty) return;
                              setDialogState(() {
                                newChecklistTitles.add(value);
                                addChecklistController.clear();
                              });
                            },
                            icon: const Icon(Icons.add_circle, color: _purple),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    if (titleController.text.trim().isEmpty ||
                        subjectController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Title and subject are required.'),
                        ),
                      );
                      return;
                    }
                    Navigator.pop(dialogContext, true);
                  },
                  child: const Text('Save changes'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == true && mounted) {
      setState(() {
        task.title = titleController.text.trim();
        task.description = descriptionController.text.trim();
        task.subject = subjectController.text.trim();
        task.due = dueController.text.trim();
        task.priority = selectedPriority;

        final updatedItems = <ChecklistItem>[];
        for (var i = 0; i < checklistControllers.length; i++) {
          final title = checklistControllers[i].text.trim();
          if (title.isNotEmpty) {
            final oldItem = i < task.checklistItems.length
                ? task.checklistItems[i]
                : null;
            updatedItems.add(
              ChecklistItem(
                title: title,
                isDone: oldItem?.isDone ?? false,
              ),
            );
          }
        }
        updatedItems.addAll(
          newChecklistTitles
              .where((title) => title.trim().isNotEmpty)
              .map((title) => ChecklistItem(title: title.trim())),
        );
        task.checklistItems
          ..clear()
          ..addAll(updatedItems);

        if (task.checklistItems.isNotEmpty) {
          task.progress = _progress;
          task.isDone = task.progress >= 1;
        }
      });
      widget.onChanged();
    }

    titleController.dispose();
    descriptionController.dispose();
    subjectController.dispose();
    dueController.dispose();
    addChecklistController.dispose();
    for (final controller in checklistControllers) {
      controller.dispose();
    }
  }

  Future<void> _deleteTask() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete task?'),
        content: Text('“${task.title}” will be removed from your task list.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !mounted) return;

    if (widget.onDelete != null) {
      widget.onDelete!();
    }
    // Close the detail page after the home screen has handled removal.
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final hasChecklist = task.checklistItems.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back, color: _ink),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Task details',
          style: TextStyle(
            color: _ink,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: task.isSaved ? 'Remove bookmark' : 'Bookmark task',
            onPressed: () {
              setState(() => task.isSaved = !task.isSaved);
              widget.onChanged();
            },
            icon: Icon(
              task.isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: _purple,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEEFF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.menu_book_outlined,
                      size: 15,
                      color: _purple,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      task.subject,
                      style: const TextStyle(
                        color: _purple,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              task.title,
              style: const TextStyle(
                color: _ink,
                fontSize: 27,
                height: 1.18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              task.description.isEmpty
                  ? 'Add a description using Edit Task.'
                  : task.description,
              style: const TextStyle(
                color: _muted,
                fontSize: 14,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: _panel,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _InfoRow(
                    icon: Icons.menu_book_outlined,
                    label: 'Subject',
                    value: task.subject,
                  ),
                  _InfoRow(
                    icon: Icons.calendar_month_outlined,
                    label: 'Due date',
                    value: task.due,
                  ),
                  _InfoRow(
                    icon: Icons.outlined_flag,
                    label: 'Priority',
                    value: task.priority,
                    valueColor: const Color(0xFFAD6800),
                    valueBackground: const Color(0xFFFFF4DF),
                  ),
                  _InfoRow(
                    icon: Icons.radio_button_checked,
                    label: 'Status',
                    value: _status,
                    valueColor: _purple,
                    valueBackground: const Color(0xFFEEEEFF),
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Session checklist',
                    style: TextStyle(
                      color: _ink,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  hasChecklist
                      ? '$_completedCount of ${task.checklistItems.length} · '
                          '${(_progress * 100).round()}%'
                      : '${(task.progress * 100).round()}%',
                  style: const TextStyle(
                    color: _purple,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: _progress,
                minHeight: 5,
                backgroundColor: const Color(0xFFEAEDFF),
                valueColor: const AlwaysStoppedAnimation<Color>(_purple),
              ),
            ),
            const SizedBox(height: 12),
            if (hasChecklist)
              ...List.generate(task.checklistItems.length, (index) {
                final item = task.checklistItems[index];
                return InkWell(
                  onTap: () {
                    setState(() {
                      item.isDone = !item.isDone;
                      _updateChecklistProgress();
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Row(
                      children: [
                        Checkbox(
                          value: item.isDone,
                          onChanged: (value) {
                            setState(() {
                              item.isDone = value ?? false;
                              _updateChecklistProgress();
                            });
                          },
                          activeColor: _purple,
                          side: const BorderSide(color: _border, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              color: item.isDone ? _muted : _ink,
                              fontSize: 12,
                              decoration: item.isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              })
            else
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'No checklist items yet. Tap Edit Task to add some.',
                  style: TextStyle(color: _muted, fontSize: 13),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _deleteTask,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Delete'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(color: Color(0xFFFFD5D5)),
                    minimumSize: const Size(0, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: _editTask,
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  label: const Text(
                    'Edit Task',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _purple,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: const Size(0, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Reusable row for the task information panel.
class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor = _ink,
    this.valueBackground = Colors.white,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;
  final Color valueBackground;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        children: [
          Icon(icon, size: 19, color: _muted),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: _muted, fontSize: 13),
            ),
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: valueBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: valueColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
