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
      title: 'Material Charts Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ChartsDemo(),
    );
  }
}

class ChartsDemo extends StatefulWidget {
  const ChartsDemo({super.key});

  @override
  State<ChartsDemo> createState() => _ChartsDemoState();
}

class _ChartsDemoState extends State<ChartsDemo> {
  int _selectedIndex = 0;

  final List<Widget> _charts = [
    const LineChartExample(),
    const BarChartExample(),
    const PieChartExample(),
    const AreaChartExample(),
    const MultiLineChartExample(),
    const StackedBarChartExample(),
    const HollowSemiCircleExample(),
    const GanttChartExample(),
    const CandlestickChartExample(),
  ];

  final List<String> _chartNames = [
    'Line Chart',
    'Bar Chart',
    'Pie Chart',
    'Area Chart',
    'Multi-Line Chart',
    'Stacked Bar Chart',
    'Hollow Semi-Circle',
    'Gantt Chart',
    'Candlestick Chart',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_chartNames[_selectedIndex]),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: _charts[_selectedIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: _chartNames
            .map((name) => BottomNavigationBarItem(
                  icon: const Icon(Icons.bar_chart),
                  label: name,
                  backgroundColor: Colors.blue,
                ))
            .toList(),
      ),
    );
  }
}

// Line Chart Example
class LineChartExample extends StatelessWidget {
  const LineChartExample({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [
      const ChartData(value: 10, label: 'Jan'),
      const ChartData(value: 25, label: 'Feb'),
      const ChartData(value: 15, label: 'Mar'),
      const ChartData(value: 30, label: 'Apr'),
      const ChartData(value: 45, label: 'May'),
      const ChartData(value: 35, label: 'Jun'),
    ];

    return Column(
      children: [
        const Text(
          'Monthly Sales Data',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        MaterialChartLine(
          data: data,
          width: 350,
          height: 250,
          style: const LineChartStyle(
            lineColor: Colors.blue,
            pointColor: Colors.red,
            useCurvedLines: true,
          ),
        ),
      ],
    );
  }
}

// Bar Chart Example
class BarChartExample extends StatelessWidget {
  const BarChartExample({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [
      const BarChartData(value: 20, label: 'Product A'),
      const BarChartData(value: 35, label: 'Product B'),
      const BarChartData(value: 25, label: 'Product C'),
      const BarChartData(value: 40, label: 'Product D'),
      const BarChartData(value: 30, label: 'Product E'),
    ];

    return Column(
      children: [
        const Text(
          'Product Sales Comparison',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        MaterialBarChart(
          data: data,
          width: 350,
          height: 300,
          style: const BarChartStyle(
            barColor: Colors.green,
            gradientEffect: true,
            gradientColors: [Colors.green, Colors.lightGreen],
          ),
        ),
      ],
    );
  }
}

// Pie Chart Example
class PieChartExample extends StatelessWidget {
  const PieChartExample({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [
      const PieChartData(value: 30, label: 'Mobile', color: Colors.blue),
      const PieChartData(value: 25, label: 'Desktop', color: Colors.red),
      const PieChartData(value: 20, label: 'Tablet', color: Colors.green),
      const PieChartData(value: 15, label: 'Watch', color: Colors.orange),
      const PieChartData(value: 10, label: 'Other', color: Colors.purple),
    ];

    return Column(
      children: [
        const Text(
          'Device Usage Distribution',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        MaterialPieChart(
          data: data,
          width: 350,
          height: 300,
          style: const PieChartStyle(
            showLegend: true,
            legendPosition: PieChartLegendPosition.bottom,
          ),
        ),
      ],
    );
  }
}

// Area Chart Example
class AreaChartExample extends StatelessWidget {
  const AreaChartExample({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [
      const AreaChartData(value: 10, label: 'Q1'),
      const AreaChartData(value: 20, label: 'Q2'),
      const AreaChartData(value: 15, label: 'Q3'),
      const AreaChartData(value: 35, label: 'Q4'),
    ];

    final series = [
      AreaChartSeries(
        name: 'Revenue',
        dataPoints: data,
        color: Colors.blue,
        gradientColor: Colors.blue.withValues(alpha: 0.3),
      ),
    ];

    return Column(
      children: [
        const Text(
          'Quarterly Revenue Trend',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        MaterialAreaChart(
          series: series,
          width: 350,
          height: 250,
        ),
      ],
    );
  }
}

// Multi-Line Chart Example
class MultiLineChartExample extends StatelessWidget {
  const MultiLineChartExample({super.key});

  @override
  Widget build(BuildContext context) {
    final series = [
      ChartSeries(
        name: 'Sales',
        dataPoints: const [
          ChartDataPoint(value: 10, label: 'Jan'),
          ChartDataPoint(value: 25, label: 'Feb'),
          ChartDataPoint(value: 15, label: 'Mar'),
          ChartDataPoint(value: 30, label: 'Apr'),
        ],
        color: Colors.blue,
      ),
      ChartSeries(
        name: 'Profit',
        dataPoints: const [
          ChartDataPoint(value: 5, label: 'Jan'),
          ChartDataPoint(value: 12, label: 'Feb'),
          ChartDataPoint(value: 8, label: 'Mar'),
          ChartDataPoint(value: 18, label: 'Apr'),
        ],
        color: Colors.green,
      ),
    ];

    return Column(
      children: [
        const Text(
          'Sales vs Profit Comparison',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        MultiLineChart(
          series: series,
          style: const MultiLineChartStyle(
            colors: [Colors.blue, Colors.green, Colors.red],
            showLegend: true,
          ),
          height: 300,
          width: 350,
        ),
      ],
    );
  }
}

// Stacked Bar Chart Example
class StackedBarChartExample extends StatelessWidget {
  const StackedBarChartExample({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [
      StackedBarData(
        label: 'Q1',
        segments: const [
          StackedBarSegment(value: 10, color: Colors.red, label: 'Product A'),
          StackedBarSegment(value: 15, color: Colors.blue, label: 'Product B'),
          StackedBarSegment(value: 12, color: Colors.green, label: 'Product C'),
        ],
      ),
      StackedBarData(
        label: 'Q2',
        segments: const [
          StackedBarSegment(value: 15, color: Colors.red, label: 'Product A'),
          StackedBarSegment(value: 20, color: Colors.blue, label: 'Product B'),
          StackedBarSegment(value: 10, color: Colors.green, label: 'Product C'),
        ],
      ),
      StackedBarData(
        label: 'Q3',
        segments: const [
          StackedBarSegment(value: 12, color: Colors.red, label: 'Product A'),
          StackedBarSegment(value: 18, color: Colors.blue, label: 'Product B'),
          StackedBarSegment(value: 15, color: Colors.green, label: 'Product C'),
        ],
      ),
    ];

    return Column(
      children: [
        const Text(
          'Quarterly Product Sales',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        MaterialStackedBarChart(
          data: data,
          width: 350,
          height: 300,
        ),
      ],
    );
  }
}

// Hollow Semi-Circle Chart Example
class HollowSemiCircleExample extends StatelessWidget {
  const HollowSemiCircleExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Goal Achievement',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        MaterialChartHollowSemiCircle(
          percentage: 75,
          size: 200,
          hollowRadius: 0.6,
          style: const ChartStyle(
            activeColor: Colors.green,
            inactiveColor: Colors.grey,
            showPercentageText: true,
          ),
        ),
        const SizedBox(height: 20),
        const Text('75% Complete'),
      ],
    );
  }
}

// Gantt Chart Example
class GanttChartExample extends StatelessWidget {
  const GanttChartExample({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [
      GanttData(
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 2, 15),
        label: 'Planning Phase',
        color: Colors.blue,
        description: 'Initial project planning and requirements gathering',
      ),
      GanttData(
        startDate: DateTime(2024, 2, 1),
        endDate: DateTime(2024, 4, 30),
        label: 'Development Phase',
        color: Colors.green,
        description: 'Core development and implementation',
      ),
      GanttData(
        startDate: DateTime(2024, 4, 15),
        endDate: DateTime(2024, 5, 30),
        label: 'Testing Phase',
        color: Colors.orange,
        description: 'Quality assurance and testing',
      ),
      GanttData(
        startDate: DateTime(2024, 5, 20),
        endDate: DateTime(2024, 6, 15),
        label: 'Deployment',
        color: Colors.red,
        description: 'Production deployment and monitoring',
      ),
    ];

    return Column(
      children: [
        const Text(
          'Project Timeline',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        MaterialGanttChart(
          data: data,
          width: 350,
          height: 300,
        ),
      ],
    );
  }
}

// Candlestick Chart Example
class CandlestickChartExample extends StatelessWidget {
  const CandlestickChartExample({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [
      CandlestickData(
        date: DateTime(2024, 1, 1),
        open: 100,
        high: 110,
        low: 95,
        close: 105,
      ),
      CandlestickData(
        date: DateTime(2024, 1, 2),
        open: 105,
        high: 115,
        low: 100,
        close: 108,
      ),
      CandlestickData(
        date: DateTime(2024, 1, 3),
        open: 108,
        high: 120,
        low: 102,
        close: 112,
      ),
      CandlestickData(
        date: DateTime(2024, 1, 4),
        open: 112,
        high: 118,
        low: 108,
        close: 115,
      ),
      CandlestickData(
        date: DateTime(2024, 1, 5),
        open: 115,
        high: 125,
        low: 110,
        close: 120,
      ),
    ];

    return Column(
      children: [
        const Text(
          'Stock Price Movement',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        MaterialCandlestickChart(
          data: data,
          width: 350,
          height: 300,
        ),
      ],
    );
  }
}
