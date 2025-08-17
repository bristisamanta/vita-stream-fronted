import 'package:flutter/material.dart';

class FeatureCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final VoidCallback onTap;

  const FeatureCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.onTap,
  });

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    // Example gradient colors, you can customize as needed
    final List<Color> gradientColors = [
      Colors.blue.withOpacity(0.7),
      Colors.purple.withOpacity(0.7),
    ];
    return GestureDetector(
      onTap: widget.onTap,
      child: _buildFeatureCard(widget.imagePath, widget.title, gradientColors),
    );
  }

  // 🔹 Feature Card with Gradient + Image
  Widget _buildFeatureCard(String imagePath, String title, List<Color> colors) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.25), // dark overlay
              BlendMode.darken,
            ),
          ),
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

}
