import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pairing Screen Demo',
      theme: ThemeData(useMaterial3: true),
      home: const PairingScreen(),
    );
  }
}

class PairingScreen extends StatefulWidget {
  const PairingScreen({super.key});

  @override
  State<PairingScreen> createState() => _PairingScreenState();
}

class _PairingScreenState extends State<PairingScreen>
    with SingleTickerProviderStateMixin {
  final List<String> devices = ["Device_01", "Device_02", "Device_03"];
  String status = "";
  bool isScanning = false;
  int selectedIndex = 1;

  late AnimationController _waveController;

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

  void onNavTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF9C4), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Bluetooth with Waves
              SizedBox(
                height: 150,
                width: 150,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Waves
                    AnimatedBuilder(
                      animation: _waveController,
                      builder: (_, __) {
                        return CustomPaint(
                          painter: WavePainter(
                            progress: _waveController.value,
                            isScanning: isScanning,
                          ),
                          size: const Size(150, 150),
                        );
                      },
                    ),
                    // Bluetooth Icon
                    Icon(
                      Icons.bluetooth,
                      size: 60,
                      color: isScanning
                          ? Colors.blueAccent
                          : Colors.grey.shade700,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Pair Device",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Scan and connect to your BLE device",
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 20),

              // Device List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: devices.length,
                  itemBuilder: (context, index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.white, Color(0xFFFFFDE7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.bluetooth,
                          color: Color(0xFF00A896),
                        ),
                        title: Text(
                          devices[index],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00A896),
                          ),
                          onPressed: () {
                            setState(() {
                              status = "Connecting to ${devices[index]}...";
                            });
                            Future.delayed(const Duration(seconds: 2), () {
                              setState(() {
                                status = "Connected to ${devices[index]} ✅";
                              });
                            });
                          },
                          child: const Text("Connect"),
                        ),
                      ),
                    );
                  },
                ),
              ),

              if (status.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    status,
                    style: const TextStyle(color: Colors.black87),
                  ),
                ),

              // Scan Button
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.search),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    setState(() {
                      status = "Scanning for devices...";
                      isScanning = true;
                    });
                    Future.delayed(const Duration(seconds: 4), () {
                      setState(() {
                        isScanning = false;
                        status = "Scan complete ✅";
                      });
                    });
                  },
                  label: const Text("Scan Devices"),
                ),
              ),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Colors.orangeAccent,
        unselectedItemColor: Colors.grey,
        onTap: onNavTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb), label: "Tips"),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double progress;
  final bool isScanning;

  WavePainter({required this.progress, required this.isScanning});

  @override
  void paint(Canvas canvas, Size size) {
    if (!isScanning) return;

    final Paint paint = Paint()
      ..color = Colors.blueAccent.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    double maxRadius = size.width / 2;
    for (int i = 0; i < 3; i++) {
      double radius = (progress + i / 3) % 1 * maxRadius;
      paint.color = Colors.blueAccent.withOpacity(
        (1 - radius / maxRadius) * 0.3,
      );
      canvas.drawCircle(size.center(Offset.zero), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isScanning != isScanning;
  }
}
