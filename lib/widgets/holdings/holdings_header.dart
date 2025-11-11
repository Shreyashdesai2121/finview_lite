import 'package:flutter/material.dart';
import '../../utils/responsive.dart';
import '../common/control_button.dart';

// Header widget for the holdings section
// Shows count and has buttons to toggle display and sort
// Properly decomposed from dashboard for better organization
class HoldingsHeader extends StatelessWidget {
  final int holdingsCount;
  final bool showPercentage;
  final String sortOptionName;
  final bool isDark;
  final VoidCallback onTogglePercentage;
  final VoidCallback onToggleSort;

  const HoldingsHeader({
    super.key,
    required this.holdingsCount,
    required this.showPercentage,
    required this.sortOptionName,
    required this.isDark,
    required this.onTogglePercentage,
    required this.onToggleSort,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final padding = Responsive.getHorizontalPadding(context);

    return Container(
      padding: padding,
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title with count
                Text(
                  'Your Holdings ($holdingsCount)',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                // Control buttons - stack on mobile
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ControlButton(
                      text: showPercentage ? '%' : '₹',
                      isActive: true,
                      isDark: isDark,
                      onTap: onTogglePercentage,
                    ),
                    ControlButton(
                      text: 'Sort: ${sortOptionName[0].toUpperCase() + sortOptionName.substring(1)} ▼',
                      isActive: false,
                      isDark: isDark,
                      onTap: onToggleSort,
                    ),
                  ],
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title with count
                Text(
                  'Your Holdings ($holdingsCount)',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black,
                    letterSpacing: -0.5,
                  ),
                ),
                // Control buttons
                Row(
                  children: [
                    // Toggle between % and currency
                    ControlButton(
                      text: showPercentage ? '% Percentage' : '₹ Amount',
                      isActive: true,
                      isDark: isDark,
                      onTap: onTogglePercentage,
                    ),
                    const SizedBox(width: 8),
                    // Sort button (cycles through options)
                    ControlButton(
                      text: 'Sort: ${sortOptionName[0].toUpperCase() + sortOptionName.substring(1)} ▼',
                      isActive: false,
                      isDark: isDark,
                      onTap: onToggleSort,
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

