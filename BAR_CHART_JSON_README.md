# Material Bar Chart

A Flutter material design bar chart widget with JSON configuration support and Plotly-compatible schemas.

## Features

- **Material Design**: Follows Material Design 3 guidelines
- **Interactive**: Hover effects and animations
- **Flexible Data Input**: Support for traditional Flutter objects, simple arrays, and JSON configuration
- **Plotly Compatibility**: JSON schema compatible with Plotly.js
- **Customizable**: Extensive styling options including gradients, colors, and animations
- **Responsive**: Adapts to different screen sizes
- **Accessible**: Built with accessibility in mind

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  material_charts: ^1.0.0
```

## Quick Start

### Traditional Flutter API

```dart
import 'package:flutter/material.dart';
import 'material_charts/material_charts.dart';

MaterialBarChart(
  data: [
    BarChartData(value: 45, label: 'Jan', color: Colors.blue),
    BarChartData(value: 78, label: 'Feb', color: Colors.green),
    BarChartData(value: 32, label: 'Mar', color: Colors.orange),
  ],
  width: 800,
  height: 400,
  style: BarChartStyle(
    barColor: Colors.blue,
    barSpacing: 0.2,
    cornerRadius: 8.0,
    gradientEffect: true,
  ),
  showGrid: true,
  showValues: true,
  interactive: true,
)
```

### Simple Data Arrays

```dart
MaterialBarChart.fromData(
  labels: ['Jan', 'Feb', 'Mar', 'Apr'],
  values: [45, 78, 32, 89],
  colors: ['#1f77b4', '#2ca02c', '#ff7f0e', '#d62728'],
  width: 800,
  height: 400,
  showGrid: true,
  showValues: true,
  interactive: true,
)
```

### JSON Configuration

```dart
final jsonConfig = {
  'data': [
    {'x': 'Jan', 'y': 45, 'color': '#1f77b4'},
    {'x': 'Feb', 'y': 78, 'color': '#2ca02c'},
    {'x': 'Mar', 'y': 32, 'color': '#ff7f0e'},
  ],
  'style': {
    'width': 800,
    'height': 400,
    'showGrid': true,
    'showValues': true,
    'interactive': true,
    'barColor': '#1f77b4',
    'barSpacing': 0.2,
    'cornerRadius': 8.0,
    'gradientEffect': true,
  },
};

MaterialBarChart.fromJson(jsonConfig)
```

## API Reference

### MaterialBarChart Constructor

| Parameter             | Type                 | Default              | Description                     |
| --------------------- | -------------------- | -------------------- | ------------------------------- |
| `data`                | `List<BarChartData>` | **Required**         | Data points for the chart       |
| `width`               | `double`             | **Required**         | Chart width in pixels           |
| `height`              | `double`             | **Required**         | Chart height in pixels          |
| `style`               | `BarChartStyle`      | `BarChartStyle()`    | Styling configuration           |
| `showGrid`            | `bool`               | `true`               | Show grid lines                 |
| `showValues`          | `bool`               | `true`               | Show values on bars             |
| `padding`             | `EdgeInsets`         | `EdgeInsets.all(24)` | Chart padding                   |
| `horizontalGridLines` | `int`                | `5`                  | Number of horizontal grid lines |
| `interactive`         | `bool`               | `true`               | Enable hover interactions       |
| `onAnimationComplete` | `VoidCallback?`      | `null`               | Animation completion callback   |

### BarChartData

| Property | Type     | Description                       |
| -------- | -------- | --------------------------------- |
| `value`  | `double` | Numeric value for the bar         |
| `label`  | `String` | Label displayed below the bar     |
| `color`  | `Color?` | Optional custom color for the bar |

### BarChartStyle

| Property            | Type           | Default            | Description                    |
| ------------------- | -------------- | ------------------ | ------------------------------ |
| `barColor`          | `Color`        | `Colors.blue`      | Default color for bars         |
| `gridColor`         | `Color`        | `Colors.grey`      | Color of grid lines            |
| `backgroundColor`   | `Color`        | `Colors.white`     | Chart background color         |
| `labelStyle`        | `TextStyle?`   | `null`             | Style for bar labels           |
| `valueStyle`        | `TextStyle?`   | `null`             | Style for bar values           |
| `barSpacing`        | `double`       | `0.2`              | Spacing between bars (0.0-1.0) |
| `cornerRadius`      | `double`       | `4.0`              | Corner radius for bars         |
| `animationDuration` | `Duration`     | `1500ms`           | Animation duration             |
| `animationCurve`    | `Curve`        | `Curves.easeInOut` | Animation curve                |
| `gradientEffect`    | `bool`         | `false`            | Enable gradient effect         |
| `gradientColors`    | `List<Color>?` | `null`             | Colors for gradient            |

## JSON Schema

### Data Format

```json
{
  "data": [
    {
      "x": "Jan",
      "y": 45,
      "color": "#1f77b4"
    },
    {
      "x": "Feb",
      "y": 78,
      "color": "#2ca02c"
    }
  ],
  "style": {
    "width": 800,
    "height": 400,
    "showGrid": true,
    "showValues": true,
    "interactive": true,
    "padding": {
      "left": 24,
      "top": 24,
      "right": 24,
      "bottom": 24
    },
    "horizontalGridLines": 5,
    "barColor": "#1f77b4",
    "gridColor": "#f0f0f0",
    "backgroundColor": "#ffffff",
    "barSpacing": 0.2,
    "cornerRadius": 4.0,
    "animationDuration": 1500,
    "animationCurve": "easeInOut",
    "gradientEffect": false,
    "gradientColors": ["#1f77b4", "#ff7f0e"]
  }
}
```

### JSON Properties

#### Data Properties

- `x`: Label for the bar (string)
- `y`: Numeric value for the bar (number)
- `color`: Bar color in hex format (string, optional)

#### Style Properties

- `width`: Chart width in pixels (number)
- `height`: Chart height in pixels (number)
- `showGrid`: Show grid lines (boolean)
- `showValues`: Show values on bars (boolean)
- `interactive`: Enable hover interactions (boolean)
- `padding`: Chart padding object with `left`, `top`, `right`, `bottom` (object)
- `horizontalGridLines`: Number of horizontal grid lines (number)
- `barColor`: Default bar color in hex format (string)
- `gridColor`: Grid line color in hex format (string)
- `backgroundColor`: Chart background color in hex format (string)
- `barSpacing`: Spacing between bars, 0.0 to 1.0 (number)
- `cornerRadius`: Corner radius for bars in pixels (number)
- `animationDuration`: Animation duration in milliseconds (number)
- `animationCurve`: Animation curve type (string)
- `gradientEffect`: Enable gradient effect (boolean)
- `gradientColors`: Array of hex colors for gradient (array)

### Animation Curves

Supported animation curve values:

- `"linear"`
- `"easeIn"`
- `"easeOut"`
- `"easeInOut"`
- `"bounceIn"`
- `"bounceOut"`

### Color Formats

Colors can be specified in multiple formats:

- Hex: `"#1f77b4"`
- RGB: `"rgb(31, 119, 180)"`
- RGBA: `"rgba(31, 119, 180, 0.8)"`

## Examples

### Basic Chart

```dart
MaterialBarChart.fromData(
  labels: ['A', 'B', 'C', 'D'],
  values: [10, 20, 30, 40],
  width: 400,
  height: 300,
)
```

### Styled Chart with Gradient

```dart
MaterialBarChart.fromData(
  labels: ['Q1', 'Q2', 'Q3', 'Q4'],
  values: [100, 150, 200, 175],
  width: 600,
  height: 400,
  style: {
    'gradientEffect': true,
    'gradientColors': ['#4CAF50', '#2196F3'],
    'barSpacing': 0.3,
    'cornerRadius': 12.0,
    'animationDuration': 2000,
  },
)
```

### Interactive Chart from JSON

```dart
final jsonConfig = {
      'data': [
        {'x': 'Jan', 'y': 45, 'color': '#1f77b4'},
        {'x': 'Feb', 'y': 78, 'color': '#2ca02c'},
        {'x': 'Mar', 'y': 32, 'color': '#ff7f0e'},
        {'x': 'Apr', 'y': 89, 'color': '#d62728'},
        {'x': 'May', 'y': 56, 'color': '#9467bd'},
        {'x': 'Jun', 'y': 67, 'color': '#8c564b'},
        {'x': 'Jul', 'y': 23, 'color': '#e377c2'},
        {'x': 'Aug', 'y': 91, 'color': '#7f7f7f'},
      ],
      'style': {
        'width': 800,
        'height': 300,
        'showGrid': true,
        'showValues': true,
        'padding': {'left': 32, 'top': 32, 'right': 32, 'bottom': 32},
        'horizontalGridLines': 6,
        'interactive': true,
        'barColor': '#1f77b4',
        'gridColor': '#f0f0f0',
        'backgroundColor': '#ffffff',
        'barSpacing': 0.3,
        'cornerRadius': 8.0,
        'animationDuration': 2000,
        'animationCurve': 'easeInOut',
        'gradientEffect': true,
        'gradientColors': ['#1f77b4', '#ff7f0e'],
      },
    };

    return SizedBox(
      width: 1000,
      height: 400,
      child: MaterialBarChart.fromJson(jsonConfig),
    );
''';

MaterialBarChart.fromJsonString(jsonString)
```
