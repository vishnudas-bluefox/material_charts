import 'package:flutter/material.dart';
import 'package:material_charts/src/line_chart/models.dart';
import 'package:material_charts/src/line_chart/painter.dart';

/// A widget that displays a line chart based on the provided data.
///
/// The chart supports various styling options, including line color,
/// point visibility, grid lines, and animation. It allows customization
/// for padding, chart size, and callback functionality upon animation completion.
class MaterialChartLine extends StatefulWidget {
  /// The data points to be displayed in the line chart.
  final List<ChartData> data;

  /// The width of the chart.
  final double width;

  /// The height of the chart.
  final double height;

  /// The styling configuration for the line chart.
  final LineChartStyle style;

  /// A flag indicating whether to show data points on the chart.
  final bool showPoints;

  /// A flag indicating whether to display grid lines in the chart.
  final bool showGrid;

  /// Padding around the chart area.
  final EdgeInsets padding;

  /// The number of horizontal grid lines to display.
  final int horizontalGridLines;

  /// A callback that is invoked when the chart animation completes.
  final VoidCallback? onAnimationComplete;

  /// Creates a new instance of [MaterialChartLine].
  const MaterialChartLine({
    super.key,
    required this.data,
    required this.width,
    required this.height,
    this.style = const LineChartStyle(),
    this.showPoints = true,
    this.showGrid = true,
    this.padding = const EdgeInsets.all(24),
    this.horizontalGridLines = 5,
    this.onAnimationComplete,
  });

  @override
  State<MaterialChartLine> createState() => _MaterialChartLineState();
}

class _MaterialChartLineState extends State<MaterialChartLine>
    with SingleTickerProviderStateMixin {
  /// The animation controller responsible for managing the chart's animation.
  late AnimationController _controller;

  /// The animation value that drives the drawing of the chart.
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  /// Initializes the animation controller and the animation.
  void _setupAnimation() {
    _controller = AnimationController(
      duration: widget.style.animationDuration,
      vsync: this,
    );

    // Animate the progress from 0.0 to 1.0 over the defined duration.
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.style.animationCurve,
      ),
    )..addStatusListener((status) {
        // Trigger the completion callback when the animation ends.
        if (status == AnimationStatus.completed) {
          widget.onAnimationComplete?.call();
        }
      });

    // Start the animation forward.
    _controller.forward();
  }

  @override
  void dispose() {
    // Dispose the animation controller when the widget is removed from the widget tree.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: widget
          .style.backgroundColor, // Set the background color for the chart.
      child: AnimatedBuilder(
        animation: _animation, // Rebuilds when the animation changes.
        builder: (context, _) {
          return CustomPaint(
            size: Size(widget.width, widget.height), // Set custom paint size.
            painter: LineChartPainter(
              data: widget.data, // Pass the data points for the chart.
              progress: _animation.value, // Use the current animation value.
              style: widget.style, // Pass the style configuration.
              showPoints: widget
                  .showPoints, // Indicates if data points should be shown.
              showGrid:
                  widget.showGrid, // Indicates if grid lines should be shown.
              padding: widget.padding, // Apply padding around the chart.
              horizontalGridLines:
                  widget.horizontalGridLines, // Define horizontal grid lines.
            ),
          );
        },
      ),
    );
  }
}
