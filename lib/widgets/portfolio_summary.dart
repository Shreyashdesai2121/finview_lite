import 'package:flutter/material.dart';
import '../models/portfolio.dart';
import '../utils/responsive.dart';
import 'common/animated_number.dart';
import 'common/animated_card.dart';

// Big card showing portfolio value and total gain/loss
// Has hover effects for web/desktop and responsive layout for mobile
// Includes professional entrance animation
class PortfolioSummary extends StatefulWidget {
  final Portfolio portfolio;
  final bool showPercentage; // Show gain as % or currency amount

  const PortfolioSummary({
    super.key,
    required this.portfolio,
    required this.showPercentage,
  });

  @override
  State<PortfolioSummary> createState() => _PortfolioSummaryState();
}

class _PortfolioSummaryState extends State<PortfolioSummary> {
  // Track if user is hovering over the card (for web/desktop)
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final supportsHover = Responsive.supportsHover(context);
    final margin = Responsive.getCardMargin(context);
    final fontScale = Responsive.getFontScale(context);
    
    // Note: gainText and portfolioValueText are no longer needed
    // as we use AnimatedNumber widget directly

    // Build the card content - responsive layout
    // Wrap in AnimatedCard for professional entrance animation
    Widget cardContent = AnimatedCard(
      delay: 0, // No delay - appears first
      duration: const Duration(milliseconds: 500), // Smooth entrance
      child: Transform.translate(
        // Lift the card up a bit when hovered (only on desktop)
        offset: Offset(0, (_isHovered && supportsHover) ? -6.0 : 0.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: margin,
          child: Card(
          // Bigger shadow when hovered
          elevation: (_isHovered && supportsHover) ? 12 : 4,
          shadowColor: isDark
              ? Colors.black45
              : Colors.black.withValues(alpha: 0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              // Orange border when hovered, gray otherwise
              color: (_isHovered && supportsHover)
                  ? const Color(0xFFF7931A)
                  : (isDark
                      ? const Color(0xFF333333)
                      : const Color(0xFFC0C0C0)),
              width: (_isHovered && supportsHover) ? 2.5 : 2,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: (_isHovered && supportsHover)
                    ? const Color(0xFFF7931A)
                    : Colors.transparent,
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                // Orange gradient line at the top when hovered
                if (_isHovered && supportsHover)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 3,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Color(0xFFF7931A),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                // Main content - responsive layout
                Padding(
                  padding: Responsive.getPadding(
                    context,
                    mobile: 20,
                    tablet: 24,
                    desktop: 32,
                  ),
                  child: isMobile
                      ? // Mobile: stack vertically
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Portfolio value
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Portfolio Value',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? const Color(0xFF999999) : const Color(0xFF3A3A3A),
                                        letterSpacing: 0.5,
                                        fontSize: 14 * fontScale,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                // Display portfolio value with gradient text effect and counting animation
                                // ShaderMask applies a gradient (orange to red-orange) to the text
                                // AnimatedNumber creates a smooth counting-up effect when value changes
                                ShaderMask(
                                  shaderCallback: (bounds) => const LinearGradient(
                                    colors: [Color(0xFFF7931A), Color(0xFFFF6B35)],
                                  ).createShader(bounds),
                                  child: AnimatedNumber(
                                    value: widget.portfolio.portfolioValue,
                                    style: TextStyle(
                                      fontSize: 36 * fontScale,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white, // White text that gets gradient applied
                                    ),
                                    prefix: '₹', // Indian Rupee symbol before the number
                                    duration: 1800, // Animation takes 1.8 seconds to count up
                                    fractionDigits: 2, // Show 2 decimal places
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // Total gain
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.trending_up,
                                      color: Color(0xFF0ECB81),
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Total Gain',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: const Color(0xFF0ECB81),
                                            fontSize: 14 * fontScale,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                // Display gain/loss either as percentage or currency amount
                                // Based on user's preference (toggle in app bar)
                                // AnimatedNumber creates smooth counting animation
                                widget.showPercentage
                                    ? AnimatedNumber(
                                        value: widget.portfolio.totalGainPercentage, // Show as percentage
                                        style: TextStyle(
                                          fontSize: 24 * fontScale,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF0ECB81), // Green for positive gain
                                        ),
                                        suffix: '%', // Percentage symbol after number
                                        duration: 1500, // 1.5 second animation
                                        fractionDigits: 2, // Two decimal places (e.g., 8.00%)
                                      )
                                    : AnimatedNumber(
                                        value: widget.portfolio.totalGain, // Show as currency amount
                                        style: TextStyle(
                                          fontSize: 24 * fontScale,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF0ECB81), // Green for positive gain
                                        ),
                                        prefix: '₹', // Rupee symbol before number
                                        duration: 1500, // 1.5 second animation
                                        fractionDigits: 2, // Two decimal places (e.g., ₹12,000.00)
                                      ),
                              ],
                            ),
                          ],
                        )
                      : // Desktop/Tablet: side by side
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Left side - portfolio value
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Portfolio Value',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: isDark ? const Color(0xFF999999) : const Color(0xFF3A3A3A),
                                          letterSpacing: 0.5,
                                          fontSize: (isTablet ? 15 : 16) * fontScale,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Big gradient text for the value with professional counting animation
                                  ShaderMask(
                                    shaderCallback: (bounds) => const LinearGradient(
                                      colors: [Color(0xFFF7931A), Color(0xFFFF6B35)],
                                    ).createShader(bounds),
                                    child: AnimatedNumber(
                                      value: widget.portfolio.portfolioValue,
                                      style: TextStyle(
                                        fontSize: (isTablet ? 42 : 48) * fontScale,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      prefix: '₹',
                                      duration: 1800,
                                      fractionDigits: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Right side - total gain
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.trending_up,
                                        color: Color(0xFF0ECB81),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: Text(
                                          'Total Gain',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: const Color(0xFF0ECB81),
                                                fontSize: (isTablet ? 15 : 16) * fontScale,
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  // Animated gain/loss with professional counting
                                  widget.showPercentage
                                      ? AnimatedNumber(
                                          value: widget.portfolio.totalGainPercentage,
                                          style: TextStyle(
                                            fontSize: (isTablet ? 24 : 28) * fontScale,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF0ECB81),
                                          ),
                                          suffix: '%',
                                          duration: 1500,
                                          fractionDigits: 2,
                                        )
                                      : AnimatedNumber(
                                          value: widget.portfolio.totalGain,
                                          style: TextStyle(
                                            fontSize: (isTablet ? 24 : 28) * fontScale,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF0ECB81),
                                          ),
                                          prefix: '₹',
                                          duration: 1500,
                                          fractionDigits: 2,
                                        ),
                                ],
                              ),
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
            setState(() => _isHovered = true);
          }
        },
        onExit: (_) {
          if (mounted) {
            setState(() => _isHovered = false);
          }
        },
        child: cardContent,
      );
    }
    
    return cardContent;
  }
}
