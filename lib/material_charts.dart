import 'dart:math';
import 'package:flutter/material.dart';

class HollowSemiCircleMeter extends StatefulWidget {
  final double percentage;
  final Color activeColor;
  final Color inactiveColor;
  final bool labelStatus;
  final double size;
  final double hollowRadius;

  const HollowSemiCircleMeter({
    super.key,
    required this.percentage,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.size = 200,
    this.hollowRadius = 0.4,
    this.labelStatus = true,
  }) : assert(hollowRadius > 0 && hollowRadius < 1,
            'Hollow radius must be between 0 and 1');

  @override
  State<HollowSemiCircleMeter> createState() => _HollowSemiCircleMeterState();
}

class _HollowSemiCircleMeterState extends State<HollowSemiCircleMeter>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.percentage,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void didUpdateWidget(HollowSemiCircleMeter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percentage != widget.percentage) {
      _animation = Tween<double>(
        begin: oldWidget.percentage,
        end: widget.percentage,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ));
      _animationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
                    painter: _HollowSemiCirclePainter(
                      percentage: _animation.value,
                      activeColor: widget.activeColor,
                      inactiveColor: widget.inactiveColor,
                      hollowRadius: widget.hollowRadius,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Text(
                      '${_animation.value.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: widget.size / 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        SizedBox(height: 16),
        widget.labelStatus
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _LegendItem(
                    color: widget.activeColor,
                    label: 'Active (${widget.percentage.toStringAsFixed(0)}%)',
                  ),
                  SizedBox(width: 16),
                  _LegendItem(
                    color: widget.inactiveColor,
                    label:
                        'Inactive (${(100 - widget.percentage).toStringAsFixed(0)}%)',
                  ),
                ],
              )
            : SizedBox(),
      ],
    );
  }
}

class _HollowSemiCirclePainter extends CustomPainter {
  final double percentage;
  final Color activeColor;
  final Color inactiveColor;
  final double hollowRadius;

  _HollowSemiCirclePainter({
    required this.percentage,
    required this.activeColor,
    required this.inactiveColor,
    required this.hollowRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius * hollowRadius;

    // Draw background (inactive) first
    _drawSection(
      canvas,
      center,
      outerRadius,
      innerRadius,
      pi,
      2 * pi,
      inactiveColor,
    );

    // Draw active section
    if (percentage > 0) {
      final endAngle = pi + (percentage / 100 * pi);
      _drawSection(
        canvas,
        center,
        outerRadius,
        innerRadius,
        pi,
        endAngle,
        activeColor,
      );
    }
  }

  void _drawSection(
    Canvas canvas,
    Offset center,
    double outerRadius,
    double innerRadius,
    double startAngle,
    double endAngle,
    Color color,
  ) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    // Outer arc
    path.addArc(
      Rect.fromCircle(center: center, radius: outerRadius),
      startAngle,
      endAngle - startAngle,
    );

    // Line to inner arc
    final endOuterX = center.dx + outerRadius * cos(endAngle);
    final endOuterY = center.dy + outerRadius * sin(endAngle);
    path.lineTo(endOuterX, endOuterY);

    // Inner arc (counter-clockwise)
    path.arcTo(
      Rect.fromCircle(center: center, radius: innerRadius),
      endAngle,
      -(endAngle - startAngle),
      false,
    );

    // Close the path
    path.lineTo(
      center.dx + outerRadius * cos(startAngle),
      center.dy + outerRadius * sin(startAngle),
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_HollowSemiCirclePainter oldDelegate) =>
      percentage != oldDelegate.percentage ||
      activeColor != oldDelegate.activeColor ||
      inactiveColor != oldDelegate.inactiveColor ||
      hollowRadius != oldDelegate.hollowRadius;
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    super.key,
    required this.color,
    required this.label,
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
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
