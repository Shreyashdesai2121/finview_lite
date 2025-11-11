import 'package:flutter/material.dart';

// Professional animated number counter widget
// Smoothly animates from start value to end value
// Used for portfolio values, gains, and other numbers
// Clean, professional animation - not childish
class AnimatedNumber extends StatefulWidget {
  final double value;
  final TextStyle? style;
  final int duration; // Duration in milliseconds
  final String? prefix; // Like "₹" or "+"
  final String? suffix; // Like "%"
  final int? fractionDigits; // Decimal places to show

  const AnimatedNumber({
    super.key,
    required this.value,
    this.style,
    this.duration = 1500, // Default 1.5 seconds - professional timing
    this.prefix,
    this.suffix,
    this.fractionDigits,
  });

  @override
  State<AnimatedNumber> createState() => _AnimatedNumberState();
}

class _AnimatedNumberState extends State<AnimatedNumber>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousValue = 0.0;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.value;
    
    // Create animation controller with professional timing
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.duration),
      vsync: this,
    );

    // Use Curves.easeOut for smooth, professional feel
    // Not bouncy or springy - just smooth
    _animation = Tween<double>(
      begin: _previousValue,
      end: widget.value,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut, // Professional easing curve
    ));

    // Start animation
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedNumber oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // If value changed, animate to new value
    if (oldWidget.value != widget.value) {
      _previousValue = _animation.value;
      _animation = Tween<double>(
        begin: _previousValue,
        end: widget.value,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ));
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Format the animated value
        final animatedValue = _animation.value;
        
        // Handle NaN and Infinity gracefully
        if (animatedValue.isNaN || animatedValue.isInfinite) {
          return Text(
            '${widget.prefix ?? ''}0${widget.suffix ?? ''}',
            style: widget.style,
          );
        }

        // Format number based on fraction digits
        String formattedValue;
        if (widget.fractionDigits != null) {
          formattedValue = animatedValue.toStringAsFixed(widget.fractionDigits!);
        } else {
          // Smart formatting: no decimals for large numbers
          if (animatedValue.abs() >= 1000) {
            formattedValue = animatedValue.toStringAsFixed(0);
          } else {
            formattedValue = animatedValue.toStringAsFixed(2);
          }
        }

        // Build the final text
        final displayText = '${widget.prefix ?? ''}$formattedValue${widget.suffix ?? ''}';

        return Text(
          displayText,
          style: widget.style,
        );
      },
    );
  }
}

