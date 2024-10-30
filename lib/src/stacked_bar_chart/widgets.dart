import 'package:flutter/material.dart';

import 'models.dart';
import 'painter.dart';

/// A customizable Material-styled stacked bar chart with animation and interaction support.
///
/// This widget renders a bar chart with multiple segments inside each bar.
/// It offers options for animation, interactivity, and custom styling.
class MaterialStackedBarChart extends StatefulWidget {
  /// List of [StackedBarData] that defines the bars and their segments.
  final List<StackedBarData> data;

  /// The width of the chart container.
  final double width;

  /// The height of the chart container.
  final double height;

  /// Configuration for the chart's styling and behavior.
  final StackedBarChartStyle style;

  /// Whether to display the chart grid lines.
  final bool showGrid;

  /// Whether to display segment values on the bars.
  final bool showValues;

  /// Padding around the chart content.
  final EdgeInsets padding;

  /// Number of horizontal grid lines on the chart.
  final int horizontalGridLines;

  /// Callback invoked when the animation completes.
  final VoidCallback? onAnimationComplete;

  /// Whether the chart is interactive (supports hover effects).
  final bool interactive;

  /// Constructs a [MaterialStackedBarChart] with customizable parameters.
  ///
  /// * [data], [width], and [height] are required.
  /// * [style] defaults to a basic [StackedBarChartStyle] if not provided.
  /// * [padding] defaults to 24 pixels on all sides.
  const MaterialStackedBarChart({
    super.key,
    required this.data,
    required this.width,
    required this.height,
    this.style = const StackedBarChartStyle(),
    this.showGrid = true,
    this.showValues = true,
    this.padding = const EdgeInsets.all(24),
    this.horizontalGridLines = 5,
    this.onAnimationComplete,
    this.interactive = true,
  });

  @override
  State<MaterialStackedBarChart> createState() =>
      _MaterialStackedBarChartState();
}

class _MaterialStackedBarChartState extends State<MaterialStackedBarChart>
    with SingleTickerProviderStateMixin {
  /// Animation controller to manage the chart animation.
  late AnimationController _controller;

  /// Animation controlling the rendering progress of the bars.
  late Animation<double> _animation;

  /// Index of the currently hovered bar (used for interaction effects).
  int? _hoveredBarIndex;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  /// Sets up the animation controller and configures animation behavior.
  void _setupAnimation() {
    _controller = AnimationController(
      duration: widget.style.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.style.animationCurve,
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onAnimationComplete?.call();
        }
      });

    _controller.forward(); // Start the animation automatically on load.
  }

  @override
  void dispose() {
    _controller
        .dispose(); // Dispose of the animation controller to free resources.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: widget.style.backgroundColor,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          return CustomPaint(
            size: Size(widget.width, widget.height),
            painter: StackedBarChartPainter(
              data: widget.data,
              progress: _animation.value,
              style: widget.style,
              showGrid: widget.showGrid,
              showValues: widget.showValues,
              padding: widget.padding,
              horizontalGridLines: widget.horizontalGridLines,
              hoveredBarIndex: _hoveredBarIndex,
            ),
          );
        },
      ),
    );
  }
}
