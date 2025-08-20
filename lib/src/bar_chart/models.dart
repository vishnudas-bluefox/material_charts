import 'package:flutter/material.dart';
import 'dart:convert';

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
  const BarChartData({required this.value, required this.label, this.color});

  /// Creates a [BarChartData] instance from a JSON map.
  /// Supports both simple and Plotly-compatible formats.
  factory BarChartData.fromJson(Map<String, dynamic> json) {
    return BarChartData(
      value: (json['y'] ?? json['value'] ?? 0.0).toDouble(),
      label: json['x'] ?? json['label'] ?? '',
      color: json['color'] != null
          ? parseColor(json['color'])
          : json['marker']?['color'] != null
              ? parseColor(json['marker']['color'])
              : null,
    );
  }

  /// Converts the [BarChartData] to a JSON map.
  /// Supports both simple and Plotly-compatible formats.
  Map<String, dynamic> toJson() {
    return {
      'x': label,
      'y': value,
      if (color != null) 'color': colorToHex(color!),
    };
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

  /// Creates a [BarChartStyle] instance from a JSON map.
  /// Supports both simple and Plotly-compatible formats.
  factory BarChartStyle.fromJson(Map<String, dynamic> json) {
    return BarChartStyle(
      barColor: json['barColor'] != null
          ? BarChartData.parseColor(json['barColor'])
          : json['marker']?['color'] != null
              ? BarChartData.parseColor(json['marker']['color'])
              : json['marker']?['colorscale'] != null
                  ? _parseColorscale(json['marker']['colorscale']).first
                  : Colors.blue,
      gridColor: json['gridColor'] != null
          ? BarChartData.parseColor(json['gridColor'])
          : json['xaxis']?['gridcolor'] != null
              ? BarChartData.parseColor(json['xaxis']['gridcolor'])
              : json['yaxis']?['gridcolor'] != null
                  ? BarChartData.parseColor(json['yaxis']['gridcolor'])
                  : Colors.grey,
      backgroundColor: json['backgroundColor'] != null
          ? BarChartData.parseColor(json['backgroundColor'])
          : json['plot_bgcolor'] != null
              ? BarChartData.parseColor(json['plot_bgcolor'])
              : json['paper_bgcolor'] != null
                  ? BarChartData.parseColor(json['paper_bgcolor'])
                  : Colors.white,
      labelStyle: _parseTextStyle(json['labelStyle'] ??
          json['xaxis']?['tickfont'] ??
          json['yaxis']?['tickfont']),
      valueStyle: _parseTextStyle(
          json['valueStyle'] ?? json['font'] ?? json['textfont']),
      barSpacing: (json['barSpacing'] ?? json['bargap'] ?? 0.2).toDouble(),
      cornerRadius: () {
        final value =
            json['cornerRadius'] ?? json['marker']?['cornerradius'] ?? 4.0;

        return value.toDouble();
      }(),
      animationDuration: Duration(
        milliseconds: (json['animationDuration'] ??
                json['animation']?['duration'] ??
                1500)
            .toInt(),
      ),
      animationCurve: _parseCurve(
          json['animationCurve'] ?? json['animation']?['curve'] ?? 'easeInOut'),
      gradientEffect: json['gradientEffect'] ??
          json['colorscale'] != null || json['marker']?['colorscale'] != null,
      gradientColors: json['gradientColors'] != null
          ? (json['gradientColors'] as List)
              .map((c) => BarChartData.parseColor(c))
              .toList()
          : json['colorscale'] != null
              ? _parseColorscale(json['colorscale'])
              : json['marker']?['colorscale'] != null
                  ? _parseColorscale(json['marker']['colorscale'])
                  : null,
    );
  }

  /// Converts the [BarChartStyle] to a JSON map.
  /// Supports both simple and Plotly-compatible formats.
  Map<String, dynamic> toJson() {
    return {
      'barColor': BarChartData.colorToHex(barColor),
      'gridColor': BarChartData.colorToHex(gridColor),
      'backgroundColor': BarChartData.colorToHex(backgroundColor),
      'barSpacing': barSpacing,
      'cornerRadius': cornerRadius,
      'animationDuration': animationDuration.inMilliseconds,
      'animationCurve': _curveToString(animationCurve),
      'gradientEffect': gradientEffect,
      if (gradientColors != null)
        'gradientColors':
            gradientColors!.map((c) => BarChartData.colorToHex(c)).toList(),
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

  /// Helper method to parse colorscale from Plotly format
  static List<Color> _parseColorscale(dynamic colorscale) {
    if (colorscale is List) {
      return colorscale.map((color) => BarChartData.parseColor(color)).toList();
    }
    // Default gradient if colorscale is not a list
    return [Colors.blue.shade300, Colors.blue.shade600];
  }

  /// Helper method to parse text style from JSON
  static TextStyle? _parseTextStyle(dynamic textStyle) {
    if (textStyle == null) return null;

    if (textStyle is Map<String, dynamic>) {
      return TextStyle(
        fontSize: (textStyle['size'] ?? textStyle['fontSize'] ?? 12).toDouble(),
        fontWeight:
            _parseFontWeight(textStyle['weight'] ?? textStyle['fontWeight']),
        color: textStyle['color'] != null
            ? BarChartData.parseColor(textStyle['color'])
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
}

/// JSON configuration for bar charts with optional Plotly compatibility.
/// This class provides a bridge between JSON format and Flutter widgets.
class BarChartJsonConfig {
  /// The data points for the chart
  final List<Map<String, dynamic>> data;

  /// The style configuration
  final Map<String, dynamic> style;

  /// Chart dimensions
  final double width;
  final double height;

  /// Display options
  final bool showGrid;
  final bool showValues;
  final EdgeInsets padding;
  final int horizontalGridLines;
  final bool interactive;
  final VoidCallback? onAnimationComplete;

  /// Creates a [BarChartJsonConfig] instance.
  const BarChartJsonConfig({
    required this.data,
    required this.style,
    required this.width,
    required this.height,
    this.showGrid = true,
    this.showValues = true,
    this.padding = const EdgeInsets.all(24),
    this.horizontalGridLines = 5,
    this.interactive = true,
    this.onAnimationComplete,
  });

  /// Creates a [BarChartJsonConfig] from a JSON map.
  /// Supports both simple and Plotly-compatible formats.
  factory BarChartJsonConfig.fromJson(Map<String, dynamic> json) {
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
        final marker = firstDataItem['marker'] as Map<String, dynamic>?;
        final colors = marker?['color'] as List?;

        // Merge marker data into style for global properties like cornerradius
        if (marker != null) {
          mergedStyle['marker'] = marker;
        }

        // Convert Plotly format to individual data objects
        for (int i = 0; i < xValues.length && i < yValues.length; i++) {
          final dataPoint = <String, dynamic>{
            'x': xValues[i],
            'y': yValues[i],
          };

          // Add color if available
          if (colors != null && i < colors.length) {
            dataPoint['color'] = colors[i];
          }

          processedData.add(dataPoint);
        }
      } else {
        // Handle regular format (array of individual data objects)
        processedData = data.cast<Map<String, dynamic>>();
      }
    }

    return BarChartJsonConfig(
      data: processedData,
      style: mergedStyle,
      width: (style['width'] ?? 800).toDouble(),
      height: (style['height'] ?? 400).toDouble(),
      showGrid: style['showGrid'] ??
          style['showgrid'] ??
          style['xaxis']?['showgrid'] ??
          style['yaxis']?['showgrid'] ??
          true,
      showValues: style['showValues'] ?? style['showvalues'] ?? true,
      padding: _parsePadding(style['padding'] ?? style['margin']),
      horizontalGridLines: (style['horizontalGridLines'] ??
              style['ygrid']?['nticks'] ??
              style['yaxis']?['nticks'] ??
              5)
          .toInt(),
      interactive: style['interactive'] ?? style['hovermode'] != null ?? true,
    );
  }

  /// Creates a [BarChartJsonConfig] from a JSON string.
  factory BarChartJsonConfig.fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return BarChartJsonConfig.fromJson(json);
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
        'showValues': showValues,
        'padding': _paddingToJson(padding),
        'horizontalGridLines': horizontalGridLines,
        'interactive': interactive,
      },
    };
  }

  /// Converts the configuration to a JSON string.
  String toJsonString() {
    return jsonEncode(toJson());
  }

  /// Converts the JSON configuration to Flutter models.
  List<BarChartData> getBarChartData() {
    return data.map((item) => BarChartData.fromJson(item)).toList();
  }

  /// Converts the JSON configuration to Flutter style.
  BarChartStyle getBarChartStyle() {
    return BarChartStyle.fromJson(style);
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
