import 'package:flutter/material.dart';

import 'models.dart';
import 'painter.dart';

/// A widget that displays a line chart based on the provided data.
///
/// The chart supports various styling options, including line color,
/// point visibility, grid lines, tooltip functionality, and animation.
/// It allows customization for padding, chart size, and callback functionality
/// upon animation completion.
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

  /// A flag indicating whether to show tooltips when hovering over data points.
  final bool showTooltips;

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
    this.showTooltips = true,
    this.padding = const EdgeInsets.all(24),
    this.horizontalGridLines = 5,
    this.onAnimationComplete,
  });

  /// Creates a [MaterialChartLine] from JSON configuration.
  /// Supports both simple and Plotly-compatible formats.
  factory MaterialChartLine.fromJson(Map<String, dynamic> json) {
    final config = LineChartJsonConfig.fromJson(json);
    return MaterialChartLine(
      data: config.getChartData(),
      width: config.width,
      height: config.height,
      style: config.getLineChartStyle(),
      showGrid: config.showGrid,
      showPoints: config.showPoints,
      showTooltips: config.showTooltips,
      padding: config.padding,
      horizontalGridLines: config.horizontalGridLines,
      onAnimationComplete: config.onAnimationComplete,
    );
  }

  /// Creates a [MaterialChartLine] from a JSON string.
  factory MaterialChartLine.fromJsonString(String jsonString) {
    final config = LineChartJsonConfig.fromJsonString(jsonString);
    return MaterialChartLine(
      data: config.getChartData(),
      width: config.width,
      height: config.height,
      style: config.getLineChartStyle(),
      showGrid: config.showGrid,
      showPoints: config.showPoints,
      showTooltips: config.showTooltips,
      padding: config.padding,
      horizontalGridLines: config.horizontalGridLines,
      onAnimationComplete: config.onAnimationComplete,
    );
  }

  /// Creates a [MaterialChartLine] from simple data arrays.
  /// This is a convenience constructor for quick chart creation.
  factory MaterialChartLine.fromData({
    required List<String> labels,
    required List<double> values,
    Map<String, dynamic>? style,
    double width = 800,
    double height = 400,
    bool showGrid = true,
    bool showPoints = true,
    bool showTooltips = true,
    EdgeInsets padding = const EdgeInsets.all(24),
    int horizontalGridLines = 5,
    VoidCallback? onAnimationComplete,
  }) {
    final data = <ChartData>[];

    for (int i = 0; i < labels.length && i < values.length; i++) {
      data.add(ChartData(value: values[i], label: labels[i]));
    }

    final chartStyle =
        style != null ? LineChartStyle.fromJson(style) : const LineChartStyle();

    return MaterialChartLine(
      data: data,
      width: width,
      height: height,
      style: chartStyle,
      showGrid: showGrid,
      showPoints: showPoints,
      showTooltips: showTooltips,
      padding: padding,
      horizontalGridLines: horizontalGridLines,
      onAnimationComplete: onAnimationComplete,
    );
  }

  @override
  State<MaterialChartLine> createState() => _MaterialChartLineState();
}

class _MaterialChartLineState extends State<MaterialChartLine>
    with SingleTickerProviderStateMixin {
  /// The animation controller responsible for managing the chart's animation.
  late AnimationController _controller;

  /// The animation value that drives the drawing of the chart.
  late Animation<double> _animation;

  /// Current mouse hover position for tooltip functionality.
  Offset? _hoverPosition;

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
      CurvedAnimation(parent: _controller, curve: widget.style.animationCurve),
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
    return MouseRegion(
      onEnter: (_) =>
          setState(() => _hoverPosition = null), // Reset hover on enter
      onHover: (details) {
        setState(() {
          _hoverPosition = details.localPosition; // Update hover position
        });
      },
      onExit: (_) =>
          setState(() => _hoverPosition = null), // Clear hover on exit
      child: Container(
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
                style: widget.showTooltips
                    ? widget.style
                    : widget.style.copyWith(
                        showTooltips: false,
                      ), // Override tooltip visibility
                showPoints: widget
                    .showPoints, // Indicates if data points should be shown.
                showGrid:
                    widget.showGrid, // Indicates if grid lines should be shown.
                padding: widget.padding, // Apply padding around the chart.
                horizontalGridLines:
                    widget.horizontalGridLines, // Define horizontal grid lines.
                hoverPosition:
                    _hoverPosition, // Pass hover position for tooltips.
              ),
            );
          },
        ),
      ),
    );
  }
}
