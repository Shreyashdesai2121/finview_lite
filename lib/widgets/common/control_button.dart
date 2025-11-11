import 'package:flutter/material.dart';
import '../../utils/responsive.dart';

// Reusable control button used in dashboard header
// Supports active/inactive states with different styling
class ControlButton extends StatelessWidget {
  final String text;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  const ControlButton({
    super.key,
    required this.text,
    required this.isActive,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 16,
          vertical: isMobile ? 8 : 10,
        ),
        decoration: BoxDecoration(
          // Orange when active
          color: isActive
              ? const Color(0xFFF7931A)
              : (isDark ? const Color(0xFF000000) : Colors.white),
          border: Border.all(
            color: isActive
                ? const Color(0xFFF7931A)
                : (isDark ? const Color(0xFF333333) : const Color(0xFFC0C0C0)),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: isMobile ? 12 : 13,
            fontWeight: FontWeight.w500,
            color: isActive
                ? Colors.black
                : (isDark ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}

