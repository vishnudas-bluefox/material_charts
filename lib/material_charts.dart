import 'dart:math';
import 'package:flutter/material.dart';

/// Specifies the style configuration for meter widgets
class ChartStyle {
  /// The color of the filled/active portion
  final Color activeColor;

  /// The color of the unfilled/inactive portion
  final Color inactiveColor;

  /// The color of the text (percentage)
  final Color? textColor;

  /// The text style for the percentage display
  final TextStyle? percentageStyle;

  /// The text style for the legend labels
  final TextStyle? legendStyle;

  /// Duration of the animation
  final Duration animationDuration;

  /// The curve to use for the animation
  final Curve animationCurve;

  /// Whether to show the percentage text
  final bool showPercentageText;

  /// Whether to show the legend
  final bool showLegend;

  /// Custom formatter for the percentage text
  final String Function(double percentage)? percentageFormatter;

  /// Custom formatter for legend labels
  final String Function(String type, double value)? legendFormatter;

  const ChartStyle({
    this.activeColor = Colors.blue,
    this.inactiveColor = const Color(0xFFE0E0E0),
    this.textColor,
    this.percentageStyle,
    this.legendStyle,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.animationCurve = Curves.easeInOut,
    this.showPercentageText = true,
    this.showLegend = true,
    this.percentageFormatter,
    this.legendFormatter,
  });

  /// Creates a copy of this MeterStyle with the given fields replaced with new values
  ChartStyle copyWith({
    Color? activeColor,
    Color? inactiveColor,
    Color? textColor,
    TextStyle? percentageStyle,
    TextStyle? legendStyle,
    Duration? animationDuration,
    Curve? animationCurve,
    bool? showPercentageText,
    bool? showLegend,
    String Function(double)? percentageFormatter,
    String Function(String, double)? legendFormatter,
  }) {
    return ChartStyle(
      activeColor: activeColor ?? this.activeColor,
      inactiveColor: inactiveColor ?? this.inactiveColor,
      textColor: textColor ?? this.textColor,
      percentageStyle: percentageStyle ?? this.percentageStyle,
      legendStyle: legendStyle ?? this.legendStyle,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      showPercentageText: showPercentageText ?? this.showPercentageText,
      showLegend: showLegend ?? this.showLegend,
      percentageFormatter: percentageFormatter ?? this.percentageFormatter,
      legendFormatter: legendFormatter ?? this.legendFormatter,
    );
  }
}

/// Base class for meter widgets
abstract class BaseChart extends StatefulWidget {
  /// The percentage value to display (0-100)
  final double percentage;

  /// The overall size of the meter
  final double size;

  /// The style configuration for the meter
  final ChartStyle style;

  /// Callback function when animation completes
  final VoidCallback? onAnimationComplete;

  const BaseChart({
    super.key,
    required this.percentage,
    required this.size,
    this.style = const ChartStyle(),
    this.onAnimationComplete,
  })  : assert(percentage >= 0 && percentage <= 100,
            'Percentage must be between 0 and 100'),
        assert(size > 0, 'Size must be greater than 0');
}

class HollowSemiCircleChart extends BaseChart {
  final double hollowRadius;

  const HollowSemiCircleChart({
    super.key,
    required super.percentage,
    super.size = 200,
    this.hollowRadius = 0.6,
    super.style,
    super.onAnimationComplete,
  }) : assert(hollowRadius > 0 && hollowRadius < 1,
            'Hollow radius must be between 0 and 1');

  @override
  State<HollowSemiCircleChart> createState() => _HollowSemiCircleChartState();
}

class _HollowSemiCircleChartState extends State<HollowSemiCircleChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: widget.style.animationDuration,
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.percentage,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.style.animationCurve,
    ))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onAnimationComplete?.call();
        }
      });

    _animationController.forward();
  }

  @override
  void didUpdateWidget(HollowSemiCircleChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percentage != widget.percentage) {
      _animation = Tween<double>(
        begin: oldWidget.percentage,
        end: widget.percentage,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: widget.style.animationCurve,
      ));
      _animationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _formatPercentage(double value) {
    if (widget.style.percentageFormatter != null) {
      return widget.style.percentageFormatter!(value);
    }
    return '${value.toStringAsFixed(0)}%';
  }

  String _formatLegendLabel(String type, double value) {
    if (widget.style.legendFormatter != null) {
      return widget.style.legendFormatter!(type, value);
    }
    return '$type (${value.toStringAsFixed(0)}%)';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.style.showLegend) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LegendItem(
                  color: widget.style.activeColor,
                  label: _formatLegendLabel('Active', widget.percentage),
                  style: widget.style.legendStyle,
                ),
                const SizedBox(width: 24),
                _LegendItem(
                  color: widget.style.inactiveColor,
                  label:
                      _formatLegendLabel('Inactive', 100 - widget.percentage),
                  style: widget.style.legendStyle,
                ),
              ],
            ),
          ),
        ],
        SizedBox(
          width: widget.size,
          height: widget.size / 2,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: Size(widget.size, widget.size / 2),
                    painter: _HollowSemiCircleChart(
                      percentage: _animation.value,
                      activeColor: widget.style.activeColor,
                      inactiveColor: widget.style.inactiveColor,
                      hollowRadius: widget.hollowRadius,
                    ),
                  ),
                  if (widget.style.showPercentageText)
                    Positioned(
                      bottom: 0,
                      child: Text(
                        _formatPercentage(_animation.value),
                        style: widget.style.percentageStyle?.copyWith(
                              color: widget.style.textColor,
                            ) ??
                            TextStyle(
                              fontSize: widget.size / 8,
                              fontWeight: FontWeight.bold,
                              color: widget.style.textColor,
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

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final TextStyle? style;

  const _LegendItem({
    required this.color,
    required this.label,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: style ?? const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}

class _HollowSemiCircleChart extends CustomPainter {
  final double percentage;
  final Color activeColor;
  final Color inactiveColor;
  final double hollowRadius;

  _HollowSemiCircleChart({
    required this.percentage,
    required this.activeColor,
    required this.inactiveColor,
    required this.hollowRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final outerRadius = size.height;
    final innerRadius = outerRadius * hollowRadius;
    final strokeWidth = outerRadius - innerRadius;

    // Draw the background (inactive) arc
    final backgroundPaint = Paint()
      ..color = inactiveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt; // Changed to butt for square ends

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: (innerRadius + outerRadius) / 2),
      pi,
      pi,
      false,
      backgroundPaint,
    );

    // Draw the progress (active) arc
    if (percentage > 0) {
      final progressPaint = Paint()
        ..color = activeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt; // Changed to butt for square ends

      final progressAngle = (percentage / 100) * pi;

      canvas.drawArc(
        Rect.fromCircle(
            center: center, radius: (innerRadius + outerRadius) / 2),
        pi,
        progressAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_HollowSemiCircleChart oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor ||
        oldDelegate.hollowRadius != hollowRadius;
  }
}
