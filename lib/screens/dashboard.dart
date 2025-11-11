import 'package:flutter/material.dart';
import '../models/portfolio.dart';
import '../widgets/portfolio_summary.dart';
import '../widgets/allocation_chart.dart';
import '../services/portfolio_service.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/responsive.dart';
import '../widgets/holdings/holdings_header.dart';
import '../widgets/holdings/holdings_list.dart';
import '../widgets/holdings/empty_holdings_state.dart';
import '../widgets/common/animated_icon_button.dart';
import '../widgets/common/app_logo.dart';
import 'login_screen.dart';

// Options for sorting the holdings
enum SortOption { name, value, gain }

// Main dashboard screen - shows portfolio overview
// Has summary card, pie chart, and list of holdings
// Can sort holdings and refresh prices
class Dashboard extends StatefulWidget {
  final Portfolio portfolio;
  final ThemeProvider themeProvider;
  final AuthProvider authProvider;

  const Dashboard({
    super.key,
    required this.portfolio,
    required this.themeProvider,
    required this.authProvider,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // Show gain as percentage or currency amount
  bool _showPercentage = false;
  
  // How to sort the holdings list
  SortOption _sortOption = SortOption.name;
  
  // Current portfolio (gets updated when we refresh)
  late Portfolio _currentPortfolio;
  
  // Holdings sorted according to _sortOption
  late List<Holding> _sortedHoldings;
  
  // Prevent multiple refreshes at the same time
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    // Start with the portfolio we got
    _currentPortfolio = widget.portfolio;
    _sortedHoldings = List.from(_currentPortfolio.holdings);
    // Sort them on initial load
    _sortHoldings();
  }

  // Sort the holdings based on the selected option
  void _sortHoldings() {
    try {
      setState(() {
        // Make sure we have holdings to sort
        if (_sortedHoldings.isEmpty) {
          return;
        }

        switch (_sortOption) {
          case SortOption.name:
            // Sort by company name (A to Z)
            try {
              _sortedHoldings.sort((a, b) {
                try {
                  return a.name.compareTo(b.name);
                } catch (e) {
                  // If comparison fails, keep original order
                  return 0;
                }
              });
            } catch (e) {
              // If sort fails, keep original order
            }
            break;
          case SortOption.value:
            // Sort by current value (highest first)
            try {
              _sortedHoldings.sort((a, b) {
                try {
                  final aValue = a.currentValue;
                  final bValue = b.currentValue;
                  // Handle invalid values
                  if (aValue.isNaN || aValue.isInfinite) return 1;
                  if (bValue.isNaN || bValue.isInfinite) return -1;
                  return bValue.compareTo(aValue);
                } catch (e) {
                  return 0;
                }
              });
            } catch (e) {
              // If sort fails, keep original order
            }
            break;
          case SortOption.gain:
            // Sort by gain/loss (biggest gain first)
            try {
              _sortedHoldings.sort((a, b) {
                try {
                  final aGain = a.gainLoss;
                  final bGain = b.gainLoss;
                  // Handle invalid values
                  if (aGain.isNaN || aGain.isInfinite) return 1;
                  if (bGain.isNaN || bGain.isInfinite) return -1;
                  return bGain.compareTo(aGain);
                } catch (e) {
                  return 0;
                }
              });
            } catch (e) {
              // If sort fails, keep original order
            }
            break;
        }
      });
    } catch (e) {
      // If sorting completely fails, just keep the original order
      // Don't crash the app
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Responsive.isMobile(context);
    final spacing = Responsive.getSpacing(context, mobile: 16, tablet: 20, desktop: 24);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF000000) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF000000) : const Color(0xFFFFFFFF),
        shadowColor: isDark ? Colors.transparent : const Color(0xFFE5E5E5),
        elevation: 0,
        // Thin line at bottom of app bar
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFE0E0E0),
          ),
        ),
        // Logo and app name - responsive layout with professional logo
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Professional app logo (Finance style - BEST option)
            AppLogo(
              style: LogoStyle.finance, // Best option - Finance chart with F
              size: isMobile ? 50 : 56,
            ),
            SizedBox(width: isMobile ? 8 : 10),
            // App name and user name below it
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'FinView Lite',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: isMobile ? 16 : 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _currentPortfolio.user,
                    style: TextStyle(
                      fontSize: isMobile ? 10 : 12,
                      color: isDark ? const Color(0xFF999999) : const Color(0xFF666666),
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        // Action buttons - responsive icon sizes with professional animations
        actions: [
          // Toggle between showing % or currency
          AnimatedIconButton(
            icon: _showPercentage ? Icons.percent : Icons.currency_rupee,
            iconSize: Responsive.getIconSize(context),
            onPressed: () {
              setState(() {
                _showPercentage = !_showPercentage;
              });
            },
            tooltip: _showPercentage ? 'Show Amount' : 'Show Percentage',
          ),
          // Theme toggle
          AnimatedIconButton(
            icon: widget.themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            iconSize: Responsive.getIconSize(context),
            onPressed: () {
              widget.themeProvider.toggleTheme();
            },
            tooltip: widget.themeProvider.isDarkMode
                ? 'Switch to Light Mode'
                : 'Switch to Dark Mode',
          ),
          // Logout button
          AnimatedIconButton(
            icon: Icons.logout,
            iconSize: Responsive.getIconSize(context),
            onPressed: () async {
              await widget.authProvider.logout();
              if (!mounted) return;
              // Navigate back to login screen
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LoginScreen(
                    authProvider: widget.authProvider,
                    themeProvider: widget.themeProvider,
                  ),
                ),
              );
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _currentPortfolio.holdings.isEmpty
          ? const EmptyHoldingsState()
          : RefreshIndicator(
              // Pull down to refresh prices
              onRefresh: () async {
                // Don't refresh if already refreshing
                if (_isRefreshing) return;
                setState(() {
                  _isRefreshing = true;
                });

                try {
                  // Simulate getting updated prices
                  final updatedPortfolio =
                      await PortfolioService.refreshPortfolio(_currentPortfolio);
                  if (mounted) {
                    setState(() {
                      _currentPortfolio = updatedPortfolio;
                      _sortedHoldings = List.from(_currentPortfolio.holdings);
                      // Re-sort with the new data
                      _sortHoldings();
                      _isRefreshing = false;
                    });
                  }
                } catch (e) {
                  // Show error if refresh failed
                  if (!mounted) return;
                  setState(() {
                    _isRefreshing = false;
                  });
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to refresh: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Big summary card at top
                    PortfolioSummary(
                      portfolio: _currentPortfolio,
                      showPercentage: _showPercentage,
                    ),
                    SizedBox(height: spacing),
                    // Pie chart showing asset allocation
                    AllocationChart(
                      holdings: _sortedHoldings,
                    ),
                    SizedBox(height: spacing),
                    // Header for holdings section with controls
                    HoldingsHeader(
                      holdingsCount: _sortedHoldings.length,
                      showPercentage: _showPercentage,
                      sortOptionName: _sortOption.name,
                      isDark: isDark,
                      onTogglePercentage: () {
                        setState(() {
                          _showPercentage = !_showPercentage;
                        });
                      },
                      onToggleSort: () {
                        setState(() {
                          // Cycle: name -> value -> gain -> name
                          if (_sortOption == SortOption.name) {
                            _sortOption = SortOption.value;
                          } else if (_sortOption == SortOption.value) {
                            _sortOption = SortOption.gain;
                          } else {
                            _sortOption = SortOption.name;
                          }
                          _sortHoldings();
                        });
                      },
                    ),
                    SizedBox(height: Responsive.getSpacing(context, mobile: 16, tablet: 18, desktop: 20)),
                    // List of all holdings
                    HoldingsList(
                      holdings: _sortedHoldings,
                      showPercentage: _showPercentage,
                    ),
                    SizedBox(height: spacing),
                  ],
                ),
              ),
            ),
    );
  }

}
