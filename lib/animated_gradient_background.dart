import 'package:flutter/material.dart';



class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  final ScrollController scrollController;

  const AnimatedGradientBackground({
    Key? key,
    required this.child,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState
    extends State<AnimatedGradientBackground> {
  double scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(() {
      setState(() {
        scrollOffset = widget.scrollController.offset;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = [
      Color(0xFF05668D), // Deep teal
      Color(0xFF00A896), // Aqua
      Color(0xFF06D6A0), // Green
      Color(0xFFFFD166), // Orange
      Color(0xFFEF476F), // Red
    ];

    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors[(scrollOffset ~/ 100) % colors.length],
            colors[(scrollOffset ~/ 100 + 1) % colors.length],
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: widget.child,
    );
  }
}
