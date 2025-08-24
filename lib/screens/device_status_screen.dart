import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
// ✅ localization import
import '../l10n/app_localizations.dart';

class DeviceStatusScreen extends StatefulWidget {
  const DeviceStatusScreen({super.key});

  @override
  State<DeviceStatusScreen> createState() => _DeviceStatusScreenState();
}

class _DeviceStatusScreenState extends State<DeviceStatusScreen> {
  double batteryLevel = 0.85;
  double syncProgress = 0.6;
  bool isConnected = true;
  String connectedDeviceName = "VitaStream Device 001"; // ✅ keep, name can also be localized if needed

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!; // ✅ use localization
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(t.deviceStatusTitle), // ✅ localized
      ),
      body: Container(
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Connected Device Name
                if (isConnected)
                  _glassCard(
                    Column(
                      children: [
                        Text(
                          t.connectedDevice, // ✅ localized
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          connectedDeviceName,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),
                // Battery Level
                _glassCard(
                  Column(
                    children: [
                      Text(
                        t.batteryLevel, // ✅ localized
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      LinearPercentIndicator(
                        lineHeight: 20,
                        percent: batteryLevel,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        progressColor: Colors.green,
                        barRadius: const Radius.circular(12),
                        center: Text(
                          "${(batteryLevel * 100).toInt()}%",
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        animation: true,
                        animationDuration: 800,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Device Connection
                _glassCard(
                  Column(
                    children: [
                      Text(
                        t.deviceConnection, // ✅ localized
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isConnected ? t.connected : t.disconnected, // ✅ localized
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isConnected ? Colors.teal : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isConnected = !isConnected;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isConnected ? Colors.teal : Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          isConnected ? t.disconnect : t.connect, // ✅ localized
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Sync Now
                _glassCard(
                  Column(
                    children: [
                      Text(
                        t.syncNow, // ✅ localized
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      LinearPercentIndicator(
                        lineHeight: 20,
                        percent: syncProgress,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        progressColor: Colors.orange,
                        barRadius: const Radius.circular(12),
                        center: Text(
                          "${(syncProgress * 100).toInt()}%",
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        animation: true,
                        animationDuration: 1000,
                        animateFromLastPercent: true,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            syncProgress = 0.0;
                            // Simulate syncing
                            Future.delayed(const Duration(milliseconds: 100),
                                () {
                              setState(() {
                                syncProgress = 1.0;
                              });
                            });
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          t.startSync, // ✅ localized
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Last Update
                _glassCard(
                  Column(
                    children: [
                      Text(
                        t.lastUpdate, // ✅ localized
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        t.lastUpdateMessage, // ✅ localized
                        style: const TextStyle(
                            fontSize: 16, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(vertical: 8),
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
}
