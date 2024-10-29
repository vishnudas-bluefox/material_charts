import 'package:flutter/material.dart';
import 'package:material_charts/src/line_chart/models.dart';
import 'package:material_charts/src/line_chart/painter.dart';

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
            painter: LineChartPainter(
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
