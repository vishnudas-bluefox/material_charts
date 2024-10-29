import 'package:flutter/material.dart';

/// Specifies the style configuration for chart widgets.
/// This class allows customization of the appearance and behavior of the charts.
class ChartStyle {
  /// Color of the active (filled) portion of the chart.
  final Color activeColor;

  /// Color of the inactive (unfilled) portion of the chart.
  final Color inactiveColor;

  /// Optional text color for percentage and legend text.
  final Color? textColor;

  /// Optional style for the percentage text.
  final TextStyle? percentageStyle;

  /// Optional style for the legend text.
  final TextStyle? legendStyle;

  /// Duration for the animation of the chart.
  final Duration animationDuration;

  /// Curve type for the animation of the chart.
  final Curve animationCurve;

  /// Whether to show the percentage text inside the chart.
  final bool showPercentageText;

  /// Whether to show the legend for the chart.
  final bool showLegend;

  /// Optional function to format the percentage text.
  /// Takes a double representing the percentage and returns a formatted string.
  final String Function(double percentage)? percentageFormatter;

  /// Optional function to format the legend text.
  /// Takes a string representing the type and a double representing the value,
  /// returning a formatted string.
  final String Function(String type, double value)? legendFormatter;

  /// Constructs a ChartStyle object with optional parameters for customization.
  const ChartStyle({
    this.activeColor = Colors.blue,
    this.inactiveColor = const Color(0xFFE0E0E0),
    this.textColor,
    this.percentageStyle,
    this.legendStyle,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.animationCurve = Curves.easeInOut,
    this.showPercentageText = true,
    this.showLegend = true,
    this.percentageFormatter,
    this.legendFormatter,
  });

  /// Creates a copy of this ChartStyle with the given fields replaced with new values.
  ChartStyle copyWith({
    Color? activeColor,
    Color? inactiveColor,
    Color? textColor,
    TextStyle? percentageStyle,
    TextStyle? legendStyle,
    Duration? animationDuration,
    Curve? animationCurve,
    bool? showPercentageText,
    bool? showLegend,
    String Function(double)? percentageFormatter,
    String Function(String, double)? legendFormatter,
  }) {
    return ChartStyle(
      activeColor: activeColor ?? this.activeColor,
      inactiveColor: inactiveColor ?? this.inactiveColor,
      textColor: textColor ?? this.textColor,
      percentageStyle: percentageStyle ?? this.percentageStyle,
      legendStyle: legendStyle ?? this.legendStyle,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      showPercentageText: showPercentageText ?? this.showPercentageText,
      showLegend: showLegend ?? this.showLegend,
      percentageFormatter: percentageFormatter ?? this.percentageFormatter,
      legendFormatter: legendFormatter ?? this.legendFormatter,
    );
  }
}

/// Base class for chart widgets.
/// This class defines common properties and assertions for all chart types.
abstract class BaseChart extends StatefulWidget {
  /// The percentage to be displayed by the chart. Must be between 0 and 100.
  final double percentage;

  /// The size of the chart (width and height).
  final double size;

  /// Style configuration for the chart's appearance and behavior.
  final ChartStyle style;

  /// Optional callback function triggered when the animation is complete.
  final VoidCallback? onAnimationComplete;

  /// Constructs a BaseChart object with required parameters and style customization.
  const BaseChart({
    super.key,
    required this.percentage,
    required this.size,
    this.style = const ChartStyle(),
    this.onAnimationComplete,
  })  : assert(percentage >= 0 && percentage <= 100,
            'Percentage must be between 0 and 100'),
        assert(size > 0, 'Size must be greater than 0');
}
