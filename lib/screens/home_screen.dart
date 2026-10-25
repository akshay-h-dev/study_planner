
import 'package:flutter/material.dart';
import 'task_detail_screen.dart';
import '../models/study_task.dart';

// Study Planner home-screen theme colors.
const Color studyPurple = Color(0xFF4827E8);
const Color studyInk = Color(0xFF20264D);
const Color studyMuted = Color(0xFF7B83A8);
const Color studyBackground = Color(0xFFF7F8FC);
const Color studyBorder = Color(0xFFE1E5F4);

// Main home screen for the Study Planner application.
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.userName = 'Maya',
    this.onOpenSettings,
    this.onOpenCalendar,
    this.onOpenSaved,
    this.onOpenProfile,
  });

  final String userName;
  final VoidCallback? onOpenSettings;
  final VoidCallback? onOpenCalendar;
  final VoidCallback? onOpenSaved;
  final VoidCallback? onOpenProfile;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _filter = 'All tasks';
  int _navigationIndex = 0;

  // Initial demonstration tasks. Replace these with persisted user tasks later.
  final List<StudyTask> _tasks = [
    StudyTask(
      title: 'Review derivatives & integrals',
      subject: 'Mathematics · Chapter 04',
      due: 'Oct 19, 2026 · 4:00 PM',
      progress: 0.60,
      isSaved: true,
      description:
          'Review the key differentiation rules and practice definite integrals. '
          'Focus on the questions marked in the lecture notes.',
      priority: 'High priority',
      checklistItems: [
        ChecklistItem(
          title: 'Review differentiation rules',
          isDone: true,
        ),
        ChecklistItem(
          title: 'Summarize lecture notes',
          isDone: true,
        ),
        ChecklistItem(
          title: 'Practice the chain rule',
          isDone: true,
        ),
        ChecklistItem(
          title: 'Solve 10 integral problems',
        ),
        ChecklistItem(
          title: 'Check answers & flag questions',
        ),
      ],
    ),
    StudyTask(
      title: 'Read & annotate chapter 6',
      subject: 'Biology · Cell division',
      due: 'Oct 20, 10:00 AM',
      progress: 0.25,
      isSaved: true,
    ),
    StudyTask(
      title: 'Outline the research essay',
      subject: 'English',
      due: 'Oct 21, 11:59 PM',
      progress: 0,
    ),
    StudyTask(
      title: 'Practice algebra exercises',
      subject: 'Mathematics',
      due: 'Oct 22, 2:00 PM',
      progress: 1,
      isDone: true,
    ),
    StudyTask(
      title: 'Revise biology notes',
      subject: 'Biology',
      due: 'Oct 23, 9:00 AM',
      progress: 1,
      isDone: true,
    ),
  ];

  int get _completed => _tasks.where((task) => task.isDone).length;

  List<StudyTask> get _visibleTasks {
    switch (_filter) {
      case 'Today':
        return _tasks.where(
          (task) => !task.isDone && task.due.startsWith('Today'),
        ).toList();
      case 'This week':
        return _tasks.where((task) => !task.isDone).toList();
      default:
        return _tasks.where((task) => !task.isDone).toList();
    }
  }

  // Opens the simple add-task form. Extra detail fields use model defaults.
  Future<void> _addTask() async {
    final StudyTask? newTask = await showDialog<StudyTask>(
      context: context,
      builder: (_) => const _AddStudyTaskDialog(),
    );

    if (!mounted || newTask == null) return;

    setState(() {
      _tasks.insert(0, newTask);
      _filter = 'All tasks';
    });
  }

  // Shows the selected task's full information and completion action.
  Future<void> _openTask(StudyTask task) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => TaskDetailScreen(
        task: task,
        onChanged: () {
          if (mounted) setState(() {});
        },
        onDelete: () {
          setState(() {
            _tasks.remove(task);
          });
        },
      ),
      ),
    );
    if (mounted) setState(() {});
  }

  
  void _selectNavigation(int index) {
    setState(() => _navigationIndex = index);

    // Connect these callbacks to your existing screens.
    switch (index) {
      case 0:
        break;
      case 1:
        if (widget.onOpenCalendar != null) {
          widget.onOpenCalendar!();
        } else {
          _showMessage('Connect your Calendar screen here.');
        }
        break;
      case 2:
        if (widget.onOpenSaved != null) {
          widget.onOpenSaved!();
        } else {
          _showMessage('Connect your Saved screen here.');
        }
        break;
      case 3:
        if (widget.onOpenProfile != null) {
          widget.onOpenProfile!();
        } else if (widget.onOpenSettings != null) {
          widget.onOpenSettings!();
        } else {
          _showMessage('Connect your Profile screen here.');
        }
        break;
    }
  }


  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final contentWidth = width > 800 ? 760.0 : double.infinity;

    return Scaffold(
      backgroundColor: studyBackground,

      // Hamburger navigation connects to the rest of the app.
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: studyPurple),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Study Planner',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home_outlined),
                title: const Text('Home'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.calendar_month_outlined),
                title: const Text('Calendar'),
                onTap: () {
                  Navigator.pop(context);
                  _selectNavigation(1);
                },
              ),
              ListTile(
                leading: const Icon(Icons.bookmark_border),
                title: const Text('Saved tasks'),
                onTap: () {
                  Navigator.pop(context);
                  _selectNavigation(2);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  widget.onOpenSettings?.call();
                },
              ),
            ],
          ),
        ),
      ),

      // The page scrolls vertically on small screens and the web.
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: contentWidth,
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Builder(
                        builder: (context) => Row(
                          children: [
                            IconButton(
                              tooltip: 'Open menu',
                              onPressed: () =>
                                  Scaffold.of(context).openDrawer(),
                              icon: const Icon(Icons.menu_rounded),
                            ),
                            const Icon(
                              Icons.menu_book_rounded,
                              color: studyPurple,
                              size: 29,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'studyplan',
                              style: TextStyle(
                                color: studyInk,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              tooltip: 'Notifications',
                              onPressed: () =>
                                  _showMessage('No new notifications.'),
                              icon: const Icon(
                                Icons.notifications_none_rounded,
                                color: studyInk,
                              ),
                            ),
                            IconButton(
                              tooltip: 'Settings',
                              onPressed: widget.onOpenSettings ??
                                  () => _showMessage(
                                        'Connect your Settings screen here.',
                                      ),
                              icon: const Icon(
                                Icons.settings_outlined,
                                color: studyInk,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        _dateLabel,
                        style: const TextStyle(
                          color: studyMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        "Let's do this, ${widget.userName}.",
                        style: const TextStyle(
                          color: studyInk,
                          fontSize: 27,
                          height: 1.2,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        'You have ${_tasks.where((t) => !t.isDone).length} '
                        'study tasks coming up.',
                        style: const TextStyle(
                          color: studyMuted,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 22),

                      // Daily progress card from the Figma wireframe.
                      _ProgressCard(
                        completed: _completed,
                        total: _tasks.length,
                      ),
                      const SizedBox(height: 24),

                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Upcoming tasks',
                              style: TextStyle(
                                color: studyInk,
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          FilledButton.icon(
                            onPressed: _addTask,
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Add task'),
                            style: FilledButton.styleFrom(
                              backgroundColor: studyPurple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 13,
                                vertical: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Filter controls for the upcoming task list.
                      Wrap(
                        spacing: 8,
                        children: ['All tasks', 'Today', 'This week']
                            .map(
                              (filter) => ChoiceChip(
                                label: Text(filter),
                                selected: _filter == filter,
                                selectedColor:
                                    const Color(0xFFEAE7FF),
                                onSelected: (_) =>
                                    setState(() => _filter = filter),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 14),

                      if (_visibleTasks.isEmpty)
                        _EmptyTasks(onAddTask: _addTask)
                      else
                        ..._visibleTasks.map(
                          (task) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _TaskCard(
                              task: task,
                              onTap: () => _openTask(task),
                              onSavedChanged: () => setState(
                                () => task.isSaved = !task.isSaved,
                              ),
                              onCompletedChanged: () => setState(() {
                                task.isDone = !task.isDone;
                                task.progress = task.isDone ? 1 : 0;
                              }),
                            ),
                          ),
                        ),

                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: () => setState(() {
                          _filter = 'All tasks';
                        }),
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('View completed progress'),
                      ),
                      if (_filter == 'All tasks')
                        ..._tasks.where((task) => task.isDone).map(
                          (task) => ListTile(
                            leading: const Icon(
                              Icons.check_circle,
                              color: studyPurple,
                            ),
                            title: Text(task.title),
                            subtitle: Text(task.subject),
                            trailing: const Text('Done'),
                          ),
                        ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // Bottom navigation mirrors the supplied Home Figma design.
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navigationIndex,
        onDestinationSelected: _selectNavigation,
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFEAE7FF),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border),
            selectedIcon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),

      // Floating action button is the main task-creation action.
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        backgroundColor: studyPurple,
        foregroundColor: Colors.white,
        tooltip: 'Add study task',
        child: const Icon(Icons.add),
      ),
    );
  }

  // Formats the current date without needing an extra package.
  String get _dateLabel {
    const weekdays = [
      'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY',
      'FRIDAY', 'SATURDAY', 'SUNDAY',
    ];
    const months = [
      'JANUARY', 'FEBRUARY', 'MARCH', 'APRIL',
      'MAY', 'JUNE', 'JULY', 'AUGUST',
      'SEPTEMBER', 'OCTOBER', 'NOVEMBER', 'DECEMBER',
    ];
    final now = DateTime.now();
    return '${weekdays[now.weekday - 1]}, '
        '${months[now.month - 1]} ${now.day}';
  }
}

// Dashboard card showing how much of the task list is completed.
class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.completed,
    required this.total,
  });

  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : completed / total;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: studyPurple,
        borderRadius: BorderRadius.circular(23),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "TODAY'S MOMENTUM",
                      style: TextStyle(
                        color: Color(0xFFD5CEFF),
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      '$completed of $total tasks done',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const CircleAvatar(
                backgroundColor: Color(0xFF6650ED),
                child: Icon(
                  Icons.school_outlined,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: const Color(0xFF8876F1),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Keep going. Every session counts.',
            style: TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// Individual task card with progress, bookmark, and completion controls.
class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.task,
    required this.onTap,
    required this.onSavedChanged,
    required this.onCompletedChanged,
  });

  final StudyTask task;
  final VoidCallback onTap;
  final VoidCallback onSavedChanged;
  final VoidCallback onCompletedChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(19),
        side: const BorderSide(color: studyBorder),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(19),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 13, 15, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.subject.toUpperCase(),
                      style: const TextStyle(
                        color: studyPurple,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: task.isSaved ? 'Unsave task' : 'Save task',
                    visualDensity: VisualDensity.compact,
                    onPressed: onSavedChanged,
                    icon: Icon(
                      task.isSaved
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      color: studyPurple,
                    ),
                  ),
                ],
              ),
              Text(
                task.title,
                style: const TextStyle(
                  color: studyInk,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    size: 15,
                    color: studyMuted,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      task.due,
                      style: const TextStyle(
                        color: studyMuted,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  Text(
                    '${(task.progress * 100).round()}%',
                    style: const TextStyle(
                      color: studyPurple,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Checkbox(
                    value: task.isDone,
                    onChanged: (_) => onCompletedChanged(),
                    activeColor: studyPurple,
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: LinearProgressIndicator(
                  value: task.progress,
                  minHeight: 4,
                  backgroundColor: const Color(0xFFEAEFFD),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(studyPurple),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Friendly empty state for filters that have no matching tasks.
class _EmptyTasks extends StatelessWidget {
  const _EmptyTasks({required this.onAddTask});

  final VoidCallback onAddTask;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: studyBorder),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.menu_book_outlined,
            size: 38,
            color: studyPurple,
          ),
          const SizedBox(height: 12),
          const Text(
            'No tasks here yet',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: studyInk,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Use the + button to plan your next study session.',
            textAlign: TextAlign.center,
            style: TextStyle(color: studyMuted),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: onAddTask,
            child: const Text('Create a task'),
          ),
        ],
      ),
    );
  }
}

// Dialog for creating a task with only a title and subject.
// The detail screen can fill in optional information later.
class _AddStudyTaskDialog extends StatefulWidget {
  const _AddStudyTaskDialog();

  @override
  State<_AddStudyTaskDialog> createState() => _AddStudyTaskDialogState();
}

class _AddStudyTaskDialogState extends State<_AddStudyTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subjectController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    // New tasks receive safe defaults for fields not requested in this form.
    final task = StudyTask(
      title: _titleController.text.trim(),
      subject: _subjectController.text.trim(),
      due: 'Today',
      progress: 0,
      isDone: false,
      isSaved: false,
      description: '',
      priority: 'Medium priority',
      checklistItems: [],
    );

    // Return the new task to _HomeScreenState._addTask().
    Navigator.of(context).pop(task);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a study task'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Task title',
                hintText: 'e.g. Review lecture notes',
              ),
              validator: (value) =>
                  value == null || value.trim().isEmpty
                      ? 'Enter a task title'
                      : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject',
                hintText: 'e.g. Mathematics',
              ),
              validator: (value) =>
                  value == null || value.trim().isEmpty
                      ? 'Enter a subject'
                      : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Add task'),
        ),
      ],
    );
  }
}
