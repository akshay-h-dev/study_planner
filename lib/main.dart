
import 'package:flutter/material.dart';

/// Application entry point for the Study Planner project.
void main() {
  runApp(const StudyPlannerApp());
}

/// Defines the app-wide Material theme and initial screen.
class StudyPlannerApp extends StatelessWidget {
  const StudyPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4657A8),
        ),
        useMaterial3: true,
      ),
      home: const StudyPlannerHomeScreen(),
    );
  }
}

/// Temporary home screen used to verify the project setup.
/// Study-task management and navigation will be added in later tasks.
class StudyPlannerHomeScreen extends StatelessWidget {
  const StudyPlannerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Planner'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.menu_book_rounded,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 20),
              Text(
                'Plan your learning journey',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Text(
                'Welcome to Study Planner. '
                'Your project setup is ready for the next steps.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Flutter project setup',
                        ),
                      ),
                      Text('Starter'),
                    ],
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
