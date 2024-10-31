import 'package:flutter/material.dart';

/// Represents a single data point in a chart.
///
/// This class holds the value of the data point, an optional label,
/// and an optional color. It is used to define individual points
/// on various types of charts.
class ChartDataPoint {
  final double value; // The numeric value of the data point.
  final String? label; // An optional label for the data point.
  final Color? color; // An optional color associated with the data point.

  /// Creates a [ChartDataPoint] instance.
  ///
  /// [value] is required to define the data point.
  /// [label] and [color] are optional.
  const ChartDataPoint({
    required this.value,
    this.label,
    this.color,
  });
}

/// Represents the data to be displayed in a tooltip.
///
/// This class encapsulates the necessary information to display
/// a tooltip for a particular data point in the chart, including
/// the series name, the data point details, color, and the position
/// of the tooltip.
class TooltipData {
  final String
      seriesName; // The name of the series to which the data point belongs.
  final ChartDataPoint dataPoint; // The data point associated with the tooltip.
  final Color color; // The color of the tooltip.
  final Offset position; // The position of the tooltip on the screen.

  /// Creates a [TooltipData] instance.
  ///
  /// All parameters are required to correctly configure the tooltip.
  TooltipData({
    required this.seriesName,
    required this.dataPoint,
    required this.color,
    required this.position,
  });
}

/// Represents the styling configuration for tooltips.
///
/// This class defines various properties to customize the appearance
/// and behavior of tooltips, such as text style, background color,
/// padding, and shadow effects.
class MultiLineTooltipStyle {
  final TextStyle textStyle; // Style for the text within the tooltip.
  final Color backgroundColor; // Background color of the tooltip.
  final double padding; // Padding around the tooltip content.
  final double threshold; // Threshold for showing the tooltip.
  final double borderRadius; // Border radius for rounded corners.
  final Color shadowColor; // Shadow color for the tooltip.
  final double shadowBlurRadius; // Blur radius of the tooltip's shadow.
  final double indicatorHeight; // Height of the tooltip indicator.

  /// Creates a [MultiLineTooltipStyle] instance with default values.
  ///
  /// Default values are provided for text style and colors to ensure
  /// a consistent look and feel across tooltips.
  const MultiLineTooltipStyle({
    this.textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    this.backgroundColor = Colors.black,
    this.padding = 8.0,
    this.threshold = 10.0,
    this.borderRadius = 4.0,
    this.shadowColor = Colors.black,
    this.shadowBlurRadius = 3.0,
    this.indicatorHeight = 2.0,
  });
}

/// Represents a series of data points on a chart.
///
/// This class encapsulates the data points for a specific series,
/// along with optional configurations such as color, visibility of
/// points, and line properties.
class ChartSeries {
  final String name; // The name of the data series.
  final List<ChartDataPoint>
      dataPoints; // The list of data points in the series.
  final Color? color; // Optional color for the series line.
  final bool? showPoints; // Flag to determine if points should be displayed.
  final bool? smoothLine; // Flag to determine if the line should be smooth.
  final double? lineWidth; // Width of the line.
  final double? pointSize; // Size of the points on the chart.

  /// Creates a [ChartSeries] instance.
  ///
  /// [name] and [dataPoints] are required to define the series.
  /// Other parameters are optional to allow customization.
  const ChartSeries({
    required this.name,
    required this.dataPoints,
    this.color,
    this.showPoints,
    this.smoothLine,
    this.lineWidth,
    this.pointSize,
  });
}

// models/chart_style.dart
/// Represents the overall styling configuration for charts.
///
/// This class defines how charts should be rendered visually,
/// including colors, styles for labels and legends, and options
/// for grid lines and animations.
class MultiLineChartStyle {
  final List<Color> colors; // List of colors used for different series.
  final double defaultLineWidth; // Default line width for series.
  final double defaultPointSize; // Default size of points in series.
  final Color gridColor; // Color for the grid lines.
  final Color backgroundColor; // Background color of the chart.
  final TextStyle? labelStyle; // Style for axis labels.
  final TextStyle? legendStyle; // Style for legend items.
  final bool smoothLines; // Flag to enable smooth lines for series.
  final EdgeInsets padding; // Padding around the chart.
  final bool showPoints; // Flag to show points on the lines.
  final bool showGrid; // Flag to show grid lines.
  final bool showLegend; // Flag to show legend.
  final double gridLineWidth; // Width of the grid lines.
  final int horizontalGridLines; // Number of horizontal grid lines.
  final ChartAnimation animation; // Configuration for chart animations.
  final LegendPosition legendPosition; // Position of the legend.
  final CrosshairConfig? crosshair; // Configuration for the crosshair.
  final bool forceYAxisFromZero; // Flag to enforce Y-axis to start from zero.
  final MultiLineTooltipStyle
      tooltipStyle; // Styling configuration for tooltips.

  /// Creates a [MultiLineChartStyle] instance with default values.
  ///
  /// All parameters can be customized, with defaults provided to
  /// facilitate immediate use.
  const MultiLineChartStyle({
    required this.colors,
    this.defaultLineWidth = 2.0,
    this.defaultPointSize = 4.0,
    this.gridColor = Colors.grey,
    this.backgroundColor = Colors.white,
    this.labelStyle,
    this.legendStyle,
    this.smoothLines = false,
    this.padding = const EdgeInsets.all(20),
    this.showPoints = true,
    this.showGrid = true,
    this.showLegend = true,
    this.gridLineWidth = 1.0,
    this.horizontalGridLines = 5,
    this.animation = const ChartAnimation(),
    this.legendPosition = LegendPosition.bottom,
    this.crosshair,
    this.forceYAxisFromZero =
        false, // Default to false to maintain existing behavior.
    this.tooltipStyle =
        const MultiLineTooltipStyle(), // Initialize tooltip style.
  });

  /// Creates a copy of the current [MultiLineChartStyle] instance with optional overrides.
  ///
  /// This method allows modification of the existing style while retaining
  /// the other properties, useful for creating variations of the chart style.
  MultiLineChartStyle copyWith({
    List<Color>? colors,
    double? defaultLineWidth,
    double? defaultPointSize,
    Color? gridColor,
    Color? backgroundColor,
    TextStyle? labelStyle,
    TextStyle? legendStyle,
    bool? smoothLines,
    EdgeInsets? padding,
    bool? showPoints,
    bool? showGrid,
    bool? showLegend,
    double? gridLineWidth,
    int? horizontalGridLines,
    ChartAnimation? animation,
    LegendPosition? legendPosition,
    CrosshairConfig? crosshair,
    bool? forceYAxisFromZero,
  }) {
    return MultiLineChartStyle(
      colors: colors ?? this.colors,
      defaultLineWidth: defaultLineWidth ?? this.defaultLineWidth,
      defaultPointSize: defaultPointSize ?? this.defaultPointSize,
      gridColor: gridColor ?? this.gridColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      labelStyle: labelStyle ?? this.labelStyle,
      legendStyle: legendStyle ?? this.legendStyle,
      smoothLines: smoothLines ?? this.smoothLines,
      padding: padding ?? this.padding,
      showPoints: showPoints ?? this.showPoints,
      showGrid: showGrid ?? this.showGrid,
      showLegend: showLegend ?? this.showLegend,
      gridLineWidth: gridLineWidth ?? this.gridLineWidth,
      horizontalGridLines: horizontalGridLines ?? this.horizontalGridLines,
      animation: animation ?? this.animation,
      legendPosition: legendPosition ?? this.legendPosition,
      crosshair: crosshair ?? this.crosshair,
      forceYAxisFromZero: forceYAxisFromZero ?? this.forceYAxisFromZero,
    );
  }
}

/// Represents a single item in the legend.
///
/// This private class holds the text and color associated with a legend item.
class LegendItem {
  final String text; // The text label for the legend item.
  final Color color; // The color associated with the legend item.

  /// Creates a [_LegendItem] instance.
  ///
  /// [text] and [color] are required for defining a legend item.
  LegendItem({required this.text, required this.color});
}

// models/chart_config.dart
/// Defines possible positions for the legend in the chart.
///
/// This enum allows for easy configuration of where the legend
/// should be displayed in relation to the chart.
enum LegendPosition { top, bottom, left, right }

/// Represents the animation configuration for the chart.
///
/// This class allows for customization of how animations are applied
/// when the chart is rendered, including duration and easing curve.
class ChartAnimation {
  final Duration duration; // Duration of the animation.
  final Curve curve; // Easing curve for the animation.
  final bool enabled; // Flag to enable or disable animations.

  /// Creates a [ChartAnimation] instance.
  ///
  /// Default values are provided to ensure animations are smooth
  /// and consistent unless otherwise specified.
  const ChartAnimation({
    this.duration = const Duration(milliseconds: 1000),
    this.curve = Curves.easeInOut,
    this.enabled = true,
  });
}

/// Configures the crosshair behavior in the chart.
///
/// This class defines the appearance and behavior of the crosshair
/// that follows the pointer, enhancing data visualization.
class CrosshairConfig {
  final Color lineColor; // Color of the crosshair line.
  final double lineWidth; // Width of the crosshair line.
  final bool enabled; // Flag to enable or disable the crosshair.
  final bool showLabel; // Flag to show the label with the crosshair.
  final TextStyle? labelStyle; // Style for the crosshair label.

  /// Creates a [CrosshairConfig] instance.
  ///
  /// Default values are provided for a consistent appearance.
  const CrosshairConfig({
    this.lineColor = Colors.grey,
    this.lineWidth = 1.0,
    this.enabled = true,
    this.showLabel = true,
    this.labelStyle,
  });
}
