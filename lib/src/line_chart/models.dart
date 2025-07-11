import 'package:flutter/material.dart';

/// Model class for chart data points.
/// This class represents a single data point in the line chart,
/// containing a value and a corresponding label.
class ChartData {
  final double value; // The numeric value of the data point
  final String label; // The label associated with the data point

  const ChartData({required this.value, required this.label});
}

/// Configuration class for line chart styling.
/// This class holds various properties to customize the appearance of the line chart.
class LineChartStyle {
  final Color lineColor; // Color of the line in the chart
  final Color gridColor; // Color of the grid lines in the chart
  final Color pointColor; // Color of the points on the line
  final Color backgroundColor; // Background color of the chart
  final TextStyle? labelStyle; // Optional text style for labels
  final double strokeWidth; // Width of the line stroke
  final double pointRadius; // Radius of the points on the line
  final Duration animationDuration; // Duration for animations
  final Curve animationCurve; // Curve for animation
  final bool
      useCurvedLines; // Whether to use curved/smooth lines between points
  final double curveIntensity; // Intensity of the curve (0.0 to 1.0)
  final bool roundedPoints; // Whether to use rounded line caps and joins

  const LineChartStyle({
    this.lineColor = Colors.blue, // Default line color
    this.gridColor = Colors.grey, // Default grid color
    this.pointColor = Colors.blue, // Default point color
    this.backgroundColor = Colors.white, // Default background color
    this.labelStyle, // Custom label style
    this.strokeWidth = 2.0, // Default stroke width
    this.pointRadius = 4.0, // Default point radius
    this.animationDuration = const Duration(
      milliseconds: 1500,
    ), // Default animation duration
    this.animationCurve = Curves.easeInOut, // Default animation curve
    this.useCurvedLines = false, // Default to straight lines
    this.curveIntensity = 0.3, // Default curve intensity (30%)
    this.roundedPoints = true, // Default to rounded line caps
  });

  /// Creates a copy of this style with the given fields replaced with new values.
  LineChartStyle copyWith({
    Color? lineColor,
    Color? gridColor,
    Color? pointColor,
    Color? backgroundColor,
    TextStyle? labelStyle,
    double? strokeWidth,
    double? pointRadius,
    Duration? animationDuration,
    Curve? animationCurve,
    bool? useCurvedLines,
    double? curveIntensity,
    bool? roundedPoints,
  }) {
    return LineChartStyle(
      lineColor: lineColor ?? this.lineColor,
      gridColor: gridColor ?? this.gridColor,
      pointColor: pointColor ?? this.pointColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      labelStyle: labelStyle ?? this.labelStyle,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      pointRadius: pointRadius ?? this.pointRadius,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      useCurvedLines: useCurvedLines ?? this.useCurvedLines,
      curveIntensity: curveIntensity ?? this.curveIntensity,
      roundedPoints: roundedPoints ?? this.roundedPoints,
    );
  }
}
