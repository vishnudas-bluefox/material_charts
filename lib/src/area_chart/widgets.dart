import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:material_charts/src/area_chart/models.dart';
import 'package:material_charts/src/area_chart/painter.dart';

/// The main area chart widget
class MaterialAreaChart extends StatefulWidget {
  final List<AreaChartSeries> series; // List of series data for the area chart
  final double width; // Width of the chart
  final double height; // Height of the chart
  final AreaChartStyle style; // Style configuration for the chart
  final VoidCallback?
      onAnimationComplete; // Callback for when the animation completes
  final bool interactive; // Flag to enable or disable interactivity

  const MaterialAreaChart({
    super.key,
    required this.series, // Required series data
    required this.width, // Required width
    required this.height, // Required height
    this.style = const AreaChartStyle(), // Default style if none provided
    this.onAnimationComplete, // Optional callback for animation completion
    this.interactive = true, // Default to interactive
  });

  @override
  State<MaterialAreaChart> createState() => _MaterialAreaChartState();
}

class _MaterialAreaChartState extends State<MaterialAreaChart>
    with SingleTickerProviderStateMixin {
  late AnimationController
      _controller; // Animation controller for managing the animation
  late Animation<double> _animation; // Animation for the progress of the chart
  Offset? _tooltipPosition; // Position of the tooltip when hovering over points

  @override
  void initState() {
    super.initState();
    _setupAnimation(); // Set up the animation when the widget is initialized
  }

  /// Sets up the animation controller and animation
  void _setupAnimation() {
    _controller = AnimationController(
      duration: widget
          .style.animationDuration, // Duration of the animation from the style
      vsync: this, // Use this state as the vsync provider
    );

    // Create a tween animation from 0.0 to 1.0
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller, // Use the controller as the parent
        curve:
            widget.style.animationCurve, // Use the curve defined in the style
      ),
    )..addStatusListener((status) {
        // Listen for animation status changes
        if (status == AnimationStatus.completed) {
          // Call the completion callback if the animation is finished
          widget.onAnimationComplete?.call();
        }
      });

    _controller.forward(); // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      // Detect mouse hover events
      onHover: widget.interactive
          ? _handleHover
          : null, // Handle hover if interactive
      onExit: widget.interactive
          ? (_) => setState(
              () => _tooltipPosition = null) // Clear tooltip position on exit
          : null,
      child: Container(
        width: widget.width, // Set the width of the container
        height: widget.height, // Set the height of the container
        color: widget
            .style.backgroundColor, // Set the background color from the style
        child: AnimatedBuilder(
          // Rebuild the widget when the animation changes
          animation: _animation,
          builder: (context, _) {
            return CustomPaint(
              size: Size(widget.width,
                  widget.height), // Set the size for the custom painter
              painter: AreaChartPainter(
                series: widget.series, // Pass the series data to the painter
                progress:
                    _animation.value, // Pass the current animation progress
                style: widget.style, // Pass the style configuration
                tooltipPosition: _tooltipPosition, // Pass the tooltip position
              ),
            );
          },
        ),
      ),
    );
  }

  /// Handles mouse hover events to show the tooltip
  void _handleHover(PointerHoverEvent event) {
    if (!widget.interactive) return; // Exit if not interactive
    setState(() => _tooltipPosition =
        event.localPosition); // Update tooltip position based on mouse location
  }
}
