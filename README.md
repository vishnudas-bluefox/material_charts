# Hollow Semi Circle Meter

A customizable Flutter widget for displaying progress or percentages in a hollow semi-circle meter format.

## Features

- Animated semi-circle meter with customizable colors and sizes
- Supports both active and inactive segments
- Displays percentage value in the center
- Optional legend items for active and inactive segments
- Smooth animation when updating values

## Getting Started

Add the package to your project's pubspec.yaml file:

## Usage

Example usage:

```
HollowSemiCircleMeter(
    percentage: 75,
    size: 300,
    hollowRadius: 0.7,
    style: MeterStyle(
    activeColor: Colors.green,
    inactiveColor: Colors.grey.shade200,
    textColor: Colors.green,
    percentageStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
    ),
    legendStyle: TextStyle(
        fontSize: 16,
        color: Colors.grey.shade700,
    ),
    animationDuration: Duration(milliseconds: 2000),
    animationCurve: Curves.elasticOut,
    percentageFormatter: (value) => '${value.toInt()}',
    legendFormatter: (type, value) =>
        '$type: ${value.toStringAsFixed(1)}%',
    ),
    onAnimationComplete: () => debugPrint('Animation completed!'),
),

```

OutPut:

![Sample Meter with 65%](https://github.com/vishnudas-bluefox/material_charts/blob/master/images/demo_chart1.png)

You can customize various properties of the meter:

- `percentage`: The percentage value to display (0-100)
- `activeColor`: Color for the active segment
- `inactiveColor`: Color for the inactive segment
- `size`: Overall size of the widget
- `hollowRadius`: Radius of the inner hole (as a fraction of the outer radius)
- `labelStatus`: Whether to show legend items below the meter

The widget supports animation when updating the percentage value.

## Additional Information

- This package uses Flutter's CustomPainter to draw the semi-circle meter.
- It's designed to be flexible and customizable to fit various design needs.
- Contributions and feature requests are welcome. Please file issues or pull requests on the GitHub repository.

For more information about the package, including API documentation and example usage, please visit the [GitHub repository](https://github.com/vishnudas-bluefox/material_charts).

[![License](https://img.shields.io/badge/License-BSD_3--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
