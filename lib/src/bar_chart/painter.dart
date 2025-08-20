import 'dart:math';
import 'package:flutter/material.dart';
import 'models.dart';

/// Custom painter for rendering a bar chart.
///
/// This class is responsible for drawing the bar chart, including bars, grid lines,
/// and labels based on the provided data and styling options.
class BarChartPainter extends CustomPainter {
  final List<BarChartData> data; // Data points to be displayed in the chart
  final double progress; // Animation progress from 0.0 to 1.0
  final BarChartStyle style; // Styling options for the chart
  final bool showGrid; // Flag to show or hide grid lines
  final bool showValues; // Flag to show or hide bar values
  final EdgeInsets padding; // Padding around the chart
  final int horizontalGridLines; // Number of horizontal grid lines to draw
  final Offset? hoverPosition; // Position of the mouse hover (for interaction)

  /// Creates an instance of [BarChartPainter].
  BarChartPainter({
    required this.data,
    required this.progress,
    required this.style,
    required this.showGrid,
    required this.showValues,
    required this.padding,
    required this.horizontalGridLines,
    required this.hoverPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return; // Exit if there's no data to display

    final chartArea = Rect.fromLTWH(
      padding.left,
      padding.top,
      size.width - padding.horizontal,
      size.height - padding.vertical,
    );

    if (showGrid) {
      _drawGrid(canvas, chartArea); // Draw grid lines if enabled
    }

    _drawBars(canvas, chartArea); // Draw the bars
    _drawLabels(canvas, chartArea); // Draw the labels
  }

  /// Draws the grid lines on the chart.
  void _drawGrid(Canvas canvas, Rect chartArea) {
    final paint = Paint()
      ..color = style.gridColor.withValues(alpha: 0.2)
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

  /// Draws the bars on the chart.
  void _drawBars(Canvas canvas, Rect chartArea) {
    final maxValue = data
        .map((point) => point.value)
        .reduce(max); // Find the max value for scaling
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

      // Check for custom color or gradient
      if (data[i].color != null) {
        paint.color = data[i].color!;
      } else if (style.gradientEffect && style.gradientColors != null) {
        paint.shader = LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: style.gradientColors!,
        ).createShader(rect.outerRect);
      } else {
        paint.color = style.barColor; // Default color
      }

      // Apply hover effect if applicable
      if (_isBarHovered(i, chartArea, barWidth, spacing)) {
        if (paint.shader != null) {
          paint.shader = LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: style.gradientColors!
                .map((c) => c.withValues(alpha: 0.8))
                .toList(),
          ).createShader(rect.outerRect);
        } else {
          paint.color = paint.color.withValues(
            alpha: 0.8,
          ); // Lighter color on hover
        }

        // Draw hover indicator
        final hoverPaint = Paint()
          ..color = (data[i].color ?? style.barColor).withValues(alpha: 0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
        canvas.drawRRect(rect, hoverPaint);
      }

      canvas.drawRRect(rect, paint); // Draw the bar

      // Draw value labels above bars if enabled
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

  /// Draws the labels for each bar on the chart.
  void _drawLabels(Canvas canvas, Rect chartArea) {
    final barWidth = (chartArea.width / data.length) * (1 - style.barSpacing);
    final spacing = (chartArea.width / data.length) * style.barSpacing;

    final textStyle =
        style.labelStyle ?? TextStyle(color: style.barColor, fontSize: 12);

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

  /// Checks if a specific bar is being hovered over
  bool _isBarHovered(
    int barIndex,
    Rect chartArea,
    double barWidth,
    double spacing,
  ) {
    if (hoverPosition == null) return false;

    final barX =
        chartArea.left + (barIndex * (barWidth + spacing)) + (spacing / 2);
    final barEndX = barX + barWidth;

    return hoverPosition!.dx >= barX && hoverPosition!.dx <= barEndX;
  }

  @override
  bool shouldRepaint(BarChartPainter oldDelegate) {
    // Determines whether the painter should repaint when properties change
    return oldDelegate.progress != progress ||
        oldDelegate.data != data ||
        oldDelegate.style != style ||
        oldDelegate.showGrid != showGrid ||
        oldDelegate.showValues != showValues ||
        oldDelegate.hoverPosition != hoverPosition ||
        oldDelegate.horizontalGridLines != horizontalGridLines;
  }
}
