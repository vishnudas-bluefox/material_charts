import 'dart:math';
import 'package:flutter/material.dart';

/// Model class for chart data points
class ChartData {
  final double value;
  final String label;

  const ChartData({required this.value, required this.label});
}

/// Configuration class for line chart styling
class LineChartStyle {
  final Color lineColor;
  final Color gridColor;
  final Color pointColor;
  final Color backgroundColor;
  final TextStyle? labelStyle;
  final double strokeWidth;
  final double pointRadius;
  final Duration animationDuration;
  final Curve animationCurve;

  const LineChartStyle({
    this.lineColor = Colors.blue,
    this.gridColor = Colors.grey,
    this.pointColor = Colors.blue,
    this.backgroundColor = Colors.white,
    this.labelStyle,
    this.strokeWidth = 2.0,
    this.pointRadius = 4.0,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.animationCurve = Curves.easeInOut,
  });
}

class MaterialChartLine extends StatefulWidget {
  final List<ChartData> data;
  final double width;
  final double height;
  final LineChartStyle style;
  final bool showPoints;
  final bool showGrid;
  final EdgeInsets padding;
  final int horizontalGridLines;
  final VoidCallback? onAnimationComplete;

  const MaterialChartLine({
    super.key,
    required this.data,
    required this.width,
    required this.height,
    this.style = const LineChartStyle(),
    this.showPoints = true,
    this.showGrid = true,
    this.padding = const EdgeInsets.all(24),
    this.horizontalGridLines = 5,
    this.onAnimationComplete,
  });

  @override
  State<MaterialChartLine> createState() => _MaterialChartLineState();
}

class _MaterialChartLineState extends State<MaterialChartLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

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
    return Container(
      width: widget.width,
      height: widget.height,
      color: widget.style.backgroundColor,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          return CustomPaint(
            size: Size(widget.width, widget.height),
            painter: _LineChartPainter(
              data: widget.data,
              progress: _animation.value,
              style: widget.style,
              showPoints: widget.showPoints,
              showGrid: widget.showGrid,
              padding: widget.padding,
              horizontalGridLines: widget.horizontalGridLines,
            ),
          );
        },
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<ChartData> data;
  final double progress;
  final LineChartStyle style;
  final bool showPoints;
  final bool showGrid;
  final EdgeInsets padding;
  final int horizontalGridLines;

  _LineChartPainter({
    required this.data,
    required this.progress,
    required this.style,
    required this.showPoints,
    required this.showGrid,
    required this.padding,
    required this.horizontalGridLines,
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

    _drawLine(canvas, chartArea);

    if (showPoints) {
      _drawPoints(canvas, chartArea);
    }

    _drawLabels(canvas, chartArea);
  }

  void _drawGrid(Canvas canvas, Rect chartArea) {
    final paint = Paint()
      ..color = style.gridColor.withOpacity(0.2)
      ..strokeWidth = 1;

    // Horizontal grid lines
    for (int i = 0; i <= horizontalGridLines; i++) {
      final y = chartArea.top + (chartArea.height / horizontalGridLines) * i;
      canvas.drawLine(
        Offset(chartArea.left, y),
        Offset(chartArea.right, y),
        paint,
      );
    }

    // Vertical grid lines
    for (int i = 0; i < data.length; i++) {
      final x = chartArea.left + (chartArea.width / (data.length - 1)) * i;
      canvas.drawLine(
        Offset(x, chartArea.top),
        Offset(x, chartArea.bottom),
        paint,
      );
    }
  }

  void _drawLine(Canvas canvas, Rect chartArea) {
    final linePaint = Paint()
      ..color = style.lineColor
      ..strokeWidth = style.strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    final points = _getPointCoordinates(chartArea);

    for (int i = 0; i < points.length; i++) {
      final point = points[i];
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    final pathMetrics = path.computeMetrics().first;
    final extractPath = pathMetrics.extractPath(
      0.0,
      pathMetrics.length * progress,
    );

    canvas.drawPath(extractPath, linePaint);
  }

  void _drawPoints(Canvas canvas, Rect chartArea) {
    final pointPaint = Paint()
      ..color = style.pointColor
      ..style = PaintingStyle.fill;

    final points = _getPointCoordinates(chartArea);
    final progressPoints = (points.length * progress).floor();

    for (int i = 0; i < progressPoints; i++) {
      canvas.drawCircle(points[i], style.pointRadius, pointPaint);
    }
  }

  void _drawLabels(Canvas canvas, Rect chartArea) {
    final textStyle = style.labelStyle ??
        TextStyle(
          color: style.lineColor,
          fontSize: 12,
        );

    for (int i = 0; i < data.length; i++) {
      final x = chartArea.left + (chartArea.width / (data.length - 1)) * i;
      final textSpan = TextSpan(
        text: data[i].label,
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(
          x - textPainter.width / 2,
          chartArea.bottom + padding.bottom / 2,
        ),
      );
    }
  }

  List<Offset> _getPointCoordinates(Rect chartArea) {
    if (data.isEmpty) return [];

    final maxValue = data.map((point) => point.value).reduce(max);
    final minValue = data.map((point) => point.value).reduce(min);
    final valueRange = maxValue - minValue;

    return List.generate(data.length, (i) {
      final x = chartArea.left + (chartArea.width / (data.length - 1)) * i;
      final normalizedValue = (data[i].value - minValue) / valueRange;
      final y = chartArea.bottom - (normalizedValue * chartArea.height);
      return Offset(x, y);
    });
  }

  @override
  bool shouldRepaint(_LineChartPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.data != data ||
        oldDelegate.style != style ||
        oldDelegate.showPoints != showPoints ||
        oldDelegate.showGrid != showGrid ||
        oldDelegate.horizontalGridLines != horizontalGridLines;
  }
}
