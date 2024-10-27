import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

/// Model class for bar chart data points
class BarChartData {
  final double value;
  final String label;
  final Color? color; // Optional custom color for individual bars

  const BarChartData({
    required this.value,
    required this.label,
    this.color,
  });
}

/// Configuration class for bar chart styling
class BarChartStyle {
  final Color barColor;
  final Color gridColor;
  final Color backgroundColor;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final double barSpacing;
  final double cornerRadius;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool gradientEffect;
  final List<Color>? gradientColors;

  const BarChartStyle({
    this.barColor = Colors.blue,
    this.gridColor = Colors.grey,
    this.backgroundColor = Colors.white,
    this.labelStyle,
    this.valueStyle,
    this.barSpacing = 0.2, // Spacing between bars as percentage (0.0 - 1.0)
    this.cornerRadius = 4.0,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.animationCurve = Curves.easeInOut,
    this.gradientEffect = false,
    this.gradientColors,
  });
}

class MaterialBarChart extends StatefulWidget {
  final List<BarChartData> data;
  final double width;
  final double height;
  final BarChartStyle style;
  final bool showGrid;
  final bool showValues;
  final EdgeInsets padding;
  final int horizontalGridLines;
  final VoidCallback? onAnimationComplete;
  final bool interactive; // Enable hover/tap interactions

  const MaterialBarChart({
    super.key,
    required this.data,
    required this.width,
    required this.height,
    this.style = const BarChartStyle(),
    this.showGrid = true,
    this.showValues = true,
    this.padding = const EdgeInsets.all(24),
    this.horizontalGridLines = 5,
    this.onAnimationComplete,
    this.interactive = true,
  });

  @override
  State<MaterialBarChart> createState() => _MaterialBarChartState();
}

class _MaterialBarChartState extends State<MaterialBarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int? _hoveredBarIndex;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: widget.interactive ? _handleHover : null,
      onExit: widget.interactive
          ? (_) => setState(() => _hoveredBarIndex = null)
          : null,
      child: Container(
        width: widget.width,
        height: widget.height,
        color: widget.style.backgroundColor,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, _) {
            return CustomPaint(
              size: Size(widget.width, widget.height),
              painter: _BarChartPainter(
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

  void _handleHover(PointerHoverEvent event) {
    if (!widget.interactive) return;

    final chartArea = Rect.fromLTWH(
      widget.padding.left,
      widget.padding.top,
      widget.width - widget.padding.horizontal,
      widget.height - widget.padding.vertical,
    );

    final barWidth =
        (chartArea.width / widget.data.length) * (1 - widget.style.barSpacing);
    final spacing =
        (chartArea.width / widget.data.length) * widget.style.barSpacing;

    final x = event.localPosition.dx - chartArea.left;
    final barIndex = (x / (barWidth + spacing)).floor();

    if (barIndex >= 0 && barIndex < widget.data.length) {
      setState(() => _hoveredBarIndex = barIndex);
    } else {
      setState(() => _hoveredBarIndex = null);
    }
  }
}

class _BarChartPainter extends CustomPainter {
  final List<BarChartData> data;
  final double progress;
  final BarChartStyle style;
  final bool showGrid;
  final bool showValues;
  final EdgeInsets padding;
  final int horizontalGridLines;
  final int? hoveredBarIndex;

  _BarChartPainter({
    required this.data,
    required this.progress,
    required this.style,
    required this.showGrid,
    required this.showValues,
    required this.padding,
    required this.horizontalGridLines,
    required this.hoveredBarIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final chartArea = Rect.fromLTWH(
      padding.left,
      padding.top,
      size.width - padding.horizontal,
      size.height - padding.vertical,
    );

    if (showGrid) {
      _drawGrid(canvas, chartArea);
    }

    _drawBars(canvas, chartArea);
    _drawLabels(canvas, chartArea);
  }

  void _drawGrid(Canvas canvas, Rect chartArea) {
    final paint = Paint()
      ..color = style.gridColor.withOpacity(0.2)
      ..strokeWidth = 1;

    // Draw horizontal grid lines
    for (int i = 0; i <= horizontalGridLines; i++) {
      final y = chartArea.top + (chartArea.height / horizontalGridLines) * i;
      canvas.drawLine(
        Offset(chartArea.left, y),
        Offset(chartArea.right, y),
        paint,
      );
    }
  }

  void _drawBars(Canvas canvas, Rect chartArea) {
    final maxValue = data.map((point) => point.value).reduce(max);
    final barWidth = (chartArea.width / data.length) * (1 - style.barSpacing);
    final spacing = (chartArea.width / data.length) * style.barSpacing;

    for (int i = 0; i < data.length; i++) {
      final barHeight =
          (data[i].value / maxValue) * chartArea.height * progress;
      final barX = chartArea.left + (i * (barWidth + spacing)) + (spacing / 2);
      final barY = chartArea.bottom - barHeight;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(barX, barY, barWidth, barHeight),
        Radius.circular(style.cornerRadius),
      );

      final paint = Paint()..style = PaintingStyle.fill;

      // First check if this bar has a custom color
      if (data[i].color != null) {
        paint.color = data[i].color!;
      } else if (style.gradientEffect && style.gradientColors != null) {
        // Only apply gradient if no custom color is specified
        paint.shader = LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: style.gradientColors!,
        ).createShader(rect.outerRect);
      } else {
        // Use default bar color if no custom color or gradient
        paint.color = style.barColor;
      }

      // Apply hover effect
      if (hoveredBarIndex == i) {
        if (paint.shader != null) {
          // If using gradient, create a lighter version
          paint.shader = LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors:
                style.gradientColors!.map((c) => c.withOpacity(0.8)).toList(),
          ).createShader(rect.outerRect);
        } else {
          // If using solid color, make it lighter
          paint.color = paint.color.withOpacity(0.8);
        }

        // Draw hover indicator
        final hoverPaint = Paint()
          ..color = (data[i].color ?? style.barColor).withOpacity(0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
        canvas.drawRRect(rect, hoverPaint);
      }

      canvas.drawRRect(rect, paint);

      if (showValues) {
        final value = data[i].value.toStringAsFixed(1);
        final textStyle = style.valueStyle ??
            TextStyle(
              color: data[i].color ?? style.barColor, // Use bar color for text
              fontSize: 12,
              fontWeight: FontWeight.bold,
            );
        final textSpan = TextSpan(text: value, style: textStyle);
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        )..layout();

        textPainter.paint(
          canvas,
          Offset(
            barX + (barWidth - textPainter.width) / 2,
            barY - textPainter.height - 4,
          ),
        );
      }
    }
  }

  void _drawLabels(Canvas canvas, Rect chartArea) {
    final barWidth = (chartArea.width / data.length) * (1 - style.barSpacing);
    final spacing = (chartArea.width / data.length) * style.barSpacing;

    final textStyle = style.labelStyle ??
        TextStyle(
          color: style.barColor,
          fontSize: 12,
        );

    for (int i = 0; i < data.length; i++) {
      final x = chartArea.left + (i * (barWidth + spacing)) + (spacing / 2);
      final textSpan = TextSpan(text: data[i].label, style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(
          x + (barWidth - textPainter.width) / 2,
          chartArea.bottom + padding.bottom / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(_BarChartPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.data != data ||
        oldDelegate.style != style ||
        oldDelegate.showGrid != showGrid ||
        oldDelegate.showValues != showValues ||
        oldDelegate.hoveredBarIndex != hoveredBarIndex ||
        oldDelegate.horizontalGridLines != horizontalGridLines;
  }
}
