import 'package:flutter/material.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/responsive.dart';
import '../services/portfolio_service.dart';
import '../widgets/common/app_logo.dart';
import 'dashboard.dart';

// Login screen with nice design
// Has form validation, hover effects, and theme toggle
// For demo, any non-empty username/password works
class LoginScreen extends StatefulWidget {
  final AuthProvider authProvider;
  final ThemeProvider themeProvider;

  const LoginScreen({
    super.key,
    required this.authProvider,
    required this.themeProvider,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for the text fields
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // UI state
  bool _isLoading = false;
  bool _obscurePassword = true; // Hide password by default
  bool _rememberMe = false;
  
  // Hover states for buttons and card
  bool _isCardHovered = false;
  bool _isGoogleHovered = false;
  bool _isLoginHovered = false;

  @override
  void dispose() {
    // Clean up controllers
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Handle the login button press
  Future<void> _handleLogin() async {
    // Validate form first
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      // Try to log in
      final success = await widget.authProvider.login(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
    );

    if (!mounted) return;

      if (!success) {
        // Login failed - show error
        setState(() {
          _isLoading = false;
        });
        final errorMessage = widget.authProvider.errorMessage ?? 
            'Login failed. Please try again.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
        return;
      }

      // Login successful - now load portfolio
      try {
        final portfolio = await PortfolioService.loadPortfolio();
        
        if (!mounted) return;
        
        // Navigate to dashboard immediately
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Dashboard(
              portfolio: portfolio,
              themeProvider: widget.themeProvider,
              authProvider: widget.authProvider,
            ),
          ),
        );
      } catch (e) {
        // Portfolio loading failed
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to load portfolio: $e'),
          backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      // Unexpected error
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isMobile = Responsive.isMobile(context);
    final supportsHover = Responsive.supportsHover(context);
    final fontScale = Responsive.getFontScale(context);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF000000) : const Color(0xFFF5F5F5),
      body: Container(
        // Clean background - no gradient for better light mode
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF000000)
              : const Color(0xFFF5F5F5),
        ),
        child: Stack(
          children: [
            // Decorative circles in dark mode (subtle orange glow)
            if (isDark) ...[
              Positioned(
                top: -100,
                right: -100,
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFF7931A).withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -150,
                left: -150,
                child: Container(
                  width: 500,
                  height: 500,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFF7931A).withValues(alpha: 0.08),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
            // Main login card - scrollable for both mobile and web
            Center(
              child: SingleChildScrollView(
                padding: Responsive.getPadding(context, mobile: 16, tablet: 20, desktop: 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    // Wider rectangular layout for web (like website logins)
                    maxWidth: isMobile 
                      ? double.infinity
                      : (Responsive.getMaxWidth(
                          context,
                          mobile: double.infinity,
                          tablet: 600,
                          desktop: 700,
                        ) ?? 700),
                  ),
                  child: _buildLoginCard(context, isDark, isMobile, supportsHover, fontScale),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginCard(BuildContext context, bool isDark, bool isMobile, bool supportsHover, double fontScale) {
    final isTablet = Responsive.isTablet(context);
    final cardContent = Transform.translate(
                            // Lift card when hovered
                            offset: Offset(0, _isCardHovered ? -8.0 : 0.0),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          decoration: BoxDecoration(
                            // Gradient background for the card
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isDark
                                  ? [
                                      const Color(0xFF0D0D0D),
                                      const Color(0xFF1A1A1A),
                                      const Color(0xFF0D0D0D),
                                    ]
                                  : [
                                      const Color(0xFFFFFFFF),
                                      const Color(0xFFFAFAFA),
                                      const Color(0xFFFFFFFF),
                                    ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              // Orange border ONLY when hovered, otherwise subtle gray
                              color: _isCardHovered
                                  ? const Color(0xFFF7931A)
                                  : (isDark
                                      ? const Color(0xFF262626)
                                      : const Color(0xFFC0C0C0)), // Better light mode border
                              width: _isCardHovered ? 2.5 : 2,
                            ),
                            boxShadow: [
                              // Orange glow ONLY on hover, otherwise subtle shadow
                              BoxShadow(
                                color: _isCardHovered
                                    ? (isDark
                                        ? const Color(0xFFF7931A).withValues(alpha: 0.3)
                                        : const Color(0xFFF7931A).withValues(alpha: 0.2))
                                    : (isDark
                                        ? Colors.black.withValues(alpha: 0.5)
                                        : Colors.black.withValues(alpha: 0.08)), // Subtle light mode shadow
                                blurRadius: _isCardHovered ? 32 : 16,
                                offset: Offset(0, _isCardHovered ? 12 : 4),
                                spreadRadius: _isCardHovered ? 2 : 0,
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Form content
                              Padding(
                padding: EdgeInsets.all(isMobile ? 24 : (isTablet ? 24 : 20)),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                      // Professional app logo (Premium style)
                      Container(
                        margin: EdgeInsets.only(bottom: isMobile ? 24 : (isTablet ? 10 : 8)),
                                        child: AppLogo(
                                          style: LogoStyle.finance, // Best option - Finance chart with F
                                          size: isMobile ? 110 : 130,
                                        ),
                                      ),
                                      // Welcome title with gradient text
                                      ShaderMask(
                                        shaderCallback: (bounds) => const LinearGradient(
                                          colors: [
                                            Color(0xFFF7931A),
                                            Color(0xFFFF6B35),
                                          ],
                                        ).createShader(bounds),
                                        child: Text(
                                          'Welcome Back',
                                          style: TextStyle(
                                            fontSize: (isMobile ? 26 : 32) * fontScale,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                            letterSpacing: -0.8,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: Responsive.getSpacing(context, mobile: 8, tablet: 10, desktop: 12)),
                                      // Subtitle
                                      Text(
                                        'Sign in to your FinView Lite account',
                                        style: TextStyle(
                                          fontSize: (isMobile ? 14 : 16) * fontScale,
                                          color: isDark
                                              ? const Color(0xFF999999)
                                              : const Color(0xFF666666),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                      SizedBox(height: isMobile ? 32 : (isTablet ? 16 : 12)),
                                      // Username field
                                      _buildLabel('Username', isDark),
                      SizedBox(height: isMobile ? 10 : 8),
                      _buildTextField(
                        controller: _usernameController,
                        hintText: 'Enter your username',
                        prefixIcon: Icons.person_outline,
                        isDark: isDark,
                      ),
                      SizedBox(height: isMobile ? 24 : (isTablet ? 16 : 12)),
                      // Password field
                      _buildLabel('Password', isDark),
                      SizedBox(height: isMobile ? 10 : 8),
                                      _buildPasswordField(isDark),
                      SizedBox(height: isMobile ? 24 : (isTablet ? 14 : 12)),
                      // Remember me and forgot password
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Remember me checkbox
                                          Row(
                                            children: [
                                              Checkbox(
                                                value: _rememberMe,
                                                onChanged: (v) =>
                                                    setState(() => _rememberMe = v!),
                                                activeColor: const Color(0xFFF7931A),
                                                checkColor: Colors.black,
                                              ),
                                              GestureDetector(
                                                onTap: () => setState(
                                                    () => _rememberMe = !_rememberMe),
                                                child: Text(
                                                  'Remember me',
                                                  style: TextStyle(
                                                    fontSize: 14 * fontScale,
                                                    fontWeight: FontWeight.w500,
                                                    color: isDark
                                                        ? Colors.white
                                                        : Colors.black87,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Forgot password link
                                          TextButton(
                                            onPressed: () {},
                                            child: Text(
                                              'Forgot password?',
                                              style: TextStyle(
                                                color: const Color(0xFFF7931A),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14 * fontScale,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                      SizedBox(height: isMobile ? 24 : (isTablet ? 14 : 12)),
                      // Sign In button
                                      supportsHover
                                          ? MouseRegion(
                                              onEnter: (_) =>
                                                  setState(() => _isLoginHovered = true),
                                              onExit: (_) =>
                                                  setState(() => _isLoginHovered = false),
                                              child: AnimatedContainer(
                                              duration: const Duration(milliseconds: 200),
                                              width: double.infinity,
                                              height: Responsive.getButtonHeight(context),
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Color(0xFFF7931A),
                                                    Color(0xFFFF9D2E),
                                                  ],
                                                ),
                                                borderRadius: BorderRadius.circular(14),
                                                boxShadow: [
                                                  BoxShadow(
                                                    // Bigger shadow when hovered
                                                    color: (_isLoginHovered && supportsHover)
                                                        ? const Color(0xFFF7931A)
                                                            .withValues(alpha: 0.5)
                                                        : const Color(0xFFF7931A)
                                                            .withValues(alpha: 0.3),
                                                    blurRadius: (_isLoginHovered && supportsHover) ? 20 : 12,
                                                    offset: Offset(0, (_isLoginHovered && supportsHover) ? 6 : 4),
                                                    spreadRadius: (_isLoginHovered && supportsHover) ? 2 : 0,
                                                  ),
                                                ],
                                              ),
                                              child: ElevatedButton(
                                                onPressed: _isLoading ? null : _handleLogin,
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.transparent,
                                                  shadowColor: Colors.transparent,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(14),
                                                  ),
                                                  padding: EdgeInsets.zero,
                                                ),
                                                child: Transform.scale(
                                                  // Slight scale when hovered (only on desktop)
                                                  scale: (_isLoginHovered && supportsHover) ? 1.02 : 1.0,
                                                  child: _isLoading
                                                      ? SizedBox(
                                                          height: 24,
                                                          width: 24,
                                                          child: CircularProgressIndicator(
                                                            strokeWidth: 2.5,
                                                            valueColor:
                                                                const AlwaysStoppedAnimation<Color>(
                                                              Colors.black,
                                                            ),
                                                          ),
                                                        )
                                                      : Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment.center,
                                                          children: [
                  Text(
                                                              'Sign In',
                                                              style: TextStyle(
                                                                fontSize: (isMobile ? 16 : 17) * fontScale,
                                                                fontWeight: FontWeight.w800,
                                                                color: Colors.black,
                                                                letterSpacing: 0.5,
                                                              ),
                                                            ),
                                                            const SizedBox(width: 10),
                                                            Icon(
                                                              Icons.arrow_forward_rounded,
                                                              size: Responsive.getIconSize(context),
                                                              color: Colors.black,
                                                            ),
                                                          ],
                                                        ),
                                                ),
                                              ),
                                            ),
                                          )
                                          : AnimatedContainer(
                                              duration: const Duration(milliseconds: 200),
                                              width: double.infinity,
                                              height: Responsive.getButtonHeight(context),
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Color(0xFFF7931A),
                                                    Color(0xFFFF9D2E),
                                                  ],
                                                ),
                                                borderRadius: BorderRadius.circular(14),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: const Color(0xFFF7931A)
                                                        .withValues(alpha: 0.3),
                                                    blurRadius: 12,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: ElevatedButton(
                                                onPressed: _isLoading ? null : _handleLogin,
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.transparent,
                                                  shadowColor: Colors.transparent,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(14),
                                                  ),
                                                  padding: EdgeInsets.zero,
                                                ),
                                                child: _isLoading
                                                    ? SizedBox(
                                                        height: 24,
                                                        width: 24,
                                                        child: CircularProgressIndicator(
                                                          strokeWidth: 2.5,
                                                          valueColor:
                                                              const AlwaysStoppedAnimation<Color>(
                                                            Colors.black,
                                                          ),
                                                        ),
                                                      )
                                                    : Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            'Sign In',
                                                            style: TextStyle(
                                                              fontSize: (isMobile ? 16 : 17) * fontScale,
                                                              fontWeight: FontWeight.w800,
                                                              color: Colors.black,
                                                              letterSpacing: 0.5,
                                                            ),
                                                          ),
                                                          const SizedBox(width: 10),
                                                          Icon(
                                                            Icons.arrow_forward_rounded,
                                                            size: Responsive.getIconSize(context),
                                                            color: Colors.black,
                                                          ),
                                                        ],
                                                      ),
                                              ),
                                            ),
                      SizedBox(height: isMobile ? 24 : (isTablet ? 14 : 12)),
                      // Divider with "or" text
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Divider(
                                            color: isDark
                                                ? const Color(0xFF333333)
                                                : const Color(0xFFC0C0C0), // Better light mode divider
                                            thickness: 1,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isDark
                                                  ? const Color(0xFF0D0D0D)
                                                  : const Color(0xFFF5F5F5), // Match background
                                            ),
                                            child: Text(
                                              'or',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: isDark
                                                    ? const Color(0xFF999999)
                                                    : const Color(0xFF666666),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                      SizedBox(height: isMobile ? 24 : (isTablet ? 14 : 12)),
                      // Google sign in button
                                      supportsHover
                                          ? MouseRegion(
                                              onEnter: (_) =>
                                                  setState(() => _isGoogleHovered = true),
                                              onExit: (_) =>
                                                  setState(() => _isGoogleHovered = false),
                                              child: AnimatedContainer(
                                                duration: const Duration(milliseconds: 200),
                                                width: double.infinity,
                                                height: Responsive.getButtonHeight(context),
                                                decoration: BoxDecoration(
                                                  // Background changes on hover
                                                  color: _isGoogleHovered
                                                      ? (isDark
                                                          ? const Color(0xFF1A1A1A)
                                                          : const Color(0xFFF8F9FA))
                                                      : (isDark
                                                          ? const Color(0xFF0D0D0D)
                                                          : const Color(0xFFFFFFFF)), // Better light mode
                                                  border: Border.all(
                                                    // Orange border ONLY when hovered
                                                    color: _isGoogleHovered
                                                        ? const Color(0xFFF7931A)
                                                        : (isDark
                                                            ? const Color(0xFF262626)
                                                            : const Color(0xFFC0C0C0)), // Better light mode border
                                                    width: _isGoogleHovered ? 2.5 : 2,
                                                  ),
                                                  borderRadius: BorderRadius.circular(14),
                                                ),
                                                child: OutlinedButton(
                                                  onPressed: () {},
                                                  style: OutlinedButton.styleFrom(
                                                    side: BorderSide.none,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(14),
                                                    ),
                                                    padding: EdgeInsets.zero,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                        Icons.g_mobiledata,
                                                        size: Responsive.getIconSize(context),
                                                        color: const Color(0xFF4285F4),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      Text(
                                                        'Continue with Google',
                                                        style: TextStyle(
                                                          fontSize: (isMobile ? 15 : 16) * fontScale,
                                                          fontWeight: FontWeight.w600,
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black87,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : AnimatedContainer(
                                              duration: const Duration(milliseconds: 200),
                                              width: double.infinity,
                                              height: Responsive.getButtonHeight(context),
                                              decoration: BoxDecoration(
                                                color: isDark
                                                    ? const Color(0xFF0D0D0D)
                                                    : Colors.white,
                                                border: Border.all(
                                                  color: isDark
                                                      ? const Color(0xFF262626)
                                                      : const Color(0xFFE9ECEF),
                                                  width: 1.5,
                                                ),
                                                borderRadius: BorderRadius.circular(14),
                                              ),
                                              child: OutlinedButton(
                                                onPressed: () {},
                                                style: OutlinedButton.styleFrom(
                                                  side: BorderSide.none,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(14),
                                                  ),
                                                  padding: EdgeInsets.zero,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.g_mobiledata,
                                                      size: Responsive.getIconSize(context),
                                                      color: const Color(0xFF4285F4),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Text(
                                                      'Continue with Google',
                                                      style: TextStyle(
                                                        fontSize: (isMobile ? 15 : 16) * fontScale,
                                                        fontWeight: FontWeight.w600,
                                                        color: isDark
                                                            ? Colors.white
                                                            : Colors.black87,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                      SizedBox(height: isMobile ? 20 : (isTablet ? 10 : 8)),
                      // Sign up link at bottom
                                      Text.rich(
                                        TextSpan(
                                          text: "Don't have an account? ",
                                          style: TextStyle(
                                            fontSize: 14 * fontScale,
                                            color: isDark
                                                ? const Color(0xFF999999)
                                                : const Color(0xFF666666),
                                          ),
                                          children: [
                                            TextSpan(
                                              text: 'Sign up',
                                              style: TextStyle(
                                                color: const Color(0xFFF7931A),
                                                fontWeight: FontWeight.w700,
                                                decoration: TextDecoration.underline,
                                                decorationColor: const Color(0xFFF7931A),
                                                fontSize: 14 * fontScale,
                                              ),
                                            ),
                                          ],
                        ),
                    textAlign: TextAlign.center,
                  ),
                                    ],
                                  ),
                                ),
                              ),
                              // Theme toggle in top right
                              Positioned(
                                top: 24,
                                right: 24,
                                child: _ThemeToggleButton(
                                  isDark: isDark,
                                  onTap: () => widget.themeProvider.toggleTheme(),
                                ),
                              ),
                            ],
                          ),
        ),
      ),
    );
    
    if (supportsHover) {
      return MouseRegion(
        onEnter: (_) => setState(() => _isCardHovered = true),
        onExit: (_) => setState(() => _isCardHovered = false),
        child: cardContent,
      );
    }
    
    return cardContent;
  }

  // Label for form fields
  Widget _buildLabel(String text, bool isDark) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : Colors.black87,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // Text field for username
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    required bool isDark,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black87,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: isDark
              ? const Color(0xFF666666)
              : const Color(0xFF999999),
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: isDark
              ? const Color(0xFF666666)
              : const Color(0xFF999999),
          size: 22,
        ),
        filled: true,
        fillColor: isDark
            ? const Color(0xFF1A1A1A)
            : const Color(0xFFFFFFFF), // Better light mode - white instead of gray
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF333333) : const Color(0xFFC0C0C0), // Better light mode border
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF333333) : const Color(0xFFC0C0C0), // Better light mode border
            width: 2,
          ),
        ),
        // Orange border when focused
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFFF7931A),
            width: 2,
          ),
        ),
                    ),
                    validator: (value) {
        // Make sure field isn't empty
        if (value == null || value.isEmpty) {
          final fieldName = hintText.toLowerCase().replaceAll('enter your ', '');
          return 'Please enter your $fieldName';
                      }
                      return null;
                    },
    );
  }

  // Password field with show/hide toggle
  Widget _buildPasswordField(bool isDark) {
    return TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black87,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
                    decoration: InputDecoration(
        hintText: '••••••••',
        hintStyle: TextStyle(
          color: isDark
              ? const Color(0xFF666666)
              : const Color(0xFF999999),
        ),
        prefixIcon: Icon(
          Icons.lock_outline,
          color: isDark
              ? const Color(0xFF666666)
              : const Color(0xFF999999),
          size: 22,
        ),
        // Eye icon to toggle visibility
                      suffixIcon: IconButton(
                        icon: Icon(
            _obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: isDark
                ? const Color(0xFF666666)
                : const Color(0xFF999999),
            size: 22,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
        filled: true,
        fillColor: isDark
            ? const Color(0xFF1A1A1A)
            : const Color(0xFFFFFFFF), // Better light mode - white instead of gray
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF333333) : const Color(0xFFC0C0C0), // Better light mode border
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF333333) : const Color(0xFFC0C0C0), // Better light mode border
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFFF7931A),
            width: 2,
          ),
        ),
                    ),
                    validator: (value) {
        // Make sure password isn't empty
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
    );
  }
}

// Theme toggle button in the corner
// Small button to switch between light and dark mode
class _ThemeToggleButton extends StatefulWidget {
  final bool isDark;
  final VoidCallback onTap;

  const _ThemeToggleButton({
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_ThemeToggleButton> createState() => _ThemeToggleButtonState();
}

class _ThemeToggleButtonState extends State<_ThemeToggleButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: widget.isDark
                  ? const Color(0xFF1A1A1A).withValues(alpha: 0.8)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                // Orange border when hovered
                color: _isHovered
                    ? (widget.isDark
                        ? const Color(0xFFF7931A).withValues(alpha: 0.5)
                        : const Color(0xFFF7931A).withValues(alpha: 0.4))
                    : (widget.isDark
                        ? const Color(0xFF333333)
                        : const Color(0xFFE9ECEF)),
                width: _isHovered ? 2 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.isDark
                      ? Colors.black.withValues(alpha: _isHovered ? 0.5 : 0.3)
                      : Colors.black.withValues(alpha: _isHovered ? 0.1 : 0.06),
                  blurRadius: _isHovered ? 16 : 12,
                  offset: Offset(0, _isHovered ? 4 : 2),
                ),
              ],
            ),
            child: Transform.scale(
              // Slight scale when hovered
              scale: _isHovered ? 1.1 : 1.0,
              child: Icon(
                // Sun in dark mode, moon in light mode
                widget.isDark ? Icons.wb_sunny : Icons.nightlight_round,
                color: widget.isDark
                    ? const Color(0xFFF7931A)
                    : const Color(0xFF374151),
                size: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
