import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lottie/lottie.dart';
import '../l10n/app_localizations.dart';

// Providers
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';

// Global plugin & navigator
import '../main.dart';

// Screens
import 'pairing_screen.dart';
import 'map_screen.dart';
import 'tips_screen.dart';
import 'water_intake_screen.dart';
import 'remainder_screen.dart';
import 'device_status_screen.dart';
import 'safe_sources_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String blockchainStatus = "";
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
      final t = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.fetchRiskFailed)),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> showAlertNotification() async {
    // Use navigatorKey to get a context when called from anywhere
    final ctx = navigatorKey.currentContext ?? context;
    final t = AppLocalizations.of(ctx)!;

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
      t.notificationUnsafeTitle,
      t.notificationUnsafeBody,
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
    final t = AppLocalizations.of(context)!;

    final List<Widget> pages = [
      const PairingScreen(),
      _buildDashboardPage(context, isDark),
      const MapScreen(),
      const TipsScreen(),
    ];

    final List<String> titles = [
      t.pairDevice,
      t.appName,              // previously "VitaStream"
      t.safeWaterSources,
      t.tips,
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
              context.read<LocaleProvider>().setLocale(Locale(value));
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'en', child: Text(t.languageEnglish)),
              PopupMenuItem(value: 'hi', child: Text(t.languageHindi)),
              PopupMenuItem(value: 'bn', child: Text(t.languageBengali)),
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
          items: [
            BottomNavigationBarItem(icon: const Icon(Icons.bluetooth), label: t.bottomPair),
            BottomNavigationBarItem(icon: const Icon(Icons.dashboard), label: t.bottomDashboard),
            BottomNavigationBarItem(icon: const Icon(Icons.map), label: t.bottomMap),
            BottomNavigationBarItem(icon: const Icon(Icons.lightbulb), label: t.bottomTips),
          ],
        ),
      ),
    );
  }

  /// Blockchain Navigation Banner
  Widget _buildBlockchainBanner(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blueAccent.withOpacity(0.7),
            Colors.purpleAccent.withOpacity(0.7)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.blockchainServices,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBannerAction(context, Icons.account_balance_wallet, t.wallet, '/wallet'),
              _buildBannerAction(context, Icons.send, t.sendTx, '/tx'),
              _buildBannerAction(context, Icons.verified_user, t.subsidy, '/subsidy'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBannerAction(
      BuildContext context, IconData icon, String label, String route) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  /// Main Dashboard Page
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

            _buildBlockchainBanner(context),
            const SizedBox(height: 24),

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
    final t = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.withOpacity(0.85), Colors.orange.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: ListTile(
          leading: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.white,
            size: 36,
          ),
          title: Text(
            t.riskBannerTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
         subtitle: const Text(
  "Immediate action required ⚠",
  style: TextStyle(color: Colors.white70, fontSize: 14),
),

          trailing: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              setState(() {
                showRiskBanner = false;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(bool isDark) {
    final t = AppLocalizations.of(context)!;
    return InkWell(
      onTap: () => Navigator.pushNamed(context, "/profile"),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.teal.shade700, Colors.blueGrey.shade800]
                : [Colors.tealAccent.shade100, Colors.blue.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage("assets/images/profile.jpg"),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Localize with a placeholder for name
                  Text(
                    t.helloName("Bristi"),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    t.dashboardMotto,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadingsRow(bool isDark) {
    final t = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _readingCard(t.readingPH, "7.1", Icons.science, Colors.green, isDark),
          _readingCard(t.readingTDS, "220 ppm", Icons.water_drop, Colors.orange, isDark),
          _readingCard(t.readingNitrate, t.readingHigh, Icons.warning, Colors.red, isDark),
        ],
      ),
    );
  }

  Widget _readingCard(String label, String value, IconData icon, Color color, bool isDark) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: isDark
              ? [Colors.teal.shade900, Colors.teal.shade700]
              : [Colors.white.withOpacity(0.8), Colors.teal.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(2, 4),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFarmHealth(bool isDark) {
    final t = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.farmHealthTitle,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black)),
          const SizedBox(height: 8),
          const LinearProgressIndicator(value: 0.75, minHeight: 12),
          const SizedBox(height: 8),
          Text(t.farmHealthHint(75),
              style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _featureCard(t.featureWaterIntake, Icons.water_drop, Colors.blue, onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WaterIntakeScreen()),
          );
        }),
        _featureCard(t.featureReminders, Icons.alarm, Colors.purple, onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RemindersScreen()),
          );
        }),
        _featureCard(t.featureDeviceStatus, Icons.devices, Colors.orange, onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DeviceStatusScreen()),
          );
        }),
        _featureCard(t.featureSafeSources, Icons.map, Colors.green, onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SafeSourcesScreen()),
          );
        }),
        _featureCard(t.featureAlerts, Icons.warning, Colors.red, onTap: () {
          Navigator.pushNamed(context, "/alert");
        }),
      ],
    );
  }

  Widget _featureCard(String title, IconData icon, Color color, {VoidCallback? onTap}) {
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
    final t = AppLocalizations.of(context)!;
    return Container(
      height: 200,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black.withOpacity(0.3),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Text(
        t.videoComingSoon,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}