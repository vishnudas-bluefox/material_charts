import 'package:flutter/material.dart';
import 'dart:convert';

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

  /// Creates a [PieChartData] instance from a JSON map.
  /// Supports both simple and Plotly-compatible formats.
  factory PieChartData.fromJson(Map<String, dynamic> json) {
    return PieChartData(
      value: (json['value'] ?? json['y'] ?? 0.0).toDouble(),
      label: json['label'] ?? json['x'] ?? '',
      color: json['color'] != null ? parseColor(json['color']) : null,
    );
  }

  /// Converts the [PieChartData] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'label': label,
      'color': color != null ? colorToHex(color!) : null,
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

  /// The position of the chart legend
  final PieChartLegendPosition legendPosition;

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
    this.animationDuration = const Duration(
      milliseconds: 1500,
    ), // Default animation duration
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
    this.legendPosition = PieChartLegendPosition.right,
  });

  /// Creates a [PieChartStyle] instance from a JSON map.
  /// Supports both simple and Plotly-compatible formats.
  factory PieChartStyle.fromJson(Map<String, dynamic> json) {
    return PieChartStyle(
      defaultColors: _parseColorsList(json['defaultColors']),
      backgroundColor: json['backgroundColor'] != null
          ? PieChartData.parseColor(json['backgroundColor'])
          : json['plot_bgcolor'] != null
              ? PieChartData.parseColor(json['plot_bgcolor'])
              : json['paper_bgcolor'] != null
                  ? PieChartData.parseColor(json['paper_bgcolor'])
                  : Colors.white,
      labelStyle: _parseTextStyle(json['labelStyle'] ?? json['font']),
      valueStyle: _parseTextStyle(json['valueStyle'] ?? json['textfont']),
      startAngle: (json['startAngle'] ?? json['rotation'] ?? -90).toDouble(),
      holeRadius: (json['holeRadius'] ?? json['hole'] ?? 0).toDouble(),
      animationDuration: Duration(
        milliseconds: (json['animationDuration'] ??
                json['animation']?['duration'] ??
                1500)
            .toInt(),
      ),
      animationCurve: _parseCurve(
        json['animationCurve'] ?? json['animation']?['curve'] ?? 'easeInOut',
      ),
      showLabels: json['showLabels'] ??
          json['textinfo']?.contains('label') ??
          json['textposition'] != 'none' ??
          true,
      showValues: json['showValues'] ??
          json['textinfo']?.contains('percent') ??
          json['textinfo']?.contains('value') ??
          true,
      labelOffset: (json['labelOffset'] ?? 20).toDouble(),
      showLegend: json['showLegend'] ?? json['showlegend'] ?? true,
      legendPadding: _parsePadding(json['legendPadding']),
      labelPosition: _parseLabelPosition(
        json['labelPosition'] ?? json['textposition'] ?? 'outside',
      ),
      showConnectorLines: json['showConnectorLines'] ?? true,
      connectorLineColor: json['connectorLineColor'] != null
          ? PieChartData.parseColor(json['connectorLineColor'])
          : Colors.black54,
      connectorLineStrokeWidth:
          (json['connectorLineStrokeWidth'] ?? 1.0).toDouble(),
      chartAlignment: _parseChartAlignment(json['chartAlignment'] ?? 'center'),
      legendPosition: _parseLegendPosition(
        json['legendPosition'] ?? json['legend']?['orientation'] ?? 'v',
      ),
    );
  }

  /// Converts the [PieChartStyle] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'defaultColors':
          defaultColors.map((color) => PieChartData.colorToHex(color)).toList(),
      'backgroundColor': PieChartData.colorToHex(backgroundColor),
      'startAngle': startAngle,
      'holeRadius': holeRadius,
      'animationDuration': animationDuration.inMilliseconds,
      'animationCurve': _curveToString(animationCurve),
      'showLabels': showLabels,
      'showValues': showValues,
      'labelOffset': labelOffset,
      'showLegend': showLegend,
      'labelPosition': _labelPositionToString(labelPosition),
      'showConnectorLines': showConnectorLines,
      'connectorLineColor': PieChartData.colorToHex(connectorLineColor),
      'connectorLineStrokeWidth': connectorLineStrokeWidth,
      'chartAlignment': _chartAlignmentToString(chartAlignment),
      'legendPosition': _legendPositionToString(legendPosition),
    };
  }

  /// Helper method to parse colors list from JSON
  static List<Color> _parseColorsList(dynamic colorsList) {
    if (colorsList is List) {
      return colorsList.map((color) => PieChartData.parseColor(color)).toList();
    }
    return const [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
    ];
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

  /// Helper method to parse label position from string
  static LabelPosition _parseLabelPosition(String position) {
    switch (position.toLowerCase()) {
      case 'inside':
      case 'auto':
        return LabelPosition.inside;
      case 'outside':
      default:
        return LabelPosition.outside;
    }
  }

  /// Helper method to convert label position to string
  static String _labelPositionToString(LabelPosition position) {
    switch (position) {
      case LabelPosition.inside:
        return 'inside';
      case LabelPosition.outside:
        return 'outside';
    }
  }

  /// Helper method to parse chart alignment from string
  static ChartAlignment _parseChartAlignment(String alignment) {
    switch (alignment.toLowerCase()) {
      case 'topleft':
        return ChartAlignment.topLeft;
      case 'topcenter':
        return ChartAlignment.topCenter;
      case 'topright':
        return ChartAlignment.topRight;
      case 'centerleft':
        return ChartAlignment.centerLeft;
      case 'center':
        return ChartAlignment.center;
      case 'centerright':
        return ChartAlignment.centerRight;
      case 'bottomleft':
        return ChartAlignment.bottomLeft;
      case 'bottomcenter':
        return ChartAlignment.bottomCenter;
      case 'bottomright':
        return ChartAlignment.bottomRight;
      default:
        return ChartAlignment.center;
    }
  }

  /// Helper method to convert chart alignment to string
  static String _chartAlignmentToString(ChartAlignment alignment) {
    switch (alignment) {
      case ChartAlignment.topLeft:
        return 'topLeft';
      case ChartAlignment.topCenter:
        return 'topCenter';
      case ChartAlignment.topRight:
        return 'topRight';
      case ChartAlignment.centerLeft:
        return 'centerLeft';
      case ChartAlignment.center:
        return 'center';
      case ChartAlignment.centerRight:
        return 'centerRight';
      case ChartAlignment.bottomLeft:
        return 'bottomLeft';
      case ChartAlignment.bottomCenter:
        return 'bottomCenter';
      case ChartAlignment.bottomRight:
        return 'bottomRight';
    }
  }

  /// Helper method to parse legend position from string
  static PieChartLegendPosition _parseLegendPosition(String position) {
    switch (position.toLowerCase()) {
      case 'bottom':
      case 'h':
        return PieChartLegendPosition.bottom;
      case 'right':
      case 'v':
      default:
        return PieChartLegendPosition.right;
    }
  }

  /// Helper method to convert legend position to string
  static String _legendPositionToString(PieChartLegendPosition position) {
    switch (position) {
      case PieChartLegendPosition.bottom:
        return 'bottom';
      case PieChartLegendPosition.right:
        return 'right';
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
            ? PieChartData.parseColor(textStyle['color'])
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

  /// Helper method to parse padding from JSON
  static EdgeInsets _parsePadding(dynamic padding) {
    if (padding == null) return const EdgeInsets.all(16);

    if (padding is Map<String, dynamic>) {
      return EdgeInsets.only(
        left: (padding['left'] ?? padding['l'] ?? 16).toDouble(),
        top: (padding['top'] ?? padding['t'] ?? 16).toDouble(),
        right: (padding['right'] ?? padding['r'] ?? 16).toDouble(),
        bottom: (padding['bottom'] ?? padding['b'] ?? 16).toDouble(),
      );
    }

    return const EdgeInsets.all(16);
  }

  /// Creates a copy of this style with the given fields replaced with new values.
  PieChartStyle copyWith({
    List<Color>? defaultColors,
    Color? backgroundColor,
    TextStyle? labelStyle,
    TextStyle? valueStyle,
    double? startAngle,
    double? holeRadius,
    Duration? animationDuration,
    Curve? animationCurve,
    bool? showLabels,
    bool? showValues,
    double? labelOffset,
    bool? showLegend,
    EdgeInsets? legendPadding,
    LabelPosition? labelPosition,
    bool? showConnectorLines,
    Color? connectorLineColor,
    double? connectorLineStrokeWidth,
    ChartAlignment? chartAlignment,
    PieChartLegendPosition? legendPosition,
  }) {
    return PieChartStyle(
      defaultColors: defaultColors ?? this.defaultColors,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      labelStyle: labelStyle ?? this.labelStyle,
      valueStyle: valueStyle ?? this.valueStyle,
      startAngle: startAngle ?? this.startAngle,
      holeRadius: holeRadius ?? this.holeRadius,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      showLabels: showLabels ?? this.showLabels,
      showValues: showValues ?? this.showValues,
      labelOffset: labelOffset ?? this.labelOffset,
      showLegend: showLegend ?? this.showLegend,
      legendPadding: legendPadding ?? this.legendPadding,
      labelPosition: labelPosition ?? this.labelPosition,
      showConnectorLines: showConnectorLines ?? this.showConnectorLines,
      connectorLineColor: connectorLineColor ?? this.connectorLineColor,
      connectorLineStrokeWidth:
          connectorLineStrokeWidth ?? this.connectorLineStrokeWidth,
      chartAlignment: chartAlignment ?? this.chartAlignment,
      legendPosition: legendPosition ?? this.legendPosition,
    );
  }
}

/// Defines the possible positions for labels on the pie chart slices.
enum LabelPosition {
  inside, // Labels are inside the slices
  outside, // Labels are outside the slices
}

enum Vertical {
  center, // Graph is placed in the vertical center
  top, // Graph is placed in the top
  bottom, // Graph is placed in the bottom
}

enum Horizontal {
  center, // Graph is placed in the horizontal center
  left, // Graph is placed in the left
  right, // Graph is placed in the right
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

enum PieChartLegendPosition { right, bottom }

/// JSON configuration for pie charts with optional Plotly compatibility.
/// This class provides a bridge between JSON format and Flutter widgets.
class PieChartJsonConfig {
  /// The data points for the chart
  final List<Map<String, dynamic>> data;

  /// The style configuration
  final Map<String, dynamic> style;

  /// Chart dimensions
  final double width;
  final double height;

  /// Display options
  final bool showLegend;
  final EdgeInsets padding;
  final double minSizePercent;
  final bool interactive;
  final bool showLabelOnlyOnHover;
  final double chartRadius;
  final VoidCallback? onAnimationComplete;

  /// Creates a [PieChartJsonConfig] instance.
  const PieChartJsonConfig({
    required this.data,
    required this.style,
    required this.width,
    required this.height,
    this.showLegend = true,
    this.padding = const EdgeInsets.all(24),
    this.minSizePercent = 0.0,
    this.interactive = true,
    this.showLabelOnlyOnHover = false,
    this.chartRadius = double.maxFinite,
    this.onAnimationComplete,
  });

  /// Creates a [PieChartJsonConfig] from a JSON map.
  /// Supports both simple and Plotly-compatible formats.
  factory PieChartJsonConfig.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>? ?? [];
    final layout = json['layout'] ?? {};

    // Handle Plotly format: data is an array with values and labels arrays
    List<Map<String, dynamic>> processedData = [];
    Map<String, dynamic> mergedStyle = Map<String, dynamic>.from(layout);

    if (data.isNotEmpty && data[0] is Map<String, dynamic>) {
      final firstDataItem = data[0] as Map<String, dynamic>;

      // Check if this is Plotly format (has values and labels as arrays)
      if (firstDataItem['values'] is List && firstDataItem['labels'] is List) {
        final values = firstDataItem['values'] as List;
        final labels = firstDataItem['labels'] as List;
        final colors = firstDataItem['marker']?['colors'] as List?;

        // Merge trace properties into style for global properties
        if (firstDataItem['textinfo'] != null) {
          mergedStyle['textinfo'] = firstDataItem['textinfo'];
        }
        if (firstDataItem['textposition'] != null) {
          mergedStyle['textposition'] = firstDataItem['textposition'];
        }
        if (firstDataItem['rotation'] != null) {
          mergedStyle['rotation'] = firstDataItem['rotation'];
        }
        if (firstDataItem['hole'] != null) {
          mergedStyle['hole'] = firstDataItem['hole'];
        }
        if (firstDataItem['marker'] != null) {
          mergedStyle['marker'] = firstDataItem['marker'];
        }

        // Convert Plotly format to individual data objects
        for (int i = 0; i < values.length && i < labels.length; i++) {
          final dataPoint = <String, dynamic>{
            'value': values[i],
            'label': labels[i],
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

    return PieChartJsonConfig(
      data: processedData,
      style: mergedStyle,
      width: (layout['width'] ?? 600).toDouble(),
      height: (layout['height'] ?? 400).toDouble(),
      showLegend: layout['showLegend'] ?? layout['showlegend'] ?? true,
      padding: _parsePadding(layout['padding'] ?? layout['margin']),
      minSizePercent: (layout['minSizePercent'] ?? 0.0).toDouble(),
      interactive: layout['interactive'] ?? true,
      showLabelOnlyOnHover: layout['showLabelOnlyOnHover'] ?? false,
      chartRadius: (layout['chartRadius'] ?? double.maxFinite).toDouble(),
    );
  }

  /// Creates a [PieChartJsonConfig] from a JSON string.
  factory PieChartJsonConfig.fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return PieChartJsonConfig.fromJson(json);
  }

  /// Converts the configuration to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'style': {
        ...style,
        'width': width,
        'height': height,
        'showLegend': showLegend,
        'padding': _paddingToJson(padding),
        'minSizePercent': minSizePercent,
        'interactive': interactive,
        'showLabelOnlyOnHover': showLabelOnlyOnHover,
        'chartRadius': chartRadius,
      },
    };
  }

  /// Converts the configuration to a JSON string.
  String toJsonString() {
    return jsonEncode(toJson());
  }

  /// Converts the JSON configuration to Flutter models.
  List<PieChartData> getPieChartData() {
    return data.map((item) => PieChartData.fromJson(item)).toList();
  }

  /// Converts the JSON configuration to Flutter style.
  PieChartStyle getPieChartStyle() {
    return PieChartStyle.fromJson(style);
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
