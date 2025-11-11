import 'package:flutter/material.dart';

// Professional shimmer loading effect
// Clean, subtle shimmer animation for loading states
// Used for skeleton loaders and loading cards
// Not flashy - just smooth, professional shimmer
class ShimmerLoader extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;

  const ShimmerLoader({
    super.key,
    required this.child,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
  });

  @override
  State<ShimmerLoader> createState() => _ShimmerLoaderState();
}

class _ShimmerLoaderState extends State<ShimmerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    
    // Smooth, continuous shimmer animation
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500), // Professional timing
      vsync: this,
    )..repeat(); // Loop continuously
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            // Create gradient that moves across
            final progress = _controller.value;
            return LinearGradient(
              begin: Alignment(-1.0 + progress * 2, 0),
              end: Alignment(1.0 + progress * 2, 0),
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

