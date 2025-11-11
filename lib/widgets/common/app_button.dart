import 'package:flutter/material.dart';
import '../../utils/responsive.dart';

// Reusable button component with consistent styling
// Supports primary (orange) and secondary (outlined) variants
// Includes hover effects, responsive sizing, and professional press animations
class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isPrimary; // Primary = orange filled, Secondary = outlined
  final IconData? icon;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isPrimary = true,
    this.icon,
    this.isLoading = false,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Responsive.isMobile(context);
    final fontScale = Responsive.getFontScale(context);

    if (widget.isPrimary) {
      return GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.97 : 1.0, // Professional press feedback
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          child: ElevatedButton(
            onPressed: widget.isLoading ? null : widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF7931A),
          foregroundColor: Colors.black,
          padding: EdgeInsets.symmetric(
            vertical: Responsive.getSpacing(context, mobile: 10, tablet: 11, desktop: 12),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
            child: widget.isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, size: Responsive.getIconSize(context)),
                        SizedBox(width: Responsive.getSpacing(context, mobile: 6, tablet: 7, desktop: 8)),
                      ],
                      Text(
                        widget.label,
                        style: TextStyle(
                          fontSize: (isMobile ? 13 : 14) * fontScale,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.97 : 1.0, // Professional press feedback
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          child: OutlinedButton(
            onPressed: widget.isLoading ? null : widget.onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isDark ? const Color(0xFF333333) : const Color(0xFFC0C0C0),
            width: 2,
          ),
          padding: EdgeInsets.symmetric(
            vertical: Responsive.getSpacing(context, mobile: 10, tablet: 11, desktop: 12),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
            child: widget.isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, size: Responsive.getIconSize(context)),
                        SizedBox(width: Responsive.getSpacing(context, mobile: 6, tablet: 7, desktop: 8)),
                      ],
                      Text(
                        widget.label,
                        style: TextStyle(
                          fontSize: (isMobile ? 13 : 14) * fontScale,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      );
    }
  }
}

