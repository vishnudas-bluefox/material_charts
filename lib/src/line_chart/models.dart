import 'package:flutter/material.dart';
import 'dart:convert';
import '../shared/shared_models.dart';

/// Model class for chart data points.
/// This class represents a single data point in the line chart,
/// containing a value and a corresponding label.
class ChartData {
  final double value; // The numeric value of the data point
  final String label; // The label associated with the data point

  const ChartData({required this.value, required this.label});

  /// Creates a [ChartData] instance from a JSON map.
  /// Supports both simple and Plotly-compatible formats.
  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      value: (json['y'] ?? json['value'] ?? 0.0).toDouble(),
      label: json['x'] ?? json['label'] ?? '',
    );
  }

  /// Converts the [ChartData] to a JSON map.
  /// Supports both simple and Plotly-compatible formats.
  Map<String, dynamic> toJson() {
    return {'x': label, 'y': value};
  }

  /// Helper method to parse color from various formats
  static Color parseColor(dynamic colorValue) {
    if (colorValue is String) {
      if (colorValue.startsWith('#')) {
        return Color(int.parse(colorValue.replaceFirst('#', '0xFF')));
      } else if (colorValue.startsWith('rgb(')) {
        // Parse rgb(r, g, b) format
        final rgb = colorValue.replaceAll('rgb(', '').replaceAll(')', '');
        final parts = rgb.split(',').map((e) => int.parse(e.trim())).toList();
        return Color.fromRGBO(parts[0], parts[1], parts[2], 1.0);
      } else if (colorValue.startsWith('rgba(')) {
        // Parse rgba(r, g, b, a) format
        final rgba = colorValue.replaceAll('rgba(', '').replaceAll(')', '');
        final parts =
            rgba.split(',').map((e) => double.parse(e.trim())).toList();
        return Color.fromRGBO(
          parts[0].toInt(),
          parts[1].toInt(),
          parts[2].toInt(),
          parts[3],
        );
      }
    }
    return Colors.blue; // Default fallback
  }

  /// Helper method to convert Color to hex string
  static String colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).padLeft(8, '0')}';
  }
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

  /// Creates a [LineChartStyle] instance from a JSON map.
  /// Supports both simple and Plotly-compatible formats.
  factory LineChartStyle.fromJson(Map<String, dynamic> json) {
    return LineChartStyle(
      lineColor: json['lineColor'] != null
          ? ChartData.parseColor(json['lineColor'])
          : json['line']?['color'] != null
              ? ChartData.parseColor(json['line']['color'])
              : json['marker']?['color'] != null
                  ? ChartData.parseColor(json['marker']['color'])
                  : Colors.blue,
      gridColor: json['gridColor'] != null
          ? ChartData.parseColor(json['gridColor'])
          : json['xaxis']?['gridcolor'] != null
              ? ChartData.parseColor(json['xaxis']['gridcolor'])
              : json['yaxis']?['gridcolor'] != null
                  ? ChartData.parseColor(json['yaxis']['gridcolor'])
                  : Colors.grey,
      pointColor: json['pointColor'] != null
          ? ChartData.parseColor(json['pointColor'])
          : json['marker']?['color'] != null
              ? ChartData.parseColor(json['marker']['color'])
              : json['line']?['color'] != null
                  ? ChartData.parseColor(json['line']['color'])
                  : Colors.blue,
      backgroundColor: json['backgroundColor'] != null
          ? ChartData.parseColor(json['backgroundColor'])
          : json['plot_bgcolor'] != null
              ? ChartData.parseColor(json['plot_bgcolor'])
              : json['paper_bgcolor'] != null
                  ? ChartData.parseColor(json['paper_bgcolor'])
                  : Colors.white,
      labelStyle: _parseTextStyle(
        json['labelStyle'] ??
            json['xaxis']?['tickfont'] ??
            json['yaxis']?['tickfont'],
      ),
      strokeWidth: (json['strokeWidth'] ??
              json['line']?['width'] ??
              json['marker']?['line']?['width'] ??
              2.0)
          .toDouble(),
      pointRadius:
          (json['pointRadius'] ?? json['marker']?['size'] ?? 4.0).toDouble(),
      animationDuration: Duration(
        milliseconds: (json['animationDuration'] ??
                json['animation']?['duration'] ??
                1500)
            .toInt(),
      ),
      animationCurve: _parseCurve(
        json['animationCurve'] ?? json['animation']?['curve'] ?? 'easeInOut',
      ),
      useCurvedLines:
          json['useCurvedLines'] ?? json['line']?['shape'] == 'spline' ?? false,
      curveIntensity:
          (json['curveIntensity'] ?? json['line']?['smoothing'] ?? 0.3)
              .toDouble(),
      roundedPoints:
          json['roundedPoints'] ?? json['line']?['shape'] != 'linear' ?? true,
      verticalLineColor: json['verticalLineColor'] != null
          ? ChartData.parseColor(json['verticalLineColor'])
          : Colors.blue,
      verticalLineWidth: (json['verticalLineWidth'] ?? 1.0).toDouble(),
      verticalLineStyle: _parseLineStyle(json['verticalLineStyle'] ?? 'solid'),
      verticalLineOpacity: (json['verticalLineOpacity'] ?? 0.7).toDouble(),
      showTooltips: json['showTooltips'] ?? json['hovermode'] != 'none' ?? true,
      tooltipStyle: _parseTooltipStyle(
        json['tooltipStyle'] ?? json['hoverlabel'],
      ),
    );
  }

  /// Converts the [LineChartStyle] to a JSON map.
  /// Supports both simple and Plotly-compatible formats.
  Map<String, dynamic> toJson() {
    return {
      'lineColor': ChartData.colorToHex(lineColor),
      'gridColor': ChartData.colorToHex(gridColor),
      'pointColor': ChartData.colorToHex(pointColor),
      'backgroundColor': ChartData.colorToHex(backgroundColor),
      'strokeWidth': strokeWidth,
      'pointRadius': pointRadius,
      'animationDuration': animationDuration.inMilliseconds,
      'animationCurve': _curveToString(animationCurve),
      'useCurvedLines': useCurvedLines,
      'curveIntensity': curveIntensity,
      'roundedPoints': roundedPoints,
      'verticalLineColor': ChartData.colorToHex(verticalLineColor),
      'verticalLineWidth': verticalLineWidth,
      'verticalLineStyle': _lineStyleToString(verticalLineStyle),
      'verticalLineOpacity': verticalLineOpacity,
      'showTooltips': showTooltips,
    };
  }

  /// Helper method to parse animation curve from string
  static Curve _parseCurve(String curveName) {
    switch (curveName.toLowerCase()) {
      case 'linear':
        return Curves.linear;
      case 'easein':
        return Curves.easeIn;
      case 'easeout':
        return Curves.easeOut;
      case 'easeinout':
        return Curves.easeInOut;
      case 'bouncein':
        return Curves.bounceIn;
      case 'bounceout':
        return Curves.bounceOut;
      default:
        return Curves.easeInOut;
    }
  }

  /// Helper method to convert curve to string
  static String _curveToString(Curve curve) {
    if (curve == Curves.linear) return 'linear';
    if (curve == Curves.easeIn) return 'easeIn';
    if (curve == Curves.easeOut) return 'easeOut';
    if (curve == Curves.easeInOut) return 'easeInOut';
    if (curve == Curves.bounceIn) return 'bounceIn';
    if (curve == Curves.bounceOut) return 'bounceOut';
    return 'easeInOut';
  }

  /// Helper method to parse line style from string
  static LineStyle _parseLineStyle(String lineStyle) {
    switch (lineStyle.toLowerCase()) {
      case 'dashed':
      case 'dash':
        return LineStyle.dashed;
      case 'dotted':
      case 'dot':
        return LineStyle.dotted;
      case 'solid':
      default:
        return LineStyle.solid;
    }
  }

  /// Helper method to convert line style to string
  static String _lineStyleToString(LineStyle lineStyle) {
    switch (lineStyle) {
      case LineStyle.dashed:
        return 'dashed';
      case LineStyle.dotted:
        return 'dotted';
      default:
        return 'solid';
    }
  }

  /// Helper method to parse text style from JSON
  static TextStyle? _parseTextStyle(dynamic textStyle) {
    if (textStyle == null) return null;

    if (textStyle is Map<String, dynamic>) {
      return TextStyle(
        fontSize: (textStyle['size'] ?? textStyle['fontSize'] ?? 12).toDouble(),
        fontWeight: _parseFontWeight(
          textStyle['weight'] ?? textStyle['fontWeight'],
        ),
        color: textStyle['color'] != null
            ? ChartData.parseColor(textStyle['color'])
            : null,
      );
    }

    return null;
  }

  /// Helper method to parse font weight from string
  static FontWeight _parseFontWeight(dynamic weight) {
    if (weight == null) return FontWeight.normal;

    if (weight is String) {
      switch (weight.toLowerCase()) {
        case 'bold':
          return FontWeight.bold;
        case 'w100':
          return FontWeight.w100;
        case 'w200':
          return FontWeight.w200;
        case 'w300':
          return FontWeight.w300;
        case 'w400':
          return FontWeight.w400;
        case 'w500':
          return FontWeight.w500;
        case 'w600':
          return FontWeight.w600;
        case 'w700':
          return FontWeight.w700;
        case 'w800':
          return FontWeight.w800;
        case 'w900':
          return FontWeight.w900;
        default:
          return FontWeight.normal;
      }
    }

    return FontWeight.normal;
  }

  /// Helper method to parse tooltip style from JSON
  static TooltipStyle _parseTooltipStyle(dynamic tooltipStyle) {
    if (tooltipStyle == null) return const TooltipStyle();

    if (tooltipStyle is Map<String, dynamic>) {
      return TooltipStyle(
        backgroundColor: tooltipStyle['backgroundColor'] != null
            ? ChartData.parseColor(tooltipStyle['backgroundColor'])
            : tooltipStyle['bgcolor'] != null
                ? ChartData.parseColor(tooltipStyle['bgcolor'])
                : Colors.white,
        borderColor: tooltipStyle['borderColor'] != null
            ? ChartData.parseColor(tooltipStyle['borderColor'])
            : tooltipStyle['bordercolor'] != null
                ? ChartData.parseColor(tooltipStyle['bordercolor'])
                : Colors.grey,
        borderRadius: (tooltipStyle['borderRadius'] ??
                tooltipStyle['borderradius'] ??
                5.0)
            .toDouble(),
        textStyle: _parseTextStyle(
              tooltipStyle['textStyle'] ?? tooltipStyle['font'],
            ) ??
            const TextStyle(color: Colors.black, fontSize: 12),
        padding: _parsePadding(tooltipStyle['padding']),
      );
    }

    return const TooltipStyle();
  }

  /// Helper method to parse padding from JSON
  static EdgeInsets _parsePadding(dynamic padding) {
    if (padding == null) return const EdgeInsets.all(8);

    if (padding is Map<String, dynamic>) {
      return EdgeInsets.only(
        left: (padding['left'] ?? padding['l'] ?? 8).toDouble(),
        top: (padding['top'] ?? padding['t'] ?? 8).toDouble(),
        right: (padding['right'] ?? padding['r'] ?? 8).toDouble(),
        bottom: (padding['bottom'] ?? padding['b'] ?? 8).toDouble(),
      );
    }

    return const EdgeInsets.all(8);
  }

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

/// JSON configuration for line charts with optional Plotly compatibility.
/// This class provides a bridge between JSON format and Flutter widgets.
class LineChartJsonConfig {
  /// The data points for the chart
  final List<Map<String, dynamic>> data;

  /// The style configuration
  final Map<String, dynamic> style;

  /// Chart dimensions
  final double width;
  final double height;

  /// Display options
  final bool showGrid;
  final bool showPoints;
  final bool showTooltips;
  final EdgeInsets padding;
  final int horizontalGridLines;
  final VoidCallback? onAnimationComplete;

  /// Creates a [LineChartJsonConfig] instance.
  const LineChartJsonConfig({
    required this.data,
    required this.style,
    required this.width,
    required this.height,
    this.showGrid = true,
    this.showPoints = true,
    this.showTooltips = true,
    this.padding = const EdgeInsets.all(24),
    this.horizontalGridLines = 5,
    this.onAnimationComplete,
  });

  /// Creates a [LineChartJsonConfig] from a JSON map.
  /// Supports both simple and Plotly-compatible formats.
  factory LineChartJsonConfig.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>? ?? [];
    final style = json['style'] ?? json['layout'] ?? {};

    // Handle Plotly format: data is an array of objects with x, y arrays
    List<Map<String, dynamic>> processedData = [];
    Map<String, dynamic> mergedStyle = Map<String, dynamic>.from(style);

    if (data.isNotEmpty && data[0] is Map<String, dynamic>) {
      final firstDataItem = data[0] as Map<String, dynamic>;

      // Check if this is Plotly format (has x and y as arrays)
      if (firstDataItem['x'] is List && firstDataItem['y'] is List) {
        final xValues = firstDataItem['x'] as List;
        final yValues = firstDataItem['y'] as List;
        final line = firstDataItem['line'] as Map<String, dynamic>?;
        final marker = firstDataItem['marker'] as Map<String, dynamic>?;
        final mode = firstDataItem['mode'] as String?;

        // Merge line and marker data into style for global properties
        if (line != null) {
          mergedStyle['line'] = line;
        }
        if (marker != null) {
          mergedStyle['marker'] = marker;
        }

        // Handle mode property for showing points/lines
        if (mode != null) {
          mergedStyle['showPoints'] = mode.contains('markers');
          mergedStyle['showLines'] = mode.contains('lines');
        }

        // Convert Plotly format to individual data objects
        for (int i = 0; i < xValues.length && i < yValues.length; i++) {
          final dataPoint = <String, dynamic>{'x': xValues[i], 'y': yValues[i]};
          processedData.add(dataPoint);
        }
      } else {
        // Handle regular format (array of individual data objects)
        processedData = data.cast<Map<String, dynamic>>();
      }
    }

    return LineChartJsonConfig(
      data: processedData,
      style: mergedStyle,
      width: (style['width'] ?? 800).toDouble(),
      height: (style['height'] ?? 400).toDouble(),
      showGrid: style['showGrid'] ??
          style['showgrid'] ??
          style['xaxis']?['showgrid'] ??
          style['yaxis']?['showgrid'] ??
          true,
      showPoints: style['showPoints'] ?? style['showLines'] == false ?? true,
      showTooltips:
          style['showTooltips'] ?? style['hovermode'] != 'none' ?? true,
      padding: _parsePadding(style['padding'] ?? style['margin']),
      horizontalGridLines: (style['horizontalGridLines'] ??
              style['ygrid']?['nticks'] ??
              style['yaxis']?['nticks'] ??
              5)
          .toInt(),
    );
  }

  /// Creates a [LineChartJsonConfig] from a JSON string.
  factory LineChartJsonConfig.fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return LineChartJsonConfig.fromJson(json);
  }

  /// Converts the configuration to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'style': {
        ...style,
        'width': width,
        'height': height,
        'showGrid': showGrid,
        'showPoints': showPoints,
        'showTooltips': showTooltips,
        'padding': _paddingToJson(padding),
        'horizontalGridLines': horizontalGridLines,
      },
    };
  }

  /// Converts the configuration to a JSON string.
  String toJsonString() {
    return jsonEncode(toJson());
  }

  /// Converts the JSON configuration to Flutter models.
  List<ChartData> getChartData() {
    return data.map((item) => ChartData.fromJson(item)).toList();
  }

  /// Converts the JSON configuration to Flutter style.
  LineChartStyle getLineChartStyle() {
    return LineChartStyle.fromJson(style);
  }

  /// Helper method to parse padding from JSON
  static EdgeInsets _parsePadding(dynamic padding) {
    if (padding == null) return const EdgeInsets.all(24);

    if (padding is Map<String, dynamic>) {
      return EdgeInsets.only(
        left: (padding['left'] ?? padding['l'] ?? 24).toDouble(),
        top: (padding['top'] ?? padding['t'] ?? 24).toDouble(),
        right: (padding['right'] ?? padding['r'] ?? 24).toDouble(),
        bottom: (padding['bottom'] ?? padding['b'] ?? 24).toDouble(),
      );
    }

    return const EdgeInsets.all(24);
  }

  /// Helper method to convert padding to JSON
  static Map<String, dynamic> _paddingToJson(EdgeInsets padding) {
    return {
      'left': padding.left,
      'top': padding.top,
      'right': padding.right,
      'bottom': padding.bottom,
    };
  }
}
