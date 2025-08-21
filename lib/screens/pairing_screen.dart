import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WavePainter extends CustomPainter {
  final double progress;
  final bool isScanning;

  WavePainter({required this.progress, required this.isScanning});

  @override
  void paint(Canvas canvas, Size size) {
    if (!isScanning) return;

    final Paint paint = Paint()
      ..color = Colors.teal.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    for (int i = 0; i < 3; i++) {
      final radius = maxRadius * (progress + i * 0.3).clamp(0.0, 1.0);
      paint.color = Colors.teal.withOpacity(0.2 - i * 0.05);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isScanning != isScanning;
  }
}

class PairingScreen extends StatefulWidget {
  const PairingScreen({super.key});

  @override
  State<PairingScreen> createState() => _PairingScreenState();
}

class _PairingScreenState extends State<PairingScreen>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> devices = [
    {
      "name": "ESP32_Sensor_01",
      "battery": 85,
      "connected": true,
      "sensorStatus": "OK"
    },
    {
      "name": "ESP32_Sensor_02",
      "battery": 60,
      "connected": false,
      "sensorStatus": "Needs Calibration"
    }
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
    setState(() {
      isScanning = true;
      status = "Scanning WiFi devices...";
    });

    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        isScanning = false;
        status = devices.isEmpty ? "No devices found ❌" : "Scan complete ✅";
      });
    });
  }

  void connectToDevice(Map<String, dynamic> device) {
    setState(() {
      status = "Connecting to ${device["name"]}...";
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        status = "Connected to ${device["name"]} ✅";
      });

      // Show pairing wizard
      showPairingWizard(device);
    });
  }

  // 🔹 Device Pairing Wizard
  void showPairingWizard(Map<String, dynamic> device) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Pairing Wizard: ${device["name"]}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              const Text("Step 1: Enter WiFi credentials"),
              const TextField(
                decoration: InputDecoration(labelText: "WiFi SSID"),
              ),
              const TextField(
                decoration: InputDecoration(labelText: "WiFi Password"),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    status = "Device paired successfully 🎉";
                  });
                },
                child: const Text("Finish Pairing"),
              ),
            ],
          ),
        );
      },
    );
  }

  // 🔹 Device Card with extra features
  Widget buildDeviceCard(Map<String, dynamic> device) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.wifi, color: Colors.teal, size: 30),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  device["name"],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () => connectToDevice(device),
                child: const Text("Pair"),
              )
            ],
          ),
          const SizedBox(height: 8),
          Text("Battery: ${device["battery"]}%"),
          Text("Status: ${device["sensorStatus"]}"),
          Text("Connected: ${device["connected"] ? "Yes ✅" : "No ❌"}"),
          const SizedBox(height: 10),
          Row(
            children: [
              TextButton(
                onPressed: () => setState(() {
                  status = "Calibrating ${device["name"]}...";
                }),
                child: const Text("Calibrate"),
              ),
              TextButton(
                onPressed: () => setState(() {
                  status = "Updating firmware of ${device["name"]}...";
                }),
                child: const Text("OTA Update"),
              ),
              TextButton(
                onPressed: () => setState(() {
                  status = "Opening settings for ${device["name"]}";
                }),
                child: const Text("Settings"),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    painter: WavePainter(
                      progress: _waveController.value,
                      isScanning: isScanning,
                    ),
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
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

        Expanded(
          child: devices.isEmpty && !isScanning
              ? Center(
                  child:
                      Lottie.asset("assets/lottie/no-devices.json", height: 150),
                )
              : ListView.builder(
                  itemCount: devices.length,
                  itemBuilder: (context, index) =>
                      buildDeviceCard(devices[index]),
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
                gradient: const LinearGradient(
                  colors: [Colors.teal, Colors.green],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: isScanning
                    ? [
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.6),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: Text(
                  isScanning ? "Scanning..." : "Scan Devices",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
