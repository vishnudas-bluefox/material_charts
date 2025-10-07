import 'dart:math';
import 'package:flutter/material.dart';
import 'models.dart';

/// Custom painter for rendering a bar chart with rotation support.
///
/// This class is responsible for drawing the bar chart, including bars, grid lines,
/// and labels based on the provided data and styling options. Supports rotation
/// at any angle while keeping text elements readable (non-rotated).
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

    // Determine if we're in horizontal mode (90 or 270 degrees)
    final isHorizontalMode = _isHorizontalOrientation();

    if (showGrid) {
      _drawGrid(canvas, chartArea, isHorizontalMode);
    }

    _drawBars(canvas, chartArea, isHorizontalMode);
    _drawLabels(canvas, chartArea, isHorizontalMode);
  }

  /// Determines if the chart is in horizontal orientation
  bool _isHorizontalOrientation() {
    final normalizedRotation = style.rotation % 360;
    // Consider horizontal if rotation is around 90° or 270°
    return (normalizedRotation >= 45 && normalizedRotation < 135) ||
        (normalizedRotation >= 225 && normalizedRotation < 315);
  }

  /// Determines if the chart is inverted (180° or 270°)
  bool _isInverted() {
    final normalizedRotation = style.rotation % 360;
    return normalizedRotation >= 135 && normalizedRotation < 315;
  }

  /// Draws the grid lines on the chart.
  void _drawGrid(Canvas canvas, Rect chartArea, bool isHorizontal) {
    final paint = Paint()
      ..color = style.gridColor.withValues(alpha: 0.2)
      ..strokeWidth = 1;

    if (isHorizontal) {
      // Vertical grid lines for horizontal bars
      for (int i = 0; i <= horizontalGridLines; i++) {
        final x = chartArea.left + (chartArea.width / horizontalGridLines) * i;
        canvas.drawLine(
          Offset(x, chartArea.top),
          Offset(x, chartArea.bottom),
          paint,
        );
      }
    } else {
      // Horizontal grid lines for vertical bars (default)
      for (int i = 0; i <= horizontalGridLines; i++) {
        final y = chartArea.top + (chartArea.height / horizontalGridLines) * i;
        canvas.drawLine(
          Offset(chartArea.left, y),
          Offset(chartArea.right, y),
          paint,
        );
      }
    }
  }

  /// Draws the bars on the chart.
  void _drawBars(Canvas canvas, Rect chartArea, bool isHorizontal) {
    final maxValue = data
        .map((point) => point.value)
        .reduce(max); // Find the max value for scaling

    if (isHorizontal) {
      _drawHorizontalBars(canvas, chartArea, maxValue);
    } else {
      _drawVerticalBars(canvas, chartArea, maxValue);
    }
  }

  /// Draws vertical bars (default mode, 0° or 180°)
  void _drawVerticalBars(Canvas canvas, Rect chartArea, double maxValue) {
    final barWidth = (chartArea.width / data.length) * (1 - style.barSpacing);
    final spacing = (chartArea.width / data.length) * style.barSpacing;
    final isInverted = _isInverted();

    for (int i = 0; i < data.length; i++) {
      final barHeight =
          (data[i].value / maxValue) * chartArea.height * progress;
      final barX = chartArea.left + (i * (barWidth + spacing)) + (spacing / 2);

      final barY = isInverted
          ? chartArea.top // Start from top when inverted
          : chartArea.bottom - barHeight; // Start from bottom normally

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(barX, barY, barWidth, barHeight),
        Radius.circular(style.cornerRadius),
      );

      final paint = Paint()..style = PaintingStyle.fill;

      // Apply colors and gradients
      _applyBarStyle(
        paint,
        rect,
        i,
        isInverted ? Alignment.topCenter : Alignment.bottomCenter,
        isInverted ? Alignment.bottomCenter : Alignment.topCenter,
      );

      // Apply hover effect
      if (_isBarHovered(i, chartArea, barWidth, spacing, isHorizontal: false)) {
        _applyHoverEffect(
          canvas,
          rect,
          paint,
          i,
          isInverted ? Alignment.topCenter : Alignment.bottomCenter,
          isInverted ? Alignment.bottomCenter : Alignment.topCenter,
        );
      }

      canvas.drawRRect(rect, paint);

      // Draw value labels (always horizontal)
      if (showValues) {
        _drawValueLabel(
          canvas,
          data[i].value,
          Offset(
            barX + barWidth / 2,
            isInverted ? barY + barHeight + 8 : barY - 4,
          ),
          data[i].color ?? style.barColor,
          isAbove: !isInverted,
        );
      }
    }
  }

  /// Draws horizontal bars (90° or 270°)
  void _drawHorizontalBars(Canvas canvas, Rect chartArea, double maxValue) {
    final barHeight = (chartArea.height / data.length) * (1 - style.barSpacing);
    final spacing = (chartArea.height / data.length) * style.barSpacing;
    final isReversed =
        style.rotation >= 225 && style.rotation < 315; // 270° mode

    for (int i = 0; i < data.length; i++) {
      final barWidth = (data[i].value / maxValue) * chartArea.width * progress;
      final barY = chartArea.top + (i * (barHeight + spacing)) + (spacing / 2);

      final barX = isReversed
          ? chartArea.right - barWidth // Start from right when reversed
          : chartArea.left; // Start from left normally

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(barX, barY, barWidth, barHeight),
        Radius.circular(style.cornerRadius),
      );

      final paint = Paint()..style = PaintingStyle.fill;

      // Apply colors and gradients
      _applyBarStyle(
        paint,
        rect,
        i,
        isReversed ? Alignment.centerRight : Alignment.centerLeft,
        isReversed ? Alignment.centerLeft : Alignment.centerRight,
      );

      // Apply hover effect
      if (_isBarHovered(i, chartArea, barHeight, spacing, isHorizontal: true)) {
        _applyHoverEffect(
          canvas,
          rect,
          paint,
          i,
          isReversed ? Alignment.centerRight : Alignment.centerLeft,
          isReversed ? Alignment.centerLeft : Alignment.centerRight,
        );
      }

      canvas.drawRRect(rect, paint);

      // Draw value labels (always horizontal)
      if (showValues) {
        _drawValueLabel(
          canvas,
          data[i].value,
          Offset(
            isReversed ? barX - 4 : barX + barWidth + 4,
            barY + barHeight / 2,
          ),
          data[i].color ?? style.barColor,
          isAbove: false,
          isLeftAligned: isReversed,
        );
      }
    }
  }

  /// Applies bar styling (color or gradient)
  void _applyBarStyle(
    Paint paint,
    RRect rect,
    int index,
    Alignment gradientBegin,
    Alignment gradientEnd,
  ) {
    if (data[index].color != null) {
      paint.color = data[index].color!;
    } else if (style.gradientEffect && style.gradientColors != null) {
      paint.shader = LinearGradient(
        begin: gradientBegin,
        end: gradientEnd,
        colors: style.gradientColors!,
      ).createShader(rect.outerRect);
    } else {
      paint.color = style.barColor;
    }
  }

  /// Applies hover effect to a bar
  void _applyHoverEffect(
    Canvas canvas,
    RRect rect,
    Paint paint,
    int index,
    Alignment gradientBegin,
    Alignment gradientEnd,
  ) {
    if (paint.shader != null) {
      paint.shader = LinearGradient(
        begin: gradientBegin,
        end: gradientEnd,
        colors:
            style.gradientColors!.map((c) => c.withValues(alpha: 0.8)).toList(),
      ).createShader(rect.outerRect);
    } else {
      paint.color = paint.color.withValues(alpha: 0.8);
    }

    // Draw hover indicator
    final hoverPaint = Paint()
      ..color = (data[index].color ?? style.barColor).withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(rect, hoverPaint);
  }

  /// Draws a value label (always horizontal and readable)
  void _drawValueLabel(
    Canvas canvas,
    double value,
    Offset position,
    Color color, {
    bool isAbove = true,
    bool isLeftAligned = false,
  }) {
    final valueText = value.toStringAsFixed(1);
    final textStyle = style.valueStyle ??
        TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold);
    final textSpan = TextSpan(text: valueText, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    Offset textPosition;
    if (isAbove) {
      // Center horizontally, position above or below
      textPosition = Offset(
        position.dx - textPainter.width / 2,
        position.dy - (isAbove ? textPainter.height : 0),
      );
    } else {
      // Position to left or right, center vertically
      textPosition = Offset(
        isLeftAligned ? position.dx - textPainter.width : position.dx,
        position.dy - textPainter.height / 2,
      );
    }

    textPainter.paint(canvas, textPosition);
  }

  /// Draws the labels for each bar on the chart (always horizontal and readable)
  void _drawLabels(Canvas canvas, Rect chartArea, bool isHorizontal) {
    final textStyle =
        style.labelStyle ?? TextStyle(color: style.barColor, fontSize: 12);

    if (isHorizontal) {
      _drawHorizontalLabels(canvas, chartArea, textStyle);
    } else {
      _drawVerticalLabels(canvas, chartArea, textStyle);
    }
  }

  /// Draws labels for vertical bars
  void _drawVerticalLabels(Canvas canvas, Rect chartArea, TextStyle textStyle) {
    final barWidth = (chartArea.width / data.length) * (1 - style.barSpacing);
    final spacing = (chartArea.width / data.length) * style.barSpacing;
    final isInverted = _isInverted();

    for (int i = 0; i < data.length; i++) {
      final x = chartArea.left + (i * (barWidth + spacing)) + (spacing / 2);
      final textSpan = TextSpan(text: data[i].label, style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      final yPosition = isInverted
          ? chartArea.top - textPainter.height - 8
          : chartArea.bottom + padding.bottom / 2 - textPainter.height / 2;

      textPainter.paint(
        canvas,
        Offset(x + (barWidth - textPainter.width) / 2, yPosition),
      );
    }
  }

  /// Draws labels for horizontal bars
  void _drawHorizontalLabels(
    Canvas canvas,
    Rect chartArea,
    TextStyle textStyle,
  ) {
    final barHeight = (chartArea.height / data.length) * (1 - style.barSpacing);
    final spacing = (chartArea.height / data.length) * style.barSpacing;
    final isReversed = style.rotation >= 225 && style.rotation < 315;

    for (int i = 0; i < data.length; i++) {
      final y = chartArea.top + (i * (barHeight + spacing)) + (spacing / 2);
      final textSpan = TextSpan(text: data[i].label, style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      final xPosition = isReversed
          ? chartArea.right + padding.right / 4
          : chartArea.left - textPainter.width - padding.left / 4;

      textPainter.paint(
        canvas,
        Offset(xPosition, y + (barHeight - textPainter.height) / 2),
      );
    }
  }

  /// Checks if a specific bar is being hovered over
  bool _isBarHovered(
    int barIndex,
    Rect chartArea,
    double barSize,
    double spacing, {
    required bool isHorizontal,
  }) {
    if (hoverPosition == null) return false;

    if (isHorizontal) {
      // Check vertical position for horizontal bars
      final barY =
          chartArea.top + (barIndex * (barSize + spacing)) + (spacing / 2);
      final barEndY = barY + barSize;
      return hoverPosition!.dy >= barY && hoverPosition!.dy <= barEndY;
    } else {
      // Check horizontal position for vertical bars
      final barX =
          chartArea.left + (barIndex * (barSize + spacing)) + (spacing / 2);
      final barEndX = barX + barSize;
      return hoverPosition!.dx >= barX && hoverPosition!.dx <= barEndX;
    }
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
