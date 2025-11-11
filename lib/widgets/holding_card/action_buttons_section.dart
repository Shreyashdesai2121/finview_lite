import 'package:flutter/material.dart';
import '../../utils/responsive.dart';
import '../common/app_button.dart';

// Action buttons section for holding card
// Shows Buy More, Sell, and Details buttons
// Properly decomposed from HoldingCard for better organization
class ActionButtonsSection extends StatelessWidget {
  final bool isDark;
  final bool isMobile;

  const ActionButtonsSection({
    super.key,
    required this.isDark,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Column(
        children: [
          // Buy More button (orange, primary action)
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'Buy More',
              icon: Icons.trending_up,
              isPrimary: true,
              onPressed: () {
                // Handle buy action
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Buy More action')),
                );
              },
            ),
          ),
          SizedBox(height: Responsive.getSpacing(context, mobile: 8, tablet: 9, desktop: 10)),
          // Sell and Details buttons side by side
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Sell',
                  icon: Icons.sell,
                  isPrimary: false,
                  onPressed: () {
                    // Handle sell action
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sell action')),
                    );
                  },
                ),
              ),
              SizedBox(width: Responsive.getSpacing(context, mobile: 8, tablet: 9, desktop: 10)),
              Expanded(
                child: AppButton(
                  label: 'Details',
                  icon: Icons.info_outline,
                  isPrimary: false,
                  onPressed: () {
                    // Handle details action
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Details action')),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Row(
        children: [
          // Buy More button (orange, primary action)
          Expanded(
            child: AppButton(
              label: 'Buy More',
              icon: Icons.trending_up,
              isPrimary: true,
              onPressed: () {
                // Handle buy action
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Buy More action')),
                );
              },
            ),
          ),
          SizedBox(width: Responsive.getSpacing(context, mobile: 8, tablet: 9, desktop: 10)),
          // Sell button
          Expanded(
            child: AppButton(
              label: 'Sell',
              icon: Icons.sell,
              isPrimary: false,
              onPressed: () {
                // Handle sell action
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sell action')),
                );
              },
            ),
          ),
          SizedBox(width: Responsive.getSpacing(context, mobile: 8, tablet: 9, desktop: 10)),
          // Details button
          Expanded(
            child: AppButton(
              label: 'Details',
              icon: Icons.info_outline,
              isPrimary: false,
              onPressed: () {
                // Handle details action
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Details action')),
                );
              },
            ),
          ),
        ],
      );
    }
  }
}

