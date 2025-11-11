import 'package:flutter/material.dart';
import '../../utils/responsive.dart';

// Reusable badge widget for displaying status indicators
// Used for top performer, trending, ROI, Sharpe ratio badges
// Supports different styles: gradient, solid, outlined
class BadgeWidget extends StatelessWidget {
  final String text;
  final BadgeStyle style;
  final bool isDark;
  final double fontScale;

  const BadgeWidget({
    super.key,
    required this.text,
    required this.style,
    required this.isDark,
    required this.fontScale,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    switch (style) {
      case BadgeStyle.gradient:
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 8 : 10,
            vertical: isMobile ? 3 : 4,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF7931A), Color(0xFFFF6B35)],
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: (isMobile ? 9 : 11) * fontScale,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              letterSpacing: 0.5,
            ),
          ),
        );

      case BadgeStyle.success:
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 10 : 12,
            vertical: isMobile ? 5 : 6,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF0ECB81).withValues(alpha: 0.15),
            border: Border.all(
              color: const Color(0xFF0ECB81).withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: (isMobile ? 11 : 12) * fontScale,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0ECB81),
            ),
          ),
        );

      case BadgeStyle.error:
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 10 : 12,
            vertical: isMobile ? 5 : 6,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF6465D).withValues(alpha: 0.15),
            border: Border.all(
              color: const Color(0xFFF6465D).withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: (isMobile ? 11 : 12) * fontScale,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFF6465D),
            ),
          ),
        );

      case BadgeStyle.outlined:
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 8 : 10,
            vertical: isMobile ? 3 : 4,
          ),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: (isMobile ? 10 : 11) * fontScale,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFF7931A),
            ),
          ),
        );

      case BadgeStyle.trending:
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 8 : 10,
            vertical: isMobile ? 3 : 4,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF6465D).withValues(alpha: 0.2),
            border: Border.all(
              color: const Color(0xFFF6465D).withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: (isMobile ? 9 : 11) * fontScale,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFF6465D),
              letterSpacing: 0.5,
            ),
          ),
        );
    }
  }
}

// Different badge styles for different use cases
enum BadgeStyle {
  gradient, // Orange gradient for top performer
  success, // Green for positive ROI
  error, // Red for negative ROI
  outlined, // Gray outlined for Sharpe ratio
  trending, // Red outlined for trending
}

