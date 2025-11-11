import 'package:flutter/material.dart';
import '../../models/portfolio.dart';
import '../../utils/responsive.dart';
import '../holding_card.dart';
import '../common/animated_card.dart';

// Widget for displaying the list of holdings
// Properly decomposed from dashboard for better organization
class HoldingsList extends StatelessWidget {
  final List<Holding> holdings;
  final bool showPercentage;

  const HoldingsList({
    super.key,
    required this.holdings,
    required this.showPercentage,
  });

  @override
  Widget build(BuildContext context) {
    // Make sure we have holdings to display
    if (holdings.isEmpty) {
      return const SizedBox.shrink();
    }

    final padding = Responsive.getHorizontalPadding(context);
    return Container(
      padding: padding,
      child: Column(
        children: holdings.asMap().entries.map((entry) {
          try {
            final index = entry.key;
            final holding = entry.value;
            // First = top performer, second = trending
            // Professional staggered entrance animation
            return AnimatedCard(
              key: ValueKey(holding.symbol),
              delay: index * 100, // 100ms stagger - professional timing
              duration: const Duration(milliseconds: 400), // Smooth 400ms animation
              child: HoldingCard(
                key: ValueKey('${holding.symbol}_card'),
                holding: holding,
                showPercentage: showPercentage,
                isTopPerformer: index == 0,
                isTrending: index == 1,
              ),
            );
          } catch (e) {
            // If one card fails to build, return empty widget
            return const SizedBox.shrink();
          }
        }).toList(),
      ),
    );
  }
}

