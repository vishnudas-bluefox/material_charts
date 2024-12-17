import 'dart:math';

import 'package:flutter/material.dart';

import 'models.dart';
import 'painter.dart';

/// A stateful widget that displays a customizable pie chart with optional animations.
///
/// The [MaterialPieChart] takes a list of [PieChartData], dimensions, style settings,
/// padding, and a callback for when the animation completes.
class MaterialPieChart extends StatefulWidget {
  /// The data points to be represented in the pie chart.
  final List<PieChartData> data;

  /// The width of the pie chart.
  final double width;

  /// The height of the pie chart.
  final double height;

  /// Style configurations for the pie chart.
  final PieChartStyle style;

  /// Padding around the pie chart.
  final EdgeInsets padding;

  /// Callback function that is invoked when the animation completes.
  final VoidCallback? onAnimationComplete;

  /// Determines whether the pie chart supports interactivity (hover effects).
  final bool interactive;

  /// Creates an instance of [MaterialPieChart].
  ///
  /// Requires [data], [width], and [height]. Optional parameters include [style],
  /// [padding], [onAnimationComplete], and [interactive].

  const MaterialPieChart({
    super.key,
    required this.data,
    required this.width,
    required this.height,
    this.style = const PieChartStyle(),
    this.padding = const EdgeInsets.all(24),
    this.onAnimationComplete,
    this.interactive = true,
  });

  @override
  State<MaterialPieChart> createState() => _MaterialPieChartState();
}

class _MaterialPieChartState extends State<MaterialPieChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller; // Controls the animation.
  late Animation<double>
      _animation; // Represents the current progress of the animation.
  int?
      _hoveredSegmentIndex; // Holds the index of the currently hovered segment.

  @override
  void initState() {
    super.initState();
    _setupAnimation(); // Initialize the animation settings.
  }

  /// Sets up the animation controller and its animation properties.
  void _setupAnimation() {
    // Create an animation controller with a specified duration from the style.
    _controller = AnimationController(
      duration: widget.style.animationDuration,
      vsync: this, // Provides a TickerProvider for the animation.
    );

    // Create a tween animation that progresses from 0.0 to 1.0.
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget
            .style.animationCurve, // Use a customizable curve for animation.
      ),
    )..addStatusListener((status) {
        // Invoke the callback when the animation completes.
        if (status == AnimationStatus.completed) {
          widget.onAnimationComplete?.call();
        }
      });

    _controller.forward(); // Start the animation.
  }

  @override
  void dispose() {
    _controller
        .dispose(); // Dispose of the animation controller when the widget is removed.
    super.dispose();
  }

  /// Determines which segment of the pie chart is hovered based on the mouse position.
  ///
  /// Returns the index of the hovered segment or null if not hovering over any segment.
  int? _getHoveredSegment(Offset localPosition) {
    // Center of the pie chart
    final center = Offset(widget.width / 2, widget.height / 2);

    // Calculate distance from the center to the mouse position
    final dx = localPosition.dx - center.dx;
    final dy = localPosition.dy - center.dy;
    final distance = sqrt(dx * dx + dy * dy);

    // Get outer and inner radius
    final outerRadius = min(
      (widget.width - widget.padding.horizontal),
      (widget.height - widget.padding.vertical),
    ) / 2;
    final innerRadius = outerRadius * widget.style.holeRadius;

    // Check if the mouse is within the outer radius but outside the inner radius
    if (distance < innerRadius || distance > outerRadius) {
      return null; // Mouse is outside the pie chart area
    }

    // Calculate the angle
    var angle = atan2(dy, dx) * 180 / pi; // Convert to degrees
    angle = (angle + 360) % 360; // Normalize to [0, 360)

    // Adjust for the starting angle
    angle = (angle - widget.style.startAngle + 360) % 360;

    // Find the hovered segment
    final total = widget.data.fold(0.0, (sum, item) => sum + item.value);
    var currentAngle = 0.0;

    for (int i = 0; i < widget.data.length; i++) {
      // Calculate sweep angle using value * 3.6
      final sweepAngle =
          (widget.data[i].value / total) * 360; // Calculate sweep angle
      if (angle >= currentAngle && angle < currentAngle + sweepAngle) {
        return i; // Return the index of the hovered segment
      }
      currentAngle += sweepAngle; // Move to the next segment
    }

    return null; // No segment found
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      // Handle mouse hover events for interactivity.
      onHover: widget.interactive
          ? (event) {
              // Get the index of the currently hovered segment based on mouse position.
              final newIndex = _getHoveredSegment(event.localPosition);
              // Update state only if the hovered segment has changed.
              if (newIndex != _hoveredSegmentIndex) {
                setState(() => _hoveredSegmentIndex = newIndex);
              }
            }
          : null,
      // Handle mouse exit events to reset the hovered segment.
      onExit: widget.interactive
          ? (_) => setState(() => _hoveredSegmentIndex = null)
          : null,
      child: Container(
        width: widget.width, // Set the width of the pie chart.
        height: widget.height, // Set the height of the pie chart.
        color: widget
            .style.backgroundColor, // Set the background color from style.
        child: AnimatedBuilder(
          // Build the pie chart with animation.
          animation: _animation,
          builder: (context, _) {
            return CustomPaint(
              size: Size(
                  widget.width, widget.height), // Size of the custom painter.
              painter: PieChartPainter(
                data: widget.data, // Pass the data for pie chart segments.
                progress: _animation.value, // Pass the animation progress.
                style: widget.style, // Pass the style configurations.
                padding: widget.padding, // Pass the padding.
                hoveredSegmentIndex:
                    _hoveredSegmentIndex, // Pass the index of the hovered segment.
              ),
            );
          },
        ),
      ),
    );
  }
}
