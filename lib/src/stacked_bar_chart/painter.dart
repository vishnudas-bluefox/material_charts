import 'dart:math';
import 'package:flutter/material.dart';

import 'models.dart';

/// A custom painter that draws a stacked bar chart with optional grid, labels, and hover effects.
///
/// This class handles the rendering logic for:
/// - Y-axis with labels and optional grid lines.
/// - Stacked bars with multiple segments per bar.
/// - Labels on segments and bars.
/// - Hover effects for interactive feedback.
/// - Smooth animations during chart rendering.
class StackedBarChartPainter extends CustomPainter {
  /// Data to be visualized, where each entry represents a bar with segments.
  final List<StackedBarData> data;

  /// Progress of the animation, ranging from 0.0 to 1.0.
  /// Controls how much of the chart is drawn.
  final double progress;

  /// Styling configuration for the chart, including colors, fonts, and animations.
  final StackedBarChartStyle style;

  /// Whether to display the grid lines across the chart.
  final bool showGrid;

  /// Whether to display value labels on each bar segment.
  final bool showValues;

  /// Padding around the chart content, controlling spacing between elements.
  final EdgeInsets padding;

  /// Number of horizontal grid lines to display.
  final int horizontalGridLines;

  /// The index of the currently hovered bar for interactive highlighting.
  final int? hoveredBarIndex;

  /// Creates a [StackedBarChartPainter] with the required data and configuration.
  StackedBarChartPainter({
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
    if (data.isEmpty) return; // Exit if no data is provided.

    // Define the chart area inside the padding, considering Y-axis width if configured.
    final yAxisConfig = style.yAxisConfig;
    final chartArea = Rect.fromLTWH(
      padding.left + (yAxisConfig?.axisWidth ?? 0),
      padding.top,
      size.width - padding.horizontal - (yAxisConfig?.axisWidth ?? 0),
      size.height - padding.vertical,
    );

    // Draw Y-axis and grid if configured.
    if (yAxisConfig != null) {
      _drawYAxis(canvas, chartArea, yAxisConfig);
    }
    if (showGrid) {
      _drawGrid(canvas, chartArea);
    }

    // Draw the stacked bars and their labels.
    _drawStackedBars(canvas, chartArea);
    _drawLabels(canvas, chartArea);
  }

  /// Draws the Y-axis with optional grid lines and value labels.
  void _drawYAxis(Canvas canvas, Rect chartArea, YAxisConfig config) {
    final maxDataValue = data.map((bar) => bar.totalValue).reduce(max);
    final minValue = config.minValue ?? 0;
    final maxValue = config.maxValue ?? maxDataValue;

    final axisPaint = Paint()
      ..color = style.gridColor
      ..strokeWidth = 1;

    // Draw the vertical Y-axis line if enabled.
    if (config.showAxisLine) {
      canvas.drawLine(
        Offset(chartArea.left, chartArea.top),
        Offset(chartArea.left, chartArea.bottom),
        axisPaint,
      );
    }

    // Draw Y-axis labels and optional horizontal grid lines.
    for (int i = 0; i <= config.divisions; i++) {
      final y = chartArea.bottom - (i / config.divisions) * chartArea.height;
      final value = minValue + (i / config.divisions) * (maxValue - minValue);

      // Format the value label.
      final label =
          config.labelFormatter?.call(value) ?? value.toStringAsFixed(1);
      final textSpan = TextSpan(
        text: label,
        style: config.labelStyle ??
            TextStyle(color: style.gridColor, fontSize: 12),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      // Draw the label next to the Y-axis.
      textPainter.paint(
        canvas,
        Offset(
          chartArea.left - textPainter.width - 8,
          y - textPainter.height / 2,
        ),
      );

      // Draw horizontal grid lines if enabled.
      if (config.showGridLines && i > 0 && i < config.divisions) {
        canvas.drawLine(
          Offset(chartArea.left, y),
          Offset(chartArea.right, y),
          axisPaint..color = style.gridColor.withOpacity(0.2),
        );
      }
    }
  }

  /// Draws horizontal grid lines across the chart area.
  void _drawGrid(Canvas canvas, Rect chartArea) {
    final paint = Paint()
      ..color = style.gridColor.withOpacity(0.2)
      ..strokeWidth = 1;

    for (int i = 0; i <= horizontalGridLines; i++) {
      final y = chartArea.top + (chartArea.height / horizontalGridLines) * i;
      canvas.drawLine(
        Offset(chartArea.left, y),
        Offset(chartArea.right, y),
        paint,
      );
    }
  }

  /// Calculates the height of a bar segment relative to the chart's value range.
  double _calculateBarHeight(double value, Rect chartArea) {
    final yAxisConfig = style.yAxisConfig;
    final minValue = yAxisConfig?.minValue ?? 0;
    final maxValue =
        yAxisConfig?.maxValue ?? data.map((bar) => bar.totalValue).reduce(max);

    return (value / (maxValue - minValue)) * chartArea.height;
  }

  /// Draws each stacked bar with its segments and optional hover effect.
  void _drawStackedBars(Canvas canvas, Rect chartArea) {
    final barWidth = (chartArea.width / data.length) * (1 - style.barSpacing);
    final spacing = (chartArea.width / data.length) * style.barSpacing;

    for (int i = 0; i < data.length; i++) {
      double currentHeight = 0;
      final barX = chartArea.left + (i * (barWidth + spacing)) + (spacing / 2);

      for (var segment in data[i].segments) {
        final segmentHeight =
            _calculateBarHeight(segment.value, chartArea) * progress;
        final segmentY = chartArea.bottom - currentHeight - segmentHeight;

        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(barX, segmentY, barWidth, segmentHeight),
          Radius.circular(style.cornerRadius),
        );

        final paint = Paint()
          ..color = hoveredBarIndex == i
              ? segment.color.withOpacity(0.8)
              : segment.color;

        canvas.drawRRect(rect, paint);

        if (showValues) {
          _drawSegmentLabel(
              canvas, segment.value.toStringAsFixed(1), rect, barWidth);
        }

        currentHeight += segmentHeight;
      }

      if (hoveredBarIndex == i) {
        _drawHoverEffect(canvas, barX, barWidth, currentHeight, chartArea);
      }
    }
  }

  /// Draws the label for each segment if there is enough space.
  void _drawSegmentLabel(
      Canvas canvas, String value, RRect segmentRect, double barWidth) {
    final textStyle = style.valueStyle ??
        const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        );

    final textSpan = TextSpan(text: value, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    if (segmentRect.height > textPainter.height * 1.2) {
      textPainter.paint(
        canvas,
        Offset(
          segmentRect.left + (barWidth - textPainter.width) / 2,
          segmentRect.top + (segmentRect.height - textPainter.height) / 2,
        ),
      );
    }
  }

  /// Draws a hover effect around the selected bar.
  void _drawHoverEffect(Canvas canvas, double barX, double barWidth,
      double totalHeight, Rect chartArea) {
    final hoverPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final fullRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
          barX, chartArea.bottom - totalHeight, barWidth, totalHeight),
      Radius.circular(style.cornerRadius),
    );
    canvas.drawRRect(fullRect, hoverPaint);
  }

  /// Draws labels for each bar below the chart area.
  void _drawLabels(Canvas canvas, Rect chartArea) {
    final barWidth = (chartArea.width / data.length) * (1 - style.barSpacing);
    final spacing = (chartArea.width / data.length) * style.barSpacing;

    for (int i = 0; i < data.length; i++) {
      final x = chartArea.left + (i * (barWidth + spacing)) + (spacing / 2);
      final textSpan = TextSpan(
        text: data[i].label,
        style: style.labelStyle ??
            const TextStyle(color: Colors.black87, fontSize: 12),
      );

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
  bool shouldRepaint(StackedBarChartPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.data != data ||
        oldDelegate.style != style ||
        oldDelegate.showGrid != showGrid ||
        oldDelegate.showValues != showValues ||
        oldDelegate.hoveredBarIndex != hoveredBarIndex ||
        oldDelegate.horizontalGridLines != horizontalGridLines;
  }
}
