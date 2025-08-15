import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PairingScreen extends StatefulWidget {
  const PairingScreen({super.key});

  @override
  State<PairingScreen> createState() => _PairingScreenState();
}

// Custom painter for animated background waves
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

    // Draw 3 animated waves
    for (int i = 0; i < 3; i++) {
      final radius = maxRadius * (progress + i * 0.3).clamp(0.0, 1.0);
      paint.color = Colors.teal.withOpacity(0.2 - i * 0.05);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isScanning != isScanning;
  }
}

class _PairingScreenState extends State<PairingScreen>
    with SingleTickerProviderStateMixin {
  final List<String> devices = ["Device_01", "Device_02", "Device_03"];
  late AnimationController _waveController; // ✅ Declared
  bool isScanning = false;
  String status = "";
  int selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    // ✅ Initialize _waveController here
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose(); // ✅ Dispose it
    super.dispose();
  }

  void onNavTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void startScan() {
    setState(() {
      isScanning = true;
      status = "Scanning for devices...";
    });

    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        isScanning = false;
        status = devices.isEmpty ? "No devices found ❌" : "Scan complete ✅";
      });
    });
  }

  void connectToDevice(String device) {
    setState(() {
      status = "Connecting to $device...";
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        status = "Connected to $device ✅";
      });
    });
  }

  Widget buildDeviceCard(String name) {
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
      child: Row(
        children: [
          const Icon(Icons.bluetooth, color: Colors.teal, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            onPressed: () => connectToDevice(name),
            child: const Text("Connect"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        title: const Text("Pair Device"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // Bluetooth with Lottie animation from assets
          SizedBox(
            height: 180,
            width: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background waves
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

                // Lottie animation
                Lottie.asset(
                  "assets/lottie/scanning.json", // Make sure path exists in pubspec.yaml
                  height: 120,
                  repeat: true,
                ),
              ],
            ),
          ),

          // Status Text
          if (status.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                status,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

          // Device List
          Expanded(
            child: devices.isEmpty && !isScanning
                ? Center(
                    child: Lottie.asset("assets/lottie/no-devices.json", height: 150),
                  )
                : ListView.builder(
                    itemCount: devices.length,
                    itemBuilder: (context, index) =>
                        buildDeviceCard(devices[index]),
                  ),
          ),

          // Scan Button
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
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: onNavTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb), label: "Tips"),
        ],
      ),
    );
  }
}
