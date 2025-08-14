import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:animated_background/animated_background.dart';
import '../main.dart';

class OnboardingLoginScreen extends StatefulWidget {
  const OnboardingLoginScreen({super.key});

  @override
  State<OnboardingLoginScreen> createState() => _OnboardingLoginScreenState();
}

class _OnboardingLoginScreenState extends State<OnboardingLoginScreen>
    with TickerProviderStateMixin {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        behaviour: RandomParticleBehaviour(
          options: ParticleOptions(
            baseColor: Colors.teal.shade300,
            spawnOpacity: 0.3,
            minOpacity: 0.1,
            maxOpacity: 0.5,
            spawnMinSpeed: 10.0,
            spawnMaxSpeed: 20.0,
            particleCount: 25,
            spawnMaxRadius: 20,
            spawnMinRadius: 10,
          ),
        ),
        vsync: this,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _controller,
                  onPageChanged: (index) {
                    setState(() => isLastPage = index == 2);
                  },
                  children: [
                    buildPage(
                      title: "Find Safe Water",
                      description: "Locate water sources around you instantly.",
                      imagePath: "assets/lottie/water_map.json",
                    ),
                    buildPage(
                      title: "Smart Pairing",
                      description:
                          "Connect with your water purifier or sensor seamlessly.",
                      imagePath: "assets/lottie/bluetooth.json",
                    ),
                    buildPage(
                      title: "Monitor Quality",
                      description:
                          "Track and ensure water safety anytime, anywhere.",
                      imagePath: "assets/lottie/water_quality.json",
                    ),
                  ],
                ),
              ),
              SmoothPageIndicator(
                controller: _controller,
                count: 3,
                effect: WormEffect(
                  activeDotColor: Colors.teal.shade700,
                  dotHeight: 10,
                  dotWidth: 10,
                ),
              ),
              const SizedBox(height: 20),
              isLastPage
                  ? buildLoginButton(context)
                  : buildSkipNextButtons(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPage({
    required String title,
    required String description,
    required String imagePath,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(imagePath, height: 250),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.teal.shade800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSkipNextButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
             Navigator.pushReplacementNamed(context, '/login');

            },
            child: const Text(
              "Skip",
              style: TextStyle(fontSize: 18),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _controller.nextPage(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal.shade600,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Next"),
          ),
        ],
      ),
    );
  }

  Widget buildLoginButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, '/login');
      },
      child: Lottie.asset(
        "assets/lottie/login_button.json",
        height: 100,
        repeat: true,
      ),
    );
  }
}
