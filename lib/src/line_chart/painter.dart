import 'dart:math';
import 'package:flutter/material.dart';

import 'models.dart';

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
      ..color = style.gridColor.withOpacity(
        0.2,
      ) // Set the grid color with opacity
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
      ..style = PaintingStyle.stroke; // Set paint style to stroke

    // Apply rounded points styling if enabled
    if (style.roundedPoints) {
      linePaint.strokeCap = StrokeCap.round; // Set stroke cap to round
      linePaint.strokeJoin = StrokeJoin.round; // Set stroke join to round
    } else {
      linePaint.strokeCap = StrokeCap.butt; // Set stroke cap to butt
      linePaint.strokeJoin = StrokeJoin.miter; // Set stroke join to miter
    }

    final points = _getPointCoordinates(
      chartArea,
    ); // Get coordinates of data points

    final Path path;
    if (style.useCurvedLines) {
      path = _createCurvedPath(points); // Create curved path
    } else {
      path = _createStraightPath(points); // Create straight path
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

  /// Creates a straight line path connecting all points.
  Path _createStraightPath(List<Offset> points) {
    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final point = points[i];
      if (i == 0) {
        path.moveTo(point.dx, point.dy); // Move to the first point
      } else {
        path.lineTo(point.dx, point.dy); // Draw line to subsequent points
      }
    }
    return path;
  }

  /// Creates a curved/smooth line path connecting all points using bezier curves.
  Path _createCurvedPath(List<Offset> points) {
    if (points.length < 2) return _createStraightPath(points);

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    if (points.length == 2) {
      // For only two points, draw a straight line
      path.lineTo(points[1].dx, points[1].dy);
      return path;
    }

    // Create smooth curves using quadratic bezier curves
    for (int i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];

      if (i == 0) {
        // First segment - use quadratic curve
        final controlPoint = _getControlPoint(
          current,
          next,
          points[i + 2],
          true,
        );
        path.quadraticBezierTo(
          controlPoint.dx,
          controlPoint.dy,
          (current.dx + next.dx) / 2,
          (current.dy + next.dy) / 2,
        );
      } else if (i == points.length - 2) {
        // Last segment - complete the curve to the final point
        final controlPoint = _getControlPoint(
          points[i - 1],
          current,
          next,
          false,
        );
        path.quadraticBezierTo(
          controlPoint.dx,
          controlPoint.dy,
          next.dx,
          next.dy,
        );
      } else {
        // Middle segments - use smooth curves
        final controlPoint = _getControlPoint(
          points[i - 1],
          current,
          next,
          false,
        );
        path.quadraticBezierTo(
          controlPoint.dx,
          controlPoint.dy,
          (current.dx + next.dx) / 2,
          (current.dy + next.dy) / 2,
        );
      }
    }

    return path;
  }

  /// Calculates a control point for smooth bezier curves.
  Offset _getControlPoint(
    Offset prev,
    Offset current,
    Offset next,
    bool isFirst,
  ) {
    final intensity = style.curveIntensity.clamp(0.0, 1.0);

    if (isFirst) {
      // For the first point, create control point based on current and next
      final direction = Offset(next.dx - current.dx, next.dy - current.dy);
      return Offset(
        current.dx + direction.dx * intensity * 0.3,
        current.dy + direction.dy * intensity * 0.3,
      );
    } else {
      // For middle points, create smooth control point
      final prevDirection = Offset(current.dx - prev.dx, current.dy - prev.dy);
      final nextDirection = Offset(next.dx - current.dx, next.dy - current.dy);

      // Average the directions for smooth transition
      final avgDirection = Offset(
        (prevDirection.dx + nextDirection.dx) / 2,
        (prevDirection.dy + nextDirection.dy) / 2,
      );

      return Offset(
        current.dx + avgDirection.dx * intensity * 0.3,
        current.dy + avgDirection.dy * intensity * 0.3,
      );
    }
  }

  /// Draws the individual points on the line chart.
  void _drawPoints(Canvas canvas, Rect chartArea) {
    final pointPaint = Paint()
      ..color = style.pointColor // Set the point color
      ..style = PaintingStyle.fill; // Set paint style to fill

    final points = _getPointCoordinates(
      chartArea,
    ); // Get coordinates of data points
    final progressPoints = (points.length * progress)
        .floor(); // Determine how many points to draw based on progress

    // Draw each point on the canvas
    for (int i = 0; i < progressPoints; i++) {
      canvas.drawCircle(
        points[i],
        style.pointRadius,
        pointPaint,
      ); // Draw circle for each point
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

    // Handle case where all values are the same
    if (valueRange == 0) {
      return List.generate(data.length, (i) {
        final x = chartArea.left + (chartArea.width / (data.length - 1)) * i;
        final y = chartArea.top + chartArea.height / 2;
        return Offset(x, y);
      });
    }

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
