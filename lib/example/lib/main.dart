import 'package:example/bar_chart.dart';
import 'package:flutter/material.dart';

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
