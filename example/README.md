# Material Charts Example

This example demonstrates how to use the Material Charts library in a Flutter application.

## Features Demonstrated

- **Line Chart**: Monthly sales data with curved lines
- **Bar Chart**: Product sales comparison with gradient effects
- **Pie Chart**: Device usage distribution with legend
- **Area Chart**: Quarterly revenue trends
- **Multi-Line Chart**: Sales vs profit comparison
- **Stacked Bar Chart**: Quarterly product sales breakdown
- **Hollow Semi-Circle**: Goal achievement indicator
- **Gantt Chart**: Project timeline visualization
- **Candlestick Chart**: Stock price movement

## Running the Example

1. Navigate to the example directory:

   ```bash
   cd example
   ```

2. Get dependencies:

   ```bash
   flutter pub get
   ```

3. Run the example:
   ```bash
    cd example
    flutter pub get
    flutter run
   ```

## Code Structure

- `main.dart`: Contains all chart examples in a tabbed interface
- Each chart type has its own widget demonstrating different configurations
- Includes various styling options and data formats

## Usage Patterns

### Basic Line Chart

```dart
MaterialChartLine(
  data: [
    ChartData(value: 10, label: 'Jan'),
    ChartData(value: 25, label: 'Feb'),
    // ...
  ],
  width: 350,
  height: 250,
  style: LineChartStyle(
    lineColor: Colors.blue,
    useCurvedLines: true,
  ),
)
```

### Interactive Pie Chart

```dart
MaterialPieChart(
  data: [
    PieChartData(value: 30, label: 'Mobile', color: Colors.blue),
    // ...
  ],
  width: 350,
  height: 300,
  interactive: true,
)
```

### Animated Bar Chart

```dart
MaterialBarChart(
  data: barData,
  width: 350,
  height: 300,
  style: BarChartStyle(
    animationDuration: Duration(milliseconds: 1500),
    gradientEffect: true,
  ),
)
```

## Customization

Each chart type supports extensive customization through its style configuration:

- Colors and gradients
- Animation duration and curves
- Label positioning and formatting
- Interactive features
- Grid and axis configuration

Explore the example code to see various customization options in action.
