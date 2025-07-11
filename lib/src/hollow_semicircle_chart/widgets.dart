import 'package:flutter/material.dart';
import 'painter.dart';
import 'models.dart';

/// A material design hollow semi-circle chart widget that displays a
/// percentage value visually as a hollow semi-circle with optional legend and
/// percentage text.
class MaterialChartHollowSemiCircle extends BaseChart {
  /// The radius ratio for the hollow section of the chart.
  /// This value should be between 0 and 1, where 0 represents a solid
  /// circle and 1 represents a fully hollow circle.
  final double hollowRadius;

  /// Constructs a [MaterialChartHollowSemiCircle] widget with required parameters.
  /// The [percentage] parameter indicates the percentage value to be displayed,
  /// and the [hollowRadius] determines how hollow the center of the chart will be.
  const MaterialChartHollowSemiCircle({
    super.key,
    required super.percentage, // Percentage to display on the chart
    super.size = 200, // Default size of the chart
    this.hollowRadius = 0.6, // Default hollow radius ratio
    super.style, // Optional style configuration for the chart
    super.onAnimationComplete, // Optional callback when animation completes
  }) : assert(
          hollowRadius > 0 && hollowRadius < 1,
          'Hollow radius must be between 0 and 1',
        );

  @override
  State<MaterialChartHollowSemiCircle> createState() =>
      _MaterialChartHollowSemiCircleState();
}

/// State class for [MaterialChartHollowSemiCircle].
/// This class manages the animation of the chart and updates its state
/// when the percentage value changes.
class _MaterialChartHollowSemiCircleState
    extends State<MaterialChartHollowSemiCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController; // Controller for the animation
  late Animation<double> _animation; // Animation for the percentage value

  @override
  void initState() {
    super.initState();
    _setupAnimation(); // Set up the animation when the widget initializes
  }

  /// Initializes the animation controller and the animation for the percentage.
  /// The animation goes from 0 to the specified percentage, using the defined
  /// animation duration and curve.
  void _setupAnimation() {
    _animationController = AnimationController(
      vsync: this, // Use the current state as the TickerProvider
      duration: widget.style.animationDuration, // Duration of the animation
    );

    // Tween to animate the percentage value from 0 to the specified percentage.
    _animation = Tween<double>(
      begin: 0, // Starting value of the animation
      end: widget.percentage, // Ending value of the animation
    ).animate(
      CurvedAnimation(
        parent: _animationController, // The animation controller
        curve: widget.style.animationCurve, // Curve for the animation
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onAnimationComplete
              ?.call(); // Call the completion callback if set.
        }
      });

    _animationController.forward(); // Start the animation
  }

  @override
  void didUpdateWidget(MaterialChartHollowSemiCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the percentage has changed, update the animation.
    if (oldWidget.percentage != widget.percentage) {
      // Create a new Tween to animate from the old percentage to the new percentage.
      _animation = Tween<double>(
        begin: oldWidget.percentage, // Start from the old percentage
        end: widget.percentage, // End at the new percentage
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: widget.style.animationCurve, // Use the same curve as before
        ),
      );
      _animationController.forward(from: 0); // Restart the animation from 0
    }
  }

  @override
  void dispose() {
    _animationController
        .dispose(); // Dispose of the animation controller to free up resources
    super.dispose(); // Call the super class dispose method
  }

  /// Formats the percentage value for display in the chart.
  /// If a custom formatter is provided, it uses that; otherwise, it defaults
  /// to showing the percentage as an integer followed by a percent sign.
  String _formatPercentage(double value) {
    if (widget.style.percentageFormatter != null) {
      return widget.style.percentageFormatter!(value);
    }
    return '${value.toStringAsFixed(0)}%'; // Default formatting
  }

  /// Formats the legend label for the chart.
  /// If a custom legend formatter is provided, it uses that; otherwise,
  /// it defaults to displaying the type and value.
  String _formatLegendLabel(String type, double value) {
    if (widget.style.legendFormatter != null) {
      return widget.style.legendFormatter!(type, value);
    }
    return '$type (${value.toStringAsFixed(0)}%)'; // Default legend formatting
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Minimize the space taken by the column
      children: [
        // Display the legend if the style allows it
        if (widget.style.showLegend) ...[
          Padding(
            padding: const EdgeInsets.only(
              bottom: 24,
            ), // Add spacing below the legend
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center align the legend items
              children: [
                _LegendItem(
                  color: widget
                      .style.activeColor, // Color for the active legend item
                  label: _formatLegendLabel(
                    'Active',
                    widget.percentage,
                  ), // Label for active
                  style: widget.style.legendStyle, // Custom style for legend
                ),
                const SizedBox(width: 24), // Space between legend items
                _LegendItem(
                  color: widget.style
                      .inactiveColor, // Color for the inactive legend item
                  label: _formatLegendLabel(
                    'Inactive',
                    100 - widget.percentage,
                  ), // Label for inactive
                  style: widget.style.legendStyle, // Custom style for legend
                ),
              ],
            ),
          ),
        ],
        // Create a SizedBox to define the size of the chart
        SizedBox(
          width: widget.size, // Width of the chart
          height: widget.size / 2, // Height of the chart (half the width)
          child: AnimatedBuilder(
            animation:
                _animation, // Animate the chart based on the animation value
            builder: (context, child) {
              return Stack(
                alignment:
                    Alignment.center, // Center the child elements in the stack
                children: [
                  CustomPaint(
                    size: Size(
                      widget.size,
                      widget.size / 2,
                    ), // Size of the custom paint area
                    painter: HollowSemiCircleChart(
                      percentage:
                          _animation.value, // Current percentage to paint
                      activeColor: widget
                          .style.activeColor, // Active color for the chart
                      inactiveColor: widget
                          .style.inactiveColor, // Inactive color for the chart
                      hollowRadius: widget.hollowRadius, // Hollow radius ratio
                    ),
                  ),
                  // Show percentage text if enabled in the style
                  if (widget.style.showPercentageText)
                    Positioned(
                      bottom: 0, // Position at the bottom of the stack
                      child: Text(
                        _formatPercentage(
                          _animation.value,
                        ), // Format the percentage text
                        style: widget.style.percentageStyle?.copyWith(
                              color: widget.style
                                  .textColor, // Apply custom text color if specified
                            ) ??
                            TextStyle(
                              fontSize: widget.size / 8, // Default font size
                              fontWeight: FontWeight.bold, // Bold font weight
                              color: widget.style
                                  .textColor, // Use custom text color if provided
                            ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

/// A widget that represents a single item in the legend of the chart.
/// Displays a colored square and a label.
class _LegendItem extends StatelessWidget {
  /// The color of the legend item.
  final Color color;

  /// The label to display next to the color.
  final String label;

  /// Optional style for the legend text.
  final TextStyle? style;

  /// Constructs a [_LegendItem] with the specified color, label, and optional style.
  const _LegendItem({
    required this.color, // Required color for the legend item
    required this.label, // Required label for the legend item
    this.style, // Optional text style for the legend
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Minimize the space taken by the row
      children: [
        // Create a small square to represent the legend color
        Container(
          width: 16, // Width of the square
          height: 16, // Height of the square
          decoration: BoxDecoration(
            color: color, // Set the background color of the square
            shape: BoxShape.rectangle, // Shape of the box
            borderRadius: BorderRadius.circular(2), // Rounded corners
          ),
        ),
        const SizedBox(width: 8), // Space between the color box and the label
        // Display the label text for the legend
        Text(
          label,
          style: style ??
              const TextStyle(
                fontSize: 14,
              ), // Use the provided style or default size
        ),
      ],
    );
  }
}
