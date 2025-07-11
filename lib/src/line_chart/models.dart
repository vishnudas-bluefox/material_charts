import 'package:flutter/material.dart';
import '../shared/shared_models.dart';

/// Model class for chart data points.
/// This class represents a single data point in the line chart,
/// containing a value and a corresponding label.
class ChartData {
  final double value; // The numeric value of the data point
  final String label; // The label associated with the data point

  const ChartData({required this.value, required this.label});
}

/// Enum for different line styles
enum LineStyle { solid, dashed, dotted }

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

  /// The color for the vertical line indicators when hovering.
  ///
  /// This property defines the color of vertical lines that are
  /// drawn when hovering over data points, providing visual feedback.
  final Color verticalLineColor;

  /// The width of the vertical line indicators when hovering.
  ///
  /// This property defines the thickness of the vertical lines,
  /// allowing for customization based on user preference or design.
  final double verticalLineWidth;

  /// The style of the vertical hover line (solid, dashed, or dotted).
  ///
  /// This property controls the appearance of the vertical line,
  /// allowing for different visual styles to match design preferences.
  final LineStyle verticalLineStyle;

  /// The opacity of the vertical hover line.
  ///
  /// This property controls the transparency of the vertical line,
  /// allowing for subtle or prominent visual feedback.
  final double verticalLineOpacity;

  /// Whether to show tooltips when hovering over data points.
  ///
  /// This property controls the visibility of tooltips, allowing
  /// users to enable or disable this interactive feature.
  final bool showTooltips;

  /// Styling configuration for tooltips associated with data points.
  final TooltipStyle tooltipStyle;

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
    this.verticalLineColor = Colors.blue, // Default vertical line color
    this.verticalLineWidth = 1.0, // Default vertical line width
    this.verticalLineStyle = LineStyle.solid, // Default to solid line
    this.verticalLineOpacity = 0.7, // Default opacity
    this.showTooltips = true, // Default to showing tooltips
    this.tooltipStyle = const TooltipStyle(), // Default tooltip style
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
    Color? verticalLineColor,
    double? verticalLineWidth,
    LineStyle? verticalLineStyle,
    double? verticalLineOpacity,
    bool? showTooltips,
    TooltipStyle? tooltipStyle,
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
      verticalLineColor: verticalLineColor ?? this.verticalLineColor,
      verticalLineWidth: verticalLineWidth ?? this.verticalLineWidth,
      verticalLineStyle: verticalLineStyle ?? this.verticalLineStyle,
      verticalLineOpacity: verticalLineOpacity ?? this.verticalLineOpacity,
      showTooltips: showTooltips ?? this.showTooltips,
      tooltipStyle: tooltipStyle ?? this.tooltipStyle,
    );
  }
}
