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

  @override
  State<MaterialBarChart> createState() => _MaterialBarChartState();
}

class _MaterialBarChartState extends State<MaterialBarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller; // Controller for the animation
  late Animation<double> _animation; // Animation for the chart
  int? _hoveredBarIndex; // Index of the currently hovered bar

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
        widget.onAnimationComplete?.call(); // Callback when animation completes
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
      onExit:
          widget.interactive
              ? (_) => setState(
                () => _hoveredBarIndex = null,
              ) // Clear hovered index on exit
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
                hoveredBarIndex: _hoveredBarIndex,
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

    final chartArea = Rect.fromLTWH(
      widget.padding.left,
      widget.padding.top,
      widget.width - widget.padding.horizontal,
      widget.height - widget.padding.vertical,
    );

    final barWidth =
        (chartArea.width / widget.data.length) * (1 - widget.style.barSpacing);
    final spacing =
        (chartArea.width / widget.data.length) * widget.style.barSpacing;

    final x = event.localPosition.dx - chartArea.left; // Calculate x position
    final barIndex = (x / (barWidth + spacing)).floor(); // Determine bar index

    if (barIndex >= 0 && barIndex < widget.data.length) {
      setState(() => _hoveredBarIndex = barIndex); // Update hovered bar index
    } else {
      setState(
        () => _hoveredBarIndex = null,
      ); // Clear hovered bar index if out of bounds
    }
  }
}
