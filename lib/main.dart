import 'package:flutter/material.dart';
import 'animated_gradient_background.dart';
import 'screens/pairing_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_login_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart'; // ✅ Import DashboardScreen
import 'screens/map_screen.dart';


void navigateWithAnimation(BuildContext context, Widget page) {
  Navigator.of(context).pushReplacement(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    ),
  );
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingLoginScreen(),
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const NavigationWrapper(initialIndex: 1), // ✅ Added
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
    const DashboardScreen(), // ✅ Dashboard screen as main tab
    const MapScreen(), 
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
