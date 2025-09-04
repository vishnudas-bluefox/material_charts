import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'models.dart';
import 'painter.dart';

/// A customizable Material-styled stacked bar chart with animation, interaction,
/// and full JSON schema support.
///
/// This widget renders a bar chart with multiple segments inside each bar.
/// It offers the exact same API as MaterialBarChart for seamless integration.
/// Supports animations, interactivity, custom styling, and direct integration
/// with JSON configurations including Plotly format.
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

  /// Creates a [MaterialStackedBarChart] from JSON configuration.
  ///
  /// This factory constructor matches the exact API pattern used in
  /// MaterialBarChart.fromJson() for seamless integration.
  /// Supports both simple and Plotly-compatible formats with comprehensive validation.
  ///
  /// Example usage:
  /// ```dart
  /// final jsonConfig = {
  ///   "data": [
  ///     {
  ///       "type": "bar",
  ///       "x": ["Q1", "Q2", "Q3"],
  ///       "y": [120, 135, 148],
  ///       "name": "Sales",
  ///       "marker": {"color": "#1f77b4"}
  ///     },
  ///     {
  ///       "x": ["Q1", "Q2", "Q3"],
  ///       "y": [45, 52, 48],
  ///       "name": "Marketing",
  ///       "marker": {"color": "#ff7f0e"}
  ///     }
  ///   ],
  ///   "layout": {
  ///     "barmode": "stack",
  ///     "width": 800,
  ///     "height": 400
  ///   }
  /// };
  ///
  /// final chart = MaterialStackedBarChart.fromJson(jsonConfig);
  /// ```
  factory MaterialStackedBarChart.fromJson(Map<String, dynamic> json) {
    try {
      final config = StackedBarChartJsonConfig.fromJson(json);
      return MaterialStackedBarChart(
        data: config.getStackedBarData(),
        width: config.width,
        height: config.height,
        style: config.getStackedBarChartStyle(),
        showGrid: config.showGrid,
        showValues: config.showValues,
        padding: config.padding,
        horizontalGridLines: config.horizontalGridLines,
        interactive: config.interactive,
        onAnimationComplete: config.onAnimationComplete,
      );
    } catch (e) {
      throw ArgumentError(
          'Failed to create MaterialStackedBarChart from JSON: $e');
    }
  }

  /// Creates a [MaterialStackedBarChart] from a JSON string.
  ///
  /// This is a convenience factory for parsing JSON strings directly.
  ///
  /// Example usage:
  /// ```dart
  /// final jsonString = '{"data": [{"x": ["A", "B"], "y": [1, 2], "name": "Series1"}], "layout": {"barmode": "stack"}}';
  /// final chart = MaterialStackedBarChart.fromJsonString(jsonString);
  /// ```
  factory MaterialStackedBarChart.fromJsonString(String jsonString) {
    try {
      final config = StackedBarChartJsonConfig.fromJsonString(jsonString);
      return MaterialStackedBarChart(
        data: config.getStackedBarData(),
        width: config.width,
        height: config.height,
        style: config.getStackedBarChartStyle(),
        showGrid: config.showGrid,
        showValues: config.showValues,
        padding: config.padding,
        horizontalGridLines: config.horizontalGridLines,
        interactive: config.interactive,
        onAnimationComplete: config.onAnimationComplete,
      );
    } catch (e) {
      throw ArgumentError(
          'Failed to create MaterialStackedBarChart from JSON string: $e');
    }
  }

  /// Creates a [MaterialStackedBarChart] from simple data arrays.
  ///
  /// This matches the exact API pattern used in MaterialBarChart.fromData()
  /// for seamless integration with existing code patterns.
  ///
  /// Example usage:
  /// ```dart
  /// final chart = MaterialStackedBarChart.fromData(
  ///   labels: ['Q1', 'Q2', 'Q3'],
  ///   values: [
  ///     [100, 120, 90],  // First series
  ///     [80, 90, 110],   // Second series
  ///   ],
  ///   seriesLabels: ['Sales', 'Marketing'],
  ///   colors: ['#FF0000', '#00FF00'],
  ///   width: 800,
  ///   height: 400,
  /// );
  /// ```
  factory MaterialStackedBarChart.fromData({
    required List<String> labels,
    required List<List<double>> values,
    List<String>? seriesLabels,
    List<String>? colors,
    Map<String, dynamic>? style,
    double width = 800,
    double height = 400,
    bool showGrid = true,
    bool showValues = true,
    EdgeInsets padding = const EdgeInsets.all(24),
    int horizontalGridLines = 5,
    bool interactive = true,
    VoidCallback? onAnimationComplete,
  }) {
    // Validate inputs
    if (labels.isEmpty) {
      throw ArgumentError('Labels cannot be empty');
    }
    if (values.isEmpty) {
      throw ArgumentError('Values cannot be empty');
    }
    for (int i = 0; i < values.length; i++) {
      if (values[i].length != labels.length) {
        throw ArgumentError(
            'All value series must have the same length as labels. Series $i has ${values[i].length} values but expected ${labels.length}');
      }
    }

    final data = <StackedBarData>[];

    // Process each category
    for (int categoryIndex = 0;
        categoryIndex < labels.length;
        categoryIndex++) {
      final segments = <StackedBarSegment>[];

      // Process each series for this category
      for (int seriesIndex = 0; seriesIndex < values.length; seriesIndex++) {
        final value = values[seriesIndex][categoryIndex];
        final color = colors != null && seriesIndex < colors.length
            ? MaterialStackedBarChart._parseColor(colors[seriesIndex])
            : _getDefaultColor(seriesIndex);
        final name = seriesLabels != null && seriesIndex < seriesLabels.length
            ? seriesLabels[seriesIndex]
            : 'Series ${seriesIndex + 1}';

        segments.add(StackedBarSegment(
          value: value,
          color: color,
          label: name,
        ));
      }

      data.add(StackedBarData(
        label: labels[categoryIndex],
        segments: segments,
      ));
    }

    final chartStyle = style != null
        ? StackedBarChartStyle.fromJson(style)
        : const StackedBarChartStyle();

    return MaterialStackedBarChart(
      data: data,
      width: width,
      height: height,
      style: chartStyle,
      showGrid: showGrid,
      showValues: showValues,
      padding: padding,
      horizontalGridLines: horizontalGridLines,
      interactive: interactive,
      onAnimationComplete: onAnimationComplete,
    );
  }

  @override
  State<MaterialStackedBarChart> createState() =>
      _MaterialStackedBarChartState();

  /// Helper method to get default colors for series
  static Color _getDefaultColor(int index) {
    final defaultColors = [
      const Color(0xFFB8D4E3), // Soft blue
      const Color(0xFFC7E8CA), // Mint green
      const Color(0xFFF4D1AE), // Peach
      const Color(0xFFE6B8AF), // Dusty rose
      const Color(0xFFD4C5F9), // Lavender
      const Color(0xFFF7D794), // Soft yellow
      const Color(0xFFB8E6B8), // Light green
      const Color(0xFFE8D5C4), // Beige
      const Color(0xFF1f77b4), // Blue
      const Color(0xFFff7f0e), // Orange
      const Color(0xFF2ca02c), // Green
      const Color(0xFFd62728), // Red
      const Color(0xFF9467bd), // Purple
      const Color(0xFF8c564b), // Brown
      const Color(0xFFe377c2), // Pink
      const Color(0xFF7f7f7f), // Gray
      const Color(0xFFbcbd22), // Olive
      const Color(0xFF17becf), // Cyan
    ];

    return defaultColors[index % defaultColors.length];
  }

  /// Helper method to parse color from various formats
  static Color _parseColor(dynamic colorValue) {
    if (colorValue is Color) {
      return colorValue;
    }

    if (colorValue is String) {
      // Handle hex colors
      if (colorValue.startsWith('#')) {
        final hex = colorValue.replaceFirst('#', '');
        if (hex.length == 6) {
          return Color(int.parse('FF$hex', radix: 16));
        } else if (hex.length == 8) {
          return Color(int.parse(hex, radix: 16));
        }
      }

      // Handle rgb() format
      if (colorValue.startsWith('rgb(')) {
        final rgb = colorValue
            .replaceAll('rgb(', '')
            .replaceAll(')', '')
            .replaceAll(' ', '');
        final parts =
            rgb.split(',').map((e) => int.tryParse(e.trim()) ?? 0).toList();
        if (parts.length >= 3) {
          return Color.fromRGBO(
            parts[0].clamp(0, 255),
            parts[1].clamp(0, 255),
            parts[2].clamp(0, 255),
            1.0,
          );
        }
      }

      // Handle rgba() format
      if (colorValue.startsWith('rgba(')) {
        final rgba = colorValue
            .replaceAll('rgba(', '')
            .replaceAll(')', '')
            .replaceAll(' ', '');
        final parts = rgba
            .split(',')
            .map((e) => double.tryParse(e.trim()) ?? 0.0)
            .toList();
        if (parts.length >= 4) {
          return Color.fromRGBO(
            parts[0].toInt().clamp(0, 255),
            parts[1].toInt().clamp(0, 255),
            parts[2].toInt().clamp(0, 255),
            parts[3].clamp(0.0, 1.0),
          );
        }
      }

      // Handle named colors
      switch (colorValue.toLowerCase()) {
        case 'red':
          return Colors.red;
        case 'green':
          return Colors.green;
        case 'blue':
          return Colors.blue;
        case 'yellow':
          return Colors.yellow;
        case 'orange':
          return Colors.orange;
        case 'purple':
          return Colors.purple;
        case 'pink':
          return Colors.pink;
        case 'teal':
          return Colors.teal;
        case 'cyan':
          return Colors.cyan;
        case 'lime':
          return Colors.lime;
        case 'indigo':
          return Colors.indigo;
        case 'amber':
          return Colors.amber;
        case 'brown':
          return Colors.brown;
        case 'grey':
        case 'gray':
          return Colors.grey;
        case 'black':
          return Colors.black;
        case 'white':
          return Colors.white;
      }
    }

    // Default fallback color
    return const Color(0xFF1f77b4); // Default blue
  }
}

/// Private state class for MaterialStackedBarChart
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
  void didUpdateWidget(MaterialStackedBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Restart animation if data changes
    if (widget.data != oldWidget.data) {
      _controller.reset();
      _controller.forward();
    }

    // Update animation duration if style changes
    if (widget.style.animationDuration != oldWidget.style.animationDuration ||
        widget.style.animationCurve != oldWidget.style.animationCurve) {
      _controller.dispose();
      _setupAnimation();
    }
  }

  @override
  void dispose() {
    _controller
        .dispose(); // Dispose of the animation controller to free resources.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: widget.interactive ? _handleHover : null,
      onExit: widget.interactive ? (_) => _clearHover() : null,
      child: Container(
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
      ),
    );
  }

  /// Handles hover events over the bar chart to determine which bar is hovered.
  void _handleHover(PointerHoverEvent event) {
    if (!widget.interactive || widget.data.isEmpty) return;

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final localPosition = renderBox.globalToLocal(event.position);

    // Calculate which bar is being hovered
    final yAxisWidth = widget.style.yAxisConfig?.axisWidth ?? 0;
    final chartArea = Rect.fromLTWH(
      widget.padding.left + yAxisWidth,
      widget.padding.top,
      widget.width - widget.padding.horizontal - yAxisWidth,
      widget.height - widget.padding.vertical,
    );

    if (chartArea.contains(localPosition)) {
      final barWidth = (chartArea.width / widget.data.length) *
          (1 - widget.style.barSpacing);
      final spacing =
          (chartArea.width / widget.data.length) * widget.style.barSpacing;
      final relativeX = localPosition.dx - chartArea.left;

      int? newHoveredIndex;
      for (int i = 0; i < widget.data.length; i++) {
        final barStart = (i * (barWidth + spacing)) + (spacing / 2);
        final barEnd = barStart + barWidth;

        if (relativeX >= barStart && relativeX <= barEnd) {
          newHoveredIndex = i;
          break;
        }
      }

      if (newHoveredIndex != _hoveredBarIndex) {
        setState(() {
          _hoveredBarIndex = newHoveredIndex;
        });
      }
    } else {
      _clearHover();
    }
  }

  /// Clears the hover state.
  void _clearHover() {
    if (_hoveredBarIndex != null) {
      setState(() {
        _hoveredBarIndex = null;
      });
    }
  }
}
