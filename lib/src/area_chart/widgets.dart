import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'models.dart';
import 'painter.dart';

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

  /// Creates a MaterialAreaChart from Plotly JSON string.
  ///
  /// This constructor allows you to directly use JSON data formatted
  /// for Plotly (commonly used in Python scripts) to create the area chart.
  ///
  /// Example usage:
  /// ```dart
  /// MaterialAreaChart.fromPlotlyJson(
  ///   plotlyJson: '''
  ///   {
  ///     "data": [
  ///       {
  ///         "x": [1, 2, 3, 4],
  ///         "y": [10, 11, 12, 13],
  ///         "type": "scatter",
  ///         "mode": "lines",
  ///         "fill": "tozeroy",
  ///         "name": "Series 1",
  ///         "line": {"color": "blue", "width": 2}
  ///       }
  ///     ],
  ///     "layout": {
  ///       "title": "My Area Chart"
  ///     }
  ///   }
  ///   ''',
  ///   width: 400,
  ///   height: 300,
  /// )
  /// ```
  factory MaterialAreaChart.fromPlotlyJson({
    Key? key,
    required String plotlyJson,
    required double width,
    required double height,
    AreaChartStyle? styleOverrides,
    VoidCallback? onAnimationComplete,
    bool interactive = true,
  }) {
    final PlotlyAreaChartData plotlyData = PlotlyAreaChartParser.fromJson(
      plotlyJson,
    );

    // Merge style overrides with parsed style
    final AreaChartStyle finalStyle = styleOverrides != null
        ? _mergeStyles(plotlyData.style, styleOverrides)
        : plotlyData.style;

    return MaterialAreaChart(
      key: key,
      series: plotlyData.series,
      width: width,
      height: height,
      style: finalStyle,
      onAnimationComplete: onAnimationComplete,
      interactive: interactive,
    );
  }

  /// Creates a MaterialAreaChart from Plotly data map.
  ///
  /// representing Plotly data structure.
  factory MaterialAreaChart.fromPlotlyMap({
    Key? key,
    required Map<String, dynamic> plotlyData,
    required double width,
    required double height,
    AreaChartStyle? styleOverrides,
    VoidCallback? onAnimationComplete,
    bool interactive = true,
  }) {
    final PlotlyAreaChartData parsedData = PlotlyAreaChartParser.fromMap(
      plotlyData,
    );

    // Merge style overrides with parsed style
    final AreaChartStyle finalStyle = styleOverrides != null
        ? _mergeStyles(parsedData.style, styleOverrides)
        : parsedData.style;

    return MaterialAreaChart(
      key: key,
      series: parsedData.series,
      width: width,
      height: height,
      style: finalStyle,
      onAnimationComplete: onAnimationComplete,
      interactive: interactive,
    );
  }

  /// Helper method to merge style overrides with parsed style
  static AreaChartStyle _mergeStyles(
    AreaChartStyle baseStyle,
    AreaChartStyle overrides,
  ) {
    return AreaChartStyle(
      colors: overrides.colors.isNotEmpty ? overrides.colors : baseStyle.colors,
      gridColor: overrides.gridColor != Colors.grey
          ? overrides.gridColor
          : baseStyle.gridColor,
      backgroundColor: overrides.backgroundColor != Colors.white
          ? overrides.backgroundColor
          : baseStyle.backgroundColor,
      labelStyle: overrides.labelStyle ?? baseStyle.labelStyle,
      defaultLineWidth: overrides.defaultLineWidth != 2.0
          ? overrides.defaultLineWidth
          : baseStyle.defaultLineWidth,
      defaultPointSize: overrides.defaultPointSize != 4.0
          ? overrides.defaultPointSize
          : baseStyle.defaultPointSize,
      showPoints: overrides.showPoints != true
          ? overrides.showPoints
          : baseStyle.showPoints,
      showGrid:
          overrides.showGrid != true ? overrides.showGrid : baseStyle.showGrid,
      animationDuration:
          overrides.animationDuration != const Duration(milliseconds: 1500)
              ? overrides.animationDuration
              : baseStyle.animationDuration,
      animationCurve: overrides.animationCurve != Curves.easeInOut
          ? overrides.animationCurve
          : baseStyle.animationCurve,
      padding: overrides.padding != const EdgeInsets.all(24)
          ? overrides.padding
          : baseStyle.padding,
      horizontalGridLines: overrides.horizontalGridLines != 5
          ? overrides.horizontalGridLines
          : baseStyle.horizontalGridLines,
      forceYAxisFromZero: overrides.forceYAxisFromZero != true
          ? overrides.forceYAxisFromZero
          : baseStyle.forceYAxisFromZero,
      title: overrides.title ?? baseStyle.title,
      xAxisTitle: overrides.xAxisTitle ?? baseStyle.xAxisTitle,
      yAxisTitle: overrides.yAxisTitle ?? baseStyle.yAxisTitle,
    );
  }

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
    return Column(
      children: [
        // Add title if present
        if (widget.style.title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              widget.style.title!,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

        // Main chart area
        MouseRegion(
          // Detect mouse hover events
          onHover: widget.interactive
              ? _handleHover
              : null, // Handle hover if interactive
          onExit: widget.interactive
              ? (_) => setState(
                    () => _tooltipPosition = null,
                  ) // Clear tooltip position on exit
              : null,
          child: Container(
            width: widget.width, // Set the width of the container
            height: widget.height, // Set the height of the container
            color: widget.style
                .backgroundColor, // Set the background color from the style
            child: AnimatedBuilder(
              // Rebuild the widget when the animation changes
              animation: _animation,
              builder: (context, _) {
                return CustomPaint(
                  size: Size(
                    widget.width,
                    widget.height,
                  ), // Set the size for the custom painter
                  painter: AreaChartPainter(
                    series:
                        widget.series, // Pass the series data to the painter
                    progress:
                        _animation.value, // Pass the current animation progress
                    style: widget.style, // Pass the style configuration
                    tooltipPosition:
                        _tooltipPosition, // Pass the tooltip position
                  ),
                );
              },
            ),
          ),
        ),

        // Add axis titles if present
        if (widget.style.xAxisTitle != null || widget.style.yAxisTitle != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Y-axis title (rotated)
                if (widget.style.yAxisTitle != null)
                  RotatedBox(
                    quarterTurns: 3,
                    child: Text(
                      widget.style.yAxisTitle!,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),

                const Spacer(),

                // X-axis title
                if (widget.style.xAxisTitle != null)
                  Text(
                    widget.style.xAxisTitle!,
                    style: const TextStyle(fontSize: 14),
                  ),

                const Spacer(),

                // Empty space for balance
                if (widget.style.yAxisTitle != null) const SizedBox(width: 20),
              ],
            ),
          ),
      ],
    );
  }

  /// Handles mouse hover events to show the tooltip
  void _handleHover(PointerHoverEvent event) {
    if (!widget.interactive) return; // Exit if not interactive
    setState(
      () => _tooltipPosition = event.localPosition,
    ); // Update tooltip position based on mouse location
  }
}
