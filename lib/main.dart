import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_state.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/onboarding_login_screen.dart';
import 'screens/login_screen.dart';
import 'screens/sign_up.dart';
import 'screens/dashboard_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/tips_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/alert_screen.dart'; // ✅ Added AlertScreen import

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.currentTheme,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.teal,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
      ),

      // ✅ Start with SplashScreen
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingLoginScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        
        // ✅ Your real dashboard with bottom navigation
        '/dashboard': (context) => const DashboardScreen(), 
        
        '/settings': (context) => const SettingsScreen(),
        '/tips': (context) => const TipsScreen(),
        '/profile': (context) => const ProfileScreen(),
        
        // ✅ New route for Alerts
        '/alert': (context) => const AlertScreen(),
      },
    );
  }
}
