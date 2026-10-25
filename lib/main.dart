
import 'package:flutter/material.dart';

import 'screens/signup_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StudyPlannerApp());
}

class StudyPlannerApp extends StatelessWidget {
  const StudyPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4B2AE8),
        ),
      ),
      initialRoute: '/signup',
      routes: {
        '/signup': (context) => const SignupScreen(),
        '/login': (context) => const LoginScreen(),

        // Home is opened by LoginScreen after successful authentication.
        '/home': (context) {
          final arguments = ModalRoute.of(context)?.settings.arguments;

          // Keep the home screen compatible with the user object
          // already passed by LoginScreen.
          String userName = 'Student';

          if (arguments != null) {
            try {
              final dynamic user = arguments;
              final dynamic name = user.name;

              if (name is String && name.trim().isNotEmpty) {
                userName = name.trim();
              }
            } catch (_) {
              // If the user model has no .name property, use the fallback.
            }
          }

          return HomeScreen(userName: userName);
        },
      },
    );
  }
}
