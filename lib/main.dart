import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'services/portfolio_service.dart';
import 'screens/dashboard.dart';
import 'screens/login_screen.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'widgets/common/shimmer_loader.dart';

// App entry point - just starts the main widget
void main() {
  runApp(const FinViewLiteApp());
}

// Main app widget that handles routing, theme, and state management
class FinViewLiteApp extends StatefulWidget {
  const FinViewLiteApp({super.key});

  @override
  State<FinViewLiteApp> createState() => _FinViewLiteAppState();
}

class _FinViewLiteAppState extends State<FinViewLiteApp> {
  // Theme provider for dark mode toggle
  final ThemeProvider _themeProvider = ThemeProvider();
  // Auth provider for login state management
  final AuthProvider _authProvider = AuthProvider();

  @override
  void initState() {
    super.initState();
    // Listen for theme and auth changes
    _themeProvider.addListener(_onThemeChanged);
    _authProvider.addListener(_onAuthChanged);
  }

  @override
  void dispose() {
    // Remove listeners to prevent memory leaks
    _themeProvider.removeListener(_onThemeChanged);
    _authProvider.removeListener(_onAuthChanged);
    super.dispose();
  }

  // Called whenever theme changes - rebuild the app
  void _onThemeChanged() {
    setState(() {});
  }

  // Called whenever auth state changes - rebuild to show/hide login
  void _onAuthChanged() {
    setState(() {});
  }

  // Get font family with fallback if Google Fonts fails to load
  static String? _getFontFamily() {
    try {
      return GoogleFonts.inter().fontFamily;
    } catch (e) {
      // If Google Fonts fails, use system default
      debugPrint('Warning: Could not load Google Fonts: $e. Using system font.');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Wrap everything in providers so child widgets can access them
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _themeProvider),
        ChangeNotifierProvider.value(value: _authProvider),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'FinView Lite',
            debugShowCheckedModeBanner: false,
            
            // Light theme - clean and minimal
            theme: ThemeData(
              brightness: Brightness.light,
              fontFamily: _getFontFamily(),
              scaffoldBackgroundColor: const Color(0xFFF5F5F5),
              cardColor: const Color(0xFFFFFFFF),
              
              // Text colors that work well on light background
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Color(0xFF000000)),
                bodyMedium: TextStyle(color: Color(0xFF2A2A2A)),
              ),
              
              // Orange is our primary brand color
              colorScheme: const ColorScheme.light(
                primary: Color(0xFFF7931A),
                secondary: Color(0xFFFF9D2E),
                surface: Color(0xFFFFFFFF),
                error: Color(0xFFF6465D),
              ),
              
              // Input fields should have consistent styling
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: const Color(0xFFFFFFFF),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFD0D5DD),
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFD0D5DD),
                    width: 1.5,
                  ),
                ),
                // Orange border when focused
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFF7931A),
                    width: 1.5,
                  ),
                ),
              ),
              
              // Cards should have subtle shadows
              cardTheme: CardThemeData(
                elevation: 3,
                shadowColor: Colors.black.withValues(alpha: 0.12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              
              // App bar should be clean with minimal elevation
              appBarTheme: const AppBarTheme(
                elevation: 0,
                centerTitle: false,
                backgroundColor: Color(0xFFFFFFFF),
                foregroundColor: Color(0xFF0A0A0A),
                shadowColor: Color(0xFFE5E5E5),
              ),
            ),
            
            // Dark theme - same structure but darker colors
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              fontFamily: _getFontFamily(),
              scaffoldBackgroundColor: const Color(0xFF000000),
              cardColor: const Color(0xFF0D0D0D),
              
              // Lighter text colors for dark background
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Color(0xFFFFFFFF)),
                bodyMedium: TextStyle(color: Color(0xFF999999)),
              ),
              
              // Same color scheme but adjusted for dark mode
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFFF7931A),
                secondary: Color(0xFFFF9D2E),
                surface: Color(0xFF0D0D0D),
                error: Color(0xFFF6465D),
              ),
              
              // Darker input fields
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: const Color(0xFF1A1A1A),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF333333),
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF333333),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFF7931A),
                    width: 1.5,
                  ),
                ),
              ),
              
              // Dark mode cards
              cardTheme: CardThemeData(
                elevation: 4,
                shadowColor: Colors.black45,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              
              appBarTheme: const AppBarTheme(
                elevation: 1,
                centerTitle: false,
                backgroundColor: Color(0xFF000000),
                foregroundColor: Colors.white,
              ),
            ),
            
            // Use the theme mode from our provider
            themeMode: themeProvider.themeMode,
            
            // Show login screen if not logged in, otherwise show dashboard
            home: _authProvider.isLoggedIn
                ? PortfolioLoader(
                    themeProvider: _themeProvider,
                    authProvider: _authProvider,
                  )
                : LoginScreen(
                    authProvider: _authProvider,
                    themeProvider: _themeProvider,
                  ),
          );
        },
      ),
    );
  }

}

// This widget loads the portfolio data and then navigates to dashboard
// Shows loading spinner while fetching, error message if it fails
class PortfolioLoader extends StatefulWidget {
  final ThemeProvider themeProvider;
  final AuthProvider authProvider;

  const PortfolioLoader({
    super.key,
    required this.themeProvider,
    required this.authProvider,
  });

  @override
  State<PortfolioLoader> createState() => _PortfolioLoaderState();
}

class _PortfolioLoaderState extends State<PortfolioLoader> {
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Start loading as soon as widget is created
    _loadPortfolio();
  }

  // Load portfolio from JSON file in assets
  Future<void> _loadPortfolio() async {
    try {
      // This reads the portfolio.json file from assets
      final portfolio = await PortfolioService.loadPortfolio();
      
      // Make sure widget is still mounted before updating state
      // (user might have navigated away)
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
        _error = null; // Clear any previous errors
      });
      
      // Validate portfolio before navigating
      if (portfolio.holdings.isEmpty) {
        if (!mounted) return;
        setState(() {
          _error = 'Portfolio is empty. Please add some holdings.';
        });
        return;
      }
      
      // Navigate to dashboard with the loaded portfolio
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Dashboard(
            portfolio: portfolio,
            themeProvider: widget.themeProvider,
            authProvider: widget.authProvider,
          ),
        ),
      );
    } on FormatException catch (e) {
      // Format errors have good messages
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = e.message;
      });
    } catch (e) {
      // Something went wrong - show error message
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        // Provide a user-friendly error message
        _error = e.toString().isNotEmpty 
            ? e.toString() 
            : 'Failed to load portfolio. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show professional shimmer loading effect
    if (_isLoading) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: ShimmerLoader(
            baseColor: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFE0E0E0),
            highlightColor: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFE0E0E0),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      );
    }

    // Show error if loading failed
    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              const Text(
                'Failed to load portfolio',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                style: const TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Let user retry if it failed
              ElevatedButton(
                onPressed: _loadPortfolio,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // Should never get here, but need to return something
    return const SizedBox.shrink();
  }
}
