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
/// - Support for Plotly JSON format (compatible with Python Plotly)
///
/// Example usage with traditional data:
/// ```dart
/// MaterialCandlestickChart(
///   data: candlestickData,
///   width: 400,
///   height: 300,
///   style: CandlestickStyle(),
///   showGrid: true,
/// )
/// ```
///
/// Example usage with Plotly JSON:
/// ```dart
/// MaterialCandlestickChart.fromPlotlyJson(
///   plotlyJsonString: jsonString,
///   width: 400,
///   height: 300,
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

  /// Optional chart title (can be extracted from Plotly JSON)
  final String? title;

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
    this.title,
  });

  /// Creates a MaterialCandlestickChart from Plotly JSON string.
  ///
  /// This constructor accepts a JSON string in the exact same format
  /// as Python Plotly candlestick charts and automatically parses it
  /// into the appropriate data structures.
  ///
  /// Example Plotly JSON format:
  /// ```json
  /// {
  ///   "data": [
  ///     {
  ///       "type": "candlestick",
  ///       "x": ["2023-01-01", "2023-01-02", "2023-01-03"],
  ///       "open": [100, 105, 110],
  ///       "high": [120, 125, 130],
  ///       "low": [90, 95, 100],
  ///       "close": [105, 110, 125],
  ///       "volume": [1000, 1500, 2000],
  ///       "increasing": {"line": {"color": "green"}},
  ///       "decreasing": {"line": {"color": "red"}}
  ///     }
  ///   ],
  ///   "layout": {
  ///     "title": "Stock Price Chart",
  ///     "xaxis": {"title": "Date"},
  ///     "yaxis": {"title": "Price"}
  ///   }
  /// }
  /// ```
  factory MaterialCandlestickChart.fromPlotlyJson({
    Key? key,
    required String plotlyJsonString,
    required double width,
    required double height,
    Color? backgroundColor,
    CandlestickStyle? baseStyle,
    ChartAxisConfig? baseAxisConfig,
    EdgeInsets? padding,
    bool showGrid = true,
    VoidCallback? onAnimationComplete,
  }) {
    try {
      final plotlyData = PlotlyJson.fromJsonString(plotlyJsonString);

      return MaterialCandlestickChart(
        key: key,
        data: plotlyData.toCandlestickData(),
        width: width,
        height: height,
        backgroundColor: backgroundColor,
        style: plotlyData.toStyle(baseStyle: baseStyle),
        axisConfig: plotlyData.toAxisConfig(baseConfig: baseAxisConfig),
        padding: padding ?? const EdgeInsets.all(16),
        showGrid: showGrid,
        onAnimationComplete: onAnimationComplete,
        title: plotlyData.layout?.title,
      );
    } catch (e) {
      throw ArgumentError('Failed to parse Plotly JSON: $e');
    }
  }

  /// Creates a MaterialCandlestickChart from a Plotly JSON Map.
  ///
  /// This is useful when you already have the JSON decoded as a Map,
  /// typically from an API response or file reading.
  factory MaterialCandlestickChart.fromPlotlyMap({
    Key? key,
    required Map<String, dynamic> plotlyJsonMap,
    required double width,
    required double height,
    Color? backgroundColor,
    CandlestickStyle? baseStyle,
    ChartAxisConfig? baseAxisConfig,
    EdgeInsets? padding,
    bool showGrid = true,
    VoidCallback? onAnimationComplete,
  }) {
    try {
      final plotlyData = PlotlyJson.fromJson(plotlyJsonMap);

      return MaterialCandlestickChart(
        key: key,
        data: plotlyData.toCandlestickData(),
        width: width,
        height: height,
        backgroundColor: backgroundColor,
        style: plotlyData.toStyle(baseStyle: baseStyle),
        axisConfig: plotlyData.toAxisConfig(baseConfig: baseAxisConfig),
        padding: padding ?? const EdgeInsets.all(16),
        showGrid: showGrid,
        onAnimationComplete: onAnimationComplete,
        title: plotlyData.layout?.title,
      );
    } catch (e) {
      throw ArgumentError('Failed to parse Plotly JSON Map: $e');
    }
  }

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
    if (widget.data.isEmpty) return;

    // Calculate total candle width and scroll to show the last candle
    final totalCandleWidth =
        widget.style.candleWidth * (1 + widget.style.spacing);
    _scrollOffset = max(
      0.0,
      totalCandleWidth * (widget.data.length - 1) - widget.width,
    );
    setState(() {}); // Trigger rebuild with updated scroll offset
  }

  /// Configures the entrance animation controller and animation
  void _setupAnimation() {
    _controller = AnimationController(
      duration: widget.style.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.style.animationCurve),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onAnimationComplete?.call();
        }
      });

    _controller.forward();
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

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.white,
        ),
        child: const Center(
          child: Text(
            'No data available',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Optional title
        if (widget.title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.title!,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),

        // Chart
        GestureDetector(
          behavior: HitTestBehavior.opaque, // Capture all touch interactions
          onPanUpdate: _handlePanUpdate,
          child: MouseRegion(
            onEnter: (_) =>
                setState(() => _hoverPosition = null), // Reset hover
            onHover: (details) {
              setState(() {
                _hoverPosition = details.localPosition; // Update hover position
              });
            },
            onExit: (_) =>
                setState(() => _hoverPosition = null), // Clear on exit
            child: Container(
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                borderRadius: BorderRadius.circular(4),
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
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// Utility class for validating and parsing Plotly JSON data
class PlotlyJsonValidator {
  /// Validates that the JSON contains required candlestick fields
  static bool isValidCandlestickJson(Map<String, dynamic> json) {
    try {
      final dataList = json['data'] as List<dynamic>?;
      if (dataList == null || dataList.isEmpty) return false;

      for (final item in dataList) {
        final trace = item as Map<String, dynamic>;
        if (trace['type'] != 'candlestick') continue;

        // Check required fields
        final requiredFields = ['x', 'open', 'high', 'low', 'close'];
        for (final field in requiredFields) {
          if (!trace.containsKey(field)) return false;
          if (trace[field] is! List) return false;
        }

        // Check array lengths match
        final x = trace['x'] as List;
        final open = trace['open'] as List;
        final high = trace['high'] as List;
        final low = trace['low'] as List;
        final close = trace['close'] as List;

        if (x.length != open.length ||
            x.length != high.length ||
            x.length != low.length ||
            x.length != close.length) {
          return false;
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Provides detailed error information for invalid JSON
  static String getValidationError(Map<String, dynamic> json) {
    try {
      final dataList = json['data'] as List<dynamic>?;
      if (dataList == null) return 'Missing "data" array';
      if (dataList.isEmpty) return 'Empty "data" array';

      for (int i = 0; i < dataList.length; i++) {
        final trace = dataList[i] as Map<String, dynamic>;

        if (trace['type'] != 'candlestick') {
          continue; // Skip non-candlestick traces
        }

        // Check required fields
        final requiredFields = ['x', 'open', 'high', 'low', 'close'];
        for (final field in requiredFields) {
          if (!trace.containsKey(field)) {
            return 'Trace $i missing required field: $field';
          }
          if (trace[field] is! List) {
            return 'Trace $i field $field must be an array';
          }
        }

        // Check array lengths
        final x = trace['x'] as List;
        final open = trace['open'] as List;
        final high = trace['high'] as List;
        final low = trace['low'] as List;
        final close = trace['close'] as List;

        if (x.length != open.length ||
            x.length != high.length ||
            x.length != low.length ||
            x.length != close.length) {
          return 'Trace $i: All arrays must have the same length';
        }

        if (x.isEmpty) {
          return 'Trace $i: Arrays cannot be empty';
        }
      }

      return 'Valid';
    } catch (e) {
      return 'JSON parsing error: $e';
    }
  }
}
