import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'theme_state.dart';
import 'package:vitastream/utils/permission_handler.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/onboarding_login_screen.dart';
import 'screens/login_screen.dart';
import 'screens/sign_up.dart';
import 'screens/dashboard_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/tips_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/alert_screen.dart';

// ✅ Global notification plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// ✅ Navigator key (needed for redirect from notifications)
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Request BLE permissions before app runs
  await AppPermissions.requestBluetoothPermissions();

  // ✅ Initialize notifications
  const AndroidInitializationSettings androidInit =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings =
      InitializationSettings(android: androidInit);

  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload == "alert") {
        // ✅ Navigate to AlertScreen when tapped
        navigatorKey.currentState?.pushNamed("/alert");
      }
    },
  );

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
      navigatorKey: navigatorKey, // ✅ added for notification navigation
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

        // ✅ Alerts screen
        '/alert': (context) => const AlertScreen(),
      },
    );
  }
}
