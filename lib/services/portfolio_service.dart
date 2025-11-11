import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../models/portfolio.dart';

// Service for loading portfolio data from JSON and simulating price updates
// All methods are static since we don't need to maintain any state
// Includes comprehensive error handling and data validation
class PortfolioService {
  // Path to our portfolio JSON file in assets
  static const String _portfolioAssetPath = 'assets/portfolio.json';

  // Loads portfolio data from the JSON file in assets
  // Returns a Portfolio object with all the data parsed and validated
  // Handles all file I/O errors, JSON parsing errors, and validation errors
  static Future<Portfolio> loadPortfolio() async {
    try {
      // Read the JSON file as a string
      final String jsonString;
      try {
        jsonString = await rootBundle.loadString(_portfolioAssetPath);
      } on PlatformException catch (e) {
        // File not found or can't be read
        debugPrint('PlatformException loading portfolio: $e');
        throw Exception('Failed to load portfolio file: ${e.message ?? "File not found"}');
      } catch (e) {
        // Other errors reading the file
        debugPrint('Error reading portfolio file: $e');
        throw Exception('Failed to read portfolio file: $e');
      }
      
      // Make sure file isn't empty
      if (jsonString.trim().isEmpty) {
        throw const FormatException('Portfolio JSON file is empty');
      }

      // Parse the JSON string into a map
      final Map<String, dynamic> jsonData;
      try {
        final decoded = json.decode(jsonString);
        if (decoded is! Map<String, dynamic>) {
          throw const FormatException('Portfolio JSON must be an object');
        }
        jsonData = decoded;
      } on FormatException {
        // Re-throw format exceptions as-is (they have good messages)
        rethrow;
      } catch (e) {
        // JSON is malformed
        debugPrint('Invalid JSON format: $e');
        throw FormatException('Invalid JSON format: $e');
      }

      // Let the Portfolio model handle validation and creation
      try {
        return Portfolio.fromJson(jsonData);
      } on FormatException {
        // Re-throw format exceptions as-is
        rethrow;
      } catch (e) {
        // Wrap other errors
        debugPrint('Failed to create portfolio from JSON: $e');
        throw Exception('Failed to create portfolio: $e');
      }
    } on FormatException {
      // Re-throw format errors as-is (they have good messages)
      rethrow;
    } catch (e) {
      // Something else went wrong
      debugPrint('Unexpected error loading portfolio: $e');
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Unexpected error loading portfolio: $e');
    }
  }

  // Simulates refreshing portfolio prices by randomly changing them
  // This mimics what would happen if we called a real API to get updated prices
  // Prices change by -5% to +5% to simulate realistic market movement
  // Includes comprehensive validation and error handling
  static Future<Portfolio> refreshPortfolio(Portfolio currentPortfolio) async {
    // Validate input
    if (currentPortfolio.holdings.isEmpty) {
      throw ArgumentError('Cannot refresh empty portfolio');
    }

    try {
      // Wait a bit to simulate network delay (feels more realistic)
      await Future.delayed(const Duration(seconds: 1));

      // Generate random price changes for each stock
      final random = Random();
      final updatedHoldings = <Holding>[];
      
      // Process each holding individually so we can handle errors
      for (int i = 0; i < currentPortfolio.holdings.length; i++) {
        try {
          final holding = currentPortfolio.holdings[i];
          
          // Validate holding data before processing
          if (holding.currentPrice.isNaN || holding.currentPrice.isInfinite) {
            // If price is invalid, keep the old holding
            updatedHoldings.add(holding);
            continue;
          }
          
          // Calculate random price change between -5% and +5%
          // random.nextDouble() gives 0.0 to 1.0
          // Subtract 0.5 to get -0.5 to +0.5
          // Multiply by 0.1 to get -0.05 to +0.05 (which is -5% to +5%)
          final priceChange = (random.nextDouble() - 0.5) * 0.1;
          
          // Apply the change and make sure price doesn't go negative or invalid
          var newPrice = holding.currentPrice * (1 + priceChange);
          
          // Clamp to valid range (0 to a reasonable max)
          newPrice = newPrice.clamp(0.0, double.maxFinite);
          
          // Make sure it's a valid number
          if (newPrice.isNaN || newPrice.isInfinite) {
            // If calculation failed, keep the old price
            newPrice = holding.currentPrice;
          }

          // Create a new holding with the updated price
          // Everything else stays the same (symbol, name, units, avg cost)
          updatedHoldings.add(
            Holding(
              symbol: holding.symbol,
              name: holding.name,
              units: holding.units,
              avgCost: holding.avgCost,
              currentPrice: newPrice,
            ),
          );
        } catch (e) {
          // If updating one holding fails, keep the old one
          // This way we don't lose all data if one fails
          debugPrint('Error updating holding at index $i: $e');
          updatedHoldings.add(currentPortfolio.holdings[i]);
        }
      }

      // Make sure we still have some holdings
      if (updatedHoldings.isEmpty) {
        throw Exception('All holdings failed to update');
      }

      // Recalculate total portfolio value from all holdings
      double newPortfolioValue = 0.0;
      try {
        newPortfolioValue = updatedHoldings.fold<double>(
          0,
          (sum, holding) {
            try {
              final value = holding.currentValue;
              // Skip invalid values
              if (value.isNaN || value.isInfinite) {
                return sum;
              }
              // Make sure we don't overflow
              final newSum = sum + value;
              if (newSum.isNaN || newSum.isInfinite) {
                return sum;
              }
              return newSum;
            } catch (e) {
              // If one holding fails, skip it
              return sum;
            }
          },
        );
        // Make sure result is valid
        if (newPortfolioValue.isNaN || newPortfolioValue.isInfinite) {
          newPortfolioValue = 0.0;
        }
        // Clamp to reasonable range
        newPortfolioValue = newPortfolioValue.clamp(0.0, double.maxFinite);
      } catch (e) {
        // If calculation fails, use 0
        debugPrint('Error calculating portfolio value: $e');
        newPortfolioValue = 0.0;
      }

      // Recalculate total gain/loss
      double newTotalGain = 0.0;
      try {
        newTotalGain = updatedHoldings.fold<double>(
          0,
          (sum, holding) {
            try {
              final gain = holding.gainLoss;
              // Skip invalid values
              if (gain.isNaN || gain.isInfinite) {
                return sum;
              }
              // Make sure we don't overflow
              final newSum = sum + gain;
              if (newSum.isNaN || newSum.isInfinite) {
                return sum;
              }
              return newSum;
            } catch (e) {
              // If one holding fails, skip it
              return sum;
            }
          },
        );
        // Make sure result is valid
        if (newTotalGain.isNaN || newTotalGain.isInfinite) {
          newTotalGain = 0.0;
        }
      } catch (e) {
        // If calculation fails, use 0
        debugPrint('Error calculating total gain: $e');
        newTotalGain = 0.0;
      }

      // Return a new portfolio with updated values
      try {
        return Portfolio(
          user: currentPortfolio.user,
          portfolioValue: newPortfolioValue,
          totalGain: newTotalGain,
          holdings: updatedHoldings,
        );
      } catch (e) {
        // If creating portfolio fails, throw error
        throw Exception('Failed to create updated portfolio: $e');
      }
    } catch (e) {
      // If it's already an ArgumentError or Exception, rethrow
      if (e is ArgumentError || e is Exception) {
        rethrow;
      }
      // Otherwise wrap it
      throw Exception('Unexpected error refreshing portfolio: $e');
    }
  }

  // Validates that a JSON string is valid before parsing
  // Useful for pre-validation before attempting to parse
  static bool isValidJson(String jsonString) {
    try {
      if (jsonString.trim().isEmpty) {
        return false;
      }
      final decoded = json.decode(jsonString);
      return decoded is Map<String, dynamic> || decoded is List;
    } catch (e) {
      return false;
    }
  }

  // Safely parses a JSON string to a Map
  // Returns null if parsing fails
  static Map<String, dynamic>? tryParseJson(String jsonString) {
    try {
      if (jsonString.trim().isEmpty) {
        return null;
      }
      final decoded = json.decode(jsonString);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
