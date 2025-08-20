import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'models.dart';
import 'painter.dart';

/// A stateful widget that represents a material design bar chart.
///
/// This widget allows customization of the bar chart's appearance,
/// interactions, and animations. It is capable of displaying data
/// dynamically with a smooth animation.
class MaterialBarChart extends StatefulWidget {
  final List<BarChartData> data; // The data points for the bar chart
  final double width; // Width of the chart
  final double height; // Height of the chart
  final BarChartStyle style; // Styling options for the chart
  final bool showGrid; // Flag to display grid lines
  final bool showValues; // Flag to display bar values
  final EdgeInsets padding; // Padding around the chart
  final int horizontalGridLines; // Number of horizontal grid lines
  final VoidCallback?
      onAnimationComplete; // Callback for when animation finishes
  final bool interactive; // Enable hover/tap interactions

  /// Creates an instance of [MaterialBarChart].
  const MaterialBarChart({
    super.key,
    required this.data,
    required this.width,
    required this.height,
    this.style = const BarChartStyle(),
    this.showGrid = true,
    this.showValues = true,
    this.padding = const EdgeInsets.all(24),
    this.horizontalGridLines = 5,
    this.onAnimationComplete,
    this.interactive = true,
  });

  /// Creates a [MaterialBarChart] from JSON configuration.
  /// Supports both simple and Plotly-compatible formats.
  factory MaterialBarChart.fromJson(Map<String, dynamic> json) {
    final config = BarChartJsonConfig.fromJson(json);
    return MaterialBarChart(
      data: config.getBarChartData(),
      width: config.width,
      height: config.height,
      style: config.getBarChartStyle(),
      showGrid: config.showGrid,
      showValues: config.showValues,
      padding: config.padding,
      horizontalGridLines: config.horizontalGridLines,
      interactive: config.interactive,
      onAnimationComplete: config.onAnimationComplete,
    );
  }

  /// Creates a [MaterialBarChart] from a JSON string.
  factory MaterialBarChart.fromJsonString(String jsonString) {
    final config = BarChartJsonConfig.fromJsonString(jsonString);
    return MaterialBarChart(
      data: config.getBarChartData(),
      width: config.width,
      height: config.height,
      style: config.getBarChartStyle(),
      showGrid: config.showGrid,
      showValues: config.showValues,
      padding: config.padding,
      horizontalGridLines: config.horizontalGridLines,
      interactive: config.interactive,
      onAnimationComplete: config.onAnimationComplete,
    );
  }

  /// Creates a [MaterialBarChart] from simple data arrays.
  /// This is a convenience constructor for quick chart creation.
  factory MaterialBarChart.fromData({
    required List<String> labels,
    required List<double> values,
    List<String>? colors,
    Map<String, dynamic>? style,
    double width = 800,
    double height = 400,
    bool showGrid = true,
    bool showValues = true,
    EdgeInsets padding = const EdgeInsets.all(24),
    int horizontalGridLines = 5,
    bool interactive = true,
    VoidCallback? onAnimationComplete,
  }) {
    final data = <BarChartData>[];

    for (int i = 0; i < labels.length; i++) {
      Color? color;
      if (colors != null && i < colors.length) {
        color = BarChartData.parseColor(colors[i]);
      }

      data.add(BarChartData(value: values[i], label: labels[i], color: color));
    }

    final chartStyle =
        style != null ? BarChartStyle.fromJson(style) : const BarChartStyle();

    return MaterialBarChart(
      data: data,
      width: width,
      height: height,
      style: chartStyle,
      showGrid: showGrid,
      showValues: showValues,
      padding: padding,
      horizontalGridLines: horizontalGridLines,
      interactive: interactive,
      onAnimationComplete: onAnimationComplete,
    );
  }

  @override
  State<MaterialBarChart> createState() => _MaterialBarChartState();
}

class _MaterialBarChartState extends State<MaterialBarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller; // Controller for the animation
  late Animation<double> _animation; // Animation for the chart
  Offset? _hoverPosition; // Position of the mouse hover

  @override
  void initState() {
    super.initState();
    _setupAnimation(); // Set up the animation
  }

  /// Configures the animation for the chart rendering.
  void _setupAnimation() {
    _controller = AnimationController(
      duration: widget.style.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.style.animationCurve),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onAnimationComplete
              ?.call(); // Callback when animation completes
        }
      });

    _controller.forward(); // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: widget.interactive ? _handleHover : null, // Handle hover events
      onExit: widget.interactive
          ? (_) => setState(
                () => _hoverPosition = null,
              ) // Clear hover position on exit
          : null,
      child: Container(
        width: widget.width,
        height: widget.height,
        color: widget.style.backgroundColor,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, _) {
            return CustomPaint(
              size: Size(widget.width, widget.height),
              painter: BarChartPainter(
                data: widget.data,
                progress: _animation.value,
                style: widget.style,
                showGrid: widget.showGrid,
                showValues: widget.showValues,
                padding: widget.padding,
                horizontalGridLines: widget.horizontalGridLines,
                hoverPosition: _hoverPosition,
              ),
            );
          },
        ),
      ),
    );
  }

  /// Handles hover events over the bar chart to update the hovered bar index.
  void _handleHover(PointerHoverEvent event) {
    if (!widget.interactive) return; // Exit if interaction is disabled

    // The event.localPosition is relative to the MouseRegion (which covers the entire container)
    // We need to check if it's within the chart area (excluding padding)
    // Note: chartArea calculation removed as it wasn't being used

    setState(() => _hoverPosition = event.localPosition);
  }
}
