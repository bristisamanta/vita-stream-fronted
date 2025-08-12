import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

// Import your onboarding screen here
import 'package:vitastream/screens/onboarding_login_screen.dart';  // Adjust path accordingly

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Animation setup
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(); // Loop wave movement

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    // Navigate after delay
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingLoginScreen()),
      );
    });
  }  // <-- Important closing bracket here

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFB7D3C6), // Sage green
                  Color(0xFFB3E5FC), // Sky blue
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Moving Waves
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: WavePainter(_controller.value),
                size: Size.infinite,
              );
            },
          ),

          // Logo & text
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo in Card
                  Card(
                    elevation: 4,
                    color: Colors.white.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Icon(
                        Icons.water_drop,
                        size: 80,
                        color: Colors.teal.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Connecting Your World to Safe Water",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black26,
                          offset: Offset(1, 1),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// WavePainter remains unchanged
class WavePainter extends CustomPainter {
  final double animationValue;

  WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.2);
    final path = Path();

    const waveHeight = 20.0;
    const waveLength = 200.0; // Smaller = more waves

    path.moveTo(0, size.height * 0.8);
    for (double i = 0; i <= size.width + waveLength; i += waveLength) {
      path.quadraticBezierTo(
        i + waveLength / 4 - animationValue * waveLength,
        size.height * 0.8 - waveHeight,
        i + waveLength / 2 - animationValue * waveLength,
        size.height * 0.8,
      );
      path.quadraticBezierTo(
        i + 3 * waveLength / 4 - animationValue * waveLength,
        size.height * 0.8 + waveHeight,
        i + waveLength - animationValue * waveLength,
        size.height * 0.8,
      );
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) => true;
}
