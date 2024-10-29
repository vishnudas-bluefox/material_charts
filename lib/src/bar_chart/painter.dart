import 'dart:math';

import 'package:flutter/material.dart';
import 'package:material_charts/src/bar_chart/models.dart';

class BarChartPainter extends CustomPainter {
  final List<BarChartData> data;
  final double progress;
  final BarChartStyle style;
  final bool showGrid;
  final bool showValues;
  final EdgeInsets padding;
  final int horizontalGridLines;
  final int? hoveredBarIndex;

  BarChartPainter({
    required this.data,
    required this.progress,
    required this.style,
    required this.showGrid,
    required this.showValues,
    required this.padding,
    required this.horizontalGridLines,
    required this.hoveredBarIndex,
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

    _drawBars(canvas, chartArea);
    _drawLabels(canvas, chartArea);
  }

  void _drawGrid(Canvas canvas, Rect chartArea) {
    final paint = Paint()
      ..color = style.gridColor.withOpacity(0.2)
      ..strokeWidth = 1;

    // Draw horizontal grid lines
    for (int i = 0; i <= horizontalGridLines; i++) {
      final y = chartArea.top + (chartArea.height / horizontalGridLines) * i;
      canvas.drawLine(
        Offset(chartArea.left, y),
        Offset(chartArea.right, y),
        paint,
      );
    }
  }

  void _drawBars(Canvas canvas, Rect chartArea) {
    final maxValue = data.map((point) => point.value).reduce(max);
    final barWidth = (chartArea.width / data.length) * (1 - style.barSpacing);
    final spacing = (chartArea.width / data.length) * style.barSpacing;

    for (int i = 0; i < data.length; i++) {
      final barHeight =
          (data[i].value / maxValue) * chartArea.height * progress;
      final barX = chartArea.left + (i * (barWidth + spacing)) + (spacing / 2);
      final barY = chartArea.bottom - barHeight;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(barX, barY, barWidth, barHeight),
        Radius.circular(style.cornerRadius),
      );

      final paint = Paint()..style = PaintingStyle.fill;

      // First check if this bar has a custom color
      if (data[i].color != null) {
        paint.color = data[i].color!;
      } else if (style.gradientEffect && style.gradientColors != null) {
        // Only apply gradient if no custom color is specified
        paint.shader = LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: style.gradientColors!,
        ).createShader(rect.outerRect);
      } else {
        // Use default bar color if no custom color or gradient
        paint.color = style.barColor;
      }

      // Apply hover effect
      if (hoveredBarIndex == i) {
        if (paint.shader != null) {
          // If using gradient, create a lighter version
          paint.shader = LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors:
                style.gradientColors!.map((c) => c.withOpacity(0.8)).toList(),
          ).createShader(rect.outerRect);
        } else {
          // If using solid color, make it lighter
          paint.color = paint.color.withOpacity(0.8);
        }

        // Draw hover indicator
        final hoverPaint = Paint()
          ..color = (data[i].color ?? style.barColor).withOpacity(0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
        canvas.drawRRect(rect, hoverPaint);
      }

      canvas.drawRRect(rect, paint);

      if (showValues) {
        final value = data[i].value.toStringAsFixed(1);
        final textStyle = style.valueStyle ??
            TextStyle(
              color: data[i].color ?? style.barColor, // Use bar color for text
              fontSize: 12,
              fontWeight: FontWeight.bold,
            );
        final textSpan = TextSpan(text: value, style: textStyle);
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        )..layout();

        textPainter.paint(
          canvas,
          Offset(
            barX + (barWidth - textPainter.width) / 2,
            barY - textPainter.height - 4,
          ),
        );
      }
    }
  }

  void _drawLabels(Canvas canvas, Rect chartArea) {
    final barWidth = (chartArea.width / data.length) * (1 - style.barSpacing);
    final spacing = (chartArea.width / data.length) * style.barSpacing;

    final textStyle = style.labelStyle ??
        TextStyle(
          color: style.barColor,
          fontSize: 12,
        );

    for (int i = 0; i < data.length; i++) {
      final x = chartArea.left + (i * (barWidth + spacing)) + (spacing / 2);
      final textSpan = TextSpan(text: data[i].label, style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(
          x + (barWidth - textPainter.width) / 2,
          chartArea.bottom + padding.bottom / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(BarChartPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.data != data ||
        oldDelegate.style != style ||
        oldDelegate.showGrid != showGrid ||
        oldDelegate.showValues != showValues ||
        oldDelegate.hoveredBarIndex != hoveredBarIndex ||
        oldDelegate.horizontalGridLines != horizontalGridLines;
  }
}
