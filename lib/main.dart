import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitastream/screens/tips_screen.dart';
import 'screens/settings_screen.dart';
import 'theme_state.dart';
import 'screens/pairing_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_login_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/map_screen.dart';
import 'screens/sign_up.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingLoginScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/dashboard': (context) => const NavigationWrapper(initialIndex: 1),
         '/settings': (context) => const SettingsScreen(),
         '/tips': (context) => const TipsScreen(),
      },
    );
  }
}

class NavigationWrapper extends StatefulWidget {
  final int initialIndex;
  const NavigationWrapper({super.key, this.initialIndex = 1});

  @override
  State<NavigationWrapper> createState() => _NavigationWrapperState();
}

class _NavigationWrapperState extends State<NavigationWrapper> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  final List<Widget> _screens = [
    const PairingScreen(),
    const DashboardScreen(),
    const MapScreen(),
    const TipsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey.shade100,
        selectedItemColor: Colors.teal.shade700,
        unselectedItemColor: Colors.grey.shade600,
        elevation: 6,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth, size: 30),
            label: 'Pair',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard, size: 26),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map, size: 26),
            label: 'Map',
          ),
        ],
      ),
    );
  }
}
