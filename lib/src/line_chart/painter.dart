import 'dart:math';
import 'package:flutter/material.dart';
import 'package:material_charts/src/line_chart/models.dart';

/// A custom painter for rendering a line chart.
/// This class extends [CustomPainter] and is responsible for drawing the chart,
/// including the lines, points, grid, and labels based on the provided data.
class LineChartPainter extends CustomPainter {
  final List<ChartData> data; // List of chart data points to be plotted
  final double progress; // Progress indicator for animated drawing
  final LineChartStyle style; // Style configurations for the chart
  final bool showPoints; // Flag to determine whether to show points
  final bool showGrid; // Flag to determine whether to show grid lines
  final EdgeInsets padding; // Padding around the chart
  final int horizontalGridLines; // Number of horizontal grid lines to draw

  /// Constructs a [LineChartPainter] with the necessary properties.
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
    // Return early if there is no data to draw
    if (data.isEmpty) return;

    // Define the area in which the chart will be drawn, considering padding
    final chartArea = Rect.fromLTWH(
      padding.left,
      padding.top,
      size.width - padding.horizontal,
      size.height - padding.vertical,
    );

    // Draw the grid if the flag is set
    if (showGrid) {
      _drawGrid(canvas, chartArea);
    }

    // Draw the line connecting the data points
    _drawLine(canvas, chartArea);

    // Draw the points at each data position if the flag is set
    if (showPoints) {
      _drawPoints(canvas, chartArea);
    }

    // Draw labels for each data point along the X-axis
    _drawLabels(canvas, chartArea);
  }

  /// Draws the grid lines (both horizontal and vertical) in the chart area.
  void _drawGrid(Canvas canvas, Rect chartArea) {
    final paint = Paint()
      ..color =
          style.gridColor.withOpacity(0.2) // Set the grid color with opacity
      ..strokeWidth = 1; // Set the stroke width for grid lines

    // Draw horizontal grid lines
    for (int i = 0; i <= horizontalGridLines; i++) {
      final y = chartArea.top + (chartArea.height / horizontalGridLines) * i;
      canvas.drawLine(
        Offset(chartArea.left, y),
        Offset(chartArea.right, y),
        paint,
      );
    }

    // Draw vertical grid lines at each data point
    for (int i = 0; i < data.length; i++) {
      final x = chartArea.left + (chartArea.width / (data.length - 1)) * i;
      canvas.drawLine(
        Offset(x, chartArea.top),
        Offset(x, chartArea.bottom),
        paint,
      );
    }
  }

  /// Draws the line connecting the data points based on the current progress.
  void _drawLine(Canvas canvas, Rect chartArea) {
    final linePaint = Paint()
      ..color = style.lineColor // Set the line color
      ..strokeWidth = style.strokeWidth // Set the stroke width
      ..strokeCap = StrokeCap.round // Set stroke cap to round
      ..strokeJoin = StrokeJoin.round // Set stroke join to round
      ..style = PaintingStyle.stroke; // Set paint style to stroke

    final path = Path(); // Create a new path for the line
    final points =
        _getPointCoordinates(chartArea); // Get coordinates of data points

    // Create the path by connecting all the points
    for (int i = 0; i < points.length; i++) {
      final point = points[i];
      if (i == 0) {
        path.moveTo(point.dx, point.dy); // Move to the first point
      } else {
        path.lineTo(point.dx, point.dy); // Draw line to subsequent points
      }
    }

    // Extract the portion of the path to be drawn based on progress
    final pathMetrics = path.computeMetrics().first;
    final extractPath = pathMetrics.extractPath(
      0.0,
      pathMetrics.length *
          progress, // Determine the length to draw based on progress
    );

    // Draw the path on the canvas
    canvas.drawPath(extractPath, linePaint);
  }

  /// Draws the individual points on the line chart.
  void _drawPoints(Canvas canvas, Rect chartArea) {
    final pointPaint = Paint()
      ..color = style.pointColor // Set the point color
      ..style = PaintingStyle.fill; // Set paint style to fill

    final points =
        _getPointCoordinates(chartArea); // Get coordinates of data points
    final progressPoints = (points.length * progress)
        .floor(); // Determine how many points to draw based on progress

    // Draw each point on the canvas
    for (int i = 0; i < progressPoints; i++) {
      canvas.drawCircle(points[i], style.pointRadius,
          pointPaint); // Draw circle for each point
    }
  }

  /// Draws the labels for each data point along the X-axis.
  void _drawLabels(Canvas canvas, Rect chartArea) {
    final textStyle = style.labelStyle ??
        TextStyle(
          color: style.lineColor, // Default label color if none is provided
          fontSize: 12, // Default font size
        );

    // Draw each label based on the data points
    for (int i = 0; i < data.length; i++) {
      final x = chartArea.left +
          (chartArea.width / (data.length - 1)) * i; // Calculate the X position
      final textSpan = TextSpan(
        text: data[i].label, // Set the label text
        style: textStyle, // Apply the text style
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout(); // Layout the text for drawing

      // Paint the text on the canvas, centered below each point
      textPainter.paint(
        canvas,
        Offset(
          x - textPainter.width / 2,
          chartArea.bottom + padding.bottom / 2,
        ),
      );
    }
  }

  /// Computes the coordinates of the data points based on the chart area.
  List<Offset> _getPointCoordinates(Rect chartArea) {
    if (data.isEmpty) return []; // Return empty if no data

    final maxValue =
        data.map((point) => point.value).reduce(max); // Find max value
    final minValue =
        data.map((point) => point.value).reduce(min); // Find min value
    final valueRange = maxValue - minValue; // Calculate range of values

    // Generate a list of Offset points based on the normalized values
    return List.generate(data.length, (i) {
      final x = chartArea.left +
          (chartArea.width / (data.length - 1)) * i; // Calculate X position
      final normalizedValue =
          (data[i].value - minValue) / valueRange; // Normalize Y value
      final y = chartArea.bottom -
          (normalizedValue * chartArea.height); // Calculate Y position
      return Offset(x, y); // Return the Offset point
    });
  }

  @override
  bool shouldRepaint(LineChartPainter oldDelegate) {
    // Determine if the painter should repaint based on changes in properties
    return oldDelegate.progress != progress ||
        oldDelegate.data != data ||
        oldDelegate.style != style ||
        oldDelegate.showPoints != showPoints ||
        oldDelegate.showGrid != showGrid ||
        oldDelegate.horizontalGridLines != horizontalGridLines;
  }
}
