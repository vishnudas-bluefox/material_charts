import 'package:flutter/material.dart';

/// Represents a single segment in a stacked bar.
///
/// Each segment contributes to the total value of the bar it belongs to.
/// A segment is defined by its value, color, and an optional label.
class StackedBarSegment {
  /// The numerical value of this segment, contributing to the total bar value.
  final double value;

  /// The color used to render this segment in the chart.
  final Color color;

  /// Optional label to describe the segment, typically used for tooltips or legends.
  final String? label;

  /// Constructs a [StackedBarSegment] with the given value, color, and optional label.
  ///
  /// * [value] is required to define the size of the segment.
  /// * [color] specifies the visual appearance of the segment.
  const StackedBarSegment({
    required this.value,
    required this.color,
    this.label,
  });
}

/// Represents the complete data for a single bar in the stacked bar chart.
///
/// A stacked bar contains multiple segments, each with its own value and color.
class StackedBarData {
  /// The label describing the entire bar, often used for the X-axis or legend.
  final String label;

  /// A list of [StackedBarSegment]s that make up this bar.
  final List<StackedBarSegment> segments;

  /// Constructs [StackedBarData] with a required label and list of segments.
  const StackedBarData({
    required this.label,
    required this.segments,
  });

  /// Computes the total value by summing all segment values in the bar.
  ///
  /// This value is used to determine the relative size of segments in the bar.
  double get totalValue =>
      segments.fold(0, (sum, segment) => sum + segment.value);
}

/// Configuration class for customizing the Y-axis of the chart.
///
/// This includes setting min/max values, grid lines, and label formatting.
class YAxisConfig {
  /// Minimum value displayed on the Y-axis. If not provided, it defaults to 0.
  final double? minValue;

  /// Maximum value displayed on the Y-axis. If not provided, the chart
  /// uses the largest total value from all bars.
  final double? maxValue;

  /// The number of divisions on the Y-axis, defining the grid intervals.
  final int divisions;

  /// Whether to display the vertical axis line.
  final bool showAxisLine;

  /// Whether to display horizontal grid lines across the chart.
  final bool showGridLines;

  /// The text style for the Y-axis labels.
  final TextStyle? labelStyle;

  /// The width allocated for rendering the Y-axis.
  final double axisWidth;

  /// Custom formatter function to format Y-axis values.
  final String Function(double value)? labelFormatter;

  /// Constructs a [YAxisConfig] with options for axis behavior and appearance.
  const YAxisConfig({
    this.minValue,
    this.maxValue,
    this.divisions = 5,
    this.showAxisLine = true,
    this.showGridLines = true,
    this.labelStyle,
    this.axisWidth = 50.0,
    this.labelFormatter,
  });
}

/// Configuration class for customizing the appearance of the stacked bar chart.
///
/// This class controls styling options such as colors, bar spacing, animations,
/// and optional Y-axis configurations.
class StackedBarChartStyle {
  /// The color of the grid lines within the chart.
  final Color gridColor;

  /// The background color of the chart container.
  final Color backgroundColor;

  /// The text style used for bar labels (e.g., X-axis labels).
  final TextStyle? labelStyle;

  /// The text style used for value labels displayed on segments.
  final TextStyle? valueStyle;

  /// Spacing between bars, defined as a fraction (0.0 to 1.0).
  final double barSpacing;

  /// The corner radius applied to the bars for rounded edges.
  final double cornerRadius;

  /// Duration of the animation used when rendering the bars.
  final Duration animationDuration;

  /// The animation curve applied during bar rendering.
  final Curve animationCurve;

  /// Optional configuration for the Y-axis, providing fine control over
  /// axis appearance and behavior.
  final YAxisConfig? yAxisConfig;

  /// Constructs a [StackedBarChartStyle] with options for styling and behavior.
  ///
  /// Default values:
  /// * [gridColor] is set to `Colors.grey`.
  /// * [backgroundColor] is set to `Colors.white`.
  /// * [barSpacing] is set to 0.2.
  /// * [cornerRadius] is set to 4.0.
  /// * [animationDuration] is set to 1500ms.
  /// * [animationCurve] uses `Curves.easeInOut`.
  const StackedBarChartStyle({
    this.gridColor = Colors.grey,
    this.backgroundColor = Colors.white,
    this.labelStyle,
    this.valueStyle,
    this.barSpacing = 0.2,
    this.cornerRadius = 4.0,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.animationCurve = Curves.easeInOut,
    this.yAxisConfig,
  });
}
