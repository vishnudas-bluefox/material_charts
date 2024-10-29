import 'package:flutter/material.dart';

/// Represents a data point for a bar chart.
///
/// This model contains the value of the bar, its label, and an optional
/// custom color for individual bars. It is used to define the data to be
/// displayed in the bar chart.
class BarChartData {
  /// The numeric value represented by the bar.
  final double value;

  /// The label displayed for the bar.
  final String label;

  /// Optional custom color for individual bars.
  /// If not provided, a default color will be used.
  final Color? color;

  /// Creates an instance of [BarChartData].
  ///
  /// The [value] and [label] parameters are required, while [color]
  /// is optional.
  const BarChartData({
    required this.value,
    required this.label,
    this.color,
  });
}

/// Configuration class for styling a bar chart.
///
/// This class allows customization of various visual aspects of the
/// bar chart, including colors, spacing, animations, and more.
class BarChartStyle {
  /// The color of the bars in the chart.
  final Color barColor;

  /// The color of the grid lines in the chart.
  final Color gridColor;

  /// The background color of the chart area.
  final Color backgroundColor;

  /// Optional style for the labels of the bars.
  final TextStyle? labelStyle;

  /// Optional style for the values displayed on the bars.
  final TextStyle? valueStyle;

  /// The spacing between bars as a percentage (0.0 - 1.0).
  /// A value of 0.2 indicates 20% spacing.
  final double barSpacing;

  /// The radius for rounded corners of the bars.
  final double cornerRadius;

  /// The duration of the animation when the chart is drawn.
  final Duration animationDuration;

  /// The curve to be used for the animation effect.
  final Curve animationCurve;

  /// Whether to apply a gradient effect to the bars.
  final bool gradientEffect;

  /// List of colors to be used for the gradient effect.
  /// This is applicable only if [gradientEffect] is true.
  final List<Color>? gradientColors;

  /// Creates an instance of [BarChartStyle] with customizable properties.
  ///
  /// The following parameters can be customized:
  /// - [barColor]: Color of the bars (default is blue).
  /// - [gridColor]: Color of the grid lines (default is grey).
  /// - [backgroundColor]: Background color of the chart (default is white).
  /// - [labelStyle]: Style for bar labels.
  /// - [valueStyle]: Style for bar values.
  /// - [barSpacing]: Spacing between bars as a percentage (default is 0.2).
  /// - [cornerRadius]: Radius for rounded corners (default is 4.0).
  /// - [animationDuration]: Duration for the draw animation (default is 1500 ms).
  /// - [animationCurve]: Curve used for the animation effect (default is easeInOut).
  /// - [gradientEffect]: Whether to apply a gradient effect (default is false).
  /// - [gradientColors]: List of colors for the gradient effect.
  const BarChartStyle({
    this.barColor = Colors.blue,
    this.gridColor = Colors.grey,
    this.backgroundColor = Colors.white,
    this.labelStyle,
    this.valueStyle,
    this.barSpacing = 0.2,
    this.cornerRadius = 4.0,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.animationCurve = Curves.easeInOut,
    this.gradientEffect = false,
    this.gradientColors,
  });
}
