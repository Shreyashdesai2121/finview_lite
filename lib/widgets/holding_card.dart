import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/portfolio.dart';
import '../utils/responsive.dart';
import 'holding_card/badges_section.dart';
import 'holding_card/stock_info_section.dart';
import 'holding_card/stats_grid_section.dart';
import 'holding_card/action_buttons_section.dart';

// Card showing all the details for one stock holding
// Has price, gain/loss, stats, mini chart, and action buttons
// Includes hover effects for web/desktop and responsive layout for mobile
class HoldingCard extends StatefulWidget {
  final Holding holding;
  final bool showPercentage; // Show gain as % or currency
  final bool isTopPerformer; // Show top performer badge
  final bool isTrending; // Show trending badge

  const HoldingCard({
    super.key,
    required this.holding,
    required this.showPercentage,
    this.isTopPerformer = false,
    this.isTrending = false,
  });

  @override
  State<HoldingCard> createState() => _HoldingCardState();
}

class _HoldingCardState extends State<HoldingCard> {
  // Track if card is being hovered (for web/desktop)
  bool _isHovered = false;

  // Generate synthetic price chart data for visual display
  // Creates a smooth line chart with realistic price movement patterns
  // This is for visual purposes only - not real historical data
  List<double> _generateChartData() {
    final random = math.Random();
    final data = <double>[];
    double value = 50.0; // Starting point for the chart line
    
    // Generate 15 data points to create a smooth line chart
    for (int i = 0; i < 15; i++) {
      // Add random price movement (can go up or down)
      // random.nextDouble() gives 0.0-1.0, subtract 0.5 to get -0.5 to +0.5
      // Multiply by 10 to get -5 to +5 price movement per point
      value += (random.nextDouble() - 0.5) * 10;
      // Clamp value to keep chart within visible bounds (5 to 55)
      // This ensures the chart always looks good regardless of random values
      value = value.clamp(5.0, 55.0);
      data.add(value);
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final supportsHover = Responsive.supportsHover(context);
    final fontScale = Responsive.getFontScale(context);
    final isPositive = widget.holding.gainLoss >= 0;
    final chartData = _generateChartData();
    final roi = widget.holding.gainLossPercentage;
    
    // Calculate a synthetic Sharpe ratio for display purposes
    // Sharpe ratio measures risk-adjusted return (higher is better)
    // For demo purposes, we generate a value between 1.5 and 2.1
    // In a real app, this would be calculated from historical price data
    final sharpe = 1.5 + (math.Random().nextDouble() * 0.6);

    // Get colors for the stock icon (each stock has different colors)
    final iconColors = _getIconColors(widget.holding.symbol);

    // Build card content
    Widget cardContent = Transform.translate(
      // Lift card up a bit when hovered (only on desktop)
      offset: Offset(0, (_isHovered && supportsHover) ? -4.0 : 0.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.only(bottom: Responsive.getSpacing(context, mobile: 12, tablet: 14, desktop: 16)),
        padding: Responsive.getPadding(context, mobile: 16, tablet: 20, desktop: 24),
        decoration: BoxDecoration(
          // Subtle gradient for the background
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF0D0D0D), const Color(0xFF000000)]
                : [
                    const Color(0xFFFFFFFF),
                    const Color(0xFFF8F9FA),
                    const Color(0xFFFFFFFF),
                  ],
          ),
          border: Border.all(
            // Orange border when hovered, gray otherwise
            color: (_isHovered && supportsHover)
                ? const Color(0xFFF7931A)
                : (isDark
                    ? const Color(0xFF262626)
                    : const Color(0xFFC0C0C0)),
            width: (_isHovered && supportsHover) ? 2.5 : 2,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: (_isHovered && supportsHover)
              ? [
                  // Orange glow when hovered
                  BoxShadow(
                    color: const Color(0xFFF7931A).withValues(alpha: 0.15),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            // Badges in top right corner
            Positioned(
              top: Responsive.getSpacing(context, mobile: 16, tablet: 20, desktop: 24),
              right: Responsive.getSpacing(context, mobile: 16, tablet: 20, desktop: 24),
              child: BadgesSection(
                isTopPerformer: widget.isTopPerformer,
                isTrending: widget.isTrending,
                roi: roi,
                sharpe: sharpe,
                isDark: isDark,
              ),
            ),
            // Main content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stock info section (icon, symbol, name, price, change)
                StockInfoSection(
                  holding: widget.holding,
                  isDark: isDark,
                  isMobile: isMobile,
                  isTablet: isTablet,
                  fontScale: fontScale,
                  iconColors: iconColors,
                ),
                SizedBox(height: Responsive.getSpacing(context, mobile: 12, tablet: 14, desktop: 16)),
                // Mini price chart
                SizedBox(
                  height: isMobile ? 50 : 60,
                  child: CustomPaint(
                    painter: _ChartPainter(
                      chartData,
                      isPositive ? const Color(0xFF0ECB81) : const Color(0xFFF6465D),
                    ),
                  ),
                ),
                SizedBox(height: Responsive.getSpacing(context, mobile: 12, tablet: 14, desktop: 16)),
                // Stats grid showing all the metrics
                StatsGridSection(
                  holding: widget.holding,
                  isDark: isDark,
                  isMobile: isMobile,
                  isTablet: isTablet,
                  fontScale: fontScale,
                ),
                SizedBox(height: Responsive.getSpacing(context, mobile: 12, tablet: 14, desktop: 16)),
                // Action buttons at bottom
                ActionButtonsSection(
                  isDark: isDark,
                  isMobile: isMobile,
                ),
              ],
            ),
          ],
        ),
      ),
    );

    // Wrap with MouseRegion only on desktop/web
    if (supportsHover) {
      return MouseRegion(
        // Detect when mouse hovers over the card
        onEnter: (_) {
          if (mounted) {
            setState(() => _isHovered = true);
          }
        },
        onExit: (_) {
          if (mounted) {
            setState(() => _isHovered = false);
          }
        },
        cursor: SystemMouseCursors.click,
        child: cardContent,
      );
    }
    
    return cardContent;
  }


  // Returns gradient colors for the stock icon
  // Each stock gets different colors so they're easy to tell apart
  List<Color> _getIconColors(String symbol) {
    final colors = {
      'TCS': [const Color(0xFF8B5CF6), const Color(0xFFA78BFA)], // Purple
      'INFY': [const Color(0xFFEC4899), const Color(0xFFF472B6)], // Pink
      'RELIANCE': [const Color(0xFFF59E0B), const Color(0xFFFBBF24)], // Amber
      'HDFCBANK': [const Color(0xFF10B981), const Color(0xFF34D399)], // Green
      'ICICIBANK': [const Color(0xFF3B82F6), const Color(0xFF60A5FA)], // Blue
    };
    // Default colors if we don't have this stock
    return colors[symbol] ?? [const Color(0xFF6366F1), const Color(0xFF818CF8)];
  }

}

// Custom painter that draws the mini price chart
// Draws a line chart with a gradient fill underneath
class _ChartPainter extends CustomPainter {
  final List<double> data;
  final Color color;

  _ChartPainter(this.data, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    // Paint for drawing the line
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Paint for the gradient fill under the line
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withValues(alpha: 0.3),
          color.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final fillPath = Path();

    // Figure out spacing and how to scale the data
    final stepX = size.width / (data.length - 1);
    final minY = data.reduce(math.min);
    final maxY = data.reduce(math.max);
    final rangeY = maxY - minY;
    // Add some padding so the line doesn't touch the edges
    final paddingY = rangeY * 0.2;

    // Start the paths
    path.moveTo(0, size.height - ((data[0] - minY + paddingY) / (rangeY + paddingY * 2)) * size.height);
    fillPath.moveTo(0, size.height);

    // Draw the line through all the data points
    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final normalizedY = (data[i] - minY + paddingY) / (rangeY + paddingY * 2);
      final y = size.height - (normalizedY * size.height);
      path.lineTo(x, y);
      fillPath.lineTo(x, y);
    }

    // Close the fill path at the bottom
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    // Draw the fill first, then the line on top
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
