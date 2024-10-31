import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'models.dart';
import 'painter.dart';

/// A widget that displays a multi-line chart with interactive features.
///
/// This chart can display multiple series of data and supports features
/// like zooming, panning, and tapping on individual data points. The
/// appearance of the chart can be customized using the [MultiLineChartStyle]
/// configuration.
class MultiLineChart extends StatefulWidget {
  final List<ChartSeries>
      series; // The data series to be displayed in the chart.
  final MultiLineChartStyle style; // The styling configuration for the chart.
  final double? height; // Optional height for the chart.
  final double? width; // Optional width for the chart.
  final ValueChanged<ChartDataPoint>?
      onPointTap; // Callback for when a point is tapped.
  final ValueChanged<Offset>?
      onChartTap; // Callback for when the chart is tapped.
  final bool enableZoom; // Flag to enable zoom functionality.
  final bool enablePan; // Flag to enable panning functionality.

  /// Creates a [MultiLineChart] widget.
  ///
  /// All parameters are required except for height, width, onPointTap,
  /// and onChartTap, which are optional. Zoom and pan functionalities are
  /// disabled by default.
  const MultiLineChart({
    super.key,
    required this.series,
    required this.style,
    this.height,
    this.width,
    this.onPointTap,
    this.onChartTap,
    this.enableZoom = false,
    this.enablePan = false,
  });

  @override
  _MultiLineChartState createState() => _MultiLineChartState();
}

class _MultiLineChartState extends State<MultiLineChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller; // Controller for managing animations.
  late Animation<double>
      _animation; // Animation object for controlling the animation progress.
  Offset? _crosshairPosition; // Current position of the crosshair.
  double _scale = 1.0; // Current scale factor for zooming.
  Offset _panOffset = Offset.zero; // Current offset for panning.
  Offset? _lastFocalPoint; // Last focal point for scaling gestures.
  Size? _containerSize; // Size of the chart container.

  @override
  void initState() {
    super.initState();
    _setupAnimation(); // Initializes the animation controller and starts the animation.
  }

  void _setupAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.style.animation.duration,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.style.animation.curve,
    );

    // Start the animation if enabled; otherwise, set it to fully completed.
    if (widget.style.animation.enabled) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the animation controller.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = widget.width ??
            constraints.maxWidth; // Determine the width of the chart.
        final height = widget.height ??
            constraints.maxHeight; // Determine the height of the chart.
        _containerSize = Size(width, height); // Set the container size.

        return MouseRegion(
          onEnter: (_) => setState(() => _crosshairPosition =
              null), // Hide the crosshair when the mouse enters.
          onExit: (_) => setState(() => _crosshairPosition =
              null), // Hide the crosshair when the mouse exits.
          onHover: (PointerHoverEvent event) {
            setState(() {
              _crosshairPosition = event
                  .localPosition; // Update the crosshair position on hover.
            });
          },
          child: widget.enableZoom || widget.enablePan
              ? GestureDetector(
                  onScaleStart:
                      _handleScaleStart, // Handle scale start gesture.
                  onScaleUpdate:
                      _handleScaleUpdate, // Handle scale update gesture.
                  child: _buildChartContent(
                      width, height), // Build the chart content.
                )
              : _buildChartContent(width,
                  height), // Just build the chart content without gestures.
        );
      },
    );
  }

  /// Builds the main content of the chart.
  ///
  /// This function creates a container that holds the chart and applies
  /// the specified background color. The chart is drawn using the
  /// CustomPaint widget with an animated painter.
  Widget _buildChartContent(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: widget
            .style.backgroundColor, // Set the background color from style.
      ),
      child: AnimatedBuilder(
        animation: _animation, // Listen for animation changes.
        builder: (context, child) {
          return CustomPaint(
            painter: MultiLineChartPainter(
              series: widget.series, // Data series for the chart.
              style: widget.style, // Style configuration for the chart.
              progress: _animation.value, // Current progress of the animation.
              crosshairPosition:
                  _crosshairPosition, // Position of the crosshair.
              scale: _scale, // Current scale factor.
              panOffset: _panOffset, // Current pan offset.
            ),
            size:
                Size(width, height), // Set the size of the CustomPaint widget.
          );
        },
      ),
    );
  }

  /// Constrains the pan offset to prevent the chart from being panned
  /// beyond its bounds.
  ///
  /// Returns a constrained offset based on the current scale and
  /// the size of the container.
  Offset _constrainPanOffset(Offset offset, Size containerSize) {
    // Calculate the bounds for panning based on scale and container size.
    final scaledWidth = containerSize.width * (_scale - 1);
    final scaledHeight = containerSize.height * (_scale - 1);

    // Calculate maximum allowed pan distances.
    final maxHorizontalPan = scaledWidth / 2;
    final maxVerticalPan = scaledHeight / 2;

    return Offset(
      offset.dx.clamp(-maxHorizontalPan, maxHorizontalPan),
      offset.dy.clamp(-maxVerticalPan, maxVerticalPan),
    );
  }

  /// Handles the start of a scaling gesture.
  ///
  /// Stores the focal point to calculate deltas during scaling.
  void _handleScaleStart(ScaleStartDetails details) {
    _lastFocalPoint = details.focalPoint; // Store the focal point.
  }

  /// Handles updates during scaling gestures.
  ///
  /// Updates the scale factor and pan offset based on user interactions.
  void _handleScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      if (widget.enableZoom) {
        // Update scale first, clamping it to the defined limits.
        final newScale = (_scale * details.scale)
            .clamp(1.0, 3.0); // Minimum scale is 1.0, maximum is 3.0.
        _scale = newScale;
      }

      if (widget.enablePan && _lastFocalPoint != null) {
        // Calculate the pan delta based on the focal point.
        final delta = details.focalPoint - _lastFocalPoint!;

        // Update pan offset with constraints.
        final newPanOffset = _panOffset + delta;
        _panOffset = _constrainPanOffset(newPanOffset, _containerSize!);

        _lastFocalPoint = details.focalPoint; // Update the last focal point.
      }
    });
  }

  /// Handles tap down events on the chart.
  ///
  /// Updates the crosshair position and triggers the onChartTap callback.
  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _crosshairPosition =
          details.localPosition; // Set the crosshair position on tap.
    });
    widget.onChartTap
        ?.call(details.localPosition); // Trigger the callback if available.
  }
}
