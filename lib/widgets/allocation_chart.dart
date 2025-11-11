import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/portfolio.dart';
import '../utils/formatters.dart';
import '../utils/responsive.dart';
import 'common/animated_card.dart';

// Pie chart showing how portfolio value is split across different stocks
// Has hover effects and an interactive legend
// Responsive layout for mobile and desktop
// Includes professional entrance animation
class AllocationChart extends StatefulWidget {
  final List<Holding> holdings;

  const AllocationChart({
    super.key,
    required this.holdings,
  });

  @override
  State<AllocationChart> createState() => _AllocationChartState();
}

class _AllocationChartState extends State<AllocationChart>
    with SingleTickerProviderStateMixin {
  // Is the whole card being hovered?
  bool _isCardHovered = false;
  
  // Which pie slice is currently hovered (for highlighting)
  int? _hoveredPieIndex;
  
  // Animation controller for chart drawing animation
  late AnimationController _chartAnimationController;
  late Animation<double> _chartAnimation;

  @override
  void initState() {
    super.initState();
    // Professional chart drawing animation - smooth 800ms
    _chartAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    // Smooth easeOut curve for professional feel
    _chartAnimation = CurvedAnimation(
      parent: _chartAnimationController,
      curve: Curves.easeOut,
    );
    
    // Start animation when chart appears
    _chartAnimationController.forward();
  }

  @override
  void dispose() {
    _chartAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Don't show anything if there's no data
    if (widget.holdings.isEmpty) {
      return const SizedBox.shrink();
    }

    // Add up all the current values to get total
    // Handle any invalid values gracefully
    double totalValue = 0.0;
    try {
      totalValue = widget.holdings.fold<double>(
        0,
        (sum, holding) {
          try {
            final value = holding.currentValue;
            // Skip invalid values
            if (value.isNaN || value.isInfinite || value < 0) {
              return sum;
            }
            return sum + value;
          } catch (e) {
            // If one holding fails, skip it
            return sum;
          }
        },
      );
      
      // Make sure total is valid
      if (totalValue.isNaN || totalValue.isInfinite) {
        totalValue = 0.0;
      }
    } catch (e) {
      // If calculation fails, use 0
      totalValue = 0.0;
    }

    // Can't show chart if total is zero or invalid
    if (totalValue <= 0) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final supportsHover = Responsive.supportsHover(context);
    final margin = Responsive.getCardMargin(context);
    final fontScale = Responsive.getFontScale(context);
    
    // Use different colors for light vs dark mode
    // Dark mode gets brighter colors, light mode gets darker colors
    final colors = isDark
        ? [
            const Color(0xFF4C7BB9), // Blue
            const Color(0xFF68D391), // Green
            const Color(0xFFED8936), // Orange
            const Color(0xFFA78BFA), // Purple
            const Color(0xFFFC8181), // Red
          ]
        : [
            const Color(0xFF2C5282), // Darker blue
            const Color(0xFF38A169), // Darker green
            const Color(0xFFD69E2E), // Darker orange
            const Color(0xFF805AD5), // Darker purple
            const Color(0xFFC53030), // Darker red
          ];

    // Filter out holdings with invalid values for the chart
    final validHoldings = widget.holdings.where((holding) {
      try {
        final value = holding.currentValue;
        return !value.isNaN && !value.isInfinite && value > 0;
      } catch (e) {
        return false;
      }
    }).toList();

    // If no valid holdings, don't show chart
    if (validHoldings.isEmpty) {
      return const SizedBox.shrink();
    }

    // Build card content
    // Wrap in AnimatedCard for professional entrance animation
    Widget cardContent = AnimatedCard(
      delay: 100, // Slight delay after portfolio summary
      duration: const Duration(milliseconds: 500), // Smooth entrance
      child: Transform.translate(
        // Lift card up a bit when hovered (only on desktop)
        offset: Offset(0, (_isCardHovered && supportsHover) ? -4.0 : 0.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: margin,
          child: Card(
          // Bigger shadow when hovered
          elevation: (_isCardHovered && supportsHover) ? 12 : 4,
          shadowColor: isDark
              ? Colors.black45
              : Colors.black.withValues(alpha: 0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              // Orange border when hovered
              color: (_isCardHovered && supportsHover)
                  ? const Color(0xFFF7931A)
                  : (isDark
                      ? const Color(0xFF333333)
                      : const Color(0xFFC0C0C0)),
              width: (_isCardHovered && supportsHover) ? 2.5 : 2,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: (_isCardHovered && supportsHover)
                    ? const Color(0xFFF7931A)
                    : Colors.transparent,
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                // Orange line at top when hovered
                if (_isCardHovered && supportsHover)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 2,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFF7931A), Colors.transparent],
                        ),
                      ),
                    ),
                  ),
                // Chart and legend - responsive layout
                Padding(
                  padding: Responsive.getPadding(
                    context,
                    mobile: 16,
                    tablet: 20,
                    desktop: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        'Asset Allocation',
                        style: TextStyle(
                          fontSize: Responsive.getTextSize(
                            context,
                            mobile: 16,
                            tablet: 17,
                            desktop: 18,
                          ) * fontScale,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                      SizedBox(height: Responsive.getSpacing(context, mobile: 16, tablet: 18, desktop: 20)),
                      // Chart and legend - stack on mobile, side by side on desktop
                      isMobile
                          ? Column(
                              children: [
                                // The pie chart itself
                                SizedBox(
                                  width: 180,
                                  height: 180,
                                  child: Stack(
                                    children: [
                                      // Pie chart with professional drawing animation
                                      AnimatedBuilder(
                                        animation: _chartAnimation,
                                        builder: (context, child) {
                                          return AnimatedScale(
                                            scale: _hoveredPieIndex != null ? 1.02 : 1.0,
                                            duration: const Duration(milliseconds: 300),
                                            child: PieChart(
                                              PieChartData(
                                                // Create a slice for each holding with drawing animation
                                                sections: validHoldings
                                                    .asMap()
                                                    .entries
                                                    .map((entry) {
                                                  try {
                                                    final index = entry.key;
                                                    final holding = entry.value;
                                                    final isHovered = _hoveredPieIndex == index;
                                                    
                                                    final value = holding.currentValue;
                                                    // Make sure value is valid
                                                    if (value.isNaN || value.isInfinite || value <= 0) {
                                                      return null;
                                                    }

                                                    // Animate value from 0 to actual value for drawing effect
                                                    final animatedValue = value * _chartAnimation.value;

                                                    return PieChartSectionData(
                                                      // Dim the color a bit when hovered
                                                      color: colors[index % colors.length]
                                                          .withValues(
                                                            alpha: isHovered ? 0.8 : 1.0,
                                                          ),
                                                      value: animatedValue, // Animated value for drawing effect
                                                      title: '', // No text on the slices
                                                      // Make slice bigger when hovered
                                                      radius: isHovered ? 65 : 60,
                                                    );
                                                  } catch (e) {
                                                    // If one holding fails, return null (will be filtered)
                                                    return null;
                                                  }
                                                })
                                                .where((section) => section != null)
                                                .cast<PieChartSectionData>()
                                                .toList(),
                                                borderData: FlBorderData(show: false),
                                                sectionsSpace: 2, // Gap between slices
                                                centerSpaceRadius: 70, // Makes it a donut chart
                                                pieTouchData: PieTouchData(
                                                  // Handle taps on slices
                                                  touchCallback: (event, response) {
                                                    try {
                                                      if (event is FlTapUpEvent &&
                                                          response?.touchedSection != null) {
                                                        if (mounted) {
                                                          setState(() {
                                                            _hoveredPieIndex = response!
                                                                .touchedSection!
                                                                .touchedSectionIndex;
                                                          });
                                                        }
                                                      }
                                                    } catch (e) {
                                                      // If tap handling fails, just ignore it
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      // Text in the center showing total value
                                      Positioned.fill(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              Formatters.currency(totalValue),
                                              style: TextStyle(
                                                fontSize: 16 * fontScale,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.color,
                                              ),
                                            ),
                                            Text(
                                              'Total',
                                              style: TextStyle(
                                                fontSize: 10 * fontScale,
                                                color: isDark ? Colors.grey : const Color(0xFF4A4A4A),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: Responsive.getSpacing(context, mobile: 16, tablet: 18, desktop: 20)),
                                // Legend showing each stock
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: validHoldings
                                      .asMap()
                                      .entries
                                      .map<Widget>((entry) {
                                    try {
                                      final index = entry.key;
                                      final holding = entry.value;
                                      // Calculate what % of total this holding is
                                      final percentage = (holding.currentValue / totalValue) * 100;
                                      
                                      // Make sure percentage is valid
                                      if (percentage.isNaN || percentage.isInfinite || percentage < 0) {
                                        return const SizedBox.shrink();
                                      }
                                      
                                      final isHovered = _hoveredPieIndex == index;

                                      return _LegendItem(
                                        holding: holding,
                                        percentage: percentage,
                                        color: colors[index % colors.length],
                                        isHovered: isHovered,
                                        isDark: isDark,
                                        isMobile: true,
                                        fontScale: fontScale,
                                        onHover: (hovered) {
                                          if (mounted) {
                                            setState(() {
                                              // Only set hover for this specific index
                                              if (hovered) {
                                                _hoveredPieIndex = index;
                                              } else if (_hoveredPieIndex == index) {
                                                // Only clear if this is the currently hovered item
                                                _hoveredPieIndex = null;
                                              }
                                            });
                                          }
                                        },
                                      );
                                    } catch (e) {
                                      // If one legend item fails, return empty widget
                                      return const SizedBox.shrink();
                                    }
                                  }).toList(),
                                ),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // The pie chart itself
                                SizedBox(
                                  width: isTablet ? 200 : 220,
                                  height: isTablet ? 200 : 220,
                                  child: Stack(
                                    children: [
                                      // Pie chart with professional drawing animation
                                      AnimatedBuilder(
                                        animation: _chartAnimation,
                                        builder: (context, child) {
                                          return AnimatedScale(
                                            scale: _hoveredPieIndex != null ? 1.02 : 1.0,
                                            duration: const Duration(milliseconds: 300),
                                            child: PieChart(
                                              PieChartData(
                                                // Create a slice for each holding with drawing animation
                                                sections: validHoldings
                                                    .asMap()
                                                    .entries
                                                    .map((entry) {
                                                  try {
                                                    final index = entry.key;
                                                    final holding = entry.value;
                                                    final isHovered = _hoveredPieIndex == index;
                                                    
                                                    final value = holding.currentValue;
                                                    // Make sure value is valid
                                                    if (value.isNaN || value.isInfinite || value <= 0) {
                                                      return null;
                                                    }

                                                    // Animate value from 0 to actual value for drawing effect
                                                    final animatedValue = value * _chartAnimation.value;

                                                    return PieChartSectionData(
                                                      // Dim the color a bit when hovered
                                                      color: colors[index % colors.length]
                                                          .withValues(
                                                            alpha: isHovered ? 0.8 : 1.0,
                                                          ),
                                                      value: animatedValue, // Animated value for drawing effect
                                                      title: '', // No text on the slices
                                                      // Make slice bigger when hovered
                                                      radius: isHovered ? 65 : 60,
                                                    );
                                                  } catch (e) {
                                                    // If one holding fails, return null (will be filtered)
                                                    return null;
                                                  }
                                                })
                                                .where((section) => section != null)
                                                .cast<PieChartSectionData>()
                                                .toList(),
                                                borderData: FlBorderData(show: false),
                                                sectionsSpace: 2, // Gap between slices
                                                centerSpaceRadius: 70, // Makes it a donut chart
                                                pieTouchData: PieTouchData(
                                                  // Handle taps on slices
                                                  touchCallback: (event, response) {
                                                    try {
                                                      if (event is FlTapUpEvent &&
                                                          response?.touchedSection != null) {
                                                        if (mounted) {
                                                          setState(() {
                                                            _hoveredPieIndex = response!
                                                                .touchedSection!
                                                                .touchedSectionIndex;
                                                          });
                                                        }
                                                      }
                                                    } catch (e) {
                                                      // If tap handling fails, just ignore it
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      // Text in the center showing total value
                                      Positioned.fill(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              Formatters.currency(totalValue),
                                              style: TextStyle(
                                                fontSize: 20 * fontScale,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.color,
                                              ),
                                            ),
                                            Text(
                                              'Total',
                                              style: TextStyle(
                                                fontSize: 12 * fontScale,
                                                color: isDark ? Colors.grey : const Color(0xFF4A4A4A),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: Responsive.getSpacing(context, mobile: 16, tablet: 24, desktop: 32)),
                                // Legend showing each stock
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: validHoldings
                                        .asMap()
                                        .entries
                                        .map<Widget>((entry) {
                                      try {
                                        final index = entry.key;
                                        final holding = entry.value;
                                        // Calculate what % of total this holding is
                                        final percentage = (holding.currentValue / totalValue) * 100;
                                        
                                        // Make sure percentage is valid
                                        if (percentage.isNaN || percentage.isInfinite || percentage < 0) {
                                          return const SizedBox.shrink();
                                        }
                                        
                                        final isHovered = _hoveredPieIndex == index;

                                        return _LegendItem(
                                          holding: holding,
                                          percentage: percentage,
                                          color: colors[index % colors.length],
                                          isHovered: isHovered,
                                          isDark: isDark,
                                          isMobile: false,
                                          fontScale: fontScale,
                                          onHover: (hovered) {
                                            if (mounted) {
                                              setState(() {
                                                // CRITICAL: When hovering, immediately clear ALL previous hover states
                                                // and set only this index. This prevents multiple items from highlighting.
                                                if (hovered) {
                                                  // Clear previous and set new in same setState call
                                                  _hoveredPieIndex = index;
                                                } else {
                                                  // Only clear if this is the currently hovered item
                                                  if (_hoveredPieIndex == index) {
                                                    _hoveredPieIndex = null;
                                                  }
                                                }
                                              });
                                            }
                                          },
                                        );
                                      } catch (e) {
                                        // If one legend item fails, return empty widget
                                        return const SizedBox.shrink();
                                      }
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );

    // Wrap with MouseRegion only on desktop/web
    if (supportsHover) {
      return MouseRegion(
        // Detect when mouse enters/exits the card
        onEnter: (_) {
          if (mounted) {
            setState(() => _isCardHovered = true);
          }
        },
        onExit: (_) {
          if (mounted) {
            setState(() => _isCardHovered = false);
          }
        },
        child: cardContent,
      );
    }
    
    return cardContent;
  }
}

// One item in the legend (one stock)
// Shows the color, name, percentage, and value
// Highlights when you hover over it
class _LegendItem extends StatelessWidget {
  final Holding holding;
  final double percentage;
  final Color color;
  final bool isHovered;
  final bool isDark;
  final bool isMobile;
  final double fontScale;
  final Function(bool) onHover;

  const _LegendItem({
    required this.holding,
    required this.percentage,
    required this.color,
    required this.isHovered,
    required this.isDark,
    required this.isMobile,
    required this.fontScale,
    required this.onHover,
  });

  @override
  Widget build(BuildContext context) {
    // Format the value safely
    String valueText;
    try {
      valueText = Formatters.currency(holding.currentValue);
    } catch (e) {
      valueText = '₹0.00';
    }

    // Format percentage safely
    String percentageText;
    try {
      if (percentage.isNaN || percentage.isInfinite) {
        percentageText = '0.0';
      } else {
        percentageText = percentage.toStringAsFixed(1);
      }
    } catch (e) {
      percentageText = '0.0';
    }

    return Container(
      // Add vertical margin to create space between legend items
      // More spacing in light mode (8px) to prevent hover overlap issues
      // Less spacing in dark mode (4px) where hover works better
      margin: EdgeInsets.symmetric(vertical: isMobile ? 2 : (isDark ? 4 : 8)),
      child: MouseRegion(
        // MouseRegion detects when user hovers over this specific legend item
        // hitTestBehavior.opaque ensures only this item responds to hover events
        // This prevents multiple items from highlighting when moving mouse quickly
        hitTestBehavior: HitTestBehavior.opaque,
        onEnter: isMobile ? null : (_) {
          // User's mouse entered this legend item
          // Call onHover(true) to update the parent widget's hover state
          // The parent will set _hoveredPieIndex to this item's index
          onHover(true);
        },
        onExit: isMobile ? null : (_) {
          // User's mouse left this legend item
          // Call onHover(false) to clear the hover state
          // Only clears if this was the currently hovered item
          onHover(false);
        },
        cursor: isMobile ? MouseCursor.defer : SystemMouseCursors.click,
        child: Container(
          padding: EdgeInsets.all(isMobile ? 6 : 8),
          margin: EdgeInsets.zero,
          // Add clipBehavior to prevent overflow
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            // Highlight background when hovered - immediate color change (no animation delay)
            color: isHovered && !isMobile
                ? (isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF1F3F5))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
        child: Row(
          children: [
            // Small colored circle matching the pie slice
            Container(
              width: isMobile ? 14 : 16,
              height: isMobile ? 14 : 16,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            SizedBox(width: isMobile ? 10 : 12),
            // Stock name and details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    holding.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: isMobile ? 13 * fontScale : 14 * fontScale,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    '$percentageText% • $valueText',
                    style: TextStyle(
                      fontSize: isMobile ? 11 * fontScale : 12 * fontScale,
                      color: isDark ? Colors.grey : const Color(0xFF4A4A4A),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
