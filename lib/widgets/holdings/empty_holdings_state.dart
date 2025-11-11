import 'package:flutter/material.dart';

// Empty state widget specifically for holdings list
// Properly decomposed from dashboard for better organization
class EmptyHoldingsState extends StatelessWidget {
  const EmptyHoldingsState({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: isDark ? Colors.grey[400] : const Color(0xFF9B9B9B),
          ),
          const SizedBox(height: 16),
          Text(
            'No Holdings Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.grey[600] : const Color(0xFF6B6B6B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your portfolio is empty',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[500] : const Color(0xFF9B9B9B),
            ),
          ),
        ],
      ),
    );
  }
}

