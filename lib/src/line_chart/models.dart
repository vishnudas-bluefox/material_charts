
import 'package:flutter/material.dart';

/// Model class for chart data points
class ChartData {
  final double value;
  final String label;

  const ChartData({required this.value, required this.label});
}

/// Configuration class for line chart styling
class LineChartStyle {
  final Color lineColor;
  final Color gridColor;
  final Color pointColor;
  final Color backgroundColor;
  final TextStyle? labelStyle;
  final double strokeWidth;
  final double pointRadius;
  final Duration animationDuration;
  final Curve animationCurve;

  const LineChartStyle({
    this.lineColor = Colors.blue,
    this.gridColor = Colors.grey,
    this.pointColor = Colors.blue,
    this.backgroundColor = Colors.white,
    this.labelStyle,
    this.strokeWidth = 2.0,
    this.pointRadius = 4.0,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.animationCurve = Curves.easeInOut,
  });
}