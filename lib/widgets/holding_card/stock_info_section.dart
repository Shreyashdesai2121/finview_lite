import 'package:flutter/material.dart';
import '../../models/portfolio.dart';
import '../../utils/formatters.dart';
import '../../utils/responsive.dart';
import '../../services/logo_service.dart';

// Stock info section for holding card
// Shows icon, symbol, name, price, and change badge
// Properly decomposed from HoldingCard for better organization
class StockInfoSection extends StatelessWidget {
  final Holding holding;
  final bool isDark;
  final bool isMobile;
  final bool isTablet;
  final double fontScale;
  final List<Color> iconColors;

  const StockInfoSection({
    super.key,
    required this.holding,
    required this.isDark,
    required this.isMobile,
    required this.isTablet,
    required this.fontScale,
    required this.iconColors,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = holding.gainLoss >= 0;

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Real company logo with fallback
              CompanyLogo(
                symbol: holding.symbol,
                size: 56,
                fallbackColors: iconColors,
              ),
              const SizedBox(width: 12),
              // Stock details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stock symbol (big and bold)
                    Text(
                      holding.symbol,
                      style: TextStyle(
                        fontSize: 18 * fontScale,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : Colors.black,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Company name and sector
                    Text(
                      '${holding.name} • ${_getSector(holding.symbol)}',
                      style: TextStyle(
                        fontSize: 11 * fontScale,
                        color: isDark ? const Color(0xFF999999) : const Color(0xFF3A3A3A),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Price and change info
          Row(
            children: [
              // Current price
              Flexible(
                child: Text(
                  Formatters.currency(holding.currentPrice),
                  style: TextStyle(
                    fontSize: 22 * fontScale,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black,
                    letterSpacing: -1,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              // Gain/loss badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: isPositive
                      ? const Color(0xFF0ECB81).withValues(alpha: 0.15)
                      : const Color(0xFFF6465D).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.trending_down,
                      size: 13,
                      color: isPositive
                          ? const Color(0xFF0ECB81)
                          : const Color(0xFFF6465D),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${isPositive ? '+' : ''}${Formatters.currency((holding.currentPrice - holding.avgCost).abs())}',
                      style: TextStyle(
                        fontSize: 13 * fontScale,
                        fontWeight: FontWeight.w700,
                        color: isPositive
                            ? const Color(0xFF0ECB81)
                            : const Color(0xFFF6465D),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Real company logo with fallback
          CompanyLogo(
            symbol: holding.symbol,
            size: isTablet ? 64 : 72,
            fallbackColors: iconColors,
          ),
          SizedBox(width: Responsive.getSpacing(context, mobile: 12, tablet: 16, desktop: 20)),
          // Stock details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stock symbol (big and bold)
                Text(
                  holding.symbol,
                  style: TextStyle(
                    fontSize: (isTablet ? 20 : 22) * fontScale,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                // Company name and sector
                Text(
                  '${holding.name} • ${_getSector(holding.symbol)}',
                  style: TextStyle(
                    fontSize: (isTablet ? 12 : 13) * fontScale,
                    color: isDark ? const Color(0xFF999999) : const Color(0xFF3A3A3A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                // Price and change info
                Row(
                  children: [
                    // Current price
                    Text(
                      Formatters.currency(holding.currentPrice),
                      style: TextStyle(
                        fontSize: (isTablet ? 24 : 28) * fontScale,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : Colors.black,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Gain/loss badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isPositive
                            ? const Color(0xFF0ECB81).withValues(alpha: 0.15)
                            : const Color(0xFFF6465D).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isPositive ? Icons.trending_up : Icons.trending_down,
                            size: 15,
                            color: isPositive
                                ? const Color(0xFF0ECB81)
                                : const Color(0xFFF6465D),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${isPositive ? '+' : ''}${Formatters.currency((holding.currentPrice - holding.avgCost).abs())}',
                            style: TextStyle(
                              fontSize: 15 * fontScale,
                              fontWeight: FontWeight.w700,
                              color: isPositive
                                  ? const Color(0xFF0ECB81)
                                  : const Color(0xFFF6465D),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 24H badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '24H',
                        style: TextStyle(
                          fontSize: 11 * fontScale,
                          color: isDark ? const Color(0xFF666666) : const Color(0xFF999999),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  // Returns sector name for a stock symbol
  String _getSector(String symbol) {
    final sectors = {
      'TCS': 'IT Services',
      'INFY': 'Technology',
      'RELIANCE': 'Conglomerate',
      'HDFCBANK': 'Banking & Finance',
      'ICICIBANK': 'Banking & Finance',
    };
    return sectors[symbol] ?? 'General';
  }
}

