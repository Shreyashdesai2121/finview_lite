import 'package:flutter/material.dart';

// Service to get company logos
// Uses local assets first, then public APIs, then fallback to colored initials
class LogoService {
  // Map of stock symbols to their local asset paths
  // Add your logo images to assets/logos/ folder
  static const Map<String, String> _localLogos = {
    'TCS': 'assets/logos/tcs.png',
    'INFY': 'assets/logos/infy.png',
    'RELIANCE': 'assets/logos/reliance.png',
    'HDFCBANK': 'assets/logos/hdfcbank.png',
    'ICICIBANK': 'assets/logos/icicibank.png',
    'HDFC': 'assets/logos/hdfc.png',
  };

  // Map of stock symbols to their company domains/logos (fallback)
  // Using Clearbit logo API and other public sources
  static const Map<String, String> _logoUrls = {
    'TCS': 'https://logo.clearbit.com/tcs.com',
    'INFY': 'https://logo.clearbit.com/infosys.com',
    'RELIANCE': 'https://logo.clearbit.com/ril.com',
    'HDFCBANK': 'https://logo.clearbit.com/hdfcbank.com',
    'ICICIBANK': 'https://logo.clearbit.com/icicibank.com',
    'HDFC': 'https://logo.clearbit.com/hdfc.com',
  };

  // Primary logo sources - using reliable Wikipedia and official sources
  static const Map<String, List<String>> _alternativeUrls = {
    'HDFCBANK': [
      'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/HDFC_Bank_Logo.svg/512px-HDFC_Bank_Logo.svg.png',
      'https://logos-world.net/wp-content/uploads/2020/04/HDFC-Bank-Logo.png',
      'https://1000logos.net/wp-content/uploads/2021/06/HDFC-Bank-Logo.png',
    ],
    'ICICIBANK': [
      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/ICICI_Bank_Logo.svg/512px-ICICI_Bank_Logo.svg.png',
      'https://logos-world.net/wp-content/uploads/2020/04/ICICI-Bank-Logo.png',
      'https://1000logos.net/wp-content/uploads/2021/06/ICICI-Bank-Logo.png',
    ],
    'TCS': [
      'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b1/Tata_Consultancy_Services_Logo.svg/512px-Tata_Consultancy_Services_Logo.svg.png',
      'https://logos-world.net/wp-content/uploads/2020/04/TCS-Logo.png',
    ],
    'INFY': [
      'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9e/Infosys_logo.svg/512px-Infosys_logo.svg.png',
      'https://logos-world.net/wp-content/uploads/2020/04/Infosys-Logo.png',
    ],
    'RELIANCE': [
      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Reliance_Industries_Logo.svg/512px-Reliance_Industries_Logo.svg.png',
      'https://logos-world.net/wp-content/uploads/2020/04/Reliance-Industries-Logo.png',
    ],
    'HDFC': [
      'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/HDFC_Bank_Logo.svg/512px-HDFC_Bank_Logo.svg.png',
      'https://logos-world.net/wp-content/uploads/2020/04/HDFC-Bank-Logo.png',
    ],
  };

  // Get local asset path for a stock symbol
  static String? getLocalLogoPath(String symbol) {
    return _localLogos[symbol] ?? _localLogos[symbol.toUpperCase()];
  }

  // Get logo URL for a stock symbol (fallback - not used, we use alternativeUrls directly)
  static String? getLogoUrl(String symbol) {
    return _logoUrls[symbol] ?? _logoUrls[symbol.toUpperCase()];
  }

  // Get alternative logo URLs (primary source - Wikipedia and reliable sources)
  static List<String>? getAlternativeUrls(String symbol) {
    return _alternativeUrls[symbol] ?? _alternativeUrls[symbol.toUpperCase()];
  }
  
  // Get primary logo URL (first from alternativeUrls for better reliability)
  static String? getPrimaryLogoUrl(String symbol) {
    final urls = getAlternativeUrls(symbol);
    return urls != null && urls.isNotEmpty ? urls[0] : null;
  }

  // Get fallback colors for a symbol (if logo fails to load)
  // Professional neutral colors instead of bright colors
  static List<Color> getFallbackColors(String symbol) {
    // Use professional neutral gray colors for all symbols
    // This gives a clean, professional look when logos fail to load
    return [
      const Color(0xFF6B7280), // Neutral gray
      const Color(0xFF4B5563), // Darker gray
    ];
  }

  // Get initials for fallback
  static String getInitials(String symbol) {
    if (symbol.length >= 2) {
      return symbol.substring(0, 2).toUpperCase();
    }
    return symbol.toUpperCase();
  }
}

// Widget that displays company logo with multiple fallback options
class CompanyLogo extends StatefulWidget {
  final String symbol;
  final double size;
  final BoxShape shape;
  final List<Color>? fallbackColors;

  const CompanyLogo({
    super.key,
    required this.symbol,
    this.size = 56,
    this.shape = BoxShape.rectangle,
    this.fallbackColors,
  });

  @override
  State<CompanyLogo> createState() => _CompanyLogoState();
}

class _CompanyLogoState extends State<CompanyLogo> {
  int _currentUrlIndex = 0;
  bool _hasTriedLocal = false;
  bool _hasTriedNetwork = false;

  @override
  Widget build(BuildContext context) {
    final localPath = LogoService.getLocalLogoPath(widget.symbol);
    final colors = widget.fallbackColors ?? LogoService.getFallbackColors(widget.symbol);
    final initials = LogoService.getInitials(widget.symbol);

    return Container(
      width: widget.size,
      height: widget.size,
      // No background decoration - transparent background for logos
      child: ClipRRect(
        borderRadius: widget.shape == BoxShape.rectangle 
            ? BorderRadius.circular(widget.size * 0.25)
            : BorderRadius.circular(widget.size),
        child: _buildLogoWidget(localPath, colors, initials),
      ),
    );
  }

  Widget _buildLogoWidget(String? localPath, List<Color> colors, String initials) {
    // Try local asset first
    if (localPath != null && !_hasTriedLocal) {
      return Image.asset(
        localPath,
        width: widget.size,
        height: widget.size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          if (mounted) {
            setState(() => _hasTriedLocal = true);
          }
          return _tryNetworkLogo(colors, initials);
        },
      );
    }

    // Try network logos
    return _tryNetworkLogo(colors, initials);
  }

  Widget _tryNetworkLogo(List<Color> colors, String initials) {
    final alternativeUrls = LogoService.getAlternativeUrls(widget.symbol);
    
    // Try alternative URLs first (more reliable - Wikipedia, etc.)
    if (alternativeUrls != null && _currentUrlIndex < alternativeUrls.length) {
      return Image.network(
        alternativeUrls[_currentUrlIndex],
        width: widget.size,
        height: widget.size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _tryNextUrl(colors, initials, alternativeUrls);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildInitialsWidget(initials, colors);
        },
      );
    }

    // Final fallback to initials (only when logo fails to load)
    return _buildInitialsWidget(initials, colors);
  }

  Widget _tryNextUrl(List<Color> colors, String initials, List<String>? alternativeUrls) {
    if (alternativeUrls != null && _currentUrlIndex < alternativeUrls.length - 1) {
      if (mounted) {
        setState(() {
          _currentUrlIndex++;
        });
      }
      return _tryNetworkLogo(colors, initials);
    }
    return _buildInitialsWidget(initials, colors);
  }

  Widget _buildInitialsWidget(String initials, List<Color> colors) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: widget.size * 0.35,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: -1,
          ),
        ),
      ),
    );
  }
}
