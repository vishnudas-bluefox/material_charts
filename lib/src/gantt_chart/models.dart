import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
}
