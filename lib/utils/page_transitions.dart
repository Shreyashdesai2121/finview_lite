import 'package:flutter/material.dart';

// Professional page transition animations
// Clean fade + slide transitions for smooth navigation
// Used for route transitions between screens
class PageTransitions {
  // Smooth fade + slide transition for professional feel
  // Used when navigating between login and dashboard
  static Route<T> fadeSlideRoute<T extends Object?>(
    Widget page, {
    RouteSettings? settings,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Fade animation - smooth opacity transition
        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut, // Professional easing
          ),
        );

        // Slide animation - subtle upward movement
        final slideAnimation = Tween<Offset>(
          begin: const Offset(0.0, 0.02), // Very subtle slide
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
        );

        // Combine fade and slide for professional transition
        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300), // Professional timing
    );
  }
}

