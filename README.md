# Material Charts

A comprehensive Flutter package offering a collection of customizable, animated charts with Material Design aesthetics. Perfect for data visualization in modern Flutter applications.

[![pub package](https://img.shields.io/pub/v/material_charts.svg)](https://pub.dev/packages/material_charts)  
[![License](https://img.shields.io/badge/License-BSD_3--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)

---

## Available Charts

### 1. Bar Chart

A beautiful, interactive, and animated bar chart, ideal for visualizing discrete data categories and comparisons.

![Bar Chart Example](https://raw.githubusercontent.com/vishnudas-bluefox/material_charts/refs/heads/master/images/bar_chart.gif)

---

### 2. Line Chart

An animated line chart with customizable styling, perfect for showing trends and time series data.

![Line Chart Example](https://raw.githubusercontent.com/vishnudas-bluefox/material_charts/refs/heads/master/images/line_chart.gif)

---

### 3. Hollow Semi Circle

A customizable progress meter in a hollow semi-circle format, ideal for displaying percentages and progress.

![Hollow Semi Circle Example](https://raw.githubusercontent.com/vishnudas-bluefox/material_charts/refs/heads/master/images/hoolow_semi_circle.gif)

---

## Features

### Common Features Across All Charts

- 🎨 Material Design aesthetics
- ✨ Smooth animations with configurable duration and curves
- 📊 Responsive and adaptive layouts
- 🎭 Customizable color schemes
- 💫 Animation completion callbacks
- 📱 Mobile-friendly design
- ♿ Accessibility support

### Bar Chart Features

- 📊 Animated bars with hover and tap interactions
- 🏷️ Customizable bar colors and labels
- 📏 Optional gridlines and padding
- 🕒 Animation support with curve control
- 🌈 Gradient or solid color options

### Line Chart Features

- 📈 Interactive data points
- 📏 Optional gridlines
- 🏷️ Customizable labels
- 📊 Automatic scaling
- 🎯 Point highlighting

### Hollow Semi Circle Features

- 📊 Percentage display
- 🎯 Legend support
- 📏 Adjustable hollow radius
- 🎨 Active/inactive segment styling
- 📝 Custom formatters

---

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  material_charts: ^1.0.0
```

---

## Usage

### Bar Chart

```dart
final data = [
  BarChartData(value: 10, label: 'Apples', color: Colors.red),
  BarChartData(value: 20, label: 'Bananas', color: Colors.yellow),
  BarChartData(value: 15, label: 'Grapes', color: Colors.purple),
];

MaterialBarChart(
  data: data,
  width: 300,
  height: 200,
  style: BarChartStyle(
    barColor: Colors.blue,
    gradientEffect: true,
    gradientColors: [Colors.blue, Colors.lightBlueAccent],
    animationCurve: Curves.easeOutBack,
  ),
  showGrid: true,
  interactive: true,
  onAnimationComplete: () {
    print('Bar chart animation completed');
  },
);
```

---

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
);
```

---

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
);
```

---

## Styling

### Common Style Properties

All charts support a base set of style properties through the `ChartStyle` class:

```dart
ChartStyle(
  animationDuration: Duration(milliseconds: 1500),
  animationCurve: Curves.easeInOut,
  // Chart-specific properties...
);
```

---

### Bar Chart Style

```dart
BarChartStyle(
  barColor: Colors.teal,
  gridColor: Colors.grey.shade300,
  backgroundColor: Colors.white,
  cornerRadius: 8.0,
  barSpacing: 0.1, // 10% spacing between bars
  animationDuration: Duration(milliseconds: 1200),
  animationCurve: Curves.easeInOut,
  gradientEffect: true,
  gradientColors: [Colors.teal, Colors.cyan],
  labelStyle: TextStyle(fontSize: 12, color: Colors.black),
  valueStyle: TextStyle(fontSize: 10, color: Colors.black87),
);
```

---

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
);
```

---

### Hollow Semi Circle Style

```dart
ChartStyle(
  activeColor: Colors.green,
  inactiveColor: Colors.grey.shade200,
  textColor: Colors.green,
  percentageStyle: TextStyle(fontSize: 24),
  legendStyle: TextStyle(fontSize: 16),
);
```

---

## Advanced Usage

### Custom Data Models

Convert your data models into chart-compatible formats.

**Bar Chart Example:**

```dart
List<BarChartData> convertToBarData(List<MyModel> data) {
  return data.map((item) => BarChartData(
    value: item.value,
    label: item.name,
    color: item.color,
  )).toList();
}
```

**Line Chart Example:**

```dart
List<ChartData> convertToLineData(List<MyModel> data) {
  return data.map((item) => ChartData(
    label: item.label,
    value: item.value,
  )).toList();
}
```

---

## Examples

### Bar Chart: Product Sales

```dart
MaterialBarChart(
  data: salesData,
  width: 400,
  height: 300,
  style: BarChartStyle(
    barColor: Colors.orange,
    gridColor: Colors.grey.shade300,
  ),
);
```

### Line Chart: Stock Prices

```dart
MaterialChartLine(
  data: stockPrices,
  style: LineChartStyle(
    lineColor: priceChange >= 0 ? Colors.green : Colors.red,
  ),
);
```

---

## Best Practices

1. **Responsive Design**

   - Use flexible widths and heights.
   - Test on multiple screen sizes and orientations.

2. **Performance**

   - Avoid datasets larger than 100 bars.
   - Use smooth animations to improve UX.

3. **Accessibility**
   - Provide labels and colors with proper contrast.
   - Add meaningful alt-text where applicable.

---

## Troubleshooting

### Common Issues

1. **Chart Not Rendering**

   - Verify that the `data` list is not empty.
   - Ensure valid size parameters are provided.

2. **Animation Issues**

   - Check if animation duration is reasonable.
   - Confirm that the widget is disposed correctly.

3. **Style Not Applying**
   - Verify the style properties and parent widget constraints.

---

## Contributing

We welcome contributions! Follow these steps:

1. Fork the repository.
2. Create a feature branch.
3. Commit your changes.
4. Push to your branch.
5. Open a Pull Request.

Refer to our [Contributing Guide](CONTRIBUTING.md) for details.

---

## Future Charts (Coming Soon)

- 🥧 Pie Chart
- 📈 Area Chart
- 🎯 Radar Chart
- 📊 Scatter Plot
- 📈 Candlestick Chart

---

## License

```
BSD 3-Clause License

Copyright (c) 2024, Material Charts
All rights reserved.
```

---

## Support

- 📚 [Documentation](https://pub.dev/documentation/material_charts/latest/)
- 💬 [GitHub Issues](https://github.com/vishnudas-bluefox/material_charts/issues)
- 📧 [Email Support](mailto:vishnudas956783@gmail.com)

---

## Credits

Developed with 💙 by [vishnudas-bluefox]

Special thanks to all [contributors](https://github.com/vishnudas-bluefox/material_charts/graphs/contributors)!

---

This version includes **all charts' information** and styling details, ensuring completeness and consistency.
