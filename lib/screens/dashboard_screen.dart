import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../theme_state.dart';
import '../main.dart';
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
  bool showRiskBanner = true; // 👈 state to control top notification

  // ✅ Local Notification
  Future<void> showAlertNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'alert_channel',
      'Water Alerts',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      "Unsafe Water Quality!",
      "Tap to view details",
      platformDetails,
      payload: "alert",
    );

    // Also show banner inside dashboard
    setState(() {
      showRiskBanner = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final List<Widget> pages = [
      const PairingScreen(),
      _buildDashboardPage(context), // 👈 new dashboard page
      const MapScreen(),
      const TipsScreen(),
    ];

    final List<String> titles = [
      "Pair Device",
      "VitaStream",
      "Safe Water Sources",
      "Tips",
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          titles[_selectedIndex],
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: showAlertNotification,
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, "/settings"),
          ),
        ],
      ),

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: pages[_selectedIndex],
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

  // ✅ Dashboard Page with Gradient + New Features + Risk Banner
  Widget _buildDashboardPage(BuildContext context) {
    return Container(
      key: const ValueKey("dashboard"),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color.fromARGB(182, 110, 197, 255), Color.fromARGB(127, 2, 96, 172), Color.fromARGB(223, 147, 202, 232)],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 100, left: 16, right: 16, bottom: 20),
        child: Column(
          children: [
            if (showRiskBanner) _buildRiskBanner(), // 👈 Top Risk Notification
            const SizedBox(height: 16),
            _buildProfileCard(),
            const SizedBox(height: 20),
            _buildReadingsRow(),
            const SizedBox(height: 20),
            _buildFarmHealth(),
            const SizedBox(height: 20),
            _buildFeatureGrid(context),
            const SizedBox(height: 20),
            _buildVideoPlaceholder(),
          ],
        ),
      ),
    );
  }

// ✅ Risk Notification Banner (Top of Dashboard)
Widget _buildRiskBanner() {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, "/alert"); // 👈 Goes to AlertScreen
    },
    child: Dismissible(
      key: const ValueKey("riskBanner"),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        setState(() {
          showRiskBanner = false;
        });
      },
      background: Container(color: Colors.transparent),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(221, 238, 82, 70).withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning, color: Colors.white),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                "⚠️ Unsafe Water Quality Detected! Tap for details.",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () =>
                  setState(() => showRiskBanner = false),
            ),
          ],
        ),
      ),
    ),
  );
}


  // ✅ Profile Card (Clickable)
  Widget _buildProfileCard() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, "/profile"),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: const [
            CircleAvatar(
                radius: 28,
                backgroundImage: AssetImage("assets/images/profile.jpg")),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                "Hello Bristi 👋\nTrust yourself and keep going.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.teal, size: 20),
          ],
        ),
      ),
    );
  }

  // ✅ Readings Row
  Widget _buildReadingsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _readingCard("pH", "7.1", Colors.green),
        _readingCard("TDS", "220 ppm", Colors.orange),
        _readingCard("Nitrate", "High", Colors.red),
      ],
    );
  }

  Widget _readingCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label,
              style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ✅ Farm Health
  Widget _buildFarmHealth() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("Farm Health Score",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          LinearProgressIndicator(value: 0.75, minHeight: 12),
          SizedBox(height: 8),
          Text("75% Healthy - Monitor water quality closely"),
        ],
      ),
    );
  }

  // ✅ Feature Grid
  Widget _buildFeatureGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _featureCard("Water Intake", Icons.water_drop, Colors.blue),
        _featureCard("Reminders", Icons.alarm, Colors.purple),
        _featureCard("Device Status", Icons.devices, Colors.orange),
        _featureCard("Safe Sources", Icons.map, Colors.green),
        _featureCard("Alerts", Icons.warning, Colors.red, onTap: () {
          Navigator.pushNamed(context, "/alert");
        }),
      ],
    );
  }

  Widget _featureCard(String title, IconData icon, Color color,
      {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.85),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 30),
              const SizedBox(height: 8),
              Text(title,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Video Placeholder
  Widget _buildVideoPlaceholder() {
    return Container(
      height: 200,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text("🎥 Tutorial Video Coming Soon",
          style: TextStyle(color: Colors.white)),
    );
  }
}
