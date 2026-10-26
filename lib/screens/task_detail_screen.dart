import 'package:flutter/material.dart';

import '../models/study_task.dart';

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
  final VoidCallback? onDelete;

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  StudyTask get task => widget.task;

  int get _completedCount =>
      task.checklistItems.where((item) => item.isDone).length;

  double get _progress => task.checklistItems.isNotEmpty
      ? _completedCount / task.checklistItems.length
      : task.progress.clamp(0.0, 1.0).toDouble();

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

  Future<void> _editTask() async {
    final result = await showDialog<_TaskEditResult>(
      context: context,
      builder: (_) => _EditTaskDialog(task: task),
    );
    if (result == null || !mounted) return;

    setState(() {
      task.title = result.title;
      task.description = result.description;
      task.subject = result.subject;
      task.due = result.due;
      task.priority = result.priority;
      task.checklistItems
        ..clear()
        ..addAll(result.checklistItems);
      if (task.checklistItems.isNotEmpty) {
        task.progress = _progress;
        task.isDone = task.progress >= 1;
      }
    });
    widget.onChanged();
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
    widget.onDelete?.call();
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEEFF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.menu_book_outlined, size: 15, color: _purple),
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
              style: const TextStyle(color: _muted, fontSize: 14, height: 1.6),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _panel,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _InfoRow(icon: Icons.menu_book_outlined, label: 'Subject', value: task.subject),
                  _InfoRow(icon: Icons.calendar_month_outlined, label: 'Due date', value: task.due),
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
                    style: TextStyle(color: _ink, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  hasChecklist
                      ? '$_completedCount of ${task.checklistItems.length} · ${(_progress * 100).round()}%'
                      : '${(task.progress * 100).round()}%',
                  style: const TextStyle(color: _purple, fontSize: 12, fontWeight: FontWeight.w600),
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              color: item.isDone ? _muted : _ink,
                              fontSize: 12,
                              decoration: item.isDone ? TextDecoration.lineThrough : TextDecoration.none,
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: _editTask,
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  label: const Text('Edit Task', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _purple,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: const Size(0, 52),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
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

class _TaskEditResult {
  const _TaskEditResult({
    required this.title,
    required this.description,
    required this.subject,
    required this.due,
    required this.priority,
    required this.checklistItems,
  });

  final String title;
  final String description;
  final String subject;
  final String due;
  final String priority;
  final List<ChecklistItem> checklistItems;
}

class _ChecklistDraft {
  _ChecklistDraft({required this.controller, required this.originalItem});

  final TextEditingController controller;
  final ChecklistItem? originalItem;
}

class _EditTaskDialog extends StatefulWidget {
  const _EditTaskDialog({required this.task});

  final StudyTask task;

  @override
  State<_EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<_EditTaskDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _subjectController;
  late final TextEditingController _dueController;
  late final TextEditingController _addChecklistController;
  late final List<_ChecklistDraft> _checklistDrafts;
  final List<TextEditingController> _removedControllers = [];
  final List<String> _newChecklistTitles = [];
  late String _selectedPriority;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _titleController = TextEditingController(text: task.title);
    _descriptionController = TextEditingController(text: task.description);
    _subjectController = TextEditingController(text: task.subject);
    _dueController = TextEditingController(text: task.due);
    _addChecklistController = TextEditingController();
    _checklistDrafts = task.checklistItems
        .map((item) => _ChecklistDraft(
              controller: TextEditingController(text: item.title),
              originalItem: item,
            ))
        .toList();
    _selectedPriority = task.priority;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _subjectController.dispose();
    _dueController.dispose();
    _addChecklistController.dispose();
    for (final draft in _checklistDrafts) {
      draft.controller.dispose();
    }
    for (final controller in _removedControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addChecklistItem([String? submittedValue]) {
    final value = (submittedValue ?? _addChecklistController.text).trim();
    if (value.isEmpty) return;
    setState(() {
      _newChecklistTitles.add(value);
      _addChecklistController.clear();
    });
  }

  void _save() {
    final title = _titleController.text.trim();
    final subject = _subjectController.text.trim();
    if (title.isEmpty || subject.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and subject are required.')),
      );
      return;
    }

    final updatedItems = <ChecklistItem>[];
    for (final draft in _checklistDrafts) {
      final itemTitle = draft.controller.text.trim();
      if (itemTitle.isNotEmpty) {
        updatedItems.add(
          ChecklistItem(
            title: itemTitle,
            isDone: draft.originalItem?.isDone ?? false,
          ),
        );
      }
    }
    updatedItems.addAll(
      _newChecklistTitles
          .where((value) => value.trim().isNotEmpty)
          .map((value) => ChecklistItem(title: value.trim())),
    );

    final result = _TaskEditResult(
      title: title,
      description: _descriptionController.text.trim(),
      subject: subject,
      due: _dueController.text.trim(),
      priority: _selectedPriority,
      checklistItems: updatedItems,
    );
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    const priorities = ['Low priority', 'Medium priority', 'High priority'];
    final priorityValue = priorities.contains(_selectedPriority)
        ? _selectedPriority
        : 'Medium priority';

    return AlertDialog(
      title: const Text('Edit Task'),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Task title', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _subjectController,
                decoration: const InputDecoration(labelText: 'Subject', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _dueController,
                decoration: const InputDecoration(
                  labelText: 'Due date / time',
                  hintText: 'e.g. Today, 4:00 PM',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: priorityValue,
                decoration: const InputDecoration(labelText: 'Priority', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'Low priority', child: Text('Low priority')),
                  DropdownMenuItem(value: 'Medium priority', child: Text('Medium priority')),
                  DropdownMenuItem(value: 'High priority', child: Text('High priority')),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _selectedPriority = value);
                },
              ),
              const SizedBox(height: 18),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Session checklist', style: TextStyle(color: _ink, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 8),
              ...List.generate(_checklistDrafts.length, (index) {
                final draft = _checklistDrafts[index];
                return Padding(
                  key: ObjectKey(draft.controller),
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          key: ObjectKey(draft.controller),
                          controller: draft.controller,
                          decoration: InputDecoration(
                            labelText: 'Checklist item ${index + 1}',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Remove checklist item',
                        onPressed: () {
                          setState(() {
                            final removed = _checklistDrafts.removeAt(index);
                            _removedControllers.add(removed.controller);
                          });
                        },
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                      ),
                    ],
                  ),
                );
              }),
              ..._newChecklistTitles.asMap().entries.map((entry) {
                return ListTile(
                  key: ValueKey('new-checklist-${entry.key}-${entry.value}'),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(entry.value),
                  trailing: IconButton(
                    tooltip: 'Remove new item',
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => _newChecklistTitles.removeAt(entry.key)),
                  ),
                );
              }),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _addChecklistController,
                      decoration: const InputDecoration(labelText: 'New checklist item', border: OutlineInputBorder()),
                      onSubmitted: _addChecklistItem,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Add checklist item',
                    onPressed: _addChecklistItem,
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
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _save, child: const Text('Save changes')),
      ],
    );
  }
}

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
            child: Text(label, style: const TextStyle(color: _muted, fontSize: 13)),
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
              decoration: BoxDecoration(
                color: valueBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: TextStyle(color: valueColor, fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
