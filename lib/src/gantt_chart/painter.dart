import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_charts/src/gantt_chart/models.dart';

class GanttBasePainter extends CustomPainter {
  final List<GanttData> data;
  final double progress;
  final GanttChartStyle style;
  final int? hoveredIndex;

  GanttBasePainter({
    required this.data,
    required this.progress,
    required this.style,
    this.hoveredIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final chartArea = Rect.fromLTWH(
      style.horizontalPadding,
      style.horizontalPadding,
      size.width - (style.horizontalPadding * 2),
      size.height - (style.horizontalPadding * 2),
    );

    _drawTimeGrid(canvas, chartArea);
    _drawTimeline(canvas, chartArea);
    if (style.showConnections) {
      _drawConnections(canvas, chartArea);
    }
    _drawLabels(canvas, chartArea);
  }

  void _drawTimeGrid(Canvas canvas, Rect chartArea) {
    final paint = Paint()
      ..color = style.connectionLineColor.withOpacity(0.5)
      ..strokeWidth = 0.3;

    final timeRange = _getTimeRange();
    final totalDuration = timeRange.end.difference(timeRange.start);
    const gridCount = 6;

    for (int i = 0; i <= gridCount; i++) {
      final x = chartArea.left + (chartArea.width / gridCount * i);

      // Draw vertical grid line
      canvas.drawLine(
        Offset(x, chartArea.top + style.timelineYOffset - 20),
        Offset(x, chartArea.bottom),
        paint,
      );

      // Draw date label at bottom
      final date = timeRange.start.add(Duration(
        milliseconds: (totalDuration.inMilliseconds ~/ gridCount * i),
      ));

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

  void _drawTimeline(Canvas canvas, Rect chartArea) {
    final paint = Paint()
      ..color = style.lineColor.withOpacity(.8)
      ..strokeWidth = style.lineWidth
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < data.length; i++) {
      final point = data[i];
      final timeRange = _getTimeRange();
      final totalDuration = timeRange.end.difference(timeRange.start);

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

      canvas.drawLine(
        Offset(startX, y),
        Offset(endX, y),
        paint,
      );
    }
  }

  void _drawConnections(Canvas canvas, Rect chartArea) {
    if (data.length < 2) return;

    final paint = Paint()
      ..color = style.connectionLineColor.withOpacity(0.5)
      ..strokeWidth = style.connectionLineWidth
      ..style = PaintingStyle.stroke;

    final timeRange = _getTimeRange();
    final totalDuration = timeRange.end.difference(timeRange.start);

    for (int i = 0; i < data.length - 1; i++) {
      final current = data[i];
      final next = data[i + 1];

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

      final path = Path()
        ..moveTo(x1, y1)
        ..cubicTo(
          x1 + (x2 - x1) / 2,
          y1,
          x1 + (x2 - x1) / 2,
          y2,
          x2,
          y2,
        );

      canvas.drawPath(path, paint);
    }
  }

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
        Offset(x - (labelPainter.width / 2),
            y - style.labelOffset - labelPainter.height),
      );
    }
  }

  DateTimeRange _getTimeRange() {
    DateTime? earliest;
    DateTime? latest;

    for (final point in data) {
      if (earliest == null || point.startDate.isBefore(earliest)) {
        earliest = point.startDate;
      }
      if (latest == null || point.endDate.isAfter(latest)) {
        latest = point.endDate;
      }
    }

    return DateTimeRange(
      start: earliest!.subtract(const Duration(days: 7)),
      end: latest!.add(const Duration(days: 7)),
    );
  }

  @override
  bool shouldRepaint(GanttBasePainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.progress != progress ||
        oldDelegate.style != style ||
        oldDelegate.hoveredIndex != hoveredIndex;
  }
}
