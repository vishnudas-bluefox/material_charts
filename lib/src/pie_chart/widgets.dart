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

  /// Set a minimal percent size for the PieChartData representation
  final double minSizePercent;

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

  /// Bool for showing the label only on hover
  final bool showLabelOnlyOnHover;

  /// Radius of the pie chart
  /// Started as [double.maxFinite] because it will take part in the min function
  /// at the painter class that calculates the radius
  final double chartRadius;

  /// Creates an instance of [MaterialPieChart].
  ///
  /// Requires [data], [width], and [height]. Optional parameters include [style],
  /// [padding], [onAnimationComplete], and [interactive].

  const MaterialPieChart({
    super.key,
    required this.data,
    required this.width,
    required this.height,
    this.minSizePercent = 0.0,
    this.style = const PieChartStyle(),
    this.padding = const EdgeInsets.all(24),
    this.onAnimationComplete,
    this.interactive = true,
    this.showLabelOnlyOnHover = false,
    this.chartRadius = double.maxFinite,
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

  /// Set the size of pie slices
  ///
  /// Set the size of each pie slice based on minSizePercent,
  /// if 0, essentialy nothing is changed
  List<double> _setSizes(double total) {
    // Minimal value that all slices must have
    double minValue = total * widget.minSizePercent / 100;
    // List os all values for easy change and access
    Iterable<double> values = widget.data.map((item) => item.value);

    // Looped verification for cases where resizing sets a previously valid value
    // to a invalid one
    while (true) {
      // Quantiti of slices to scale up
      final qttToScaleUp = values.where((item) => item < minValue).length;
      // Sum of all values of valid slices
      final validTotal = values
          .where((item) => item >= minValue)
          .fold(0.0, (sum, item) => sum + item);
      // New minimal value based on reconfigured values
      final newMinValue = validTotal /
          (1 - (qttToScaleUp * widget.minSizePercent / 100)) *
          widget.minSizePercent /
          100;
      // When true, this means that all the proporsions are over the minial
      if (newMinValue == minValue) break;
      // Sets the minValue to the new one for the next loop verification
      minValue = newMinValue;
    }
    // Sets the invalid values to the minimal one
    values = values.map((item) => max(item, minValue));
    // Gets the new total for further resizing
    final newTotal = values.fold(0.0, (sum, item) => sum + item);
    // Resizes all values in proporsion to the old one
    values = values.map((item) => item * (total / newTotal));
    return values.toList();
  }

  /// Determines which segment of the pie chart is hovered based on the mouse position.
  ///
  /// Returns the index of the hovered segment or null if not hovering over any segment.
  int? _getHoveredSegment(Offset localPosition) {
    // Get outer and inner radius
    final outerRadius = [
      (widget.width - widget.padding.horizontal) / 2,
      (widget.height - widget.padding.vertical) / 2,
      widget.chartRadius,
    ].reduce(min);
    final innerRadius = outerRadius * widget.style.holeRadius;

    // Center of the pie chart
    final position = Offset(
      switch (widget.style.chartAlignment.horizontal) {
        Horizontal.center => widget.width / 2,
        Horizontal.left => outerRadius + widget.padding.left,
        Horizontal.right => widget.width - (widget.padding.right + outerRadius),
      },
      switch (widget.style.chartAlignment.vertical) {
        Vertical.center => widget.height / 2,
        Vertical.top => outerRadius + widget.padding.top,
        Vertical.bottom => widget.height - (widget.padding.bottom + outerRadius),
      },
    );

    // Calculate distance from the center to the mouse position
    final dx = localPosition.dx - position.dx;
    final dy = localPosition.dy - position.dy;
    final distance = sqrt(dx * dx + dy * dy);

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

    final sizesList = _setSizes(total);

    for (int i = 0; i < widget.data.length; i++) {
      // Calculate sweep angle using value * 3.6
      final sweepAngle = (sizesList[i] / total) * 360; // Calculate sweep angle
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
      child: GestureDetector(
        onTap: _hoveredSegmentIndex != null
            ? widget.data[_hoveredSegmentIndex!].onTap
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
                  sliceSizes: _setSizes(
                    widget.data.fold(0.0, (sum, item) => sum + item.value)),
                  // Pass the sizes of the piechart slices
                  progress: _animation.value, // Pass the animation progress.
                  style: widget.style, // Pass the style configurations.
                  showLabelOnlyOnHover: widget.showLabelOnlyOnHover, 
                   // Pass the show label configuration
                  padding: widget.padding, // Pass the padding.
                  hoveredSegmentIndex:
                      _hoveredSegmentIndex, // Pass the index of the hovered segment.
                  chartRadius: widget.chartRadius, // Pass the chart radius
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
