import 'package:flutter/material.dart';

// Professional animated card wrapper
// Provides smooth fade-in and slide-up animation
// Used for staggered entrance animations
// Clean, professional feel - not flashy
class AnimatedCard extends StatefulWidget {
  final Widget child;
  final int delay; // Delay in milliseconds for staggered effect
  final Duration duration; // Animation duration

  const AnimatedCard({
    super.key,
    required this.child,
    this.delay = 0,
    this.duration = const Duration(milliseconds: 400), // Professional timing
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    // Fade in animation - smooth opacity transition
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut, // Professional easing
    ));

    // Slide up animation - subtle movement
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08), // Subtle slide up - professional
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic, // Smooth cubic easing for premium feel
    ));

    // Subtle scale animation for premium feel
    _scaleAnimation = Tween<double>(
      begin: 0.95, // Start slightly smaller
      end: 1.0, // End at full size
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    // Start animation after delay for staggered effect
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: widget.child,
        ),
      ),
    );
  }
}

