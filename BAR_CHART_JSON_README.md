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

### JSON Configuration (Plotly-Compatible)

```dart
final jsonConfig = {
  "data": [
    {
      "type": "bar",
      "x": ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug"],
      "y": [45, 78, 32, 89, 56, 67, 23, 91],
      "marker": {
        "color": ["#F1C40F", "#E67E22", "#1ABC9C", "#3498DB",
                  "#9B59B6", "#2ECC71", "#E74C3C", "#34495E"],
        "colorscale": ["#B8D4E3", "#7B9E87"]
      }
    }
  ],
  "layout": {
    "width": 800,
    "height": 300,
    "plot_bgcolor": "#16213E",
    "paper_bgcolor": "#16213E",
    "showlegend": false,
    "bargap": 0.3,
    "bargroupgap": 0.1,
    "xaxis": {
      "showgrid": true,
      "gridcolor": "#34495E",
      "tickfont": {
        "size": 16,
        "color": "#E8F4F8"
      },
      "tickcolor": "#E8F4F8",
      "title": {
        "text": "Months",
        "font": {
          "size": 18,
          "color": "#E8F4F8"
        }
      }
    },
    "yaxis": {
      "showgrid": true,
      "gridcolor": "#34495E",
      "nticks": 6,
      "tickfont": {
        "size": 14,
        "color": "#E8F4F8"
      },
      "tickcolor": "#E8F4F8",
      "title": {
        "text": "Values",
        "font": {
          "size": 18,
          "color": "#E8F4F8"
        }
      }
    },
    "font": {
      "size": 12,
      "color": "#E8F4F8"
    }
  }
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

## JSON Schema (Plotly-Compatible)

### Data Format

```json
{
  "data": [
    {
      "type": "bar",
      "x": ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug"],
      "y": [45, 78, 32, 89, 56, 67, 23, 91],
      "marker": {
        "color": ["#F1C40F", "#E67E22", "#1ABC9C", "#3498DB",
                  "#9B59B6", "#2ECC71", "#E74C3C", "#34495E"],
        "colorscale": ["#B8D4E3", "#7B9E87"]
      }
    }
  ],
  "layout": {
    "width": 800,
    "height": 300,
    "plot_bgcolor": "#16213E",
    "paper_bgcolor": "#16213E",
    "showlegend": false,
    "bargap": 0.3,
    "bargroupgap": 0.1,
    "xaxis": {
      "showgrid": true,
      "gridcolor": "#34495E",
      "tickfont": {
        "size": 16,
        "color": "#E8F4F8"
      },
      "tickcolor": "#E8F4F8",
      "title": {
        "text": "Months",
        "font": {
          "size": 18,
          "color": "#E8F4F8"
        }
      }
    },
    "yaxis": {
      "showgrid": true,
      "gridcolor": "#34495E",
      "nticks": 6,
      "tickfont": {
        "size": 14,
        "color": "#E8F4F8"
      },
      "tickcolor": "#E8F4F8",
      "title": {
        "text": "Values",
        "font": {
          "size": 18,
          "color": "#E8F4F8"
        }
      }
    },
    "font": {
      "size": 12,
      "color": "#E8F4F8"
    }
  }
}
```

### JSON Properties

#### Data Properties

- `type`: Chart type, should be "bar" (string)
- `x`: Array of labels for the bars (array of strings)
- `y`: Array of numeric values for the bars (array of numbers)
- `marker`: Object containing styling for the bars (object)
  - `color`: Array of colors for individual bars (array of strings, optional)
  - `colorscale`: Array of colors for gradient effect (array of strings, optional)

#### Layout Properties

- `width`: Chart width in pixels (number)
- `height`: Chart height in pixels (number)
- `plot_bgcolor`: Plot area background color in hex format (string)
- `paper_bgcolor`: Paper/container background color in hex format (string)
- `showlegend`: Show legend (boolean)
- `bargap`: Gap between bars, 0.0 to 1.0 (number)
- `bargroupgap`: Gap between bar groups, 0.0 to 1.0 (number)

#### X-Axis Properties

- `showgrid`: Show grid lines (boolean)
- `gridcolor`: Grid line color in hex format (string)
- `tickfont`: Font styling for tick labels (object)
  - `size`: Font size (number)
  - `color`: Font color in hex format (string)
- `tickcolor`: Tick color in hex format (string)
- `title`: Axis title configuration (object)
  - `text`: Title text (string)
  - `font`: Title font styling (object)
    - `size`: Font size (number)
    - `color`: Font color in hex format (string)

#### Y-Axis Properties

- `showgrid`: Show grid lines (boolean)
- `gridcolor`: Grid line color in hex format (string)
- `nticks`: Number of tick marks (number)
- `tickfont`: Font styling for tick labels (object)
  - `size`: Font size (number)
  - `color`: Font color in hex format (string)
- `tickcolor`: Tick color in hex format (string)
- `title`: Axis title configuration (object)
  - `text`: Title text (string)
  - `font`: Title font styling (object)
    - `size`: Font size (number)
    - `color`: Font color in hex format (string)

#### Global Font Properties

- `font`: Global font styling (object)
  - `size`: Font size (number)
  - `color`: Font color in hex format (string)

### Color Formats

Colors can be specified in multiple formats:

- Hex: `"#1f77b4"`
- RGB: `"rgb(31, 119, 180)"`
- RGBA: `"rgba(31, 119, 180, 0.8)"`

