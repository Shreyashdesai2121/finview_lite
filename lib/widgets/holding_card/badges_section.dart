import 'package:flutter/material.dart';
import '../../utils/responsive.dart';
import '../common/badge_widget.dart';

// Badges section for holding card
// Shows top performer, trending, ROI, and Sharpe ratio badges
// Properly decomposed from HoldingCard for better organization
class BadgesSection extends StatelessWidget {
  final bool isTopPerformer;
  final bool isTrending;
  final double roi;
  final double sharpe;
  final bool isDark;

  const BadgesSection({
    super.key,
    required this.isTopPerformer,
    required this.isTrending,
    required this.roi,
    required this.sharpe,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final fontScale = Responsive.getFontScale(context);
    final isPositive = roi >= 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Top performer badge (only if this is the top one)
        if (isTopPerformer)
          BadgeWidget(
            text: '⭐ TOP PERFORMER',
            style: BadgeStyle.gradient,
            isDark: isDark,
            fontScale: fontScale,
          ),
        if (isTopPerformer)
          SizedBox(height: Responsive.getSpacing(context, mobile: 6, tablet: 7, desktop: 8)),
        // Trending badge (only if this is trending)
        if (isTrending)
          BadgeWidget(
            text: '🔥 TRENDING',
            style: BadgeStyle.trending,
            isDark: isDark,
            fontScale: fontScale,
          ),
        if (isTrending)
          SizedBox(height: Responsive.getSpacing(context, mobile: 6, tablet: 7, desktop: 8)),
        // ROI badge (green if positive, red if negative)
        BadgeWidget(
          text: 'ROI ${isPositive ? '+' : ''}${roi.toStringAsFixed(2)}%',
          style: isPositive ? BadgeStyle.success : BadgeStyle.error,
          isDark: isDark,
          fontScale: fontScale,
        ),
        SizedBox(height: Responsive.getSpacing(context, mobile: 6, tablet: 7, desktop: 8)),
        // Sharpe ratio badge
        BadgeWidget(
          text: 'Sharpe ${sharpe.toStringAsFixed(1)}',
          style: BadgeStyle.outlined,
          isDark: isDark,
          fontScale: fontScale,
        ),
      ],
    );
  }
}

