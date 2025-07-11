import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models.dart';

/// Custom painter for rendering a Gantt chart.
///
/// This class extends [CustomPainter] and is responsible for drawing
/// the Gantt chart using the provided data, style, and animation progress.
class GanttBasePainter extends CustomPainter {
  /// The data points representing tasks in the Gantt chart.
  final List<GanttData> data;

  /// The animation progress (from 0.0 to 1.0) for rendering the chart.
  final double progress;

  /// The style configuration for customizing the appearance of the chart.
  final GanttChartStyle style;

  /// The index of the currently hovered task, if any.
  final int? hoveredIndex;

  /// Creates a new instance of [GanttBasePainter].
  GanttBasePainter({
    required this.data,
    required this.progress,
    required this.style,
    this.hoveredIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Define the chart area, excluding padding
    final chartArea = Rect.fromLTWH(
      style.horizontalPadding,
      style.horizontalPadding,
      size.width - (style.horizontalPadding * 2),
      size.height - (style.horizontalPadding * 2),
    );

    // Draw the grid for time intervals
    _drawTimeGrid(canvas, chartArea);

    // Draw the main timeline for tasks
    _drawTimeline(canvas, chartArea);

    // Draw connection lines between tasks if enabled in the style
    if (style.showConnections) {
      _drawConnections(canvas, chartArea);
    }

    // Draw task labels above their corresponding timeline
    _drawLabels(canvas, chartArea);
  }

  /// Draws a grid representing time intervals on the Gantt chart.
  void _drawTimeGrid(Canvas canvas, Rect chartArea) {
    // Paint settings for the grid lines
    final paint = Paint()
      ..color = style.connectionLineColor.withValues(alpha: 0.5)
      ..strokeWidth = 0.3;

    // Get the overall time range covered by the data
    final timeRange = _getTimeRange();
    final totalDuration = timeRange.end.difference(timeRange.start);
    const gridCount = 6;

    // Draw vertical grid lines and corresponding date labels
    for (int i = 0; i <= gridCount; i++) {
      final x = chartArea.left + (chartArea.width / gridCount * i);

      // Draw vertical grid line
      canvas.drawLine(
        Offset(x, chartArea.top + style.timelineYOffset - 20),
        Offset(x, chartArea.bottom),
        paint,
      );

      // Calculate and draw date label at the bottom of the grid
      final date = timeRange.start.add(
        Duration(milliseconds: (totalDuration.inMilliseconds ~/ gridCount * i)),
      );

      final dateText = TextPainter(
        text: TextSpan(
          text:
              style.dateFormat?.format(date) ?? DateFormat.yMMMd().format(date),
          style: style.dateStyle ??
              TextStyle(fontSize: 10, color: style.connectionLineColor),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();

      dateText.paint(
        canvas,
        Offset(
          x - (dateText.width / 2),
          chartArea.bottom - dateText.height - 10,
        ),
      );
    }
  }

  /// Draws the main timeline for the Gantt chart tasks.
  void _drawTimeline(Canvas canvas, Rect chartArea) {
    // Paint settings for task lines
    final paint = Paint()
      ..color = style.lineColor.withValues(alpha: 0.8)
      ..strokeWidth = style.lineWidth
      ..strokeCap = StrokeCap.round;

    // Iterate over each data point to draw the timeline
    for (int i = 0; i < data.length; i++) {
      final point = data[i];
      final timeRange = _getTimeRange();
      final totalDuration = timeRange.end.difference(timeRange.start);

      // Calculate X positions for the start and end of the task
      final startX = chartArea.left +
          (point.startDate.difference(timeRange.start).inMilliseconds /
                  totalDuration.inMilliseconds) *
              chartArea.width *
              progress;

      final endX = chartArea.left +
          (point.endDate.difference(timeRange.start).inMilliseconds /
                  totalDuration.inMilliseconds) *
              chartArea.width *
              progress;

      final y =
          chartArea.top + style.timelineYOffset + (i * style.verticalSpacing);

      // Draw the task line on the canvas
      canvas.drawLine(Offset(startX, y), Offset(endX, y), paint);
    }
  }

  /// Draws connection lines between tasks in the Gantt chart.
  void _drawConnections(Canvas canvas, Rect chartArea) {
    if (data.length < 2) return; // No connections to draw if less than 2 tasks

    final paint = Paint()
      ..color = style.connectionLineColor.withValues(alpha: 0.5)
      ..strokeWidth = style.connectionLineWidth
      ..style = PaintingStyle.stroke;

    final timeRange = _getTimeRange();
    final totalDuration = timeRange.end.difference(timeRange.start);

    // Iterate over pairs of tasks to draw connection lines
    for (int i = 0; i < data.length - 1; i++) {
      final current = data[i];
      final next = data[i + 1];

      // Calculate X and Y positions for the start and end of the connection
      final x1 = chartArea.left +
          (current.startDate.difference(timeRange.start).inMilliseconds /
                  totalDuration.inMilliseconds) *
              chartArea.width *
              progress;
      final y1 =
          chartArea.top + style.timelineYOffset + (i * style.verticalSpacing);

      final x2 = chartArea.left +
          (next.startDate.difference(timeRange.start).inMilliseconds /
                  totalDuration.inMilliseconds) *
              chartArea.width *
              progress;
      final y2 = chartArea.top +
          style.timelineYOffset +
          ((i + 1) * style.verticalSpacing);

      // Create a cubic bezier path for a smooth connection
      final path = Path()
        ..moveTo(x1, y1)
        ..cubicTo(x1 + (x2 - x1) / 2, y1, x1 + (x2 - x1) / 2, y2, x2, y2);

      // Draw the connection path on the canvas
      canvas.drawPath(path, paint);
    }
  }

  /// Draws labels for each task above their corresponding timeline.
  void _drawLabels(Canvas canvas, Rect chartArea) {
    final timeRange = _getTimeRange();
    final totalDuration = timeRange.end.difference(timeRange.start);

    for (int i = 0; i < data.length; i++) {
      final point = data[i];
      final x = chartArea.left +
          (point.startDate.difference(timeRange.start).inMilliseconds /
                  totalDuration.inMilliseconds) *
              chartArea.width *
              progress;
      final y =
          chartArea.top + style.timelineYOffset + (i * style.verticalSpacing);

      // Draw label above the point
      final labelPainter = TextPainter(
        text: TextSpan(
          text: point.label,
          style: style.labelStyle ??
              TextStyle(
                color: point.color ?? style.pointColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();

      labelPainter.paint(
        canvas,
        Offset(
          x - (labelPainter.width / 2),
          y - style.labelOffset - labelPainter.height,
        ),
      );
    }
  }

  /// Calculates the overall time range covered by the data points.
  ///
  /// Returns a [DateTimeRange] that extends slightly beyond the
  /// earliest and latest dates in the data to provide padding.
  DateTimeRange _getTimeRange() {
    DateTime? earliest;
    DateTime? latest;

    // Determine the earliest start date and latest end date
    for (final point in data) {
      if (earliest == null || point.startDate.isBefore(earliest)) {
        earliest = point.startDate;
      }
      if (latest == null || point.endDate.isAfter(latest)) {
        latest = point.endDate;
      }
    }

    // Return a time range with added padding of 7 days
    return DateTimeRange(
      start: earliest!.subtract(const Duration(days: 7)),
      end: latest!.add(const Duration(days: 7)),
    );
  }

  @override
  bool shouldRepaint(GanttBasePainter oldDelegate) {
    // Check if the painter should repaint based on changes in data, progress, style, or hovered index
    return oldDelegate.data != data ||
        oldDelegate.progress != progress ||
        oldDelegate.style != style ||
        oldDelegate.hoveredIndex != hoveredIndex;
  }
}
