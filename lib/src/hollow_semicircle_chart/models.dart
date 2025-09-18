import 'package:flutter/material.dart';
import 'dart:convert';

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

  /// Creates a [ChartStyle] instance from a JSON map.
  /// Supports both simple and Plotly-compatible formats.
  factory ChartStyle.fromJson(Map<String, dynamic> json) {
    return ChartStyle(
      activeColor: json['activeColor'] != null
          ? _parseColor(json['activeColor'])
          : json['gauge']?['bar']?['color'] != null
              ? _parseColor(json['gauge']['bar']['color'])
              : Colors.blue,
      inactiveColor: json['inactiveColor'] != null
          ? _parseColor(json['inactiveColor'])
          : json['gauge']?['bgcolor'] != null
              ? _parseColor(json['gauge']['bgcolor'])
              : const Color(0xFFE0E0E0),
      textColor: json['textColor'] != null
          ? _parseColor(json['textColor'])
          : json['font']?['color'] != null
              ? _parseColor(json['font']['color'])
              : null,
      percentageStyle: _parseTextStyle(json['percentageStyle'] ?? json['font']),
      legendStyle: _parseTextStyle(json['legendStyle'] ?? json['font']),
      animationDuration: Duration(
        milliseconds: (json['animationDuration'] ??
                json['animation']?['duration'] ??
                1500)
            .toInt(),
      ),
      animationCurve: _parseCurve(
        json['animationCurve'] ?? json['animation']?['curve'] ?? 'easeInOut',
      ),
      showPercentageText: json['showPercentageText'] ??
          json['mode']?.toString().contains('number') ??
          true,
      showLegend: json['showLegend'] ?? json['showlegend'] ?? true,
      // Note: percentageFormatter and legendFormatter cannot be parsed from JSON
      // as they are functions. They would need to be set programmatically.
    );
  }

  /// Converts the [ChartStyle] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'activeColor': _colorToHex(activeColor),
      'inactiveColor': _colorToHex(inactiveColor),
      'textColor': textColor != null ? _colorToHex(textColor!) : null,
      'animationDuration': animationDuration.inMilliseconds,
      'animationCurve': _curveToString(animationCurve),
      'showPercentageText': showPercentageText,
      'showLegend': showLegend,
    };
  }

  /// Helper method to parse color from various formats
  static Color _parseColor(dynamic colorValue) {
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
      } else {
        // Handle named colors
        switch (colorValue.toLowerCase()) {
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
          case 'black':
            return Colors.black;
          case 'white':
            return Colors.white;
          case 'gray':
          case 'grey':
            return Colors.grey;
          default:
            return Colors.blue;
        }
      }
    }
    return Colors.blue; // Default fallback
  }

  /// Helper method to convert Color to hex string
  static String _colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
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

  /// Helper method to parse text style from JSON
  static TextStyle? _parseTextStyle(dynamic textStyle) {
    if (textStyle == null) return null;

    if (textStyle is Map<String, dynamic>) {
      return TextStyle(
        fontSize: (textStyle['size'] ?? textStyle['fontSize'] ?? 12).toDouble(),
        fontWeight: _parseFontWeight(
          textStyle['weight'] ?? textStyle['fontWeight'],
        ),
        color:
            textStyle['color'] != null ? _parseColor(textStyle['color']) : null,
        fontFamily: textStyle['family'] ?? textStyle['fontFamily'],
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
  })  : assert(
          percentage >= 0 && percentage <= 100,
          'Percentage must be between 0 and 100',
        ),
        assert(size > 0, 'Size must be greater than 0');
}

/// JSON configuration for hollow semicircle charts with optional Plotly compatibility.
/// This class provides a bridge between JSON format and Flutter widgets.
class HollowSemiCircleChartJsonConfig {
  /// The percentage value for the chart
  final double percentage;

  /// The size of the chart
  final double size;

  /// The hollow radius ratio
  final double hollowRadius;

  /// The style configuration
  final Map<String, dynamic> style;

  /// Display options
  final VoidCallback? onAnimationComplete;

  /// Creates a [HollowSemiCircleChartJsonConfig] instance.
  const HollowSemiCircleChartJsonConfig({
    required this.percentage,
    required this.size,
    required this.hollowRadius,
    required this.style,
    this.onAnimationComplete,
  });

  /// Creates a [HollowSemiCircleChartJsonConfig] from a JSON map.
  /// Supports both simple and Plotly-compatible formats.
  factory HollowSemiCircleChartJsonConfig.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>? ?? [];
    final layout = json['layout'] ?? {};

    // Handle Plotly format
    double percentage = 0;
    double size = 200;
    double hollowRadius = 0.6;
    Map<String, dynamic> mergedStyle = Map<String, dynamic>.from(layout);

    if (data.isNotEmpty && data[0] is Map<String, dynamic>) {
      final firstDataItem = data[0] as Map<String, dynamic>;

      // Extract percentage from various Plotly formats
      if (firstDataItem['value'] != null) {
        final value = firstDataItem['value'].toDouble();
        final maxValue =
            firstDataItem['gauge']?['axis']?['range']?[1]?.toDouble() ??
                firstDataItem['max']?.toDouble() ??
                100.0;
        final minValue =
            firstDataItem['gauge']?['axis']?['range']?[0]?.toDouble() ??
                firstDataItem['min']?.toDouble() ??
                0.0;

        // Convert to percentage (0-100 range)
        percentage = ((value - minValue) / (maxValue - minValue)) * 100;
      }

      // Merge gauge properties into style
      if (firstDataItem['gauge'] != null) {
        mergedStyle['gauge'] = firstDataItem['gauge'];
      }

      // Handle mode for showing text/numbers
      if (firstDataItem['mode'] != null) {
        mergedStyle['mode'] = firstDataItem['mode'];
      }

      // Handle title
      if (firstDataItem['title'] != null) {
        mergedStyle['title'] = firstDataItem['title'];
      }

      // Handle domain for size calculations
      if (firstDataItem['domain'] != null) {
        mergedStyle['domain'] = firstDataItem['domain'];
      }
    }

    // Handle simple format (direct percentage)
    if (json['percentage'] != null) {
      percentage = json['percentage'].toDouble();
    } else if (json['value'] != null && json['max'] != null) {
      final value = json['value'].toDouble();
      final maxValue = json['max'].toDouble();
      final minValue = json['min']?.toDouble() ?? 0.0;
      percentage = ((value - minValue) / (maxValue - minValue)) * 100;
    }

    // Extract size from layout or direct property
    if (layout['width'] != null && layout['height'] != null) {
      size = [
        layout['width'].toDouble(),
        layout['height'].toDouble() * 2,
      ].reduce((a, b) => a < b ? a : b);
    } else if (json['size'] != null) {
      size = json['size'].toDouble();
    }

    // Extract hollow radius
    if (json['hollowRadius'] != null) {
      hollowRadius = json['hollowRadius'].toDouble();
    } else if (mergedStyle['gauge']?['hole'] != null) {
      hollowRadius = mergedStyle['gauge']['hole'].toDouble();
    }

    return HollowSemiCircleChartJsonConfig(
      percentage: percentage.clamp(0.0, 100.0),
      size: size,
      hollowRadius: hollowRadius.clamp(0.0, 1.0),
      style: mergedStyle,
    );
  }

  /// Creates a [HollowSemiCircleChartJsonConfig] from a JSON string.
  factory HollowSemiCircleChartJsonConfig.fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return HollowSemiCircleChartJsonConfig.fromJson(json);
  }

  /// Converts the configuration to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'percentage': percentage,
      'size': size,
      'hollowRadius': hollowRadius,
      'style': style,
    };
  }

  /// Converts the configuration to a JSON string.
  String toJsonString() {
    return jsonEncode(toJson());
  }

  /// Converts the JSON configuration to Flutter style.
  ChartStyle getChartStyle() {
    return ChartStyle.fromJson(style);
  }
}
