import 'package:flutter/material.dart';
import 'dart:math';

import 'models.dart';
import 'painter.dart';

/// MaterialCandlestickChart is a stateful widget that provides a user-friendly
/// interface for displaying and interacting with candlestick chart data.
///
/// Features:
/// - Animated chart rendering
/// - Interactive scrolling
/// - Hover effects
/// - Responsive sizing
/// - Customizable styling and configuration
///
/// Example usage:
/// ```dart
/// MaterialCandlestickChart(
///   data: candlestickData,
///   width: 400,
///   height: 300,
///   style: CandlestickStyle(),
///   showGrid: true,
/// )
/// ```
class MaterialCandlestickChart extends StatefulWidget {
  /// The candlestick data to be displayed
  final List<CandlestickData> data;

  /// Fixed width of the chart
  final double width;

  /// Fixed height of the chart
  final double height;

  /// Optional background color for the chart container
  final Color? backgroundColor;

  /// Visual styling configuration for candlesticks
  final CandlestickStyle style;

  /// Configuration for chart axes
  final ChartAxisConfig axisConfig;

  /// Padding around the chart
  final EdgeInsets padding;

  /// Whether to show grid lines
  final bool showGrid;

  /// Callback fired when entrance animation completes
  final VoidCallback? onAnimationComplete;

  const MaterialCandlestickChart({
    super.key,
    required this.data,
    required this.width,
    required this.height,
    this.backgroundColor,
    this.style = const CandlestickStyle(),
    this.axisConfig = const ChartAxisConfig(),
    this.padding = const EdgeInsets.all(16),
    this.showGrid = true,
    this.onAnimationComplete,
  });

  @override
  State<MaterialCandlestickChart> createState() =>
      _MaterialCandlestickChartState();
}

/// State class for MaterialCandlestickChart handling animations, gestures, and rendering
class _MaterialCandlestickChartState extends State<MaterialCandlestickChart>
    with SingleTickerProviderStateMixin {
  /// Controls the entrance animation
  late AnimationController _controller;

  /// Animation for progressive chart rendering
  late Animation<double> _animation;

  /// Current horizontal scroll position
  double _scrollOffset = 0.0;

  /// Current mouse hover position
  Offset? _hoverPosition;

  /// Stores the initial touch position for pan gesture
  double? _lastFocalPointX;

  /// Base scroll offset when starting a pan gesture
  double _baseScrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _scrollToEnd(); // Scroll to the last candle on initial build
  }

  @override
  void didUpdateWidget(MaterialCandlestickChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data.length != widget.data.length) {
      _scrollToEnd(); // Scroll to the last candle when data updates
    }
  }

  /// Scrolls the chart to show the most recent candlesticks
  /// Called on initialization and when data updates
  void _scrollToEnd() {
    // Calculate total candle width and scroll to show the last candle
    final totalCandleWidth =
        widget.style.candleWidth * (1 + widget.style.spacing);
    _scrollOffset =
        max(0.0, totalCandleWidth * (widget.data.length - 1) - widget.width);
    setState(() {}); // Trigger rebuild with updated scroll offset
  }

  /// Configures the entrance animation controller and animation
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

    _controller.forward();
  }

  /// Handles the start of a pan gesture
  /// Stores initial position for calculating delta
  void _handlePanStart(DragStartDetails details) {
    _lastFocalPointX = details.globalPosition.dx;
    _baseScrollOffset = _scrollOffset;
  }

  /// Handles pan gesture updates
  /// Updates scroll position based on drag delta
  void _handlePanUpdate(DragUpdateDetails details) {
    if (details.delta.dx.abs() < 1.0) return; // Ignore very small movements

    setState(() {
      final dx = details.delta.dx;
      final totalCandleWidth =
          widget.style.candleWidth * (1 + widget.style.spacing);

      _scrollOffset = (_scrollOffset - dx).clamp(
        0.0,
        max(0.0, totalCandleWidth * widget.data.length - widget.width),
      );
    });
  }

  /// Cleans up pan gesture state
  void _handlePanEnd(DragEndDetails details) {
    _lastFocalPointX = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque, // Capture all touch interactions
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hoverPosition = null), // Reset hover
        onHover: (details) {
          setState(() {
            _hoverPosition = details.localPosition; // Update hover position
          });
        },
        onExit: (_) => setState(() => _hoverPosition = null), // Clear on exit
        child: Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
          ),
          width: widget.width,
          height: widget.height,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, _) {
              return CustomPaint(
                size: Size(widget.width, widget.height),
                painter: CandlestickChartPainter(
                  data: widget.data,
                  progress: _animation.value,
                  style: widget.style,
                  axisConfig: widget.axisConfig,
                  padding: widget.padding,
                  showGrid: widget.showGrid,
                  scrollOffset: _scrollOffset,
                  hoverPosition:
                      _hoverPosition, // Pass hover position to painter
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
