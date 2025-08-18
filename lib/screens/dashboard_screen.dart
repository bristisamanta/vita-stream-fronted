import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_state.dart';
import 'pairing_screen.dart';
import 'map_screen.dart';
import 'tips_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 1; // Default = Dashboard

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final List<Widget> _pages = [
      const PairingScreen(),
      _buildDashboardPage(themeProvider),
      const MapScreen(),
      const TipsScreen(),
    ];

    final List<String> _titles = [
      "Pair Device",
      "VitaStream",
      "Safe Water Sources",
      "Tips",
    ];

    return Scaffold(
      backgroundColor:
          themeProvider.isDarkMode ? Colors.black : Colors.grey[100],

      appBar: AppBar(
        backgroundColor: themeProvider.isDarkMode
            ? Colors.black
            : Colors.teal.shade400,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.water_drop, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              _titles[_selectedIndex],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: themeProvider.isDarkMode
                ? const Icon(Icons.wb_sunny, color: Colors.white)
                : const Icon(Icons.nightlight_round, color: Colors.white),
            onPressed: () => themeProvider.toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, "/settings"),
          ),
        ],
      ),

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _pages[_selectedIndex],
      ),

      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.bluetooth), label: "Pair"),
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard), label: "Dashboard"),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
            BottomNavigationBarItem(
                icon: Icon(Icons.lightbulb), label: "Tips"),
          ],
        ),
      ),
    );
  }

  // ✅ Dashboard Page
  Widget _buildDashboardPage(ThemeProvider themeProvider) {
    return SingleChildScrollView(
      key: const ValueKey("dashboard"),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildProfileCard(themeProvider),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              hintText: "Search...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: themeProvider.isDarkMode
                  ? Colors.grey[850]
                  : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text("Features",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.1,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildFeatureCard("assets/images/water.png", "Water Intake",
                  [Colors.blue, Colors.teal]),
              _buildFeatureCard("assets/images/alarm.png", "Reminders",
                  [Colors.purple, Colors.deepPurple]),
              _buildFeatureCard("assets/images/device.png", "Device Status",
                  [Colors.orange, Colors.red]),
              _buildFeatureCard("assets/images/map.png", "Safe Sources",
                  [Colors.green, Colors.teal]),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ Profile Card
  Widget _buildProfileCard(ThemeProvider themeProvider) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, "/profile"),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: themeProvider.isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 32,
              backgroundImage: AssetImage("assets/images/profile.jpg"),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Hello Bristi 👋",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text("Trust yourself and keep going.",
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.teal, size: 20),
          ],
        ),
      ),
    );
  }

  // ✅ Feature Card
  Widget _buildFeatureCard(
      String imagePath, String title, List<Color> gradientColors) {
    return InkWell(
      onTap: () {},
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.35), BlendMode.darken),
            ),
          ),
          child: Center(
            child: Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
