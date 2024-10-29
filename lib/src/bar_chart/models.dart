import 'package:flutter/material.dart';

/// Model class for bar chart data points
class BarChartData {
  final double value;
  final String label;
  final Color? color; // Optional custom color for individual bars

  const BarChartData({
    required this.value,
    required this.label,
    this.color,
  });
}

/// Configuration class for bar chart styling
class BarChartStyle {
  final Color barColor;
  final Color gridColor;
  final Color backgroundColor;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final double barSpacing;
  final double cornerRadius;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool gradientEffect;
  final List<Color>? gradientColors;

  const BarChartStyle({
    this.barColor = Colors.blue,
    this.gridColor = Colors.grey,
    this.backgroundColor = Colors.white,
    this.labelStyle,
    this.valueStyle,
    this.barSpacing = 0.2, // Spacing between bars as percentage (0.0 - 1.0)
    this.cornerRadius = 4.0,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.animationCurve = Curves.easeInOut,
    this.gradientEffect = false,
    this.gradientColors,
  });
}
