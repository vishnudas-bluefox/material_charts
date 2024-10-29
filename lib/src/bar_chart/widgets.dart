import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:material_charts/src/bar_chart/models.dart';
import 'package:material_charts/src/bar_chart/painter.dart';

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
              painter: BarChartPainter(
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
