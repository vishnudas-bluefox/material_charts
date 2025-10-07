import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'models.dart';
import 'painter.dart';

/// A stateful widget that represents a material design bar chart with rotation support.
///
/// This widget allows customization of the bar chart's appearance,
/// interactions, animations, and rotation. It is capable of displaying data
/// dynamically with smooth animation and supports professional chart orientations
/// like Plotly (vertical, horizontal, and custom rotations).
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
  /// Supports both simple and Plotly-compatible formats including rotation.
  ///
  /// Example JSON with rotation:
  /// ```json
  /// {
  ///   "data": [
  ///     {"x": "A", "y": 10},
  ///     {"x": "B", "y": 20}
  ///   ],
  ///   "style": {
  ///     "rotation": 90  // or use "orientation": "h" for Plotly compatibility
  ///   }
  /// }
  /// ```
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

  /// Creates a [MaterialBarChart] from Plotly-compatible data arrays.
  /// Supports Plotly's orientation parameter ('v' or 'h').
  ///
  /// Example:
  /// ```dart
  /// MaterialBarChart.fromPlotly(
  ///   x: ['A', 'B', 'C'],
  ///   y: [10, 20, 15],
  ///   orientation: 'h', // horizontal bars (90 degree rotation)
  /// )
  /// ```
  factory MaterialBarChart.fromPlotly({
    Key? key,
    required List<String> x,
    required List<double> y,
    List<String>? colors,
    String orientation = 'v', // 'v' for vertical, 'h' for horizontal
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

    for (int i = 0; i < x.length; i++) {
      Color? color;
      if (colors != null && i < colors.length) {
        color = BarChartData.parseColor(colors[i]);
      }

      data.add(BarChartData(value: y[i], label: x[i], color: color));
    }

    // Merge orientation with style
    final styleMap =
        style != null ? Map<String, dynamic>.from(style) : <String, dynamic>{};
    styleMap['orientation'] = orientation;

    final chartStyle = BarChartStyle.fromJson(styleMap);

    return MaterialBarChart(
      key: key,
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

  /// Creates a [MaterialBarChart] from simple data arrays.
  /// This is a convenience constructor for quick chart creation with optional rotation.
  ///
  /// Example:
  /// ```dart
  /// MaterialBarChart.fromData(
  ///   labels: ['A', 'B', 'C'],
  ///   values: [10, 20, 15],
  ///   rotation: 90, // Optional: rotate chart 90 degrees
  /// )
  /// ```
  factory MaterialBarChart.fromData({
    Key? key,
    required List<String> labels,
    required List<double> values,
    List<String>? colors,
    Map<String, dynamic>? style,
    double? rotation, // Custom rotation in degrees
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

    // Merge rotation with style if provided
    final styleMap =
        style != null ? Map<String, dynamic>.from(style) : <String, dynamic>{};
    if (rotation != null) {
      styleMap['rotation'] = rotation;
    }

    final chartStyle = BarChartStyle.fromJson(styleMap);

    return MaterialBarChart(
      key: key,
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
  void didUpdateWidget(MaterialBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Restart animation if data or style changes significantly
    if (oldWidget.data != widget.data ||
        oldWidget.style.rotation != widget.style.rotation) {
      _controller.reset();
      _controller.forward();
    }
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

    setState(() => _hoverPosition = event.localPosition);
  }
}
