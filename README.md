# Material Charts

**Material Charts** is a Flutter package designed to offer versatile, customizable chart components that adapt to a variety of use cases. It supports **Line Charts**, **Hollow Semi-Circle Charts**, and **Bar Charts**, with extensive customization, smooth animations, and real-time data updates.

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

## **Installation**

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  material_charts: latest_version
```

---

## **Chart Types**

### **1. Line Chart**

Displays trends or data points over time with connected lines.

#### **Code Usage**

```dart
MaterialChartLine(
  data: [
    ChartData(value: 50, label: 'Mon'),
    ChartData(value: 30, label: 'Tue'),
  ],
  lineColor: Colors.blue,
  gridColor: Colors.grey,
  pointColor: Colors.red,
  strokeWidth: 2.5,
  animationCurve: Curves.easeInOut,
  animationDuration: Duration(milliseconds: 1500),
);
```

### **Line Chart Properties and Style**

| **Property**        | **Type**     | **Description**                      | **Default Value**  |
| ------------------- | ------------ | ------------------------------------ | ------------------ |
| `value`             | `double`     | Value represented by the data point. | **Required**       |
| `label`             | `String`     | Label for the data point.            | **Required**       |
| `lineColor`         | `Color`      | Color of the connecting line.        | `Colors.blue`      |
| `gridColor`         | `Color`      | Grid line color.                     | `Colors.grey`      |
| `pointColor`        | `Color`      | Color of data points.                | `Colors.red`       |
| `backgroundColor`   | `Color`      | Background color of the chart.       | `Colors.white`     |
| `labelStyle`        | `TextStyle?` | Style for point labels.              | `null`             |
| `strokeWidth`       | `double`     | Thickness of the connecting line.    | `2.5`              |
| `pointRadius`       | `double`     | Radius of data points.               | `4.0`              |
| `animationDuration` | `Duration`   | Duration of the chart animation.     | `1500ms`           |
| `animationCurve`    | `Curve`      | Animation curve for transitions.     | `Curves.easeInOut` |

---

### **2. Hollow Semi-Circle Chart**

A semi-circle chart ideal for displaying progress or percentages.

#### **Code Usage**

```dart
MaterialChartHollowSemiCircle(
  percentage: 75,
  activeColor: Colors.green,
  inactiveColor: Colors.grey,
  textColor: Colors.black,
  animationCurve: Curves.easeInOut,
  animationDuration: Duration(milliseconds: 1500),
  showPercentageText: true,
);
```

### **Hollow Semi-Circle Chart Properties and Style**

| **Property**          | **Type**                   | **Description**                           | **Default Value**  |
| --------------------- | -------------------------- | ----------------------------------------- | ------------------ |
| `activeColor`         | `Color`                    | Color of the active (filled) portion.     | **Required**       |
| `inactiveColor`       | `Color`                    | Color of the inactive (unfilled) portion. | `Colors.grey`      |
| `textColor`           | `Color?`                   | Color of the percentage text.             | `null`             |
| `percentageStyle`     | `TextStyle?`               | Style for percentage display.             | `null`             |
| `legendStyle`         | `TextStyle?`               | Style for legend labels.                  | `null`             |
| `animationDuration`   | `Duration`                 | Duration of the animation.                | `1500ms`           |
| `animationCurve`      | `Curve`                    | Animation curve for transitions.          | `Curves.easeInOut` |
| `showPercentageText`  | `bool`                     | Whether to display the percentage text.   | `true`             |
| `showLegend`          | `bool`                     | Whether to show the legend.               | `true`             |
| `percentageFormatter` | `Function(double)`         | Custom formatter for percentage text.     | `null`             |
| `legendFormatter`     | `Function(String, double)` | Custom formatter for legend labels.       | `null`             |

---

### **3. Bar Chart**

Used for comparing values across different categories.

#### **Code Usage**

```dart
MaterialBarChart(
  data: [
    BarChartData(value: 70, label: 'Q1', color: Colors.blue),
    BarChartData(value: 85, label: 'Q2', color: Colors.red),
  ],
  style: BarChartStyle(
    barColor: Colors.blue,
    gridColor: Colors.grey,
    barSpacing: 16,
    animationCurve: Curves.easeInOut,
  ),
  showGrid: true,
  showValues: true,
);
```

### **Bar Chart: Properties and Style**

| **Property**          | **Type**             | **Description**                      | **Default Value**  |
| --------------------- | -------------------- | ------------------------------------ | ------------------ |
| `data`                | `List<BarChartData>` | List of bar chart data.              | **Required**       |
| `progress`            | `double`             | Progress percentage (0 to 100).      | `0.0`              |
| `showGrid`            | `bool`               | Whether to display grid lines.       | `true`             |
| `showValues`          | `bool`               | Whether to display bar values.       | `true`             |
| `padding`             | `EdgeInsets`         | Padding around the chart.            | `EdgeInsets.zero`  |
| `horizontalGridLines` | `int`                | Number of horizontal grid lines.     | `5`                |
| `hoveredBarIndex`     | `int?`               | Index of the currently hovered bar.  | `null`             |
| `barColor`            | `Color`              | Color of the bars.                   | `Colors.blue`      |
| `gridColor`           | `Color`              | Color of the grid lines.             | `Colors.grey`      |
| `backgroundColor`     | `Color`              | Background color of the chart.       | `Colors.white`     |
| `labelStyle`          | `TextStyle?`         | Style for bar labels.                | `null`             |
| `valueStyle`          | `TextStyle?`         | Style for bar values.                | `null`             |
| `barSpacing`          | `double`             | Spacing between bars.                | `8.0`              |
| `cornerRadius`        | `double`             | Corner radius of the bars.           | `4.0`              |
| `animationDuration`   | `Duration`           | Duration of the animation.           | `1500ms`           |
| `animationCurve`      | `Curve`              | Animation curve for bar transitions. | `Curves.easeInOut` |
| `gradientEffect`      | `bool`               | Whether to apply a gradient effect.  | `false`            |
| `gradientColors`      | `List<Color>?`       | Colors used for the gradient effect. | `null`             |

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
