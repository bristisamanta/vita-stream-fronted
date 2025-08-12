import 'package:flutter/material.dart';
import 'animated_gradient_background.dart';
import 'screens/pairing_screen.dart';
import 'screens/splash_screen.dart'; // ✅ Import splash screen

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
        '/': (context) => const SplashScreen(), // ✅ Splash first
        '/home': (context) => const NavigationWrapper(),
      },
    );
  }
}

class NavigationWrapper extends StatefulWidget {
  const NavigationWrapper({super.key});

  @override
  State<NavigationWrapper> createState() => _NavigationWrapperState();
}

class _NavigationWrapperState extends State<NavigationWrapper> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const PairingScreen(), // First tab
    HomeScreen(),          // Your gradient list
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
        backgroundColor: Colors.grey.shade100, // matte tone
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
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBackground(
        scrollController: _scrollController,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: 20,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.white.withOpacity(0.8),
              margin: const EdgeInsets.all(12),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Row ${index + 1}',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

