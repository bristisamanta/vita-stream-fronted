import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../l10n/app_localizations.dart';

class WavePainter extends CustomPainter {
  final double progress;
  final bool isScanning;

  WavePainter({required this.progress, required this.isScanning});

  @override
  void paint(Canvas canvas, Size size) {
    if (!isScanning) return;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    for (int i = 0; i < 3; i++) {
      final radius = maxRadius * (progress + i * 0.3).clamp(0.0, 1.0);
      paint.color = const Color(0xFFB7D9EB).withOpacity(0.25 - i * 0.07);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isScanning != isScanning;
  }
}

class PairingScreen extends StatefulWidget {
  const PairingScreen({super.key});

  @override
  State<PairingScreen> createState() => _PairingScreenState();
}

class _PairingScreenState extends State<PairingScreen> with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> devices = [
    {"name": "ESP32_Sensor_01", "battery": 85, "connected": true, "sensorStatus": "OK"},
    {"name": "ESP32_Sensor_02", "battery": 60, "connected": false, "sensorStatus": "Needs Calibration"},
  ];

  late AnimationController _waveController;
  bool isScanning = false;
  String status = "";

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void startScan() {
    final t = AppLocalizations.of(context)!;
    setState(() {
      isScanning = true;
      status = t.scanningDevices;
    });

    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        isScanning = false;
        status = devices.isEmpty ? t.noDevicesFound : t.scanComplete;
      });
    });
  }

  void connectToDevice(Map<String, dynamic> device) {
    final t = AppLocalizations.of(context)!;
    setState(() {
      status = t.connectingTo(device["name"]);
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        status = t.connectedTo(device["name"]);
      });
      showPairingWizard(device);
    });
  }

  void showPairingWizard(Map<String, dynamic> device) {
    final t = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black.withOpacity(0.8)
          : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(t.pairingWizard(device["name"]),
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color)),
              const SizedBox(height: 20),
              Text(t.stepEnterWifiCredentials,
                  style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
              const TextField(
                decoration: InputDecoration(labelText: "WiFi SSID"),
              ),
              const TextField(
                decoration: InputDecoration(labelText: "WiFi Password"),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    status = t.devicePairedSuccessfully;
                  });
                },
                child: Text(t.finishPairing),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget gradientButton(String text, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF007AFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.blueAccent.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF0F2027), const Color(0xFF203A43), const Color(0xFF2C5364)]
              : [const Color(0xFFB7D9EB), const Color(0xFFDEEFFF), const Color(0xFFAACCE0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            width: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _waveController,
                  builder: (_, __) {
                    return CustomPaint(
                      painter: WavePainter(progress: _waveController.value, isScanning: isScanning),
                      size: const Size(180, 180),
                    );
                  },
                ),
                Lottie.asset(
                  "assets/lottie/scanning.json",
                  height: 120,
                  repeat: true,
                ),
              ],
            ),
          ),
          if (status.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                status,
                style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
              ),
            ),
          Expanded(
            child: devices.isEmpty && !isScanning
                ? Center(child: Lottie.asset("assets/lottie/no-devices.json", height: 150))
                : ListView.builder(
                    itemCount: devices.length,
                    itemBuilder: (context, index) {
                      final device = devices[index];
                      return buildDeviceCard(device, isDark);
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: GestureDetector(
              onTap: startScan,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: isDark
                        ? [Colors.blueGrey.shade900, Colors.blueGrey.shade700]
                        : [const Color(0xFFB7D9EB), const Color(0xFFAACCE0), const Color(0xFF7FB3D5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 18, spreadRadius: 3)],
                ),
                child: Center(
                  child: Text(
                    isScanning ? AppLocalizations.of(context)!.scanning : AppLocalizations.of(context)!.scanDevices,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDeviceCard(Map<String, dynamic> device, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark ? Colors.black54 : Colors.white.withOpacity(0.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${AppLocalizations.of(context)!.battery}: ${device["battery"]}%"),
          Text("${AppLocalizations.of(context)!.status}: ${device["sensorStatus"]}"),
          Text("${AppLocalizations.of(context)!.connected}: ${device["connected"] ? "Yes" : "No"}"),
        ],
      ),
    );
  }
}
