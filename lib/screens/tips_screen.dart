import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import '../l10n/app_localizations.dart'; // ✅ Add localization

class TipsScreen extends StatefulWidget {
  const TipsScreen({super.key});

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen>
    with SingleTickerProviderStateMixin {
  double pH = 7.2;
  double battery = 78;
  String lastSync = "5 min ago";
  bool isSafe = true;
  String factOfTheDay = "";

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _fetchRandomFact();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _fetchRandomFact() async {
    final t = AppLocalizations.of(context)!;
    final url =
        Uri.parse("https://uselessfacts.jsph.pl/api/v2/facts/random?language=en");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          factOfTheDay = "💡 ${data["text"]}";
        });
      } else {
        setState(() {
          factOfTheDay = t.factFallback;
        });
      }
    } catch (e) {
      setState(() {
        factOfTheDay = t.factError;
      });
    }
  }

  void _simulatePHChange() {
    setState(() {
      if (isSafe) {
        pH = 5.8;
        isSafe = false;
      } else {
        pH = 7.2;
        isSafe = true;
      }
    });
    _fetchRandomFact();
  }

  Widget _glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon, Color color) {
    return _glassCard(
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 12, color: Colors.white70)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String text, String assetPath, Color bgColor) {
    return _glassCard(
      child: Row(
        children: [
          SvgPicture.asset(assetPath, height: 30, width: 30, color: bgColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundGradient = isDark
        ? LinearGradient(
            colors: [Colors.blueGrey.shade900, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : (isSafe
            ? LinearGradient(
                colors: [Colors.teal.shade700, Colors.green.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [Colors.red.shade700, Colors.orange.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ));

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        child: SafeArea(
          child: GestureDetector(
            onTap: _simulatePHChange,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  // Pulsing Badge
                  ScaleTransition(
                    scale: Tween(begin: 1.0, end: 1.15).animate(
                      CurvedAnimation(
                          parent: _pulseController, curve: Curves.easeInOut),
                    ),
                    child: _glassCard(
                      child: Column(
                        children: [
                          Lottie.asset(
                            "assets/lottie/fact.json",
                            width: 120,
                            height: 120,
                            repeat: true,
                          ),
                          Text(
                            isSafe ? t.safeWater : t.unsafeWater,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Info Cards
                  Row(
                    children: [
                      Expanded(
                          child: _buildInfoCard(
                              t.phValue, "$pH", Icons.science, Colors.tealAccent)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _buildInfoCard(
                              t.battery, "$battery%", Icons.battery_charging_full,
                              Colors.orangeAccent)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _buildInfoCard(
                              t.lastSync, lastSync, Icons.sync, Colors.blueAccent)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(t.safeTips,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.tealAccent.shade100)),
                  ),
                  const SizedBox(height: 12),
                  _buildTipItem(t.boilWater, "assets/lottie/boil.json",
                      Colors.greenAccent),
                  const SizedBox(height: 10),
                  _buildTipItem(
                      t.useFilters, "assets/lottie/filter.json", Colors.tealAccent),
                  const SizedBox(height: 10),
                  _buildTipItem(t.cleanContainers, "assets/lottie/container.json",
                      Colors.blueAccent),

                  const SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(t.unsafeActions,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.redAccent.shade100)),
                  ),
                  const SizedBox(height: 12),
                  _buildTipItem(t.avoidDrinking, "assets/icons/warning.svg",
                      const Color.fromARGB(255, 246, 81, 81)),
                  const SizedBox(height: 10),
                  _buildTipItem(t.reportAuthority, "assets/icons/report.svg",
                      const Color.fromARGB(255, 240, 205, 160)),

                  const SizedBox(height: 20),

                  // Fact of the Day
                  _glassCard(
                    child: Text(
                      factOfTheDay.isEmpty ? t.factLoading : factOfTheDay,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
