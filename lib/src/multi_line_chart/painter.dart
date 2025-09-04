import 'dart:math';

import 'package:flutter/material.dart';

import 'models.dart';

/// A custom painter for drawing a multi-line chart with optional features such as grid, legend, crosshair, and tooltips.
///
/// The chart is drawn on a [Canvas] and can handle multiple series of data points,
/// with options for customizing appearance and behavior based on the provided [MultiLineChartStyle].
class MultiLineChartPainter extends CustomPainter {
  /// The list of chart series to be drawn on the chart.
  final List<ChartSeries> series;

  /// The style settings for the chart, including colors, grid lines, tooltips, etc.
  final MultiLineChartStyle style;

  /// The progress value used for animation. Ranges from 0.0 (not started) to 1.0 (complete).
  final double progress;

  /// The current position of the crosshair, if enabled. Used for displaying tooltips.
  final Offset? crosshairPosition;

  /// The scale factor for zooming in/out of the chart.
  final double scale;

  /// The offset applied for panning the chart.
  final Offset panOffset;

  /// Constructs a [MultiLineChartPainter] with the required series and style, and optional parameters.
  MultiLineChartPainter({
    required this.series,
    required this.style,
    required this.progress,
    this.crosshairPosition,
    this.scale = 1.0,
    this.panOffset = Offset.zero,
  });

  /// Paints the chart on the given canvas with the specified size.
  ///
  /// This method handles drawing the grid, series lines, legend, and any tooltips or crosshairs if applicable.
  @override
  void paint(Canvas canvas, Size size) {
    // Calculate the chart area within the canvas size, accounting for legends and padding
    final chartArea = _getChartArea(size);

    // Save the current canvas state for transformations
    canvas.save();

    // Apply panning and scaling transformations
    canvas.translate(panOffset.dx, panOffset.dy);
    canvas.scale(scale);

    // Draw the grid if enabled in style
    if (style.showGrid) {
      _drawGrid(canvas, chartArea);
    }

    // Draw the chart series lines and points
    _drawSeries(canvas, chartArea);

    // Draw the legend if enabled
    if (style.showLegend) {
      _drawLegend(canvas, chartArea, size);
    }

    // Draw the crosshair and tooltip if a crosshair position is specified
    if (crosshairPosition != null && style.crosshair?.enabled == true) {
      _drawCrosshair(canvas, chartArea);

      // Find and draw tooltip data for the nearest point to the crosshair
      final tooltipData = _findNearestPoint(crosshairPosition!, chartArea);
      if (tooltipData != null) {
        _drawTooltip(canvas, tooltipData, chartArea);
      }
    }

    // Restore the canvas state to avoid affecting other drawings
    canvas.restore();
  }

  /// Finds the nearest data point to the provided hover point within the chart area.
  ///
  /// This method calculates the distance from the hover point to each data point in the series
  /// and returns the closest one, along with relevant tooltip data.

  /// Finds the nearest data point to the given hover point within the chart area.
  /// Returns the corresponding TooltipData if a nearby point is found within the threshold.
  TooltipData? _findNearestPoint(Offset hoverPoint, Rect chartArea) {
    TooltipData? nearest; // Variable to hold the nearest tooltip data
    double minDistance =
        double.infinity; // Initialize minimum distance as infinity

    // Iterate through each series in the chart
    for (int i = 0; i < series.length; i++) {
      final seriesData = series[i]; // Get current series data
      final color = seriesData.color ??
          style.colors[
              i % style.colors.length]; // Determine color for the series
      final points = _getSeriesPoints(
        chartArea,
        seriesData,
      ); // Retrieve the series points for the chart area

      // Iterate through each point in the series
      for (int j = 0; j < points.length; j++) {
        final distance = (points[j] - hoverPoint)
            .distance; // Calculate distance from hover point to current point

        // Check if this point is closer than the previous nearest and within the threshold
        if (distance < minDistance && distance < style.tooltipStyle.threshold) {
          minDistance = distance; // Update the minimum distance
          nearest = TooltipData(
            seriesName: seriesData.name,
            dataPoint:
                seriesData.dataPoints[j], // Store the relevant data point
            color: color,
            position: points[j], // Store the position of the nearest point
          );
        }
      }
    }

    return nearest; // Return the nearest tooltip data, or null if none found
  }

  /// Draws the tooltip on the canvas for the provided tooltip data.
  ///
  /// The tooltip displays the name of the series, the label, and the value of the data point.
  void _drawTooltip(Canvas canvas, TooltipData tooltipData, Rect chartArea) {
    final style = this.style.tooltipStyle; // Access the tooltip style settings

    // Prepare tooltip content
    final valueText = tooltipData.dataPoint.value.toStringAsFixed(
      1,
    ); // Format the value to one decimal place
    final labelText = tooltipData.dataPoint.label ??
        ''; // Get the label text, default to empty
    final text =
        '${tooltipData.seriesName}\n$labelText: $valueText'; // Combine series name, label, and value

    // Create a text painter to layout the text
    final textSpan = TextSpan(
      text: text,
      style: style.textStyle, // Use the specified text style
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr, // Set text direction
    )..layout(); // Layout the text for rendering

    // Calculate tooltip dimensions and position
    final padding = style.padding; // Get padding from tooltip style
    final tooltipWidth =
        textPainter.width + (padding * 2); // Calculate total width with padding
    final tooltipHeight = textPainter.height +
        (padding * 2); // Calculate total height with padding

    // Set initial tooltip position above the data point
    var tooltipX = tooltipData.position.dx;
    var tooltipY = tooltipData.position.dy - tooltipHeight - 10;

    // Adjust X position if tooltip exceeds chart area
    if (tooltipX + tooltipWidth > chartArea.right) {
      tooltipX = chartArea.right - tooltipWidth; // Shift left if it exceeds
    }
    // Adjust Y position if tooltip goes above chart area
    if (tooltipY < chartArea.top) {
      tooltipY = tooltipData.position.dy + 10; // Shift down if it exceeds
    }

    // Draw shadow for the tooltip
    final shadowPaint = Paint()
      ..color = style.shadowColor.withValues(alpha: 0.1)
      ..maskFilter = MaskFilter.blur(
        BlurStyle.normal,
        style.shadowBlurRadius,
      );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          tooltipX,
          tooltipY,
          tooltipWidth,
          tooltipHeight,
        ).shift(const Offset(0, 2)), // Offset shadow slightly down
        Radius.circular(style.borderRadius), // Use rounded corners for shadow
      ),
      shadowPaint, // Paint the shadow
    );

    // Draw background for the tooltip
    final bgPaint = Paint()
      ..color = style.backgroundColor.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(tooltipX, tooltipY, tooltipWidth, tooltipHeight),
        Radius.circular(style.borderRadius), // Use rounded corners
      ),
      bgPaint, // Paint the background
    );

    // Draw color indicator for the tooltip
    final indicatorPaint = Paint()
      ..color = tooltipData.color // Set the color for the indicator
      ..style = PaintingStyle.fill; // Fill the indicator
    canvas.drawRect(
      Rect.fromLTWH(
        tooltipX,
        tooltipY +
            tooltipHeight -
            style.indicatorHeight, // Position at the bottom of the tooltip
        tooltipWidth,
        style.indicatorHeight, // Set height from tooltip style
      ),
      indicatorPaint, // Paint the color indicator
    );

    // Draw the tooltip text
    textPainter.paint(
      canvas,
      Offset(
        tooltipX + padding,
        tooltipY + padding,
      ), // Position text with padding
    );
  }

  /// Draws all the series lines and points on the canvas.
  void _drawSeries(Canvas canvas, Rect chartArea) {
    for (int i = 0; i < series.length; i++) {
      final seriesData = series[i];
      final color = seriesData.color ?? style.colors[i % style.colors.length];
      final showPoints = seriesData.showPoints ?? style.showPoints;
      final smoothLine = seriesData.smoothLine ?? style.smoothLines;
      final lineWidth = seriesData.lineWidth ?? style.defaultLineWidth;

      _drawLine(canvas, chartArea, seriesData, color, lineWidth, smoothLine);

      if (showPoints) {
        _drawPoints(canvas, chartArea, seriesData, color);
      }
    }
  }

  /// Calculates and returns the chart area as a rectangle based on the size and style settings.
  Rect _getChartArea(Size size) {
    double legendHeight = 0;
    double legendWidth = 0;
    // Determine dimensions for the legend based on its position and visibility
    if (style.showLegend) {
      switch (style.legendPosition) {
        case LegendPosition.top:
        case LegendPosition.bottom:
          legendHeight = 40; // Fixed height for top/bottom legends
          break;
        case LegendPosition.left:
        case LegendPosition.right:
          legendWidth = 100; // Fixed width for left/right legends
          break;
      }
    }
    // Create a rectangle representing the chart area within the canvas
    return Rect.fromLTWH(
      style.padding.left +
          legendWidth * (style.legendPosition == LegendPosition.left ? 1 : 0),
      style.padding.top +
          legendHeight * (style.legendPosition == LegendPosition.top ? 1 : 0),
      size.width - style.padding.horizontal - legendWidth,
      size.height - style.padding.vertical - legendHeight,
    );
  }

  /// Draws the grid lines on the canvas within the chart area.
  /// Draws the grid on the canvas within the defined chart area.
  /// It also includes horizontal and vertical labels for the axes.
  void _drawGrid(Canvas canvas, Rect chartArea) {
    final paint = Paint()
      ..color = style.gridColor.withValues(alpha: 0.2)
      ..strokeWidth = style.gridLineWidth;

    // Draw horizontal grid lines
    for (int i = 0; i <= style.horizontalGridLines; i++) {
      final y = chartArea.top +
          (chartArea.height / style.horizontalGridLines) *
              i; // Calculate Y position for grid line
      canvas.drawLine(
        Offset(chartArea.left, y), // Start point (left)
        Offset(chartArea.right, y), // End point (right)
        paint,
      );

      // Draw Y-axis labels
      if (series.isNotEmpty) {
        final maxValue = _getMaxValue(); // Get maximum value from the series
        final minValue = _getMinValue(); // Get minimum value from the series
        final valueRange = maxValue - minValue; // Calculate range of values
        final value = maxValue -
            (valueRange /
                style.horizontalGridLines *
                i); // Calculate value for label

        final textSpan = TextSpan(
          text: value.toStringAsFixed(1), // Format value to one decimal place
          style: style.labelStyle ??
              TextStyle(
                color: style.gridColor,
                fontSize: 10,
              ), // Use custom label style or default
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr, // Left-to-right text direction
        )..layout(); // Layout the text
        textPainter.paint(
          canvas,
          Offset(
            chartArea.left -
                textPainter.width -
                5, // Position label to the left of the grid line
            y - textPainter.height / 2,
          ), // Center vertically
        );
      }
    }

    // Draw vertical grid lines
    if (series.isNotEmpty && series[0].dataPoints.isNotEmpty) {
      final pointCount = series[0]
          .dataPoints
          .length; // Get the number of data points in the first series
      for (int i = 0; i < pointCount; i++) {
        final x = _getXCoordinate(
          chartArea,
          i,
          pointCount,
        ); // Calculate X position for grid line
        canvas.drawLine(
          Offset(x, chartArea.top), // Start point (top)
          Offset(x, chartArea.bottom), // End point (bottom)
          paint,
        );

        // Draw X-axis labels
        final label =
            series[0].dataPoints[i].label; // Get label for current data point
        if (label != null) {
          final textSpan = TextSpan(
            text: label, // Use the label from the data point
            style: style.labelStyle ??
                TextStyle(
                  color: style.gridColor,
                  fontSize: 10,
                ), // Use custom label style or default
          );
          final textPainter = TextPainter(
            text: textSpan,
            textDirection: TextDirection.ltr, // Left-to-right text direction
          )..layout(); // Layout the text
          textPainter.paint(
            canvas,
            Offset(
              x - textPainter.width / 2,
              chartArea.bottom + 5,
            ), // Center label horizontally below the grid line
          );
        }
      }
    }
  }

  /// Draws a line on the canvas for the given series data with specified styling.
  /// Supports smooth and straight line rendering.
  void _drawLine(
    Canvas canvas,
    Rect chartArea,
    ChartSeries seriesData,
    Color color,
    double lineWidth,
    bool smoothLine,
  ) {
    final linePaint = Paint()
      ..color = color // Set color for the line
      ..strokeWidth = lineWidth // Set width for the line
      ..strokeCap = StrokeCap.round // Set line cap to round
      ..strokeJoin = StrokeJoin.round // Set line join to round
      ..style = PaintingStyle.stroke; // Set paint style to stroke

    final path = Path(); // Create a new path for the line
    final points = _getSeriesPoints(
      chartArea,
      seriesData,
    ); // Get calculated points for the series

    if (points.isEmpty) return; // Exit if there are no points to draw

    // Choose the appropriate line drawing method based on smoothLine flag
    if (smoothLine) {
      _drawSmoothLine(path, points); // Draw smooth line
    } else {
      _drawStraightLine(path, points); // Draw straight line
    }

    // Apply animation progress to the path
    final pathMetrics = path
        .computeMetrics()
        .first; // Get the path metrics for the animated path
    final animatedPath = pathMetrics.extractPath(
      0.0,
      pathMetrics.length *
          progress, // Calculate length of the animated path based on progress
    );

    canvas.drawPath(
      animatedPath,
      linePaint,
    ); // Draw the animated path on the canvas
  }

  /// Draws a straight line connecting the given points in the path.
  void _drawStraightLine(Path path, List<Offset> points) {
    path.moveTo(points.first.dx, points.first.dy); // Move to the first point
    for (int i = 1; i < points.length; i++) {
      path.lineTo(
        points[i].dx,
        points[i].dy,
      ); // Connect each subsequent point with a line
    }
  }

  /// Draws a smooth line connecting the given points using cubic Bezier curves.
  void _drawSmoothLine(Path path, List<Offset> points) {
    if (points.length < 2) return; // Exit if fewer than 2 points

    path.moveTo(points[0].dx, points[0].dy); // Move to the first point

    for (int i = 0; i < points.length - 1; i++) {
      final current = points[i]; // Current point
      final next = points[i + 1]; // Next point
      final controlPoint1 = Offset(
        current.dx +
            (next.dx - current.dx) / 2, // Control point for first curve
        current.dy,
      );
      final controlPoint2 = Offset(
        current.dx +
            (next.dx - current.dx) / 2, // Control point for second curve
        next.dy,
      );

      // Create a cubic Bezier curve between the control points and the next point
      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        next.dx,
        next.dy,
      );
    }
  }

  /// Draws points on the canvas for the specified series data, including a border around each point.
  void _drawPoints(
    Canvas canvas,
    Rect chartArea,
    ChartSeries seriesData,
    Color color,
  ) {
    final pointPaint = Paint()
      ..color = color // Set color for the points
      ..style = PaintingStyle.fill; // Set paint style to fill

    final points = _getSeriesPoints(
      chartArea,
      seriesData,
    ); // Get calculated points for the series
    final progressPoints = (points.length * progress)
        .floor(); // Calculate number of points to draw based on progress
    final pointSize = seriesData.pointSize ??
        style.defaultPointSize; // Get point size, default if not specified

    for (int i = 0; i < progressPoints; i++) {
      canvas.drawCircle(
        points[i],
        pointSize,
        pointPaint,
      ); // Draw the filled point

      // Draw white border around points
      final borderPaint = Paint()
        ..color = style.backgroundColor // Set border color to background color
        ..style = PaintingStyle.stroke // Set paint style to stroke
        ..strokeWidth = 2; // Set border width
      canvas.drawCircle(
        points[i],
        pointSize,
        borderPaint,
      ); // Draw the border around the point
    }
  }

  /// Draws the legend on the canvas based on the series data and style settings.
  /// Draws the legend on the canvas within the defined chart area.
  /// The legend items are based on the series data and can be displayed
  /// in different orientations depending on the specified legend position.
  void _drawLegend(Canvas canvas, Rect chartArea, Size size) {
    // Define the text style for legend items, using default if not provided
    final legendStyle =
        style.legendStyle ?? TextStyle(color: style.gridColor, fontSize: 12);
    const itemSpacing = 20.0; // Space between legend items
    const itemHeight = 20.0; // Height of each legend item

    // Create a list of legend items from the series data
    List<LegendItem> legendItems = series.asMap().entries.map((entry) {
      final index = entry.key; // Get the index of the series
      final series = entry.value; // Get the series object
      return LegendItem(
        text: series.name, // Use the series name for the legend text
        color: series.color ??
            style.colors[index %
                style.colors.length], // Use series color or default color
      );
    }).toList();

    // Determine the legend position and draw accordingly
    switch (style.legendPosition) {
      case LegendPosition.top:
      case LegendPosition.bottom:
        _drawHorizontalLegend(
          canvas,
          legendItems,
          legendStyle,
          itemSpacing,
          itemHeight,
          chartArea,
          size,
        );
        break;
      case LegendPosition.left:
      case LegendPosition.right:
        _drawVerticalLegend(
          canvas,
          legendItems,
          legendStyle,
          itemSpacing,
          itemHeight,
          chartArea,
          size,
        );
        break;
    }
  }

  /// Draws a horizontal legend on the canvas.
  /// Items are arranged horizontally, with markers and corresponding text.
  void _drawHorizontalLegend(
    Canvas canvas,
    List<LegendItem> items,
    TextStyle textStyle, // Renamed from 'style' to 'textStyle' for clarity
    double spacing, // Space between items
    double height, // Height of each legend item
    Rect chartArea, // Area of the chart to determine drawing limits
    Size size, // Size of the overall drawing area
  ) {
    double xOffset =
        chartArea.left; // Start drawing from the left of the chart area
    // Determine the Y position based on the legend position
    final y = style.legendPosition == LegendPosition.top
        ? style.padding.top // Position at the top if specified
        : size.height -
            height -
            style.padding.bottom; // Position at the bottom otherwise

    for (final item in items) {
      // Draw legend marker
      final markerPaint = Paint()
        ..color = item.color // Set the color for the legend marker
        ..style = PaintingStyle.fill; // Set marker style to fill

      // Draw the circular marker for the legend item
      canvas.drawCircle(
        Offset(
          xOffset + height / 2,
          y + height / 2,
        ), // Center the marker vertically
        height / 4, // Set marker radius to one-fourth of the item height
        markerPaint, // Use the defined paint for the marker
      );

      // Draw legend text
      final textSpan = TextSpan(
        text: item.text,
        style: textStyle,
      ); // Create text span with the item text
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr, // Left-to-right text direction
      )..layout(); // Layout the text for rendering

      // Position the text next to the marker
      textPainter.paint(
        canvas,
        Offset(
          xOffset + height + 5,
          y + (height - textPainter.height) / 2,
        ), // Center text vertically
      );

      // Increment the xOffset for the next item to avoid overlap
      xOffset += height +
          textPainter.width +
          spacing; // Adjust xOffset for the next legend item
    }
  }

  /// Draws a vertical legend on the canvas.
  /// Items are arranged vertically, with markers and corresponding text.
  void _drawVerticalLegend(
    Canvas canvas,
    List<LegendItem> items,
    TextStyle textStyle, // Renamed from 'style' to 'textStyle' for clarity
    double spacing, // Space between items
    double height, // Height of each legend item
    Rect chartArea, // Area of the chart to determine drawing limits
    Size size, // Size of the overall drawing area
  ) {
    // Determine the X position based on the legend position
    final x = style.legendPosition == LegendPosition.left
        ? style.padding.left // Position on the left side if specified
        : size.width -
            100 -
            style.padding.right; // Adjust X position for the right side

    double yOffset =
        chartArea.top; // Start drawing from the top of the chart area

    for (final item in items) {
      // Draw legend marker
      final markerPaint = Paint()
        ..color = item.color // Set the color for the legend marker
        ..style = PaintingStyle.fill; // Set marker style to fill

      // Draw the circular marker for the legend item
      canvas.drawCircle(
        Offset(
          x + height / 2,
          yOffset + height / 2,
        ), // Center the marker vertically
        height / 4, // Set marker radius to one-fourth of the item height
        markerPaint, // Use the defined paint for the marker
      );

      // Draw legend text
      final textSpan = TextSpan(
        text: item.text,
        style: textStyle,
      ); // Create text span with the item text
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr, // Left-to-right text direction
      )..layout(); // Layout the text for rendering

      // Position the text next to the marker
      textPainter.paint(
        canvas,
        Offset(
          x + height + 5,
          yOffset + (height - textPainter.height) / 2,
        ), // Center text vertically
      );

      // Increment the yOffset for the next item to avoid overlap
      yOffset += height + spacing; // Adjust yOffset for the next legend item
    }
  }

  /// Draws the crosshair on the canvas, indicating the current position
  /// within the chart area. If the crosshair position is null or
  /// styling options are not defined, the method returns early.
  void _drawCrosshair(Canvas canvas, Rect chartArea) {
    // Exit if crosshair position or styling is not defined
    if (crosshairPosition == null || style.crosshair == null) return;

    // Set up the paint properties for the crosshair lines
    final paint = Paint()
      ..color = style.crosshair!.lineColor // Color for the crosshair lines
      ..strokeWidth =
          style.crosshair!.lineWidth; // Width of the crosshair lines

    // Draw the vertical crosshair line
    canvas.drawLine(
      Offset(crosshairPosition!.dx, chartArea.top), // Start at the top
      Offset(crosshairPosition!.dx, chartArea.bottom), // End at the bottom
      paint,
    );

    // Draw the horizontal crosshair line
    canvas.drawLine(
      Offset(chartArea.left, crosshairPosition!.dy), // Start at the left
      Offset(chartArea.right, crosshairPosition!.dy), // End at the right
      paint,
    );

    // If enabled, draw the crosshair labels
    if (style.crosshair!.showLabel) {
      _drawCrosshairLabels(canvas, chartArea);
    }
  }

  /// Draws labels for the crosshair at its current position,
  /// including the value represented by the crosshair.
  /// The labels are drawn on both the X and Y axes.
  void _drawCrosshairLabels(Canvas canvas, Rect chartArea) {
    // Exit if crosshair position is not defined
    if (crosshairPosition == null) return;

    // Retrieve the value at the current crosshair position
    final value = _getValueAtPosition(crosshairPosition!);
    final label = value.toStringAsFixed(1); // Format value for display

    // Define text style for the crosshair label, using default if not provided
    final textStyle = style.crosshair!.labelStyle ??
        TextStyle(color: style.crosshair!.lineColor, fontSize: 10);
    final textSpan = TextSpan(text: label, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr, // Left-to-right text direction
    )..layout(); // Layout the text for rendering

    // Draw background for the label
    final bgPaint = Paint()
      ..color = style.backgroundColor // Background color for label
      ..style = PaintingStyle.fill; // Fill style for background

    // Draw Y-axis label
    final yLabelRect = Rect.fromLTWH(
      chartArea.left -
          textPainter.width -
          25, // Position to the left of the chart
      crosshairPosition!.dy - textPainter.height / 2, // Center vertically
      textPainter.width + 10, // Width of the background rectangle
      textPainter.height, // Height of the background rectangle
    );
    canvas.drawRect(yLabelRect, bgPaint); // Draw the background rectangle
    textPainter.paint(
      canvas,
      Offset(
        chartArea.left - textPainter.width - 20,
        crosshairPosition!.dy - textPainter.height / 2,
      ), // Position the text
    );

    // Draw X-axis label
    final xLabelRect = Rect.fromLTWH(
      crosshairPosition!.dx - textPainter.width / 2, // Center horizontally
      chartArea.bottom + 5, // Position slightly below the chart
      textPainter.width + 10, // Width of the background rectangle
      textPainter.height, // Height of the background rectangle
    );
    canvas.drawRect(xLabelRect, bgPaint); // Draw the background rectangle
    textPainter.paint(
      canvas,
      Offset(
        crosshairPosition!.dx - textPainter.width / 2,
        chartArea.bottom + 5,
      ), // Position the text
    );
  }

  /// Returns a list of points representing the data points for the series
  /// within the given chart area. The points are normalized based on the
  /// chart's value range and position.
  List<Offset> _getSeriesPoints(Rect chartArea, ChartSeries seriesData) {
    // if (seriesData.dataPoints.isEmpty)
    //   return []; // Return empty if no data points

    final maxValue = _getMaxValue(); // Get the maximum value in the series
    final minValue = _getMinValue(); // Get the minimum value in the series
    final valueRange = maxValue - minValue; // Calculate the value range

    // Generate the list of points based on the data points
    return List.generate(seriesData.dataPoints.length, (i) {
      final x = _getXCoordinate(
        chartArea,
        i,
        seriesData.dataPoints.length,
      ); // Get X coordinate
      // Calculate Y position based on normalized value
      final normalizedValue =
          (seriesData.dataPoints[i].value - minValue) / valueRange;
      final y = chartArea.bottom -
          (normalizedValue * chartArea.height); // Invert Y for drawing
      return Offset(x, y); // Return the point as Offset
    });
  }

  /// Computes the X coordinate for a given index within the chart area,
  /// ensuring even spacing of points across the width of the chart.
  double _getXCoordinate(Rect chartArea, int index, int totalPoints) {
    return chartArea.left +
        (chartArea.width / (totalPoints - 1)) * index; // Calculate X coordinate
  }

  /// Returns the maximum value among all data points across all series.
  double _getMaxValue() {
    return series
        .expand((s) => s.dataPoints)
        .map((p) => p.value)
        .reduce(max); // Get max value
  }

  /// Returns the minimum value among all data points across all series.
  /// If forced to zero, returns zero instead of the minimum.
  double _getMinValue() {
    if (style.forceYAxisFromZero) {
      return 0; // Force Y-axis to start from zero
    }
    return series
        .expand((s) => s.dataPoints)
        .map((p) => p.value)
        .reduce(min); // Get min value
  }

  /// Retrieves the value represented at the specified position within the chart.
  /// The value is normalized based on the position of the crosshair in the chart area.
  double _getValueAtPosition(Offset position) {
    final chartArea = _getChartArea(
      Size(
        position.dx + style.padding.horizontal,
        position.dy + style.padding.vertical,
      ),
    );

    final maxValue = _getMaxValue(); // Get max value
    final minValue = _getMinValue(); // Get min value
    final valueRange = maxValue - minValue; // Calculate value range

    // Normalize the position to find the corresponding value
    final normalizedValue = (chartArea.bottom - position.dy) / chartArea.height;
    return minValue + (valueRange * normalizedValue); // Calculate actual value
  }

  /// Determines whether the chart should repaint based on changes in properties.
  /// Returns true if any relevant property has changed.
  @override
  bool shouldRepaint(MultiLineChartPainter oldDelegate) {
    return oldDelegate.progress !=
            progress || // Check if animation progress has changed
        oldDelegate.series != series || // Check if the series data has changed
        oldDelegate.style != style || // Check if the styling has changed
        oldDelegate.crosshairPosition !=
            crosshairPosition || // Check if crosshair position has changed
        oldDelegate.scale != scale || // Check if the scale has changed
        oldDelegate.panOffset !=
            panOffset; // Check if the pan offset has changed
  }
}
