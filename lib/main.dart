import 'package:flutter/material.dart';

import 'screens/signup_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/settings_menu_screen.dart';

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

        // LoginScreen passes the authenticated user to this route.
        '/home': (context) {
          final arguments = ModalRoute.of(context)?.settings.arguments;
          String userName = 'Student';

          if (arguments != null) {
            try {
              final dynamic user = arguments;
              final dynamic name = user.name;
              if (name is String && name.trim().isNotEmpty) {
                userName = name.trim();
              }
            } catch (_) {
              // Keep the fallback if the supplied user has no name property.
            }
          }

          return HomeScreen(
            userName: userName,
            onOpenSettings: () {
              Navigator.of(context).pushNamed(
                '/menu',
                arguments: userName,
              );
            },
          );
        },

        // Settings menu is opened from the Home drawer or Settings icon.
        '/menu': (context) {
          final arguments = ModalRoute.of(context)?.settings.arguments;
          final userName = arguments is String && arguments.trim().isNotEmpty
              ? arguments.trim()
              : 'Student';

          return SettingsMenuScreen(userName: userName);
        },
      },
    );
  }
}
