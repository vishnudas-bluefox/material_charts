import 'package:flutter/material.dart';
import 'package:material_charts/material_charts.dart';

MaterialGanttChart exampleGanttChart() {
  // Example timeline data points
  final timelineData = [
    GanttData(
      startDate: DateTime(2024, 1, 1),
      endDate: DateTime(2024, 1, 15),
      label: 'Project Start',
      description: 'Initial project planning phase',
      color: Colors.blue,
      icon: Icons.start,

      tapContent:
          'Additional details for the project start phase...', // Optional tap content
    ),
    GanttData(
      startDate: DateTime(2024, 1, 16),
      endDate: DateTime(2024, 1, 20),
      label: 'Kickoff Meeting',
      description: 'Project initiation and goal setting.',
      color: Colors.blue,
      icon: Icons.event,
    ),
    GanttData(
      startDate: DateTime(2024, 1, 20),
      endDate: DateTime(2024, 2, 1),
      label: 'Design Phase',
      description: 'UI/UX design and prototype creation.',
      color: Colors.orange,
      icon: Icons.design_services,
    ),
    GanttData(
      startDate: DateTime(2024, 2, 1),
      endDate: DateTime(2024, 3, 20),
      label: 'Development Phase',
      description: 'Implementation of core features.',
      color: Colors.green,
      icon: Icons.code,
    ),
    GanttData(
      startDate: DateTime(2024, 3, 21),
      endDate: DateTime(2024, 4, 5),
      label: 'Testing & QA',
      description: 'Bug fixing and quality checks.',
      color: Colors.red,
      icon: Icons.bug_report,
    ),
    GanttData(
      startDate: DateTime(2024, 4, 6),
      endDate: DateTime(2024, 4, 15),
      tapContent: "Tap",
      label: 'Release',
      description: 'Deployment and client delivery.',
      color: Colors.purple,
      icon: Icons.rocket_launch,
    ),
  ];

  // Timeline chart styling
  const style = GanttChartStyle(
    lineColor: Color.fromRGBO(96, 125, 139, 1),
    lineWidth: 8,
    pointRadius: 6,
    connectionLineWidth: 3,
    showConnections: true,
    pointColor: Colors.blue,
    connectionLineColor: Colors.grey,
    backgroundColor: Colors.white,
    labelStyle: TextStyle(
        fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
    dateStyle: TextStyle(fontSize: 12, color: Colors.grey),
    animationDuration: Duration(seconds: 2),
    animationCurve: Curves.easeInOut,
    verticalSpacing: 90.0, // Adjust spacing for readability
    // horizontalPadding: 120.0,
  );

  // Create the timeline chart widget
  return MaterialGanttChart(
    data: timelineData,
    width: 700,
    height: 800,
    style: style,
    onPointTap: (point) {
      debugPrint('Tapped on ${point.label}');
    },
  );
}
