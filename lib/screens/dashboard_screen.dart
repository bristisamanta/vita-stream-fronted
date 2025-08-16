import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:provider/provider.dart';
import '../theme_state.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

AppBar buildDashboardAppBar(
  BuildContext context,
  Animation<double> titleAnimation,
) {
  final themeProvider = Provider.of<ThemeProvider>(context);

  return AppBar(
    elevation: 0,
    backgroundColor: themeProvider.isDarkMode
        ? Colors.black
        : Colors.green.shade400,
    title: ScaleTransition(
      scale: titleAnimation,
      child: Row(
        children: [
          const Icon(Icons.water_drop, color: Colors.white),
          const SizedBox(width: 8),
          const Text(
            "VitaStream",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
    actions: [
      // 🌙 Dark / Light toggle
      Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: GestureDetector(
          onTap: () => themeProvider.toggleTheme(),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, anim) => RotationTransition(
              turns: child.key == const ValueKey('dark')
                  ? Tween<double>(begin: 1, end: 0.75).animate(anim)
                  : Tween<double>(begin: 0.75, end: 1).animate(anim),
              child: FadeTransition(opacity: anim, child: child),
            ),
            child: themeProvider.isDarkMode
                ? const Icon(
                    Icons.nightlight_round,
                    key: ValueKey('dark'),
                    color: Colors.white,
                    size: 26,
                  )
                : const Icon(
                    Icons.wb_sunny,
                    key: ValueKey('light'),
                    color: Colors.white,
                    size: 26,
                  ),
          ),
        ),
      ),
      IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () {
          Navigator.pushNamed(context, "/settings");
        },
      ),

      IconButton(icon: const Icon(Icons.person), onPressed: () {}),
    ],
  );
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _titleAnimation;
  int _selectedIndex = 1;

  final List<Map<String, dynamic>> _features = [
    {"icon": Icons.local_drink, "label": "Water Intake"},
    {"icon": Icons.analytics, "label": "Reports"},
    {"icon": Icons.call, "label": "Emergency"},
    {"icon": Icons.alarm, "label": "Reminders"},
    {"icon": Icons.wifi, "label": "Device Status"},
    {"icon": Icons.water, "label": "Safe Sources"},
  ];

  final List<Widget> _pages = [
    const Center(child: Text("Map Screen Placeholder")),
    const Center(child: Text("Dashboard Screen Placeholder")),
    const Center(child: Text("Profile Screen Placeholder")),
    const Center(child: Text("Tips Screen Placeholder")),
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _titleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildFeatureCard(Map<String, dynamic> feature, int index) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.7, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(index * 0.1, 1.0, curve: Curves.elasticOut),
        ),
      ),
      child: OpenContainer(
        closedElevation: 3,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        closedColor: Colors.white,
        transitionDuration: const Duration(milliseconds: 500),
        openBuilder: (context, _) => Scaffold(
          appBar: AppBar(title: Text(feature['label'])),
          body: Center(child: Text("${feature['label']} Screen")),
        ),
        closedBuilder: (context, openContainer) => InkWell(
          onTap: openContainer,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [Colors.green.shade300, Colors.yellow.shade200],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(feature['icon'], size: 28, color: Colors.white),
                const SizedBox(height: 6),
                Text(
                  feature['label'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade50, Colors.yellow.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: GridView.count(
        crossAxisCount: 3,
        padding: const EdgeInsets.all(12),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: List.generate(
          _features.length,
          (index) => _buildFeatureCard(_features[index], index),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade300, Colors.teal.shade400],
                ),
              ),
              child: const Center(
                child: Text(
                  "Menu",
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text("Map Screen"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.bluetooth),
              title: const Text("Pairing Screen"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.lightbulb),
              title: const Text("Tips Screen"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.insert_chart),
              title: const Text("Reports"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.alarm),
              title: const Text("Reminders"),
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green.shade400,
        title: ScaleTransition(
          scale: _titleAnimation,
          child: Row(
            children: [
              const Icon(Icons.water_drop, color: Colors.white),
              const SizedBox(width: 8),
              const Text(
                "VitaStream", // ✅ Project name
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
          IconButton(icon: const Icon(Icons.person), onPressed: () {}),
        ],
      ),
      body: _selectedIndex == 1
          ? _buildDashboardContent()
          : _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green.shade800,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth, size: 26),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb, size: 26),
            label: 'Tips',
          ),
        ],
      ),
    );
  }
}
