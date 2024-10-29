import 'package:flutter/material.dart';
import 'package:material_charts/src/hollow_semicircle_chart/models.dart';
import 'package:material_charts/src/hollow_semicircle_chart/painter.dart';

class MaterialChartHollowSemiCircle extends BaseChart {
  final double hollowRadius;

  const MaterialChartHollowSemiCircle({
    super.key,
    required super.percentage,
    super.size = 200,
    this.hollowRadius = 0.6,
    super.style,
    super.onAnimationComplete,
  }) : assert(hollowRadius > 0 && hollowRadius < 1,
            'Hollow radius must be between 0 and 1');

  @override
  State<MaterialChartHollowSemiCircle> createState() =>
      _MaterialChartHollowSemiCircleState();
}

class _MaterialChartHollowSemiCircleState
    extends State<MaterialChartHollowSemiCircle>
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
  void didUpdateWidget(MaterialChartHollowSemiCircle oldWidget) {
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
                    painter: HollowSemiCircleChart(
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
