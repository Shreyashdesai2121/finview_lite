import 'package:flutter/material.dart';

// Professional app logo widget for FinView Lite
// Modern design with chart/graph icon instead of just "FV"
enum LogoStyle {
  finance,      // Option 1: Finance chart with F (BEST - Recommended) ⭐
  chartIcon,    // Option 2: Chart icon with gradient
  gradient,     // Option 3: Gradient with F icon
  minimal,      // Option 4: Minimal with chart line
  premium,      // Option 5: Premium with shield
  modern,       // Option 6: Modern with graph
}

// Main logo widget - uses actual logo image from assets
class AppLogo extends StatelessWidget {
  final LogoStyle style;
  final double size;
  final bool showText;
  final TextStyle? textStyle;

  const AppLogo({
    super.key,
    this.style = LogoStyle.finance, // Kept for compatibility but uses image now
    this.size = 48,
    this.showText = false,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Use actual logo image from assets
    Widget logoWidget = Image.asset(
      'assets/logos/finview_lite.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to finance logo if image fails to load
        return _FinanceLogo(size: size);
      },
    );

    if (showText) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          logoWidget,
          const SizedBox(width: 12),
          Text(
            'FinView Lite',
            style: textStyle ?? TextStyle(
              fontSize: size * 0.6,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : Colors.black,
              letterSpacing: -0.5,
            ),
          ),
        ],
      );
    }

    return logoWidget;
  }
}

// Option 1: Finance Logo (NEW - BEST OPTION) ⭐
// Professional finance chart with F - looks like real finance app
class _FinanceLogo extends StatelessWidget {
  final double size;

  const _FinanceLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF7931A),
            Color(0xFFFF6B35),
            Color(0xFFFF9D2E),
          ],
        ),
        borderRadius: BorderRadius.circular(size * 0.25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF7931A).withValues(alpha: 0.6),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 3,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background chart pattern
          CustomPaint(
            painter: _FinanceChartPainter(),
            size: Size(size, size),
          ),
          // F letter overlay
          Center(
            child: Text(
              'F',
              style: TextStyle(
                fontSize: size * 0.5,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: -2,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    offset: const Offset(0, 2),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for finance chart background
class _FinanceChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final width = size.width;
    final height = size.height;
    
    // Draw upward trending line (finance chart)
    final path = Path();
    path.moveTo(width * 0.15, height * 0.75);
    path.lineTo(width * 0.3, height * 0.6);
    path.lineTo(width * 0.45, height * 0.5);
    path.lineTo(width * 0.6, height * 0.4);
    path.lineTo(width * 0.75, height * 0.3);
    path.lineTo(width * 0.85, height * 0.25);
    
    canvas.drawPath(path, paint);
    
    // Draw small circles at key points
    final circlePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(width * 0.15, height * 0.75), 2, circlePaint);
    canvas.drawCircle(Offset(width * 0.75, height * 0.3), 3, circlePaint);
    canvas.drawCircle(Offset(width * 0.85, height * 0.25), 3.5, circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Option 2: Chart Icon Logo
// Modern chart icon with gradient - looks professional
class _ChartIconLogo extends StatelessWidget {
  final double size;

  const _ChartIconLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF7931A),
            Color(0xFFFF9D2E),
            Color(0xFFFFB84D),
          ],
        ),
        borderRadius: BorderRadius.circular(size * 0.22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF7931A).withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 3,
          ),
        ],
      ),
      child: CustomPaint(
        painter: _ChartIconPainter(),
        size: Size(size, size),
      ),
    );
  }
}

// Custom painter for chart icon (trending up chart)
class _ChartIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    final width = size.width;
    final height = size.height;
    
    // Draw chart line (trending up)
    final path = Path();
    path.moveTo(width * 0.15, height * 0.75);
    path.lineTo(width * 0.35, height * 0.55);
    path.lineTo(width * 0.55, height * 0.45);
    path.lineTo(width * 0.75, height * 0.25);
    path.lineTo(width * 0.85, height * 0.15);
    
    canvas.drawPath(path, paint);
    
    // Fill area under chart
    path.lineTo(width * 0.85, height * 0.75);
    path.lineTo(width * 0.15, height * 0.75);
    path.close();
    canvas.drawPath(path, fillPaint);
    
    // Draw small circles at key points
    final circlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(width * 0.15, height * 0.75), 3, circlePaint);
    canvas.drawCircle(Offset(width * 0.55, height * 0.45), 3.5, circlePaint);
    canvas.drawCircle(Offset(width * 0.85, height * 0.15), 4, circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Option 2: Gradient F with modern design
class _GradientLogo extends StatelessWidget {
  final double size;

  const _GradientLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF7931A),
            Color(0xFFFF9D2E),
            Color(0xFFFFB84D),
          ],
        ),
        borderRadius: BorderRadius.circular(size * 0.25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF7931A).withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Text(
          'F',
          style: TextStyle(
            fontSize: size * 0.5,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -2,
          ),
        ),
      ),
    );
  }
}

// Option 3: Minimal with chart line (clean, professional)
class _MinimalLogo extends StatelessWidget {
  final double size;
  final bool isDark;

  const _MinimalLogo({required this.size, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(size * 0.2),
        border: Border.all(
          color: const Color(0xFFF7931A),
          width: 2.5,
        ),
      ),
      child: CustomPaint(
        painter: _ChartLinePainter(
          color: const Color(0xFFF7931A),
        ),
        size: Size(size, size),
      ),
    );
  }
}

// Option 4: Premium with shield and F (most professional)
class _PremiumLogo extends StatelessWidget {
  final double size;

  const _PremiumLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF7931A),
            Color(0xFFFF6B35),
          ],
        ),
        borderRadius: BorderRadius.circular(size * 0.3),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF7931A).withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 3,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Shield shape background
          CustomPaint(
            painter: _ShieldPainter(),
            size: Size(size, size),
          ),
          // F letter
          Center(
            child: Text(
              'F',
              style: TextStyle(
                fontSize: size * 0.45,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: -2,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Option 5: Modern with graph icon
class _ModernLogo extends StatelessWidget {
  final double size;
  final bool isDark;

  const _ModernLogo({required this.size, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D0D0D) : Colors.white,
        borderRadius: BorderRadius.circular(size * 0.22),
        border: Border.all(
          color: const Color(0xFFF7931A),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.5)
                : Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _GraphPainter(
          color: const Color(0xFFF7931A),
        ),
        size: Size(size, size),
      ),
    );
  }
}

// Custom painter for chart line
class _ChartLinePainter extends CustomPainter {
  final Color color;

  _ChartLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    final width = size.width;
    final height = size.height;
    
    // Draw upward trending line
    path.moveTo(width * 0.2, height * 0.7);
    path.lineTo(width * 0.4, height * 0.5);
    path.lineTo(width * 0.6, height * 0.4);
    path.lineTo(width * 0.8, height * 0.3);
    
    canvas.drawPath(path, paint);
    
    // Draw small circle at end
    canvas.drawCircle(
      Offset(width * 0.8, height * 0.3),
      3,
      Paint()..color = color..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for shield shape
class _ShieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    final path = Path();
    final width = size.width;
    final height = size.height;
    
    // Draw shield shape
    path.moveTo(width * 0.5, height * 0.15);
    path.lineTo(width * 0.75, height * 0.25);
    path.lineTo(width * 0.75, height * 0.6);
    path.quadraticBezierTo(width * 0.75, height * 0.75, width * 0.5, height * 0.85);
    path.quadraticBezierTo(width * 0.25, height * 0.75, width * 0.25, height * 0.6);
    path.lineTo(width * 0.25, height * 0.25);
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for graph icon
class _GraphPainter extends CustomPainter {
  final Color color;

  _GraphPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final width = size.width;
    final height = size.height;
    
    // Draw graph bars
    final barWidth = width * 0.15;
    final spacing = width * 0.1;
    final baseY = height * 0.7;
    
    // Bar 1 (short)
    canvas.drawRect(
      Rect.fromLTWH(
        width * 0.2,
        baseY - height * 0.15,
        barWidth,
        height * 0.15,
      ),
      paint..style = PaintingStyle.fill,
    );
    
    // Bar 2 (medium)
    canvas.drawRect(
      Rect.fromLTWH(
        width * 0.2 + barWidth + spacing,
        baseY - height * 0.3,
        barWidth,
        height * 0.3,
      ),
      paint..style = PaintingStyle.fill,
    );
    
    // Bar 3 (tall)
    canvas.drawRect(
      Rect.fromLTWH(
        width * 0.2 + (barWidth + spacing) * 2,
        baseY - height * 0.45,
        barWidth,
        height * 0.45,
      ),
      paint..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
