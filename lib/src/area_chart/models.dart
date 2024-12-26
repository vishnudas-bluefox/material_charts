import 'package:flutter/material.dart';

/// Represents a single data point in the area chart.
class AreaChartData {
  final double value; // The value of the data point, plotted on the Y-axis.
  final String?
      label; // Optional label for the data point, shown on the X-axis.
  final TooltipConfig?
      tooltipConfig; // Configuration for the tooltip displayed on hover.

  /// Creates an instance of `AreaChartData`.
  const AreaChartData({
    required this.value,
    this.label,
    this.tooltipConfig,
  });
}

/// Configuration for tooltips displayed when hovering over chart points.
class TooltipConfig {
  final String? text; // Custom text to display in the tooltip.
  final TextStyle textStyle; // Style for the tooltip text.
  final Color backgroundColor; // Background color of the tooltip.
  final double borderRadius; // Radius for the tooltip's rounded corners.
  final EdgeInsets padding; // Inner padding within the tooltip box.
  final double hoverRadius; // Radius for detecting hover events around a point.
  final bool enabled; // Whether tooltips are enabled for this chart.

  /// Creates a `TooltipConfig` with customizable properties.
  const TooltipConfig({
    this.text,
    this.textStyle = const TextStyle(
      color: Colors.black87,
      fontSize: 12,
    ),
    this.backgroundColor = Colors.white,
    this.borderRadius = 4.0,
    this.padding = const EdgeInsets.all(8.0),
    this.hoverRadius = 10.0,
    this.enabled = true,
  });
}

/// Represents a series of data points and their appearance in the area chart.
class AreaChartSeries {
  final String name; // Name of the series (used for legend or labels).
  final List<AreaChartData> dataPoints; // List of data points in the series.
  final Color? color; // Primary color for the series line or area.
  final Color?
      gradientColor; // Optional gradient color for the area under the line.
  final double? lineWidth; // Thickness of the series line.
  final bool? showPoints; // Whether to display markers at data points.
  final double? pointSize; // Size of the markers for data points.
  final TooltipConfig? tooltipConfig; // Tooltip configuration for this series.

  /// Creates an instance of `AreaChartSeries`.
  const AreaChartSeries({
    required this.name,
    required this.dataPoints,
    this.color,
    this.gradientColor,
    this.lineWidth,
    this.showPoints,
    this.pointSize,
    this.tooltipConfig,
  });
}

/// Configuration for the overall style and appearance of the area chart.
class AreaChartStyle {
  final List<Color> colors; // Default colors for multiple series.
  final Color gridColor; // Color of the grid lines.
  final Color backgroundColor; // Background color of the chart.
  final TextStyle? labelStyle; // Style for axis labels.
  final double defaultLineWidth; // Default thickness of series lines.
  final double defaultPointSize; // Default size for data point markers.
  final bool showPoints; // Whether to show data point markers by default.
  final bool showGrid; // Whether to display grid lines in the chart.
  final Duration animationDuration; // Duration for chart animations.
  final Curve animationCurve; // Animation curve for transitions.
  final EdgeInsets padding; // Padding around the chart.
  final int horizontalGridLines; // Number of horizontal grid lines.
  final bool forceYAxisFromZero; // Force Y-axis to start from zero.

  /// Creates an instance of `AreaChartStyle` with default or custom properties.
  const AreaChartStyle({
    this.colors = const [Colors.blue, Colors.green, Colors.red],
    this.gridColor = Colors.grey,
    this.backgroundColor = Colors.white,
    this.labelStyle,
    this.defaultLineWidth = 2.0,
    this.defaultPointSize = 4.0,
    this.showPoints = true,
    this.showGrid = true,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.animationCurve = Curves.easeInOut,
    this.padding = const EdgeInsets.all(24),
    this.horizontalGridLines = 5,
    this.forceYAxisFromZero = true,
  });
}
