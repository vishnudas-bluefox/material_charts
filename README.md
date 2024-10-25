# Material Charts

A comprehensive Flutter package offering a collection of customizable, animated charts with Material Design aesthetics. Perfect for data visualization in modern Flutter applications.

[![pub package](https://img.shields.io/pub/v/material_charts.svg)](https://pub.dev/packages/material_charts)
[![License](https://img.shields.io/badge/License-BSD_3--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)

## Available Charts

### 1. Line Chart

An animated line chart with customizable styling, perfect for showing trends and time series data.

![Line Chart Example](https://github.com/vishnudas-bluefox/material_charts/blob/master/images/demo_chart1.png)

### 2. Hollow Semi Circle

A customizable progress meter in a hollow semi-circle format, ideal for displaying percentages and progress.

![Hollow Semi Circle Example](https://github.com/vishnudas-bluefox/material_charts/blob/master/images/demo_chart1.png)

## Features

### Common Features Across All Charts

- 🎨 Material Design aesthetics
- ✨ Smooth animations with configurable duration and curves
- 📊 Responsive and adaptive layouts
- 🎭 Customizable color schemes
- 💫 Animation completion callbacks
- 📱 Mobile-friendly design
- ♿ Accessibility support

### Line Chart Features

- 📈 Interactive data points
- 📏 Optional grid lines
- 🏷️ Customizable labels
- 📊 Automatic scaling
- 🎯 Point highlighting

### Hollow Semi Circle Features

- 📊 Percentage display
- 🎯 Legend support
- 📏 Adjustable hollow radius
- 🎨 Active/inactive segment styling
- 📝 Custom formatters

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  material_charts: ^1.0.0
```

## Usage

### Line Chart

```dart
final data = [
  ChartData(label: 'Jan', value: 30),
  ChartData(label: 'Feb', value: 45),
  ChartData(label: 'Mar', value: 35),
  ChartData(label: 'Apr', value: 60),
];

MaterialChartLine(
  data: data,
  width: 350,
  height: 200,
  style: LineChartStyle(
    lineColor: Colors.blue,
    pointColor: Colors.blue,
    strokeWidth: 2.0,
  ),
)
```

### Hollow Semi Circle

```dart
MaterialChartHollowSemiCircle(
  percentage: 75,
  size: 300,
  hollowRadius: 0.7,
  style: ChartStyle(
    activeColor: Colors.green,
    inactiveColor: Colors.grey.shade200,
    textColor: Colors.green,
  ),
)
```

## Styling

### Common Style Properties

All charts support a base set of style properties through the `ChartStyle` class:

```dart
ChartStyle(
  animationDuration: Duration(milliseconds: 1500),
  animationCurve: Curves.easeInOut,
  // Chart-specific properties...
)
```

### Line Chart Style

```dart
LineChartStyle(
  lineColor: Colors.blue,
  gridColor: Colors.grey.withOpacity(0.2),
  pointColor: Colors.blue,
  backgroundColor: Colors.white,
  labelStyle: TextStyle(fontSize: 12),
  strokeWidth: 2.0,
  pointRadius: 4.0,
)
```

### Hollow Semi Circle Style

```dart
ChartStyle(
  activeColor: Colors.green,
  inactiveColor: Colors.grey.shade200,
  textColor: Colors.green,
  percentageStyle: TextStyle(fontSize: 24),
  legendStyle: TextStyle(fontSize: 16),
)
```

## Advanced Usage

### Custom Data Models

Convert your data models to chart-compatible formats:

```dart
// For Line Chart
List<ChartData> convertToLineData(List<YourModel> data) {
  return data.map((item) => ChartData(
    label: item.label,
    value: item.value,
  )).toList();
}

// For Hollow Semi Circle
double calculatePercentage(YourModel data) {
  return (data.completed / data.total) * 100;
}
```

### Animation Control

All charts support animation control:

```dart
MaterialChartLine(
  // ... other properties
  style: LineChartStyle(
    animationDuration: Duration(milliseconds: 2000),
    animationCurve: Curves.elasticOut,
  ),
  onAnimationComplete: () {
    print('Animation completed!');
  },
)
```

## Examples

### Line Chart Examples

#### Basic Time Series

```dart
MaterialChartLine(
  data: monthlyData,
  width: 350,
  height: 200,
)
```

#### Stock Price Chart

```dart
MaterialChartLine(
  data: stockPrices,
  style: LineChartStyle(
    lineColor: priceChange >= 0 ? Colors.green : Colors.red,
  ),
)
```

### Hollow Semi Circle Examples

#### Download Progress

```dart
MaterialChartHollowSemiCircle(
  percentage: downloadProgress,
  style: ChartStyle(
    percentageFormatter: (value) => '${value.toInt()}% Downloaded',
  ),
)
```

#### Performance Meter

```dart
MaterialChartHollowSemiCircle(
  percentage: performanceScore,
  style: ChartStyle(
    activeColor: performanceScore > 80 ? Colors.green : Colors.orange,
  ),
)
```

## Best Practices

1. **Responsive Design**

   - Use flexible widths when possible
   - Consider screen orientation changes
   - Test on different screen sizes

2. **Performance**

   - Keep data points reasonable (< 100 for line charts)
   - Use appropriate animation durations
   - Implement efficient data updates

3. **Accessibility**
   - Provide meaningful labels
   - Use sufficient color contrast
   - Include alternative text when necessary

## Troubleshooting

### Common Issues

1. **Chart Not Rendering**

   - Verify data is not empty
   - Check container constraints
   - Ensure valid size parameters

2. **Animation Issues**

   - Verify animation duration is reasonable
   - Check state management implementation
   - Confirm widget is properly disposed

3. **Style Not Applying**
   - Verify style object properties
   - Check parent widget constraints
   - Confirm theme inheritance

## Contributing

We welcome contributions! Here's how you can help:

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

Please read our [Contributing Guide](CONTRIBUTING.md) for details.

## Future Charts (Coming Soon)

- 📊 Bar Chart
- 🥧 Pie Chart
- 📈 Area Chart
- 🎯 Radar Chart
- 📊 Scatter Plot
- 📈 Candlestick Chart

## License

```
BSD 3-Clause License

Copyright (c) 2024, Material Charts
All rights reserved.
```

## Support

- 📚 [Documentation](https://pub.dev/documentation/material_charts/latest/)
- 💬 [GitHub Issues](https://github.com/vishnudas-bluefox/material_charts/issues)
- 📧 [Email Support](mailto:vishnudas956783@gmail.com)

## Credits

Developed with 💙 by [vishnudas-bluefox]

Special thanks to all [contributors](https://github.com/vishnudas-bluefox/material_charts/graphs/contributors)!
