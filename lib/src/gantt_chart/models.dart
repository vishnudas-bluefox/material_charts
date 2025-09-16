import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

/// Exception thrown when Gantt chart data is invalid.
class GanttChartException implements Exception {
  final String message;

  /// Creates a new instance of [GanttChartException].
  GanttChartException(this.message);

  @override
  String toString() => 'GanttChartException: $message';
}

/// Model class for Gantt chart data points.
class GanttData {
  /// The start date of the Gantt chart task.
  final DateTime startDate;

  /// The end date of the Gantt chart task.
  final DateTime endDate;

  /// The label or name of the Gantt chart task.
  final String label;

  /// An optional description of the task.
  final String? description;

  /// An optional color for the task representation in the chart.
  final Color? color;

  /// An optional icon to visually represent the task.
  final IconData? icon;

  /// An optional content to display when the task is tapped.
  final String? tapContent;

  /// Creates a new instance of [GanttData].
  ///
  /// Throws a [GanttChartException] if the end date is before the start date.
  GanttData({
    required this.startDate,
    required this.endDate,
    required this.label,
    this.description,
    this.color,
    this.icon,
    this.tapContent,
  }) {
    if (endDate.isBefore(startDate)) {
      throw GanttChartException(
        'End date ($endDate) cannot be before start date ($startDate)',
      );
    }
  }

  /// Creates a [GanttData] instance from a JSON map.
  /// Supports both simple and Plotly-compatible formats.
  factory GanttData.fromJson(Map<String, dynamic> json) {
    // Handle different date formats and field names
    DateTime parseDate(dynamic dateValue) {
      if (dateValue is String) {
        // Try different date formats
        final dateFormats = [
          DateFormat('yyyy-MM-dd'),
          DateFormat('yyyy-MM-ddTHH:mm:ss'),
          DateFormat('yyyy-MM-dd HH:mm:ss'),
          DateFormat('MM/dd/yyyy'),
          DateFormat('dd/MM/yyyy'),
          DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ'),
        ];

        for (final format in dateFormats) {
          try {
            return format.parse(dateValue);
          } catch (e) {
            continue;
          }
        }

        // If all formats fail, try DateTime.parse
        try {
          return DateTime.parse(dateValue);
        } catch (e) {
          throw GanttChartException('Invalid date format: $dateValue');
        }
      } else if (dateValue is DateTime) {
        return dateValue;
      } else {
        throw GanttChartException(
          'Invalid date type: ${dateValue.runtimeType}',
        );
      }
    }

    Color? parseColor(dynamic colorValue) {
      if (colorValue == null) return null;

      if (colorValue is String) {
        if (colorValue.startsWith('#')) {
          return Color(int.parse(colorValue.replaceFirst('#', '0xFF')));
        } else if (colorValue.startsWith('rgb(')) {
          final rgb = colorValue.replaceAll('rgb(', '').replaceAll(')', '');
          final parts = rgb.split(',').map((e) => int.parse(e.trim())).toList();
          return Color.fromRGBO(parts[0], parts[1], parts[2], 1.0);
        } else if (colorValue.startsWith('rgba(')) {
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
      return null;
    }

    // Support multiple field name variations (Plotly compatibility)
    final startDate = parseDate(
      json['startDate'] ??
          json['start'] ??
          json['Start'] ??
          json['x'] ??
          json['start_date'],
    );

    final endDate = parseDate(
      json['endDate'] ??
          json['end'] ??
          json['Finish'] ??
          json['finish'] ??
          json['end_date'],
    );

    final label = json['label'] ??
        json['name'] ??
        json['Task'] ??
        json['task'] ??
        json['y'] ??
        json['title'] ??
        'Task';

    return GanttData(
      startDate: startDate,
      endDate: endDate,
      label: label,
      description: json['description'] ??
          json['text'] ??
          json['hover_text'] ??
          json['Resource'] ??
          json['resource'],
      color: parseColor(json['color'] ?? json['marker']?['color']),
      tapContent: json['tapContent'] ?? json['hover_text'],
    );
  }

  /// Converts the [GanttData] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'label': label,
      'description': description,
      'color': color != null ? _colorToHex(color!) : null,
      'tapContent': tapContent,
    };
  }

  /// Helper method to convert Color to hex string
  static String _colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
  }
}

/// Configuration class for Gantt chart styling.
class GanttChartStyle {
  /// The color of the lines representing tasks in the Gantt chart.
  final Color lineColor;

  /// The color of the points representing the start and end of tasks.
  final Color pointColor;

  /// The color of the lines connecting tasks.
  final Color connectionLineColor;

  /// The background color of the Gantt chart.
  final Color backgroundColor;

  /// The text style for task labels.
  final TextStyle? labelStyle;

  /// The text style for dates displayed in the chart.
  final TextStyle? dateStyle;

  /// The text style for task descriptions.
  final TextStyle? descriptionStyle;

  /// The width of the task lines.
  final double lineWidth;

  /// The radius of the points at the start and end of tasks.
  final double pointRadius;

  /// The width of the connection lines between tasks.
  final double connectionLineWidth;

  /// The duration of the animation for chart rendering.
  final Duration animationDuration;

  /// The curve applied to the animation for a smooth effect.
  final Curve animationCurve;

  /// A flag indicating whether to show connection lines between tasks.
  final bool showConnections;

  /// Optional date format for displaying task dates.
  final DateFormat? dateFormat;

  /// The vertical spacing between tasks in the Gantt chart.
  final double verticalSpacing;

  /// The horizontal padding around the Gantt chart.
  final double horizontalPadding;

  /// The offset for the task labels from their respective lines.
  final double labelOffset;

  /// The vertical offset for the timeline of the Gantt chart.
  final double timelineYOffset;

  /// Creates a new instance of [GanttChartStyle] with default values.
  const GanttChartStyle({
    this.lineColor = Colors.blue,
    this.pointColor = Colors.blue,
    this.connectionLineColor = Colors.grey,
    this.backgroundColor = Colors.white,
    this.labelStyle,
    this.dateStyle,
    this.descriptionStyle,
    this.lineWidth = 2.0,
    this.pointRadius = 4.0,
    this.connectionLineWidth = 1.0,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.animationCurve = Curves.easeInOut,
    this.showConnections = true,
    this.dateFormat,
    this.verticalSpacing = 120.0,
    this.horizontalPadding = 32.0,
    this.labelOffset = 25.0,
    this.timelineYOffset = 60.0,
  });

  /// Creates a [GanttChartStyle] instance from a JSON map.
  /// Supports both simple and Plotly-compatible formats.
  factory GanttChartStyle.fromJson(Map<String, dynamic> json) {
    Color parseColor(dynamic colorValue, Color defaultColor) {
      if (colorValue == null) return defaultColor;

      if (colorValue is String) {
        if (colorValue.startsWith('#')) {
          return Color(int.parse(colorValue.replaceFirst('#', '0xFF')));
        } else if (colorValue.startsWith('rgb(')) {
          final rgb = colorValue.replaceAll('rgb(', '').replaceAll(')', '');
          final parts = rgb.split(',').map((e) => int.parse(e.trim())).toList();
          return Color.fromRGBO(parts[0], parts[1], parts[2], 1.0);
        }
      }
      return defaultColor;
    }

    TextStyle? parseTextStyle(dynamic textStyle) {
      if (textStyle == null) return null;

      if (textStyle is Map<String, dynamic>) {
        return TextStyle(
          fontSize:
              (textStyle['size'] ?? textStyle['fontSize'] ?? 12).toDouble(),
          fontWeight: _parseFontWeight(
            textStyle['weight'] ?? textStyle['fontWeight'],
          ),
          color: parseColor(textStyle['color'], Colors.black),
        );
      }
      return null;
    }

    Curve parseCurve(String curveName) {
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

    return GanttChartStyle(
      lineColor: parseColor(
        json['lineColor'] ?? json['line']?['color'],
        Colors.blue,
      ),
      pointColor: parseColor(
        json['pointColor'] ?? json['marker']?['color'],
        Colors.blue,
      ),
      connectionLineColor: parseColor(
        json['connectionLineColor'] ?? json['connector']?['line']?['color'],
        Colors.grey,
      ),
      backgroundColor: parseColor(
        json['backgroundColor'] ??
            json['plot_bgcolor'] ??
            json['paper_bgcolor'],
        Colors.white,
      ),
      labelStyle: parseTextStyle(json['labelStyle'] ?? json['font']),
      dateStyle: parseTextStyle(
        json['dateStyle'] ?? json['xaxis']?['tickfont'],
      ),
      descriptionStyle: parseTextStyle(json['descriptionStyle']),
      lineWidth:
          (json['lineWidth'] ?? json['line']?['width'] ?? 2.0).toDouble(),
      pointRadius:
          (json['pointRadius'] ?? json['marker']?['size'] ?? 4.0).toDouble(),
      connectionLineWidth: (json['connectionLineWidth'] ?? 1.0).toDouble(),
      animationDuration: Duration(
        milliseconds: (json['animationDuration'] ??
                json['transition']?['duration'] ??
                1500)
            .toInt(),
      ),
      animationCurve: parseCurve(
        json['animationCurve'] ?? json['transition']?['easing'] ?? 'easeInOut',
      ),
      showConnections: json['showConnections'] ?? true,
      dateFormat:
          json['dateFormat'] != null ? DateFormat(json['dateFormat']) : null,
      verticalSpacing: (json['verticalSpacing'] ?? 120.0).toDouble(),
      horizontalPadding: (json['horizontalPadding'] ?? 32.0).toDouble(),
      labelOffset: (json['labelOffset'] ?? 25.0).toDouble(),
      timelineYOffset: (json['timelineYOffset'] ?? 60.0).toDouble(),
    );
  }

  /// Converts the [GanttChartStyle] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'lineColor': GanttData._colorToHex(lineColor),
      'pointColor': GanttData._colorToHex(pointColor),
      'connectionLineColor': GanttData._colorToHex(connectionLineColor),
      'backgroundColor': GanttData._colorToHex(backgroundColor),
      'lineWidth': lineWidth,
      'pointRadius': pointRadius,
      'connectionLineWidth': connectionLineWidth,
      'animationDuration': animationDuration.inMilliseconds,
      'animationCurve': _curveToString(animationCurve),
      'showConnections': showConnections,
      'dateFormat': dateFormat?.pattern,
      'verticalSpacing': verticalSpacing,
      'horizontalPadding': horizontalPadding,
      'labelOffset': labelOffset,
      'timelineYOffset': timelineYOffset,
    };
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

  /// Creates a copy of this style with the given fields replaced with new values.
  GanttChartStyle copyWith({
    Color? lineColor,
    Color? pointColor,
    Color? connectionLineColor,
    Color? backgroundColor,
    TextStyle? labelStyle,
    TextStyle? dateStyle,
    TextStyle? descriptionStyle,
    double? lineWidth,
    double? pointRadius,
    double? connectionLineWidth,
    Duration? animationDuration,
    Curve? animationCurve,
    bool? showConnections,
    DateFormat? dateFormat,
    double? verticalSpacing,
    double? horizontalPadding,
    double? labelOffset,
    double? timelineYOffset,
  }) {
    return GanttChartStyle(
      lineColor: lineColor ?? this.lineColor,
      pointColor: pointColor ?? this.pointColor,
      connectionLineColor: connectionLineColor ?? this.connectionLineColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      labelStyle: labelStyle ?? this.labelStyle,
      dateStyle: dateStyle ?? this.dateStyle,
      descriptionStyle: descriptionStyle ?? this.descriptionStyle,
      lineWidth: lineWidth ?? this.lineWidth,
      pointRadius: pointRadius ?? this.pointRadius,
      connectionLineWidth: connectionLineWidth ?? this.connectionLineWidth,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      showConnections: showConnections ?? this.showConnections,
      dateFormat: dateFormat ?? this.dateFormat,
      verticalSpacing: verticalSpacing ?? this.verticalSpacing,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      labelOffset: labelOffset ?? this.labelOffset,
      timelineYOffset: timelineYOffset ?? this.timelineYOffset,
    );
  }
}

/// JSON configuration for Gantt charts with optional Plotly compatibility.
/// This class provides a bridge between JSON format and Flutter widgets.
class GanttChartJsonConfig {
  /// The data points for the chart
  final List<Map<String, dynamic>> data;

  /// The style configuration
  final Map<String, dynamic> style;

  /// Chart dimensions
  final double width;
  final double height;

  /// Display options
  final bool interactive;
  final VoidCallback? onAnimationComplete;

  /// Creates a [GanttChartJsonConfig] instance.
  const GanttChartJsonConfig({
    required this.data,
    required this.style,
    required this.width,
    required this.height,
    this.interactive = true,
    this.onAnimationComplete,
  });

  /// Creates a [GanttChartJsonConfig] from a JSON map.
  /// Supports both simple and Plotly-compatible formats.
  factory GanttChartJsonConfig.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>? ?? [];
    final layout = json['layout'] ?? {};

    List<Map<String, dynamic>> processedData = [];

    if (data.isNotEmpty) {
      // Handle Plotly figure_factory format (list of task objects)
      if (data.first is Map<String, dynamic> &&
              (data.first as Map<String, dynamic>).containsKey('Task') ||
          (data.first as Map<String, dynamic>).containsKey('task')) {
        processedData = data.cast<Map<String, dynamic>>();
      }
      // Handle Plotly traces format (x and y arrays)
      else if (data.first is Map<String, dynamic>) {
        final trace = data.first as Map<String, dynamic>;
        if (trace['x'] is List && trace['y'] is List) {
          final xValues = trace['x'] as List;
          final yValues = trace['y'] as List;

          // Group x values by y values (tasks)
          final Map<String, List<DateTime>> taskDates = {};

          for (int i = 0; i < xValues.length && i < yValues.length; i++) {
            final taskName = yValues[i].toString();
            final date = DateTime.parse(xValues[i].toString());

            if (!taskDates.containsKey(taskName)) {
              taskDates[taskName] = [];
            }
            taskDates[taskName]!.add(date);
          }

          // Convert to GanttData format
          taskDates.forEach((taskName, dates) {
            if (dates.length >= 2) {
              dates.sort();
              processedData.add({
                'label': taskName,
                'startDate': dates.first.toIso8601String(),
                'endDate': dates.last.toIso8601String(),
                'color': trace['line']?['color'] ?? trace['marker']?['color'],
              });
            }
          });
        } else {
          // Handle regular format
          processedData = data.cast<Map<String, dynamic>>();
        }
      }
    }

    return GanttChartJsonConfig(
      data: processedData,
      style: layout,
      width: (layout['width'] ?? 800).toDouble(),
      height: (layout['height'] ?? 600).toDouble(),
      interactive: layout['interactive'] ?? true,
    );
  }

  /// Creates a [GanttChartJsonConfig] from a JSON string.
  factory GanttChartJsonConfig.fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return GanttChartJsonConfig.fromJson(json);
  }

  /// Converts the configuration to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'layout': {
        ...style,
        'width': width,
        'height': height,
        'interactive': interactive,
      },
    };
  }

  /// Converts the configuration to a JSON string.
  String toJsonString() {
    return jsonEncode(toJson());
  }

  /// Converts the JSON configuration to Flutter models.
  List<GanttData> getGanttChartData() {
    return data.map((item) => GanttData.fromJson(item)).toList();
  }

  /// Converts the JSON configuration to Flutter style.
  GanttChartStyle getGanttChartStyle() {
    return GanttChartStyle.fromJson(style);
  }
}
