
import 'package:material_charts/material_charts.dart';

MaterialChartLine exampleLineChart() {
  return const MaterialChartLine(
    width: 500,
    height: 500,
    data: [
      ChartData(value: 50, label: 'Mon'),
      ChartData(value: 30, label: 'Tue'),
    ],
  );
}
