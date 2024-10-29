import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


/// Exception thrown when Gantt chart data is invalid
class GanttChartException implements Exception {
  final String message;
  GanttChartException(this.message);

  @override
  String toString() => 'GanttChartException: $message';
}

/// Model class for Gantt chart data points
class GanttData {
  final DateTime startDate;
  final DateTime endDate;
  final String label;
  final String? description;
  final Color? color;
  final IconData? icon;
  final String? tapContent;

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

/// Configuration class for Gantt chart styling
class GanttChartStyle {
  final Color lineColor;
  final Color pointColor;
  final Color connectionLineColor;
  final Color backgroundColor;
  final TextStyle? labelStyle;
  final TextStyle? dateStyle;
  final TextStyle? descriptionStyle;
  final double lineWidth;
  final double pointRadius;
  final double connectionLineWidth;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool showConnections;
  final DateFormat? dateFormat;
  final double verticalSpacing;
  final double horizontalPadding;
  final double labelOffset;
  final double timelineYOffset;

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