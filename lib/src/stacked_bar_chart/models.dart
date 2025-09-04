import 'package:flutter/material.dart';
import 'dart:convert';

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

  /// Creates a [StackedBarSegment] from JSON data.
  /// Supports both simple and Plotly-compatible formats.
  factory StackedBarSegment.fromJson(
    Map<String, dynamic> json, {
    Color? defaultColor,
  }) {
    return StackedBarSegment(
      value: (json['y'] ?? json['value'] ?? 0.0).toDouble(),
      label: json['name'] ?? json['label'],
      color: json['color'] != null
          ? _parseColor(json['color'])
          : json['marker']?['color'] != null
              ? _parseColor(json['marker']['color'])
              : defaultColor ?? Colors.blue,
    );
  }

  /// Converts the segment to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'color': _colorToHex(color),
      if (label != null) 'label': label,
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
      }
    }
    return Colors.blue; // Default fallback
  }

  /// Helper method to convert Color to hex string
  static String _colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).padLeft(8, '0')}';
  }
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
  const StackedBarData({required this.label, required this.segments});

  /// Computes the total value by summing all segment values in the bar.
  ///
  /// This value is used to determine the relative size of segments in the bar.
  double get totalValue =>
      segments.fold(0, (sum, segment) => sum + segment.value);

  /// Creates [StackedBarData] from JSON.
  /// Supports both simple format and Plotly trace format.
  factory StackedBarData.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('segments')) {
      // Simple format: direct segments array
      final segmentsList = json['segments'] as List<dynamic>;
      return StackedBarData(
        label: json['label'] ?? '',
        segments: segmentsList
            .map(
              (s) => StackedBarSegment.fromJson(s as Map<String, dynamic>),
            )
            .toList(),
      );
    } else {
      // Single segment format
      return StackedBarData(
        label: json['x'] ?? json['label'] ?? '',
        segments: [StackedBarSegment.fromJson(json)],
      );
    }
  }

  /// Converts to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'segments': segments.map((s) => s.toJson()).toList(),
    };
  }
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

  /// Creates [YAxisConfig] from JSON data (Plotly yaxis format).
  factory YAxisConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const YAxisConfig();

    return YAxisConfig(
      minValue: json['range']?[0]?.toDouble(),
      maxValue: json['range']?[1]?.toDouble(),
      divisions: json['nticks'] ?? json['dtick'] ?? 5,
      showAxisLine: json['showline'] ?? true,
      showGridLines: json['showgrid'] ?? true,
      labelStyle: _parseTextStyle(json['tickfont']),
      axisWidth: (json['tickwidth'] ?? 50.0).toDouble(),
      labelFormatter: json['tickformat'] != null
          ? (value) => value.toStringAsFixed(
                json['tickformat'].contains('.') ? 1 : 0,
              )
          : null,
    );
  }

  /// Converts to JSON format.
  Map<String, dynamic> toJson() {
    return {
      if (minValue != null && maxValue != null) 'range': [minValue, maxValue],
      'nticks': divisions,
      'showline': showAxisLine,
      'showgrid': showGridLines,
      if (labelStyle != null) 'tickfont': _textStyleToJson(labelStyle!),
      'tickwidth': axisWidth,
    };
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
            ? StackedBarSegment._parseColor(textStyle['color'])
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

  /// Helper method to convert text style to JSON
  static Map<String, dynamic> _textStyleToJson(TextStyle style) {
    return {
      if (style.fontSize != null) 'size': style.fontSize,
      if (style.fontWeight != null)
        'weight': _fontWeightToString(style.fontWeight!),
      if (style.color != null)
        'color': StackedBarSegment._colorToHex(style.color!),
    };
  }

  /// Helper method to convert font weight to string
  static String _fontWeightToString(FontWeight weight) {
    switch (weight) {
      case FontWeight.w100:
        return 'w100';
      case FontWeight.w200:
        return 'w200';
      case FontWeight.w300:
        return 'w300';
      case FontWeight.w400:
        return 'w400';
      case FontWeight.w500:
        return 'w500';
      case FontWeight.w600:
        return 'w600';
      case FontWeight.w700:
        return 'w700';
      case FontWeight.w800:
        return 'w800';
      case FontWeight.w900:
        return 'w900';
      default:
        return 'normal';
    }
  }
}

/// Configuration class for customizing the appearance of the stacked bar chart.
///
/// This class controls styling options such as colors, bar spacing, animations,
/// and optional Y-axis configurations with full Plotly JSON support.
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

  /// Creates [StackedBarChartStyle] from JSON (Plotly layout format).
  factory StackedBarChartStyle.fromJson(Map<String, dynamic> json) {
    return StackedBarChartStyle(
      gridColor: json['gridcolor'] != null
          ? StackedBarSegment._parseColor(json['gridcolor'])
          : json['xaxis']?['gridcolor'] != null
              ? StackedBarSegment._parseColor(json['xaxis']['gridcolor'])
              : json['yaxis']?['gridcolor'] != null
                  ? StackedBarSegment._parseColor(json['yaxis']['gridcolor'])
                  : Colors.grey,
      backgroundColor: json['plot_bgcolor'] != null
          ? StackedBarSegment._parseColor(json['plot_bgcolor'])
          : json['paper_bgcolor'] != null
              ? StackedBarSegment._parseColor(json['paper_bgcolor'])
              : Colors.white,
      labelStyle: YAxisConfig._parseTextStyle(
        json['font'] ?? json['xaxis']?['tickfont'],
      ),
      valueStyle: YAxisConfig._parseTextStyle(
        json['valueStyle'] ?? json['font'] ?? json['annotations']?[0]?['font'],
      ),
      barSpacing: (json['bargap'] ?? 0.2).toDouble(),
      cornerRadius: (json['shapes']?[0]?['cornerradius'] ?? 4.0).toDouble(),
      animationDuration: Duration(
        milliseconds: (json['transition']?['duration'] ?? 1500).toInt(),
      ),
      animationCurve: _parseCurve(
        json['transition']?['easing'] ?? 'cubic-in-out',
      ),
      yAxisConfig: YAxisConfig.fromJson(json['yaxis']),
    );
  }

  /// Converts to JSON format (Plotly layout format).
  Map<String, dynamic> toJson() {
    return {
      'plot_bgcolor': StackedBarSegment._colorToHex(backgroundColor),
      'paper_bgcolor': StackedBarSegment._colorToHex(backgroundColor),
      'bargap': barSpacing,
      'transition': {
        'duration': animationDuration.inMilliseconds,
        'easing': _curveToString(animationCurve),
      },
      if (yAxisConfig != null) 'yaxis': yAxisConfig!.toJson(),
      'xaxis': {'gridcolor': StackedBarSegment._colorToHex(gridColor)},
      'yaxis': {
        ...?yAxisConfig?.toJson(),
        'gridcolor': StackedBarSegment._colorToHex(gridColor),
      },
    };
  }

  /// Helper method to parse animation curve from string
  static Curve _parseCurve(String curveName) {
    switch (curveName.toLowerCase()) {
      case 'linear':
        return Curves.linear;
      case 'ease-in':
      case 'easein':
        return Curves.easeIn;
      case 'ease-out':
      case 'easeout':
        return Curves.easeOut;
      case 'ease-in-out':
      case 'easeinout':
        return Curves.easeInOut;
      case 'bounce-in':
      case 'bouncein':
        return Curves.bounceIn;
      case 'bounce-out':
      case 'bounceout':
        return Curves.bounceOut;
      case 'cubic-in-out':
        return Curves.easeInOut;
      default:
        return Curves.easeInOut;
    }
  }

  /// Helper method to convert curve to string
  static String _curveToString(Curve curve) {
    if (curve == Curves.linear) return 'linear';
    if (curve == Curves.easeIn) return 'ease-in';
    if (curve == Curves.easeOut) return 'ease-out';
    if (curve == Curves.easeInOut) return 'ease-in-out';
    if (curve == Curves.bounceIn) return 'bounce-in';
    if (curve == Curves.bounceOut) return 'bounce-out';
    return 'ease-in-out';
  }
}

/// JSON configuration class for stacked bar charts with full Plotly compatibility.
/// This class provides a bridge between Plotly JSON format and Flutter widgets.
/// Handles all JSON validation and parsing like the regular bar chart.
class StackedBarChartJsonConfig {
  /// The data points for the chart (Plotly traces or simple format)
  final List<Map<String, dynamic>> data;

  /// The style/layout configuration
  final Map<String, dynamic> style;

  /// Chart configuration options
  final Map<String, dynamic> config;

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

  /// Creates a [StackedBarChartJsonConfig] instance.
  const StackedBarChartJsonConfig({
    required this.data,
    required this.style,
    this.config = const {},
    required this.width,
    required this.height,
    this.showGrid = true,
    this.showValues = true,
    this.padding = const EdgeInsets.all(24),
    this.horizontalGridLines = 5,
    this.interactive = true,
    this.onAnimationComplete,
  });

  /// Creates [StackedBarChartJsonConfig] from JSON configuration.
  /// Supports both simple and Plotly-compatible formats with comprehensive validation.
  factory StackedBarChartJsonConfig.fromJson(Map<String, dynamic> json) {
    try {
      // Validate input
      if (json.isEmpty) {
        throw ArgumentError('JSON configuration cannot be empty');
      }

      // Determine format type and extract data
      List<Map<String, dynamic>> processedData = [];
      Map<String, dynamic> layoutConfig = {};

      if (_isPlotlyFormat(json)) {
        // Handle Plotly format
        final plotlyData = json['data'] as List<dynamic>? ?? [];
        layoutConfig = json['layout'] as Map<String, dynamic>? ?? {};

        _validatePlotlyData(plotlyData);
        processedData = _processPlotlyData(plotlyData);
      } else if (_isSimpleStackedFormat(json)) {
        // Handle simple stacked format
        final simpleData = json['data'] as List<dynamic>? ?? [];
        layoutConfig = json['style'] as Map<String, dynamic>? ??
            json['layout'] as Map<String, dynamic>? ??
            {};

        _validateSimpleData(simpleData);
        processedData = _processSimpleData(simpleData);
      } else {
        throw ArgumentError(
          'Unsupported JSON format. Expected Plotly format with data/layout or simple format with data/style',
        );
      }

      return StackedBarChartJsonConfig(
        data: processedData,
        style: layoutConfig,
        config: json['config'] as Map<String, dynamic>? ?? {},
        width: _extractWidth(layoutConfig, json),
        height: _extractHeight(layoutConfig, json),
        showGrid: _extractShowGrid(layoutConfig, json),
        showValues: _extractShowValues(layoutConfig, json),
        padding: _extractPadding(layoutConfig, json),
        horizontalGridLines: _extractHorizontalGridLines(layoutConfig, json),
        interactive: _extractInteractive(layoutConfig, json),
      );
    } catch (e) {
      throw ArgumentError('Failed to parse JSON configuration: $e');
    }
  }

  /// Creates from JSON string with validation.
  factory StackedBarChartJsonConfig.fromJsonString(String jsonString) {
    try {
      if (jsonString.trim().isEmpty) {
        throw ArgumentError('JSON string cannot be empty');
      }

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return StackedBarChartJsonConfig.fromJson(json);
    } catch (e) {
      throw ArgumentError('Failed to parse JSON string: $e');
    }
  }

  /// Converts to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'layout': {
        ...style,
        'width': width,
        'height': height,
        'margin': _paddingToPlotlyMargin(padding),
      },
      'config': {...config, 'displayModeBar': interactive},
    };
  }

  /// Converts to JSON string.
  String toJsonString() {
    return jsonEncode(toJson());
  }

  /// Validation: Check if JSON follows Plotly format
  static bool _isPlotlyFormat(Map<String, dynamic> json) {
    if (!json.containsKey('data') || json['data'] is! List) return false;

    final data = json['data'] as List;
    if (data.isEmpty) return false;

    final firstItem = data[0];
    if (firstItem is! Map<String, dynamic>) return false;

    // Check for Plotly-specific properties
    return firstItem.containsKey('x') && firstItem.containsKey('y');
  }

  /// Validation: Check if JSON follows simple stacked format
  static bool _isSimpleStackedFormat(Map<String, dynamic> json) {
    if (!json.containsKey('data') || json['data'] is! List) return false;

    final data = json['data'] as List;
    if (data.isEmpty) return false;

    final firstItem = data[0];
    if (firstItem is! Map<String, dynamic>) return false;

    return firstItem.containsKey('label') || firstItem.containsKey('segments');
  }

  /// Validation: Validate Plotly data structure
  static void _validatePlotlyData(List<dynamic> data) {
    if (data.isEmpty) {
      throw ArgumentError('Plotly data cannot be empty');
    }

    for (int i = 0; i < data.length; i++) {
      final trace = data[i];
      if (trace is! Map<String, dynamic>) {
        throw ArgumentError('Plotly trace $i must be a Map');
      }

      final traceMap = trace;

      if (!traceMap.containsKey('x') || !traceMap.containsKey('y')) {
        throw ArgumentError('Plotly trace $i must contain x and y arrays');
      }

      final x = traceMap['x'] as List;
      final y = traceMap['y'] as List;

      if (x.isEmpty || y.isEmpty) {
        throw ArgumentError('Plotly trace $i x and y arrays cannot be empty');
      }

      if (x.length != y.length) {
        throw ArgumentError(
          'Plotly trace $i x and y arrays must have the same length',
        );
      }
    }
  }

  /// Validation: Validate simple data structure
  static void _validateSimpleData(List<dynamic> data) {
    if (data.isEmpty) {
      throw ArgumentError('Simple data cannot be empty');
    }

    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      if (item is! Map<String, dynamic>) {
        throw ArgumentError('Simple data item $i must be a Map');
      }

      final itemMap = item;

      if (!itemMap.containsKey('label') && !itemMap.containsKey('segments')) {
        throw ArgumentError(
          'Simple data item $i must contain label and/or segments',
        );
      }

      if (itemMap.containsKey('segments')) {
        final segments = itemMap['segments'];
        if (segments is! List || segments.isEmpty) {
          throw ArgumentError(
            'Simple data item $i segments must be a non-empty array',
          );
        }
      }
    }
  }

  /// Process Plotly data into internal format
  static List<Map<String, dynamic>> _processPlotlyData(
    List<dynamic> plotlyData,
  ) {
    final Map<String, List<Map<String, dynamic>>> categoryTraces = {};

    // Group traces by category (x values)
    for (final trace in plotlyData) {
      final traceMap = trace as Map<String, dynamic>;
      final xValues = traceMap['x'] as List;
      final yValues = traceMap['y'] as List;
      final traceName = traceMap['name'] ?? 'Series';
      final color = _extractTraceColor(traceMap);

      for (int i = 0; i < xValues.length && i < yValues.length; i++) {
        final category = xValues[i].toString();
        final value = (yValues[i] ?? 0.0).toDouble();

        categoryTraces[category] ??= [];
        categoryTraces[category]!.add({
          'value': value,
          'color': color,
          'label': traceName,
        });
      }
    }

    // Convert to expected format
    return categoryTraces.entries
        .map(
          (entry) => {
            'x': entry.key,
            'label': entry.key,
            'segments': entry.value,
            'totalValue': entry.value.fold<double>(
              0,
              (sum, segment) => sum + (segment['value'] as double),
            ),
          },
        )
        .toList();
  }

  /// Process simple data into internal format
  static List<Map<String, dynamic>> _processSimpleData(
    List<dynamic> simpleData,
  ) {
    return simpleData.cast<Map<String, dynamic>>().map((item) {
      final segments = item['segments'] as List<dynamic>? ?? [];
      final processedSegments = segments.map((segment) {
        final segmentMap = segment as Map<String, dynamic>;
        return {
          'value': (segmentMap['value'] ?? 0.0).toDouble(),
          'color': segmentMap['color'] ?? '#1f77b4',
          'label': segmentMap['label'] ?? segmentMap['name'],
        };
      }).toList();

      return {
        'label': item['label'] ?? item['x'] ?? '',
        'segments': processedSegments,
        'totalValue': processedSegments.fold<double>(
          0,
          (sum, segment) => sum + (segment['value'] as double),
        ),
      };
    }).toList();
  }

  /// Extract trace color from various formats
  static String _extractTraceColor(Map<String, dynamic> trace) {
    if (trace['marker']?['color'] != null) {
      return trace['marker']['color'].toString();
    }
    if (trace['color'] != null) {
      return trace['color'].toString();
    }
    return '#1f77b4'; // Default blue
  }

  /// Extract chart width from configuration
  static double _extractWidth(
    Map<String, dynamic> layout,
    Map<String, dynamic> root,
  ) {
    return (layout['width'] ?? root['width'] ?? 800).toDouble();
  }

  /// Extract chart height from configuration
  static double _extractHeight(
    Map<String, dynamic> layout,
    Map<String, dynamic> root,
  ) {
    return (layout['height'] ?? root['height'] ?? 400).toDouble();
  }

  /// Extract showGrid setting from configuration
  static bool _extractShowGrid(
    Map<String, dynamic> layout,
    Map<String, dynamic> root,
  ) {
    return layout['xaxis']?['showgrid'] ??
        layout['yaxis']?['showgrid'] ??
        layout['showGrid'] ??
        root['showGrid'] ??
        true;
  }

  /// Extract showValues setting from configuration
  static bool _extractShowValues(
    Map<String, dynamic> layout,
    Map<String, dynamic> root,
  ) {
    return layout['showValues'] ??
        root['showValues'] ??
        (layout['annotations'] != null &&
            (layout['annotations'] as List).isNotEmpty) ??
        true;
  }

  /// Extract padding from configuration
  static EdgeInsets _extractPadding(
    Map<String, dynamic> layout,
    Map<String, dynamic> root,
  ) {
    final margin = layout['margin'] ??
        root['margin'] ??
        layout['padding'] ??
        root['padding'];
    return _parsePadding(margin);
  }

  /// Extract horizontal grid lines count
  static int _extractHorizontalGridLines(
    Map<String, dynamic> layout,
    Map<String, dynamic> root,
  ) {
    return layout['yaxis']?['nticks'] ??
        layout['horizontalGridLines'] ??
        root['horizontalGridLines'] ??
        5;
  }

  /// Extract interactive setting
  static bool _extractInteractive(
    Map<String, dynamic> layout,
    Map<String, dynamic> root,
  ) {
    final config = root['config'] as Map<String, dynamic>? ?? {};
    return config['displayModeBar'] ??
        layout['interactive'] ??
        root['interactive'] ??
        true;
  }

  /// Converts processed data to Flutter stacked bar data.
  List<StackedBarData> getStackedBarData() {
    try {
      if (data.isEmpty) {
        return [];
      }

      return data.map((item) {
        final label = item['label']?.toString() ?? '';
        final segments = item['segments'] as List<dynamic>? ?? [];

        final stackedSegments = segments.map((segment) {
          final segmentMap = segment as Map<String, dynamic>;
          return StackedBarSegment(
            value: (segmentMap['value'] ?? 0.0).toDouble(),
            color: StackedBarSegment._parseColor(
              segmentMap['color'] ?? '#1f77b4',
            ),
            label: segmentMap['label']?.toString(),
          );
        }).toList();

        return StackedBarData(label: label, segments: stackedSegments);
      }).toList();
    } catch (e) {
      throw ArgumentError('Failed to convert data to StackedBarData: $e');
    }
  }

  /// Gets the chart style from configuration.
  StackedBarChartStyle getStackedBarChartStyle() {
    try {
      return StackedBarChartStyle.fromJson(style);
    } catch (e) {
      // Return default style if parsing fails
      return const StackedBarChartStyle();
    }
  }

  /// Helper method to parse padding from Plotly margin format
  static EdgeInsets _parsePadding(dynamic margin) {
    if (margin == null) return const EdgeInsets.all(24);

    if (margin is Map<String, dynamic>) {
      return EdgeInsets.only(
        left: (margin['l'] ?? 24).toDouble(),
        top: (margin['t'] ?? 24).toDouble(),
        right: (margin['r'] ?? 24).toDouble(),
        bottom: (margin['b'] ?? 24).toDouble(),
      );
    }

    return const EdgeInsets.all(24);
  }

  /// Helper method to convert padding to Plotly margin format
  static Map<String, dynamic> _paddingToPlotlyMargin(EdgeInsets padding) {
    return {
      'l': padding.left,
      't': padding.top,
      'r': padding.right,
      'b': padding.bottom,
    };
  }
}
