import 'package:flutter/material.dart';
import 'dart:convert';

/// Represents a single data point in the area chart.
class AreaChartData {
  final double value; // The value of the data point, plotted on the Y-axis.
  final String?
      label; // Optional label for the data point, shown on the X-axis.
  final TooltipConfig?
      tooltipConfig; // Configuration for the tooltip displayed on hover.

  /// Creates an instance of `AreaChartData`.
  const AreaChartData({required this.value, this.label, this.tooltipConfig});
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
    this.textStyle = const TextStyle(color: Colors.black87, fontSize: 12),
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

  /// Creates an `AreaChartSeries` from a Plotly trace object.
  ///
  /// Supports Plotly JSON format commonly used in Python scripts.
  /// The trace should be a Map representing a single Plotly trace with
  /// 'x' and 'y' arrays, along with optional styling properties.
  factory AreaChartSeries.fromPlotlyTrace(Map<String, dynamic> trace) {
    // Extract x and y data arrays
    final List<dynamic> xData = trace['x'] as List<dynamic>? ?? [];
    final List<dynamic> yData = trace['y'] as List<dynamic>? ?? [];

    // Ensure both arrays have the same length
    final int dataLength = [
      xData.length,
      yData.length,
    ].reduce((a, b) => a < b ? a : b);

    // Convert to AreaChartData list
    final List<AreaChartData> dataPoints = List.generate(dataLength, (index) {
      final double? parsedValue = _parseNumber(yData[index]);
      if (parsedValue == null) {
        throw FormatException('Invalid y-value at index $index');
      }
      return AreaChartData(
        value: parsedValue,
        label: xData.isNotEmpty ? xData[index]?.toString() : null,
      );
    });

    // Extract series name
    final String seriesName = trace['name']?.toString() ?? 'Series';

    // Parse line properties
    final Map<String, dynamic>? lineConfig =
        trace['line'] as Map<String, dynamic>?;
    Color? lineColor;
    double? lineWidth;

    if (lineConfig != null) {
      lineColor = _parseColor(lineConfig['color']);
      lineWidth = _parseNumber(lineConfig['width'])?.toDouble();
    }

    // Parse marker properties
    final Map<String, dynamic>? markerConfig =
        trace['marker'] as Map<String, dynamic>?;
    double? pointSize;
    bool? showPoints;

    if (markerConfig != null) {
      pointSize = _parseNumber(markerConfig['size'])?.toDouble();
      showPoints =
          true; // If marker config exists, assume points should be shown
    }

    // Determine if this should be treated as area chart
    final String? fill = trace['fill']?.toString();
    Color? gradientColor;

    if (fill != null &&
        (fill == 'tozeroy' || fill == 'tonexty' || fill == 'toself')) {
      // If fill is specified, create a gradient color
      if (lineColor != null) {
        gradientColor = lineColor.withValues(alpha: 0.2);
      }
    }

    // Parse fillcolor if explicitly provided
    if (trace['fillcolor'] != null) {
      gradientColor = _parseColor(trace['fillcolor']);
    }

    return AreaChartSeries(
      name: seriesName,
      dataPoints: dataPoints,
      color: lineColor,
      gradientColor: gradientColor,
      lineWidth: lineWidth,
      showPoints: showPoints,
      pointSize: pointSize,
    );
  }

  /// Helper method to parse color from various formats
  static Color? _parseColor(dynamic colorValue) {
    if (colorValue == null) return null;

    String colorStr = colorValue.toString().toLowerCase();

    // Handle hex colors
    if (colorStr.startsWith('#')) {
      colorStr = colorStr.substring(1);
      if (colorStr.length == 6) {
        return Color(int.parse('FF$colorStr', radix: 16));
      } else if (colorStr.length == 8) {
        return Color(int.parse(colorStr, radix: 16));
      }
    }

    // Handle RGB/RGBA format
    if (colorStr.startsWith('rgb')) {
      final RegExp rgbRegex = RegExp(
        r'rgba?\((\d+),\s*(\d+),\s*(\d+)(?:,\s*([\d.]+))?\)',
      );
      final Match? match = rgbRegex.firstMatch(colorStr);
      if (match != null) {
        final int r = int.parse(match.group(1)!);
        final int g = int.parse(match.group(2)!);
        final int b = int.parse(match.group(3)!);
        final double a =
            match.group(4) != null ? double.parse(match.group(4)!) : 1.0;
        return Color.fromRGBO(r, g, b, a);
      }
    }

    // Handle named colors
    switch (colorStr) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      case 'pink':
        return Colors.pink;
      case 'cyan':
        return Colors.cyan;
      case 'brown':
        return Colors.brown;
      case 'grey':
      case 'gray':
        return Colors.grey;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      default:
        return null;
    }
  }

  /// Helper method to safely parse numbers
  static double? _parseNumber(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }
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
  final String? title; // Chart title from Plotly layout
  final String? xAxisTitle; // X-axis title from Plotly layout
  final String? yAxisTitle; // Y-axis title from Plotly layout

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
    this.title,
    this.xAxisTitle,
    this.yAxisTitle,
  });

  /// Creates an `AreaChartStyle` from a Plotly layout object.
  ///
  /// Extracts styling information from Plotly JSON layout configuration.
  factory AreaChartStyle.fromPlotlyLayout(Map<String, dynamic> layout) {
    // Extract title
    final String? title = layout['title']?.toString();

    // Extract axis titles
    final Map<String, dynamic>? xAxis =
        layout['xaxis'] as Map<String, dynamic>?;
    final Map<String, dynamic>? yAxis =
        layout['yaxis'] as Map<String, dynamic>?;

    final String? xAxisTitle = xAxis?['title']?.toString();
    final String? yAxisTitle = yAxis?['title']?.toString();

    // Extract background color
    Color backgroundColor = Colors.white;
    if (layout['plot_bgcolor'] != null) {
      backgroundColor =
          AreaChartSeries._parseColor(layout['plot_bgcolor']) ?? Colors.white;
    }

    // Extract grid color
    Color gridColor = Colors.grey;
    if (xAxis?['gridcolor'] != null) {
      gridColor =
          AreaChartSeries._parseColor(xAxis!['gridcolor']) ?? Colors.grey;
    }

    return AreaChartStyle(
      title: title,
      xAxisTitle: xAxisTitle,
      yAxisTitle: yAxisTitle,
      backgroundColor: backgroundColor,
      gridColor: gridColor,
    );
  }
}

/// Utility class for parsing complete Plotly JSON format
class PlotlyAreaChartParser {
  /// Parses a complete Plotly JSON string and returns series and style data.
  ///
  /// Expected JSON format:
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "x": [1, 2, 3, 4],
  ///       "y": [10, 11, 12, 13],
  ///       "type": "scatter",
  ///       "mode": "lines",
  ///       "fill": "tozeroy",
  ///       "name": "Series 1",
  ///       "line": {"color": "blue", "width": 2},
  ///       "marker": {"size": 6}
  ///     }
  ///   ],
  ///   "layout": {
  ///     "title": "Area Chart",
  ///     "xaxis": {"title": "X Axis"},
  ///     "yaxis": {"title": "Y Axis"}
  ///   }
  /// }
  /// ```
  static PlotlyAreaChartData fromJson(String jsonString) {
    final Map<String, dynamic> plotlyData = json.decode(jsonString);
    return fromMap(plotlyData);
  }

  /// Parses a Plotly data map and returns series and style data.
  static PlotlyAreaChartData fromMap(Map<String, dynamic> plotlyData) {
    final List<dynamic> traces = plotlyData['data'] as List<dynamic>? ?? [];
    final Map<String, dynamic> layout =
        plotlyData['layout'] as Map<String, dynamic>? ?? {};

    // Convert traces to AreaChartSeries
    final List<AreaChartSeries> series = traces
        .cast<Map<String, dynamic>>()
        .where((trace) {
          // Filter for traces that can be converted to area charts
          final String? type = trace['type']?.toString();
          final String? fill = trace['fill']?.toString();

          // Include scatter traces with fill, or explicit area/line types
          return (type == 'scatter' && fill != null) ||
              type == 'area' ||
              type == null; // Default to scatter if no type specified
        })
        .map((trace) => AreaChartSeries.fromPlotlyTrace(trace))
        .toList();

    // Parse layout to style
    final AreaChartStyle style = layout.isNotEmpty
        ? AreaChartStyle.fromPlotlyLayout(layout)
        : const AreaChartStyle();

    return PlotlyAreaChartData(series: series, style: style);
  }
}

/// Container for parsed Plotly data
class PlotlyAreaChartData {
  final List<AreaChartSeries> series;
  final AreaChartStyle style;

  const PlotlyAreaChartData({required this.series, required this.style});
}
