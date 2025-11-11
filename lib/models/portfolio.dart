// Represents a user's investment portfolio
// Contains the total value, gain/loss, and list of all holdings
// Includes comprehensive data validation and error handling
class Portfolio {
  final String user;
  final double portfolioValue; // Total current value of all stocks
  final double totalGain; // Can be negative if portfolio is down
  final List<Holding> holdings; // All the individual stocks

  Portfolio({
    required this.user,
    required this.portfolioValue,
    required this.totalGain,
    required this.holdings,
  }) {
    // Validate portfolio data makes sense
    if (user.trim().isEmpty) {
      throw ArgumentError('User name cannot be empty');
    }
    if (portfolioValue.isNaN || portfolioValue.isInfinite) {
      throw ArgumentError('Portfolio value must be a valid number');
    }
    if (portfolioValue < 0) {
      throw ArgumentError('Portfolio value cannot be negative');
    }
    if (totalGain.isNaN || totalGain.isInfinite) {
      throw ArgumentError('Total gain must be a valid number');
    }
    if (holdings.isEmpty) {
      throw ArgumentError('Portfolio must have at least one holding');
    }
  }

  // Creates a Portfolio from JSON data
  // Validates all required fields are present and correct
  // Handles all edge cases and provides detailed error messages
  factory Portfolio.fromJson(Map<String, dynamic> json) {
    try {
      // Check all required fields exist
      if (!json.containsKey('user') || json['user'] == null) {
        throw const FormatException('Missing required field: user');
      }
      if (!json.containsKey('portfolio_value') || json['portfolio_value'] == null) {
        throw const FormatException('Missing required field: portfolio_value');
      }
      if (!json.containsKey('total_gain') || json['total_gain'] == null) {
        throw const FormatException('Missing required field: total_gain');
      }
      if (!json.containsKey('holdings') || json['holdings'] == null) {
        throw const FormatException('Missing required field: holdings');
      }

      // Validate and extract user field
      final userValue = json['user'];
      if (userValue is! String) {
        throw const FormatException('User field must be a string');
      }
      // Normalize: trim whitespace
      final user = userValue.trim();
      if (user.isEmpty) {
        throw const FormatException('User name cannot be empty');
      }

      // Validate and extract portfolio_value
      final portfolioValueValue = json['portfolio_value'];
      if (portfolioValueValue is! num) {
        throw const FormatException('Portfolio value must be a number');
      }
      final portfolioValue = portfolioValueValue.toDouble();
      if (portfolioValue.isNaN || portfolioValue.isInfinite) {
        throw const FormatException('Portfolio value must be a valid number');
      }
      if (portfolioValue < 0) {
        throw const FormatException('Portfolio value cannot be negative');
      }

      // Validate and extract total_gain
      final totalGainValue = json['total_gain'];
      if (totalGainValue is! num) {
        throw const FormatException('Total gain must be a number');
      }
      final totalGain = totalGainValue.toDouble();
      if (totalGain.isNaN || totalGain.isInfinite) {
        throw const FormatException('Total gain must be a valid number');
      }

      // Validate holdings is a list
      final holdingsValue = json['holdings'];
      if (holdingsValue is! List) {
        throw const FormatException('Holdings must be a list');
      }
      final holdingsList = holdingsValue;
      
      if (holdingsList.isEmpty) {
        throw const FormatException('Holdings list cannot be empty');
      }

      // Parse each holding and handle any that fail
      final parsedHoldings = <Holding>[];
      for (int i = 0; i < holdingsList.length; i++) {
        try {
          final holdingJson = holdingsList[i];
          if (holdingJson == null) {
            throw FormatException('Holding at index $i is null');
          }
          if (holdingJson is! Map<String, dynamic>) {
            throw FormatException('Holding at index $i must be an object');
          }
          parsedHoldings.add(Holding.fromJson(holdingJson));
        } catch (e) {
          // If one holding fails, throw with context
          throw FormatException('Failed to parse holding at index $i: $e');
        }
      }

      // Create and return the portfolio
      return Portfolio(
        user: user,
        portfolioValue: portfolioValue,
        totalGain: totalGain,
        holdings: parsedHoldings,
      );
    } catch (e) {
      // If it's already a FormatException, just rethrow it
      if (e is FormatException) {
        rethrow;
      }
      // Otherwise wrap it
      throw FormatException('Failed to parse portfolio JSON: $e');
    }
  }

  // Converts Portfolio to JSON format
  // Useful for serialization and data persistence
  Map<String, dynamic> toJson() {
    try {
      return {
        'user': user,
        'portfolio_value': portfolioValue,
        'total_gain': totalGain,
        'holdings': holdings.map((holding) => holding.toJson()).toList(),
      };
    } catch (e) {
      throw FormatException('Failed to serialize portfolio to JSON: $e');
    }
  }

  // Calculate gain/loss as a percentage
  // Formula: (totalGain / investedAmount) × 100
  // investedAmount = portfolioValue - totalGain (what we originally put in)
  double get totalGainPercentage {
    try {
      final investedAmount = portfolioValue - totalGain;
      // Avoid division by zero
      if (investedAmount == 0 || portfolioValue == 0) {
        return 0.0;
      }
      final percentage = (totalGain / investedAmount) * 100;
      // Make sure result is valid
      if (percentage.isNaN || percentage.isInfinite) {
        return 0.0;
      }
      return percentage;
    } catch (e) {
      // If anything goes wrong, return 0
      return 0.0;
    }
  }

  // Creates a copy of this portfolio with updated values
  // Useful for immutability and state management
  Portfolio copyWith({
    String? user,
    double? portfolioValue,
    double? totalGain,
    List<Holding>? holdings,
  }) {
    try {
      return Portfolio(
        user: user ?? this.user,
        portfolioValue: portfolioValue ?? this.portfolioValue,
        totalGain: totalGain ?? this.totalGain,
        holdings: holdings ?? this.holdings,
      );
    } catch (e) {
      throw ArgumentError('Failed to create portfolio copy: $e');
    }
  }
}

// Represents a single stock holding
// Has all the info about one stock: symbol, name, how many shares, prices, etc.
// Includes comprehensive validation and safe calculations
class Holding {
  final String symbol; // Stock ticker like "TCS" or "INFY"
  final String name; // Full company name
  final int units; // How many shares we own
  final double avgCost; // What we paid per share on average
  final double currentPrice; // Current market price per share

  Holding({
    required this.symbol,
    required this.name,
    required this.units,
    required this.avgCost,
    required this.currentPrice,
  }) {
    // Make sure the data makes sense
    if (symbol.trim().isEmpty) {
      throw ArgumentError('Symbol cannot be empty');
    }
    if (name.trim().isEmpty) {
      throw ArgumentError('Name cannot be empty');
    }
    if (units <= 0) {
      throw ArgumentError('Units must be greater than 0');
    }
    if (avgCost.isNaN || avgCost.isInfinite) {
      throw ArgumentError('Average cost must be a valid number');
    }
    if (avgCost <= 0) {
      throw ArgumentError('Average cost must be greater than 0');
    }
    if (currentPrice.isNaN || currentPrice.isInfinite) {
      throw ArgumentError('Current price must be a valid number');
    }
    if (currentPrice < 0) {
      throw ArgumentError('Current price cannot be negative');
    }
  }

  // Creates a Holding from JSON
  // Validates all fields are present and have valid values
  // Handles type coercion and data normalization
  factory Holding.fromJson(Map<String, dynamic> json) {
    try {
      // Check all required fields exist
      final requiredFields = ['symbol', 'name', 'units', 'avg_cost', 'current_price'];
      for (final field in requiredFields) {
        if (!json.containsKey(field) || json[field] == null) {
          throw FormatException('Missing required field: $field');
        }
      }

      // Extract and validate symbol
      final symbolValue = json['symbol'];
      if (symbolValue is! String) {
        throw const FormatException('Symbol must be a string');
      }
      // Normalize: trim and uppercase
      final symbol = symbolValue.trim().toUpperCase();
      if (symbol.isEmpty) {
        throw const FormatException('Symbol cannot be empty');
      }

      // Extract and validate name
      final nameValue = json['name'];
      if (nameValue is! String) {
        throw const FormatException('Name must be a string');
      }
      // Normalize: trim whitespace
      final name = nameValue.trim();
      if (name.isEmpty) {
        throw const FormatException('Name cannot be empty');
      }

      // Extract and validate units
      final unitsValue = json['units'];
      int units;
      if (unitsValue is int) {
        units = unitsValue;
      } else if (unitsValue is double) {
        // Allow double but convert to int (round to nearest)
        units = unitsValue.round();
      } else {
        throw const FormatException('Units must be an integer');
      }
      if (units <= 0) {
        throw const FormatException('Units must be greater than 0');
      }

      // Extract and validate avg_cost
      final avgCostValue = json['avg_cost'];
      if (avgCostValue is! num) {
        throw const FormatException('Average cost must be a number');
      }
      final avgCost = avgCostValue.toDouble();
      if (avgCost.isNaN || avgCost.isInfinite) {
        throw const FormatException('Average cost must be a valid number');
      }
      if (avgCost <= 0) {
        throw const FormatException('Average cost must be greater than 0');
      }

      // Extract and validate current_price
      final currentPriceValue = json['current_price'];
      if (currentPriceValue is! num) {
        throw const FormatException('Current price must be a number');
      }
      final currentPrice = currentPriceValue.toDouble();
      if (currentPrice.isNaN || currentPrice.isInfinite) {
        throw const FormatException('Current price must be a valid number');
      }
      if (currentPrice < 0) {
        throw const FormatException('Current price cannot be negative');
      }

      // Create and return the holding
      return Holding(
        symbol: symbol,
        name: name,
        units: units,
        avgCost: avgCost,
        currentPrice: currentPrice,
      );
    } catch (e) {
      // If it's already a FormatException, just rethrow it
      if (e is FormatException) {
        rethrow;
      }
      // Otherwise wrap it
      throw FormatException('Failed to parse holding JSON: $e');
    }
  }

  // Converts Holding to JSON format
  // Useful for serialization and data persistence
  Map<String, dynamic> toJson() {
    try {
      return {
        'symbol': symbol,
        'name': name,
        'units': units,
        'avg_cost': avgCost,
        'current_price': currentPrice,
      };
    } catch (e) {
      throw FormatException('Failed to serialize holding to JSON: $e');
    }
  }

  // Total amount we invested in this stock
  // Just units × average cost per unit
  // Returns 0.0 if calculation fails or result is invalid
  double get costBasis {
    try {
      final result = units * avgCost;
      // Make sure result is valid
      if (result.isNaN || result.isInfinite) {
        return 0.0;
      }
      // Clamp to reasonable range
      return result.clamp(0.0, double.maxFinite);
    } catch (e) {
      return 0.0;
    }
  }

  // Current value of this holding
  // Units × current market price
  // Returns 0.0 if calculation fails or result is invalid
  double get currentValue {
    try {
      final result = units * currentPrice;
      // Make sure result is valid
      if (result.isNaN || result.isInfinite) {
        return 0.0;
      }
      // Clamp to reasonable range
      return result.clamp(0.0, double.maxFinite);
    } catch (e) {
      return 0.0;
    }
  }

  // How much we've gained or lost (in rupees)
  // Positive = profit, negative = loss
  // Returns 0.0 if calculation fails or result is invalid
  double get gainLoss {
    try {
      final result = currentValue - costBasis;
      // Make sure result is valid
      if (result.isNaN || result.isInfinite) {
        return 0.0;
      }
      return result;
    } catch (e) {
      return 0.0;
    }
  }

  // Gain/loss as a percentage
  // (gainLoss / costBasis) × 100
  // Returns 0 if costBasis is 0 to avoid division by zero
  double get gainLossPercentage {
    try {
      final basis = costBasis;
      if (basis == 0) return 0.0;
      final percentage = (gainLoss / basis) * 100;
      // Make sure result is valid
      if (percentage.isNaN || percentage.isInfinite) {
        return 0.0;
      }
      return percentage;
    } catch (e) {
      return 0.0;
    }
  }

  // Creates a copy of this holding with updated values
  // Useful for immutability and state management
  Holding copyWith({
    String? symbol,
    String? name,
    int? units,
    double? avgCost,
    double? currentPrice,
  }) {
    try {
      return Holding(
        symbol: symbol ?? this.symbol,
        name: name ?? this.name,
        units: units ?? this.units,
        avgCost: avgCost ?? this.avgCost,
        currentPrice: currentPrice ?? this.currentPrice,
      );
    } catch (e) {
      throw ArgumentError('Failed to create holding copy: $e');
    }
  }
}
