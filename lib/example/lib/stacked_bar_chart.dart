import 'package:flutter/material.dart';
import 'package:material_charts/material_charts.dart';

MaterialStackedBarChart exampleStackedBarChart() {
  final data = [
    const StackedBarData(
      label: 'Q1',
      segments: [
        StackedBarSegment(
            value: 30,
            color: Color.fromRGBO(46, 142, 149, 1),
            label: 'Product A'),
        StackedBarSegment(
            value: 35,
            color: Color.fromRGBO(46, 142, 149, 0.342),
            label: 'Product B'),
      ],
    ),
    const StackedBarData(
      label: 'Q2',
      segments: [
        StackedBarSegment(
            value: 50, color: Color(0xFF605e70), label: 'Product A'),
        StackedBarSegment(
            value: 20, color: Color(0xFFa19dc7), label: 'Product B'),
        StackedBarSegment(
            value: 15, color: Color(0xFFf3f2fe), label: 'Product C'),
      ],
    ),
    const StackedBarData(
      label: 'Q3',
      segments: [
        StackedBarSegment(
            value: 40,
            color: Color.fromRGBO(46, 142, 149, 1),
            label: 'Product A'),
        StackedBarSegment(
            value: 15,
            color: Color.fromRGBO(46, 142, 149, 0.342),
            label: 'Product B'),
      ],
    ),
    const StackedBarData(
      label: 'Q4',
      segments: [
        StackedBarSegment(
            value: 20, color: Color(0xFF605e70), label: 'Product A'),
        StackedBarSegment(
            value: 50, color: Color(0xFFa19dc7), label: 'Product B'),
        StackedBarSegment(
            value: 25, color: Color(0xFFf3f2fe), label: 'Product C'),
      ],
    ),
    // Add more StackedBarData items...
  ];
  return MaterialStackedBarChart(
    showGrid: true,
    horizontalGridLines: 5,
    showValues: true,
    data: data,
    width: 400,
    height: 300,
    style: StackedBarChartStyle(
      gridColor: Colors.black,
      // showSegmentLabels: true,
      cornerRadius: 3,
      barSpacing: .7,
      valueStyle: const TextStyle(
        // backgroundColor: Color.fromARGB(68, 255, 255, 255),
        color: Colors.black87,
      ),
      labelStyle: const TextStyle(
        color: Colors.grey,
      ),
      yAxisConfig: YAxisConfig(
        minValue: 0,
        maxValue: 100,
        divisions: 5,
        showGridLines: false,
        labelFormatter: (value) => '${value.toInt()}',
        labelStyle: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
    ),
  );
}
