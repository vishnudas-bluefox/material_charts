import 'dart:math';

import 'package:flutter/material.dart';

class HollowSemiCircleChart extends CustomPainter {
  final double percentage;
  final Color activeColor;
  final Color inactiveColor;
  final double hollowRadius;

  HollowSemiCircleChart({
    required this.percentage,
    required this.activeColor,
    required this.inactiveColor,
    required this.hollowRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final outerRadius = size.height;
    final innerRadius = outerRadius * hollowRadius;
    final strokeWidth = outerRadius - innerRadius;

    // Draw the background (inactive) arc
    final backgroundPaint = Paint()
      ..color = inactiveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt; // Changed to butt for square ends

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: (innerRadius + outerRadius) / 2),
      pi,
      pi,
      false,
      backgroundPaint,
    );

    // Draw the progress (active) arc
    if (percentage > 0) {
      final progressPaint = Paint()
        ..color = activeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt; // Changed to butt for square ends

      final progressAngle = (percentage / 100) * pi;

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

  @override
  bool shouldRepaint(HollowSemiCircleChart oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor ||
        oldDelegate.hollowRadius != hollowRadius;
  }
}