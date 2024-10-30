import 'package:flutter/material.dart';
import 'package:material_charts/material_charts.dart';

MaterialBarChart exampleBarChart() {
  return const MaterialBarChart(
    width: 500,
    height: 500,
    data: [
      BarChartData(value: 70, label: 'Q1', color: Colors.blue),
      BarChartData(value: 85, label: 'Q2', color: Colors.red),
    ],
    style: BarChartStyle(
      barColor: Colors.blue,
      gridColor: Colors.grey,
      barSpacing: .9,
      animationCurve: Curves.easeInOut,
    ),
    showGrid: true,
    showValues: true,
  );
}
