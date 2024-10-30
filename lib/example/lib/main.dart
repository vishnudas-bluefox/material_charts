import 'package:flutter/material.dart';
import 'package:material_charts/material_charts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 20),
            width: 800,
            height: 700,
            child:
                exampleBarChart(), // Example for building the chart change functions to exampleBarChart, exampleGanttChart, exampleHollowSemiCircleChart,exampleLineChart,exampleStackedBarChart,exampleCandleStickChart
          ),
        ),
      ),
    );
  }
}

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
