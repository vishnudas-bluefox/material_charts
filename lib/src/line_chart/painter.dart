import 'dart:math';

import 'package:flutter/material.dart';
import 'package:material_charts/src/line_chart/models.dart';

class LineChartPainter extends CustomPainter {
  final List<ChartData> data;
  final double progress;
  final LineChartStyle style;
  final bool showPoints;
  final bool showGrid;
  final EdgeInsets padding;
  final int horizontalGridLines;

  LineChartPainter({
    required this.data,
    required this.progress,
    required this.style,
    required this.showPoints,
    required this.showGrid,
    required this.padding,
    required this.horizontalGridLines,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final chartArea = Rect.fromLTWH(
      padding.left,
      padding.top,
      size.width - padding.horizontal,
      size.height - padding.vertical,
    );

    if (showGrid) {
      _drawGrid(canvas, chartArea);
    }

    _drawLine(canvas, chartArea);

    if (showPoints) {
      _drawPoints(canvas, chartArea);
    }

    _drawLabels(canvas, chartArea);
  }

  void _drawGrid(Canvas canvas, Rect chartArea) {
    final paint = Paint()
      ..color = style.gridColor.withOpacity(0.2)
      ..strokeWidth = 1;

    // Horizontal grid lines
    for (int i = 0; i <= horizontalGridLines; i++) {
      final y = chartArea.top + (chartArea.height / horizontalGridLines) * i;
      canvas.drawLine(
        Offset(chartArea.left, y),
        Offset(chartArea.right, y),
        paint,
      );
    }

    // Vertical grid lines
    for (int i = 0; i < data.length; i++) {
      final x = chartArea.left + (chartArea.width / (data.length - 1)) * i;
      canvas.drawLine(
        Offset(x, chartArea.top),
        Offset(x, chartArea.bottom),
        paint,
      );
    }
  }

  void _drawLine(Canvas canvas, Rect chartArea) {
    final linePaint = Paint()
      ..color = style.lineColor
      ..strokeWidth = style.strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    final points = _getPointCoordinates(chartArea);

    for (int i = 0; i < points.length; i++) {
      final point = points[i];
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    final pathMetrics = path.computeMetrics().first;
    final extractPath = pathMetrics.extractPath(
      0.0,
      pathMetrics.length * progress,
    );

    canvas.drawPath(extractPath, linePaint);
  }

  void _drawPoints(Canvas canvas, Rect chartArea) {
    final pointPaint = Paint()
      ..color = style.pointColor
      ..style = PaintingStyle.fill;

    final points = _getPointCoordinates(chartArea);
    final progressPoints = (points.length * progress).floor();

    for (int i = 0; i < progressPoints; i++) {
      canvas.drawCircle(points[i], style.pointRadius, pointPaint);
    }
  }

  void _drawLabels(Canvas canvas, Rect chartArea) {
    final textStyle = style.labelStyle ??
        TextStyle(
          color: style.lineColor,
          fontSize: 12,
        );

    for (int i = 0; i < data.length; i++) {
      final x = chartArea.left + (chartArea.width / (data.length - 1)) * i;
      final textSpan = TextSpan(
        text: data[i].label,
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(
          x - textPainter.width / 2,
          chartArea.bottom + padding.bottom / 2,
        ),
      );
    }
  }

  List<Offset> _getPointCoordinates(Rect chartArea) {
    if (data.isEmpty) return [];

    final maxValue = data.map((point) => point.value).reduce(max);
    final minValue = data.map((point) => point.value).reduce(min);
    final valueRange = maxValue - minValue;

    return List.generate(data.length, (i) {
      final x = chartArea.left + (chartArea.width / (data.length - 1)) * i;
      final normalizedValue = (data[i].value - minValue) / valueRange;
      final y = chartArea.bottom - (normalizedValue * chartArea.height);
      return Offset(x, y);
    });
  }

  @override
  bool shouldRepaint(LineChartPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.data != data ||
        oldDelegate.style != style ||
        oldDelegate.showPoints != showPoints ||
        oldDelegate.showGrid != showGrid ||
        oldDelegate.horizontalGridLines != horizontalGridLines;
  }
}