import 'package:flutter/material.dart';

import 'dart:ui' as ui;
import 'dart:math';
import 'package:intl/intl.dart';

import 'models.dart';

/// CandlestickChartPainter is a CustomPainter implementation for rendering candlestick charts.
/// It supports features like scrolling, hover effects, tooltips, and customizable styling.
///
/// Key features:
/// - Animated candlesticks with customizable colors for bullish/bearish patterns
/// - Interactive tooltip on hover
/// - Scrollable chart view
/// - Configurable grid lines
/// - Customizable axis labels
/// - Progress-based animation support
///
/// The chart uses the following coordinate system:
/// - X-axis: Time/dates moving left to right
/// - Y-axis: Price values moving bottom to top
///
/// Usage example:
/// ```dart
/// CustomPaint(
///   painter: CandlestickChartPainter(
///     data: candlestickData,
///     progress: 1.0,
///     style: CandlestickStyle(),
///     axisConfig: ChartAxisConfig(),
///     padding: EdgeInsets.all(16),
///     showGrid: true,
///     scrollOffset: 0,
///   ),
/// )
/// ```

class CandlestickChartPainter extends CustomPainter {
  // Core data and configuration properties
  final List<CandlestickData> data; // List of candlestick data points
  final double progress; // Animation progress (0.0 to 1.0)
  final CandlestickStyle style; // Visual styling configuration
  final ChartAxisConfig axisConfig; // Axis configuration
  final EdgeInsets padding; // Chart padding
  final bool showGrid; // Flag to show/hide grid lines
  final double scrollOffset; // Horizontal scroll position
  final Offset? hoverPosition; // Current hover position (if any)
  // New properties for tooltip
  final TextStyle tooltipTextStyle = const TextStyle(
    color: Colors.black,
    fontSize: 12,
    backgroundColor: Colors.white,
  );

  /// Constructor requiring all necessary properties for chart rendering
  CandlestickChartPainter({
    required this.data,
    required this.progress,
    required this.style,
    required this.axisConfig,
    required this.padding,
    required this.showGrid,
    required this.scrollOffset,
    this.hoverPosition,
  });

  /// Main paint method called by Flutter's rendering system
  /// Handles the complete drawing of the chart including:
  /// - Hover effects and tooltips
  /// - Axes and grid
  /// - Candlesticks
  /// - Labels
  @override
  void paint(Canvas canvas, Size size) {
    // Draw the vertical line and check for candle tooltip
    if (hoverPosition != null) {
      final chartArea = Rect.fromLTWH(
        padding.left + axisConfig.yAxisWidth,
        padding.top,
        size.width - padding.horizontal - axisConfig.yAxisWidth,
        size.height - padding.vertical - axisConfig.xAxisHeight,
      );
      final verticalLineX = hoverPosition!.dx;

      final verticalLinePaint = Paint()
        ..color = style.verticalLineColor
        ..strokeWidth = style.verticalLineWidth;

      // Draw the vertical line
      canvas.drawLine(
        Offset(verticalLineX, chartArea.top),
        Offset(verticalLineX, chartArea.bottom),
        verticalLinePaint,
      );

      // Check if we are hovering over a candle
      final candleIndex = _getCandleIndexAtPosition(verticalLineX, chartArea);
      if (candleIndex != null) {
        // Draw the tooltip if hovering over a candle
        _drawTooltip(canvas, chartArea, candleIndex);
      }
    }

    if (data.isEmpty) return;

    final chartArea = Rect.fromLTWH(
      padding.left + axisConfig.yAxisWidth,
      padding.top,
      size.width - padding.horizontal - axisConfig.yAxisWidth,
      size.height - padding.vertical - axisConfig.xAxisHeight,
    );

    // Apply clipping to prevent overflow
    canvas.save();
    canvas.clipRect(chartArea);

    _drawAxes(canvas, chartArea);
    if (showGrid) _drawGrid(canvas, chartArea);
    _drawCandlesticks(canvas, chartArea);

    canvas.restore();

    // Draw axes labels outside the clipped area
    _drawYAxisLabels(canvas, chartArea);
    _drawXAxisLabels(canvas, chartArea);
  }

  /// Determines which candle is being hovered over based on x-coordinate
  /// Returns the index of the candle or null if none is found
  int? _getCandleIndexAtPosition(double x, Rect chartArea) {
    final candleWidth = style.candleWidth;
    final totalCandleWidth = candleWidth * (1 + style.spacing);

    // Calculate which candle's position is at x
    for (int i = 0; i < data.length; i++) {
      final candleX = _getCandleX(i, chartArea);
      if (x >= candleX && x <= candleX + candleWidth) {
        return i; // Return index of the candle
      }
    }
    return null; // No candle found at position
  }

  /// Draws the tooltip when hovering over a candle
  /// Shows date, open, high, low, and close values
  /// Includes styling for background, border, and text
  void _drawTooltip(Canvas canvas, Rect chartArea, int candleIndex) {
    final candle = data[candleIndex];
    final tooltipText =
        'Date: ${DateFormat('MMM dd, yyyy').format(candle.date)}\n'
        'Open: ${candle.open.toStringAsFixed(2)}\n'
        'High: ${candle.high.toStringAsFixed(2)}\n'
        'Low: ${candle.low.toStringAsFixed(2)}\n'
        'Close: ${candle.close.toStringAsFixed(2)}';

    // Calculate the position to draw the tooltip
    final tooltipOffset =
        Offset(hoverPosition!.dx + 10, hoverPosition!.dy + 10);

    // Create a text painter for the tooltip
    final textSpan =
        TextSpan(text: tooltipText, style: style.tooltipStyle.textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: ui.TextDirection.ltr,
      textAlign: TextAlign.left,
    );

    textPainter.layout();

    // Draw a background rectangle for the tooltip
    final tooltipRect = Rect.fromLTWH(
      tooltipOffset.dx,
      tooltipOffset.dy,
      textPainter.width + style.tooltipStyle.padding.horizontal,
      textPainter.height + style.tooltipStyle.padding.vertical,
    );

    final tooltipPaint = Paint()..color = style.tooltipStyle.backgroundColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        tooltipRect,
        Radius.circular(style.tooltipStyle.borderRadius),
      ),
      tooltipPaint,
    );

    // Draw the border (optional)
    final borderPaint = Paint()
      ..color = style.tooltipStyle.borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        tooltipRect,
        Radius.circular(style.tooltipStyle.borderRadius),
      ),
      borderPaint,
    );

    // Draw the tooltip text
    textPainter.paint(
      canvas,
      Offset(tooltipOffset.dx + style.tooltipStyle.padding.left,
          tooltipOffset.dy + style.tooltipStyle.padding.top),
    );
  }

  /// Draws the basic X and Y axes of the chart
  void _drawAxes(Canvas canvas, Rect chartArea) {
    final axisPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(chartArea.left, chartArea.top),
      Offset(chartArea.left, chartArea.bottom),
      axisPaint,
    );

    canvas.drawLine(
      Offset(chartArea.left, chartArea.bottom),
      Offset(chartArea.right, chartArea.bottom),
      axisPaint,
    );
  }

  /// Calculates the x-coordinate for a given candle index
  /// Takes into account candleWidth, spacing, and scroll position
  double _getCandleX(int index, Rect chartArea) {
    final candleWidth = style.candleWidth;
    final candleSpacing = candleWidth * style.spacing;
    final totalCandleWidth = candleWidth + candleSpacing;
    return chartArea.left + (index * totalCandleWidth) - scrollOffset;
  }

  /// Draws all visible candlesticks with animation
  /// Optimizes rendering by only drawing candlesticks in view
  /// Handles both bullish and bearish candlesticks
  void _drawCandlesticks(Canvas canvas, Rect chartArea) {
    final high = data.map((d) => d.high).reduce(max);
    final low = data.map((d) => d.low).reduce(min);
    final priceRange = high - low;

    // Calculate visible range
    final candleWidth = style.candleWidth;
    final totalCandleWidth = candleWidth * (1 + style.spacing);
    final startIdx = max(0, (scrollOffset / totalCandleWidth).floor());
    final endIdx = min(
      data.length,
      startIdx + (chartArea.width / totalCandleWidth).ceil() + 1,
    );

    // Only draw visible candlesticks
    for (int i = startIdx; i < endIdx; i++) {
      final candle = data[i];
      final x = _getCandleX(i, chartArea);

      // Skip if outside visible area
      if (x + candleWidth < chartArea.left || x > chartArea.right) continue;

      final wickPaint = Paint()
        ..color = candle.isBullish ? style.bullishColor : style.bearishColor
        ..strokeWidth = style.wickWidth;

      final candlePaint = Paint()
        ..color = candle.isBullish ? style.bullishColor : style.bearishColor
        ..style = PaintingStyle.fill;

      // Calculate Y positions with progress animation
      final highY = chartArea.bottom -
          ((candle.high - low) / priceRange * chartArea.height * progress);
      final lowY = chartArea.bottom -
          ((candle.low - low) / priceRange * chartArea.height * progress);
      final openY = chartArea.bottom -
          ((candle.open - low) / priceRange * chartArea.height * progress);
      final closeY = chartArea.bottom -
          ((candle.close - low) / priceRange * chartArea.height * progress);

      // Draw wick
      canvas.drawLine(
        Offset(x + candleWidth / 2, highY),
        Offset(x + candleWidth / 2, lowY),
        wickPaint,
      );

      // Draw candle body
      final bodyRect = Rect.fromLTWH(
        x,
        min(openY, closeY),
        candleWidth,
        (openY - closeY).abs(),
      );
      canvas.drawRect(bodyRect, candlePaint);
    }
  }

  // Previous grid and label drawing methods with scroll adjustments...
  void _drawGrid(Canvas canvas, Rect chartArea) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1;

    // Horizontal grid lines
    for (int i = 1; i < axisConfig.priceDivisions; i++) {
      final y =
          chartArea.top + (chartArea.height / axisConfig.priceDivisions * i);
      canvas.drawLine(
        Offset(chartArea.left, y),
        Offset(chartArea.right, y),
        paint,
      );
    }

    // Vertical grid lines adjusted for scroll
    final candleWidth = style.candleWidth;
    final totalCandleWidth = candleWidth * (1 + style.spacing);
    final startIdx = (scrollOffset / totalCandleWidth).floor();
    final visibleCount = (chartArea.width / totalCandleWidth).ceil();

    for (int i = startIdx; i < startIdx + visibleCount; i++) {
      if (i % axisConfig.dateDivisions == 0) {
        final x = _getCandleX(i, chartArea);
        canvas.drawLine(
          Offset(x, chartArea.top),
          Offset(x, chartArea.bottom),
          paint,
        );
      }
    }
  }

  /// Draws price labels on the Y-axis
  /// Uses provided formatter or defaults to 2 decimal places
  void _drawYAxisLabels(Canvas canvas, Rect chartArea) {
    final high = data.map((d) => d.high).reduce(max);
    final low = data.map((d) => d.low).reduce(min);
    final range = high - low;

    for (int i = 0; i <= axisConfig.priceDivisions; i++) {
      final price = low + (range * i / axisConfig.priceDivisions);
      final y =
          chartArea.bottom - (i / axisConfig.priceDivisions * chartArea.height);

      final label =
          axisConfig.priceFormatter?.call(price) ?? price.toStringAsFixed(2);
      final textSpan = TextSpan(
        text: label,
        style: axisConfig.labelStyle ??
            const TextStyle(color: Colors.grey, fontSize: 12),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: ui.TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(
          chartArea.left - textPainter.width - 8,
          y - textPainter.height / 2,
        ),
      );
    }
  }

  /// Draws date labels on the X-axis
  /// Adjusts label density based on visible area
  /// Handles scroll position when determining visible labels
  void _drawXAxisLabels(Canvas canvas, Rect chartArea) {
    final totalCandles = data.length;
    final candleWidth = style.candleWidth;
    final totalCandleWidth = candleWidth * (1 + style.spacing);

    // Calculate visible count for drawing labels
    final visibleCount = (chartArea.width / totalCandleWidth).ceil();

    // Define the date formatter
    final dateFormatter = DateFormat('MMM dd');

    // Determine how many labels to skip based on density
    final labelSkipCount = (visibleCount > 10) ? (visibleCount / 10).ceil() : 1;

    // Draw the labels based on the visible candles
    for (int i = 0; i < visibleCount; i++) {
      final index = i +
          (scrollOffset / totalCandleWidth).floor(); // Adjust index for scroll

      // Skip drawing labels based on density
      if (index < totalCandles && (i % labelSkipCount == 0)) {
        final x = _getCandleX(index, chartArea);
        final date = data[index].date;

        // Format the date using the formatter or a custom one if provided
        final label =
            axisConfig.dateFormatter?.call(date) ?? dateFormatter.format(date);

        final textSpan = TextSpan(
          text: label,
          style: axisConfig.labelStyle ??
              const TextStyle(color: Colors.grey, fontSize: 12),
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: ui.TextDirection.ltr,
        )..layout();

        // Center the label and ensure it's within bounds
        textPainter.paint(
          canvas,
          Offset(
            x - textPainter.width / 2, // Center the label over the candle
            chartArea.bottom + 8, // Place below the X-axis
          ),
        );
      }
    }
  }

  /// Determines whether the painter should repaint based on property changes
  @override
  bool shouldRepaint(CandlestickChartPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.data != data ||
        oldDelegate.style != style ||
        oldDelegate.showGrid != showGrid ||
        oldDelegate.scrollOffset != scrollOffset ||
        oldDelegate.hoverPosition !=
            hoverPosition; // Check hover position change
  }
}
