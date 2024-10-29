import 'dart:math';
import 'package:flutter/material.dart';

/// Custom painter for rendering a hollow semi-circle chart.
class HollowSemiCircleChart extends CustomPainter {
  /// The percentage of the chart that is filled.
  final double percentage;

  /// Color for the active (filled) section of the chart.
  final Color activeColor;

  /// Color for the inactive (unfilled) section of the chart.
  final Color inactiveColor;

  /// The radius ratio for the hollow section of the chart (0 < hollowRadius < 1).
  final double hollowRadius;

  /// Constructs a HollowSemiCircleChart object with required parameters.
  HollowSemiCircleChart({
    required this.percentage,
    required this.activeColor,
    required this.inactiveColor,
    required this.hollowRadius,
  });

  /// Paints the chart onto the canvas.
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final outerRadius = size.height; // The outer radius is equal to height
    final innerRadius = outerRadius * hollowRadius; // Hollow inner radius
    final strokeWidth = outerRadius - innerRadius; // Width of the stroke

    // Draw the background (inactive) arc
    final backgroundPaint = Paint()
      ..color = inactiveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt; // Square ends for the arc

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: (innerRadius + outerRadius) / 2),
      pi, // Start angle (left side)
      pi, // Sweep angle (half-circle)
      false,
      backgroundPaint,
    );

    // Draw the progress (active) arc if the percentage is greater than 0
    if (percentage > 0) {
      final progressPaint = Paint()
        ..color = activeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      final progressAngle = (percentage / 100) *
          pi; // Calculate the sweep angle based on percentage

      canvas.drawArc(
        Rect.fromCircle(
            center: center, radius: (innerRadius + outerRadius) / 2),
        pi,
        progressAngle,
        false,
        progressPaint,
      );
    }
  }

  /// Determines whether the painter should repaint when the properties change.
  @override
  bool shouldRepaint(HollowSemiCircleChart oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor ||
        oldDelegate.hollowRadius != hollowRadius;
  }
}
