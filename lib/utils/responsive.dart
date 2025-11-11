import 'package:flutter/material.dart';

// Helper class for making the app responsive across different screen sizes
// Handles mobile, tablet, and desktop breakpoints
class Responsive {
  // Breakpoints for different device types
  static const double mobileBreakpoint = 600; // Below 600px = mobile
  static const double tabletBreakpoint = 1200; // 600-1200px = tablet, above = desktop

  // Check if current screen is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  // Check if current screen is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  // Check if current screen is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  // Check if device supports hover (desktop/web)
  static bool supportsHover(BuildContext context) {
    return MediaQuery.of(context).size.width >= mobileBreakpoint;
  }

  // Get responsive padding based on screen size
  static EdgeInsets getPadding(
    BuildContext context, {
    double mobile = 16,
    double tablet = 20,
    double desktop = 24,
  }) {
    if (isMobile(context)) {
      return EdgeInsets.all(mobile);
    } else if (isTablet(context)) {
      return EdgeInsets.all(tablet);
    } else {
      return EdgeInsets.all(desktop);
    }
  }

  // Get responsive horizontal padding
  static EdgeInsets getHorizontalPadding(
    BuildContext context, {
    double mobile = 16,
    double tablet = 20,
    double desktop = 24,
  }) {
    if (isMobile(context)) {
      return EdgeInsets.symmetric(horizontal: mobile);
    } else if (isTablet(context)) {
      return EdgeInsets.symmetric(horizontal: tablet);
    } else {
      return EdgeInsets.symmetric(horizontal: desktop);
    }
  }

  // Get responsive spacing
  static double getSpacing(
    BuildContext context, {
    double mobile = 16,
    double tablet = 20,
    double desktop = 24,
  }) {
    if (isMobile(context)) {
      return mobile;
    } else if (isTablet(context)) {
      return tablet;
    } else {
      return desktop;
    }
  }

  // Get responsive font scale (for accessibility)
  static double getFontScale(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor;
    // Clamp to reasonable range
    return textScale.clamp(0.8, 1.2);
  }

  // Get responsive text size
  static double getTextSize(
    BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    if (isMobile(context)) {
      return mobile;
    } else if (isTablet(context)) {
      return tablet;
    } else {
      return desktop;
    }
  }

  // Get responsive card margin
  static EdgeInsets getCardMargin(
    BuildContext context, {
    double mobile = 16,
    double tablet = 20,
    double desktop = 24,
  }) {
    if (isMobile(context)) {
      return EdgeInsets.all(mobile);
    } else if (isTablet(context)) {
      return EdgeInsets.all(tablet);
    } else {
      return EdgeInsets.all(desktop);
    }
  }

  // Get max width for content (centers content on large screens)
  static double? getMaxWidth(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isMobile(context)) {
      return mobile;
    } else if (isTablet(context)) {
      return tablet;
    } else {
      return desktop;
    }
  }

  // Get responsive icon size
  static double getIconSize(
    BuildContext context, {
    double mobile = 20,
    double tablet = 22,
    double desktop = 24,
  }) {
    if (isMobile(context)) {
      return mobile;
    } else if (isTablet(context)) {
      return tablet;
    } else {
      return desktop;
    }
  }

  // Get responsive button height
  static double getButtonHeight(
    BuildContext context, {
    double mobile = 48,
    double tablet = 52,
    double desktop = 56,
  }) {
    if (isMobile(context)) {
      return mobile;
    } else if (isTablet(context)) {
      return tablet;
    } else {
      return desktop;
    }
  }
}

