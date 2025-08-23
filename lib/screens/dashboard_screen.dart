import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lottie/lottie.dart';
import '../l10n/app_localizations.dart';

// ✅ Providers
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';

// ✅ Import the global plugin instance
import '../main.dart'; // gives access to flutterLocalNotificationsPlugin

// Screens
import 'pairing_screen.dart';
import 'map_screen.dart';
import 'tips_screen.dart';
import 'water_intake_screen.dart'; // ✅ NEW IMPORT

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 1;
  bool showRiskBanner = true;
  bool isLoading = false;

  Future<void> fetchRiskData() async {
    setState(() => isLoading = true);
    try {
      await Future.delayed(const Duration(seconds: 2));
      final response = {"risk": true};
      if (response["risk"] == true) {
        setState(() => showRiskBanner = true);
      }
    } catch (e) {
      debugPrint("API error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch risk data")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> showAlertNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'alert_channel',
      'Water Alerts',
      channelDescription: 'Notifications about unsafe water quality',
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

    setState(() {
      showRiskBanner = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchRiskData();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    final localeProvider = Provider.of<LocaleProvider>(context, listen: true);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Widget> pages = [
      const PairingScreen(),
      _buildDashboardPage(context, isDark),
      const MapScreen(),
      const TipsScreen(),
    ];

    final List<String> titles = [
      AppLocalizations.of(context)!.pairDevice,
      "VitaStream",
      AppLocalizations.of(context)!.safeWaterSources,
      AppLocalizations.of(context)!.tips,
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
          PopupMenuButton<String>(
            icon: const Icon(Icons.language, color: Colors.white),
            onSelected: (value) {
              if (value == 'en') {
                localeProvider.setLocale(const Locale('en'));
              } else if (value == 'hi') {
                localeProvider.setLocale(const Locale('hi'));
              } else if (value == 'bn') {
                localeProvider.setLocale(const Locale('bn'));
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'en', child: Text("English")),
              const PopupMenuItem(value: 'hi', child: Text("हिन्दी")),
              const PopupMenuItem(value: 'bn', child: Text("বাংলা")),
            ],
          ),
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: Colors.white,
            ),
            onPressed: () {
              themeProvider.toggleTheme(
                themeProvider.themeMode != ThemeMode.dark,
              );
            },
          ),
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
          backgroundColor: Colors.black.withOpacity(0.2),
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.bluetooth), label: "Pair"),
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

  Widget _buildDashboardPage(BuildContext context, bool isDark) {
    return Container(
      key: const ValueKey("dashboard"),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(182, 110, 197, 255),
            Color.fromARGB(127, 2, 96, 172),
            Color.fromARGB(223, 147, 202, 232)
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding:
            const EdgeInsets.only(top: 100, left: 16, right: 16, bottom: 20),
        child: Column(
          children: [
            if (isLoading)
              Center(
                child: Lottie.asset(
                  'assets/lottie/loading.json',
                  width: 100,
                  height: 100,
                ),
              ),
            if (showRiskBanner) ...[
              _glassCard(_buildRiskBanner()),
              const SizedBox(height: 16),
            ],
            _glassCard(_buildProfileCard(isDark)),
            const SizedBox(height: 20),
            _glassCard(_buildReadingsRow(isDark)),
            const SizedBox(height: 20),
            _glassCard(_buildFarmHealth(isDark)),
            const SizedBox(height: 20),
            _glassCard(_buildFeatureGrid(context)),
            const SizedBox(height: 20),
            _glassCard(_buildVideoPlaceholder()),
          ],
        ),
      ),
    );
  }

  Widget _glassCard(Widget child) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildRiskBanner() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const Icon(Icons.warning, color: Colors.red, size: 28),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "⚠️ Unsafe Water Quality Detected!",
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () {
              setState(() {
                showRiskBanner = false;
              });
            },
          )
        ],
      ),
    );
  }

  Widget _buildProfileCard(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundImage: AssetImage("assets/images/profile.jpg"),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              "Hello Bristi 👋\nTrust yourself and keep going.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.teal, size: 20),
        ],
      ),
    );
  }

  Widget _buildReadingsRow(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _readingCard("pH", "7.1", Colors.green, isDark),
          _readingCard("TDS", "220 ppm", Colors.orange, isDark),
          _readingCard("Nitrate", "High", Colors.red, isDark),
        ],
      ),
    );
  }

  Widget _readingCard(String label, String value, Color color, bool isDark) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            )),
      ],
    );
  }

  Widget _buildFarmHealth(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Farm Health Score",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black)),
          const SizedBox(height: 8),
          const LinearProgressIndicator(value: 0.75, minHeight: 12),
          const SizedBox(height: 8),
          Text("75% Healthy - Monitor water quality closely",
              style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _featureCard("Water Intake", Icons.water_drop, Colors.blue, onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WaterIntakeScreen()),
          );
        }),
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
          borderRadius: BorderRadius.circular(16),
          color: color.withOpacity(0.6),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
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

  Widget _buildVideoPlaceholder() {
    return Container(
      height: 200,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black.withOpacity(0.3),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: const Text("🎥 Tutorial Video Coming Soon",
          style: TextStyle(color: Colors.white)),
    );
  }
}
