import 'package:flutter/material.dart';
import '../utils/responsive.dart';

// Shows a nice empty state when there's no data
// Used when portfolio is empty or data failed to load
// Responsive layout for mobile and desktop
class EmptyState extends StatelessWidget {
  final String message;
  final String? subtitle; // Optional extra text below the main message

  const EmptyState({
    super.key,
    this.message = 'No investments to display',
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final fontScale = Responsive.getFontScale(context);
    
    return Center(
      child: Padding(
        padding: Responsive.getPadding(context, mobile: 24, tablet: 28, desktop: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon in a circle with subtle background
            Container(
              padding: Responsive.getPadding(context, mobile: 20, tablet: 22, desktop: 24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.account_balance_wallet_outlined,
                size: Responsive.getTextSize(context, mobile: 56, tablet: 60, desktop: 64) * fontScale,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: Responsive.getSpacing(context, mobile: 20, tablet: 22, desktop: 24)),
            
            // Main message text
            Text(
              message,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: Responsive.getTextSize(context, mobile: 20, tablet: 22, desktop: 24) * fontScale,
                  ),
              textAlign: TextAlign.center,
            ),
            
            // Show subtitle if provided
            if (subtitle != null) ...[
              SizedBox(height: Responsive.getSpacing(context, mobile: 6, tablet: 7, desktop: 8)),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: Responsive.getTextSize(context, mobile: 14, tablet: 15, desktop: 16) * fontScale,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
