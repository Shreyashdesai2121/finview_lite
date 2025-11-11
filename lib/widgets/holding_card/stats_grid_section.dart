import 'package:flutter/material.dart';
import '../../models/portfolio.dart';
import '../../utils/formatters.dart';
import '../../utils/responsive.dart';
import '../common/stat_box.dart';

// Stats grid section for holding card
// Shows all the metrics in a responsive grid
// Properly decomposed from HoldingCard for better organization
class StatsGridSection extends StatelessWidget {
  final Holding holding;
  final bool isDark;
  final bool isMobile;
  final bool isTablet;
  final double fontScale;

  const StatsGridSection({
    super.key,
    required this.holding,
    required this.isDark,
    required this.isMobile,
    required this.isTablet,
    required this.fontScale,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = holding.gainLoss >= 0;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Responsive.getSpacing(context, mobile: 16, tablet: 18, desktop: 20),
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFE0E0E0),
          ),
          bottom: BorderSide(
            color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFE0E0E0),
          ),
        ),
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: isMobile ? 2 : (isTablet ? 3 : 6),
        mainAxisSpacing: Responsive.getSpacing(context, mobile: 12, tablet: 16, desktop: 20),
        crossAxisSpacing: Responsive.getSpacing(context, mobile: 12, tablet: 16, desktop: 20),
        childAspectRatio: isMobile ? 2.2 : (isTablet ? 2.3 : 2.5),
        children: [
          StatBox(
            label: 'Units Held',
            value: holding.units.toString(),
            isDark: isDark,
            isMobile: isMobile,
            fontScale: fontScale,
          ),
          StatBox(
            label: 'Avg Buy Price',
            value: Formatters.currency(holding.avgCost),
            isDark: isDark,
            isMobile: isMobile,
            fontScale: fontScale,
          ),
          StatBox(
            label: 'Invested',
            value: Formatters.currency(holding.costBasis),
            isDark: isDark,
            isMobile: isMobile,
            fontScale: fontScale,
          ),
          StatBox(
            label: 'Current Value',
            value: Formatters.currency(holding.currentValue),
            isDark: isDark,
            isMobile: isMobile,
            fontScale: fontScale,
          ),
          StatBox(
            label: 'Total Gain',
            value: '${isPositive ? '+' : ''}${Formatters.currency(holding.gainLoss.abs())}',
            subtext: '${isPositive ? '+' : ''}${holding.gainLossPercentage.toStringAsFixed(2)}%',
            isDark: isDark,
            isMobile: isMobile,
            fontScale: fontScale,
            valueColor: isPositive ? const Color(0xFF0ECB81) : const Color(0xFFF6465D),
          ),
          StatBox(
            label: '24H Volume',
            value: '2.4M',
            isDark: isDark,
            isMobile: isMobile,
            fontScale: fontScale,
          ),
        ],
      ),
    );
  }
}

