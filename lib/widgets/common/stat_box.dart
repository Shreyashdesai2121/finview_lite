import 'package:flutter/material.dart';
import '../../utils/responsive.dart';

// Reusable stat box widget for displaying metrics
// Used in holding cards to show units, prices, gains, etc.
// Supports label, value, and optional subtext
class StatBox extends StatelessWidget {
  final String label;
  final String value;
  final String? subtext; // Optional subtext (like percentage)
  final bool isDark;
  final bool isMobile;
  final double fontScale;
  final Color? valueColor; // Optional custom color for value

  const StatBox({
    super.key,
    required this.label,
    required this.value,
    this.subtext,
    required this.isDark,
    required this.isMobile,
    required this.fontScale,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label (small text)
        Text(
          label,
          style: TextStyle(
            fontSize: (isMobile ? 9 : 11) * fontScale,
            color: isDark ? const Color(0xFF666666) : const Color(0xFF3A3A3A),
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: Responsive.getSpacing(context, mobile: 4, tablet: 5, desktop: 6)),
        // Value (bigger text)
        Text(
          value,
          style: TextStyle(
            fontSize: (isMobile ? 14 : 16) * fontScale,
            fontWeight: FontWeight.w700,
            color: valueColor ?? (isDark ? Colors.white : Colors.black),
            letterSpacing: -0.3,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        // Optional subtext (like percentage)
        if (subtext != null) ...[
          SizedBox(height: Responsive.getSpacing(context, mobile: 2, tablet: 2, desktop: 2)),
          Text(
            subtext!,
            style: TextStyle(
              fontSize: (isMobile ? 9 : 11) * fontScale,
              color: isDark ? const Color(0xFF666666) : const Color(0xFF999999),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}

