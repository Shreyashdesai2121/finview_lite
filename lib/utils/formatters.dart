import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

// Helper class for formatting numbers consistently across the app
// Using intl package for proper locale-aware formatting
// Includes comprehensive error handling and data validation
class Formatters {
  // Formats a number as Indian Rupee currency
  // Uses en_IN locale which gives us lakhs/crores format (1,50,000 instead of 150,000)
  // Handles all edge cases: NaN, Infinity, null, overflow
  static String currency(double amount) {
    try {
      // Handle invalid numbers
      if (amount.isNaN || amount.isInfinite) {
        return '₹0.00';
      }
      
      // Clamp to reasonable range to avoid formatting issues
      final clampedAmount = amount.clamp(-double.maxFinite, double.maxFinite);
      
      // Validate clamped amount is still valid
      if (clampedAmount.isNaN || clampedAmount.isInfinite) {
        return '₹0.00';
      }
      
      final formatter = NumberFormat.currency(
        locale: 'en_IN', // Indian numbering system
        symbol: '₹',
        decimalDigits: 2,
      );
      
      try {
        return formatter.format(clampedAmount);
      } on FormatException catch (e) {
        // If formatting fails due to format exception, use fallback
        debugPrint('Currency formatting error: $e');
        return '₹${clampedAmount.toStringAsFixed(2)}';
      } catch (e) {
        // If any other error occurs, use fallback
        debugPrint('Currency formatting error: $e');
        return '₹${clampedAmount.toStringAsFixed(2)}';
      }
    } catch (e) {
      // If anything goes wrong, return a safe default
      debugPrint('Currency formatting error: $e');
      return '₹0.00';
    }
  }

  // Formats a number as percentage with % symbol
  // Handles both positive and negative values
  // Handles all edge cases: NaN, Infinity, null, overflow
  static String percentage(double value) {
    try {
      // Handle invalid numbers
      if (value.isNaN || value.isInfinite) {
        return '0.00%';
      }
      
      // Clamp to reasonable range
      final clampedValue = value.clamp(-double.maxFinite, double.maxFinite);
      
      // Validate clamped value is still valid
      if (clampedValue.isNaN || clampedValue.isInfinite) {
        return '0.00%';
      }
      
      final formatter = NumberFormat.decimalPattern('en_US');
      
      try {
        return '${formatter.format(clampedValue)}%';
      } on FormatException catch (e) {
        // If formatting fails due to format exception, use fallback
        debugPrint('Percentage formatting error: $e');
        return '${clampedValue.toStringAsFixed(2)}%';
      } catch (e) {
        // If any other error occurs, use fallback
        debugPrint('Percentage formatting error: $e');
        return '${clampedValue.toStringAsFixed(2)}%';
      }
    } catch (e) {
      // If anything goes wrong, return a safe default
      debugPrint('Percentage formatting error: $e');
      return '0.00%';
    }
  }

  // Safely formats a number as currency, returning a default if it fails
  // Useful when you want to ensure a value is always returned
  static String currencySafe(double? amount) {
    if (amount == null) {
      return '₹0.00';
    }
    return currency(amount);
  }

  // Safely formats a number as percentage, returning a default if it fails
  // Useful when you want to ensure a value is always returned
  static String percentageSafe(double? value) {
    if (value == null) {
      return '0.00%';
    }
    return percentage(value);
  }

  // Validates if a number is valid for formatting
  // Returns true if the number can be safely formatted
  static bool isValidNumber(double value) {
    return !value.isNaN && !value.isInfinite;
  }
}
