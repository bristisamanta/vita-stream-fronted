import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

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
  String factOfTheDay = "💡 Loading fact...";

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _fetchRandomFact();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _fetchRandomFact() async {
    final url =
        Uri.parse("https://uselessfacts.jsph.pl/api/v2/facts/random?language=en");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          factOfTheDay = "💡 Fact of the Day: ${data["text"]}";
        });
      } else {
        setState(() {
          factOfTheDay = "💡 Stay hydrated and safe!";
        });
      }
    } catch (e) {
      setState(() {
        factOfTheDay = "💡 Could not load fact. Try again later.";
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

  Widget _buildInfoCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 12, color: Colors.black54)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String text, String assetPath, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          SvgPicture.asset(assetPath, height: 28, width: 28, color: bgColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _simulatePHChange,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Pulsing Badge
            ScaleTransition(
              scale: Tween(begin: 1.0, end: 1.1).animate(
                CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
              ),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSafe ? Colors.green.shade300 : Colors.red.shade300,
                ),
                child: Column(
                  children: [
                    Lottie.asset(
                      "assets/lottie/fact.json",
                      width: 100,
                      height: 100,
                      repeat: true,
                    ),
                    Text(
                      isSafe ? "Safe Water" : "Unsafe Water",
                      style: const TextStyle(
                          fontSize: 18,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: _buildInfoCard(
                        "pH Value", "$pH", Icons.science, Colors.teal)),
                const SizedBox(width: 10),
                Expanded(
                    child: _buildInfoCard("Battery", "$battery%",
                        Icons.battery_std, Colors.orange)),
                const SizedBox(width: 10),
                Expanded(
                    child: _buildInfoCard(
                        "Last Sync", lastSync, Icons.sync, Colors.blue)),
              ],
            ),
            const SizedBox(height: 20),

            // Safe Water Tips
            Align(
              alignment: Alignment.centerLeft,
              child: Text("✅ Safe Water Tips",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: const Color.fromARGB(255, 225, 233, 225))),
            ),
            const SizedBox(height: 8),
            _buildTipItem("Boil water before drinking", "assets/lottie/boil.json",
                Colors.green),
            const SizedBox(height: 8),
            _buildTipItem("Use proper water filters", "assets/lottie/filter.json",
                Colors.teal),
            const SizedBox(height: 8),
            _buildTipItem("Store in clean, closed containers",
                "assets/lottie/container.json", Colors.blue),

            const SizedBox(height: 20),

            // Unsafe Water Steps
            Align(
              alignment: Alignment.centerLeft,
              child: Text("⚠️ Unsafe Water Actions",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.red.shade700)),
            ),
            const SizedBox(height: 8),
            _buildTipItem("Avoid drinking until tested", "assets/icons/warning.svg",
                 Colors.red),
            const SizedBox(height: 8),
            _buildTipItem("Report to local authority", "assets/icons/report.svg", 
                Colors.orange),

            const SizedBox(height: 20),

            // Fact of the Day
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.yellow.shade100,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                factOfTheDay,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
