Here is the updated README with the new **Bar Chart** section:

---

# Material Charts

A comprehensive Flutter package offering a collection of customizable, animated charts with Material Design aesthetics. Perfect for data visualization in modern Flutter applications.

[![pub package](https://img.shields.io/pub/v/material_charts.svg)](https://pub.dev/packages/material_charts)  
[![License](https://img.shields.io/badge/License-BSD_3--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)

## Available Charts

### 1. Bar Chart

A beautiful, interactive, and animated bar chart, ideal for displaying discrete data categories.

![bar Chart Example](https://raw.githubusercontent.com/vishnudas-bluefox/material_charts/refs/heads/master/images/bar_chart.gif)

### 2. Line Chart

An animated line chart with customizable styling, perfect for showing trends and time series data.

![Line Chart Example](https://raw.githubusercontent.com/vishnudas-bluefox/material_charts/refs/heads/master/images/line_chart.gif)

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
  BarChartData(value: 10, label: 'Apples'),
  BarChartData(value: 20, label: 'Bananas', color: Colors.yellow),
  BarChartData(value: 15, label: 'Grapes', color: Colors.purple),
];

MaterialBarChart(
  data: data,
  width: 300,
  height: 200,
  style: BarChartStyle(
      animationCurve: Curves.decelerate,
      animationDuration: Duration(milliseconds: 3000),
      barColor: Colors.red,
      gradientEffect: true,
      barSpacing: .8,
      gradientColors: [Colors.red, Colors.green],
      cornerRadius: 5.0,
    );,
  showGrid: false,
  interactive: true,
  onAnimationComplete: () {
    print('Bar chart animation completed');
  },
);
```

### Line Chart

```dart
final data = [
  ChartData(label: 'Jan', value: 30),
  ChartData(label: 'Feb', value: 45),
  ChartData(label: 'Mar', value: 35),
];

MaterialChartLine(
  data: data,
  width: 350,
  height: 200,
  style: LineChartStyle(lineColor: Colors.blue, strokeWidth: 2.0),
);
```

---

## Styling

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

## Advanced Usage

### Interactive Features

The **Bar Chart** supports interaction with hover and tap detection:

```dart
MaterialBarChart(
  data: data,
  interactive: true,
  onAnimationComplete: () {
    print('Chart animation completed!');
  },
);
```

### Custom Data Handling

Convert your data models into the required `BarChartData` format:

```dart
List<BarChartData> convertToBarData(List<MyModel> data) {
  return data.map((item) => BarChartData(
    value: item.value,
    label: item.name,
    color: item.color,
  )).toList();
}
```

---

## Examples

### Bar Chart Example: Product Sales

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

---

## Best Practices

1. **Responsive Design**

   - Use flexible widths and heights when possible.
   - Test on different screen sizes and orientations.

2. **Performance**

   - Avoid large datasets (> 100 bars) for better performance.
   - Use smooth animations to improve UX.

3. **Accessibility**

   - Use meaningful labels and colors with good contrast.
   - Provide alternative text when needed.

---

## Troubleshooting

### Common Issues

1. **Chart Not Rendering**

   - Ensure the `data` list is not empty.
   - Verify the `width` and `height` are correctly set.

2. **Animation Not Working**

   - Confirm animation duration is reasonable.
   - Ensure the widget is properly disposed to avoid animation leaks.

3. **Style Not Applying**

   - Double-check style object properties.
   - Verify parent widget constraints allow the chart to render fully.

---

## Contributing

We welcome contributions! Here's how you can help:

1. Fork the repository.
2. Create your feature branch.
3. Commit your changes.
4. Push to the branch.
5. Create a Pull Request.

Please read our [Contributing Guide](CONTRIBUTING.md) for more details.

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

This updated README introduces the **Bar Chart**, including its usage, styling options, and interactive features, keeping it consistent with the overall structure of the package documentation.
