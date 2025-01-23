import 'package:flutter/material.dart';

/// Represents data for a single slice of a pie chart.
class PieChartData {
  /// The value that represents the size of the slice.
  final double value;

  /// The label for the slice, which will be displayed in the chart.
  final String label;

  /// The color of the slice. It can be null, in which case a default color will be used.
  final Color? color;

  /// The action on tap for the slice.
  final VoidCallback? onTap;

  /// Constructor for [PieChartData].
  ///
  /// Requires [value] and [label] to be provided.
  /// [color] is optional and can be null.
  /// [onTap] is optional and can be null.
  const PieChartData({
    required this.value,
    required this.label,
    this.color,
    this.onTap,
  });
}

/// Defines the style properties for the pie chart.
class PieChartStyle {
  /// The list of default colors to be used for pie slices.
  final List<Color> defaultColors;

  /// The background color of the pie chart.
  final Color backgroundColor;

  /// The text style to be applied to slice labels.
  final TextStyle? labelStyle;

  /// The text style to be applied to slice values.
  final TextStyle? valueStyle;

  /// The starting angle for the pie chart slices (in degrees).
  final double startAngle;

  /// The radius of the hole in the center of the pie chart (for doughnut charts).
  final double holeRadius;

  /// Duration of the animation when the pie chart is drawn.
  final Duration animationDuration;

  /// The curve type for the animation (e.g., easeInOut).
  final Curve animationCurve;

  /// Whether to show labels on the pie chart slices.
  final bool showLabels;

  /// Whether to show values on the pie chart slices.
  final bool showValues;

  /// The offset distance of the labels from the slices.
  final double labelOffset;

  /// Whether to show the legend for the pie chart.
  final bool showLegend;

  /// Padding around the legend.
  final EdgeInsets legendPadding;

  /// The position of the labels relative to the pie chart slices.
  final LabelPosition labelPosition;

  /// Whether to show connector lines from the legend to the slices.
  final bool showConnectorLines;

  /// The color of the connector lines.
  final Color connectorLineColor;

  /// The stroke width of the connector lines.
  final double connectorLineStrokeWidth;

  /// The position that the chart will be placed
  final ChartAlignment chartAlignment;

  /// Constructor for [PieChartStyle].
  ///
  /// All parameters have default values, allowing for flexible customization.
  /// If not provided, the pie chart will use the defaults for each property.
  const PieChartStyle({
    this.defaultColors = const [
      Colors.blue, // Default color 1
      Colors.red, // Default color 2
      Colors.green, // Default color 3
      Colors.yellow, // Default color 4
      Colors.purple, // Default color 5
      Colors.orange, // Default color 6
    ],
    this.backgroundColor = Colors.white, // Default background color
    this.labelStyle, // Optional text style for labels
    this.valueStyle, // Optional text style for values
    this.startAngle = -90, // Default starting angle for the first slice
    this.holeRadius = 0, // No hole by default (full pie chart)
    this.animationDuration = const Duration(milliseconds: 1500), // Default animation duration
    this.animationCurve = Curves.easeInOut, // Default animation curve
    this.showLabels = true, // Labels are shown by default
    this.showValues = true, // Values are shown by default
    this.labelOffset = 20, // Default label offset
    this.showLegend = true, // Legend is shown by default
    this.legendPadding = const EdgeInsets.all(16), // Default legend padding
    this.labelPosition = LabelPosition.outside, // Default label position
    this.showConnectorLines = true, // Connector lines are shown by default
    this.connectorLineColor = Colors.black54, // Default connector line color
    this.connectorLineStrokeWidth = 1.0, // Default connector line stroke width
    this.chartAlignment = ChartAlignment.center, // Default vertical position
  });
}

/// Defines the possible positions for labels on the pie chart slices.
enum LabelPosition {
  inside, // Labels are inside the slices
  outside, // Labels are outside the slices
}

enum Vertical {
  center, // Graph is placed in the vertical center
  top, // Graph is placed in the top
  bottom; // Graph is placed in the bottom
}

enum Horizontal {
  center, // Graph is placed in the horizontal center
  left, // Graph is placed in the left
  right; // Graph is placed in the right
}

enum ChartAlignment {
  bottomCenter(Vertical.bottom, Horizontal.center),
  bottomLeft(Vertical.bottom, Horizontal.left),
  bottomRight(Vertical.bottom, Horizontal.right),
  center(Vertical.center, Horizontal.center),
  centerLeft(Vertical.center, Horizontal.left),
  centerRight(Vertical.center, Horizontal.right),
  topCenter(Vertical.top, Horizontal.center),
  topLeft(Vertical.top, Horizontal.left),
  topRight(Vertical.top, Horizontal.right);

  final Horizontal horizontal;
  final Vertical vertical;
  const ChartAlignment(this.vertical, this.horizontal);
}
