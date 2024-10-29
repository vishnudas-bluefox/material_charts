import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_charts/src/gantt_chart/models.dart';
import 'package:material_charts/src/gantt_chart/painter.dart';

class MaterialGanttChart extends StatefulWidget {
  final List<GanttData> data;
  final double width;
  final double height;
  final GanttChartStyle style;
  final bool interactive;
  final void Function(GanttData)? onPointTap;
  final void Function(GanttData)? onPointHover;
  final VoidCallback? onAnimationComplete;

  MaterialGanttChart({
    super.key,
    required this.data,
    required this.width,
    required this.height,
    this.style = const GanttChartStyle(),
    this.interactive = true,
    this.onPointTap,
    this.onPointHover,
    this.onAnimationComplete,
  }) {
    if (data.isEmpty) {
      throw GanttChartException('Gantt data cannot be empty');
    }
    if (width <= 0 || height <= 0) {
      throw GanttChartException('Width and height must be positive values');
    }
  }

  @override
  State<MaterialGanttChart> createState() => _MaterialGanttChartState();
}

class _MaterialGanttChartState extends State<MaterialGanttChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int? _hoveredPointIndex;

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
    )
      ..addListener(() {
        setState(() {}); // Ensure widget rebuilds during animation
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onAnimationComplete?.call();
        }
      });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: widget.style.backgroundColor,
      child: Stack(
        children: [
          // Base timeline
          AnimatedBuilder(
            animation: _animation,
            builder: (context, _) {
              return CustomPaint(
                size: Size(widget.width, widget.height),
                painter: GanttBasePainter(
                  data: widget.data,
                  progress: _animation.value,
                  style: widget.style,
                  hoveredIndex: _hoveredPointIndex,
                ),
              );
            },
          ),
          // Interactive points with MouseRegion and Tooltip
          ...List.generate(widget.data.length, (index) {
            final point = widget.data[index];
            final position = _calculatePointPosition(index);

            return Positioned(
              left: position.dx - 20,
              top: position.dy - 20,
              child: MouseRegion(
                onEnter: (_) => _handleHover(true, point, index),
                onExit: (_) => _handleHover(false, point, index),
                child: Tooltip(
                  message:
                      '${DateFormat.yMMMd().format(point.startDate)} - ${DateFormat.yMMMd().format(point.endDate)}',
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _handleTap(point),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        child: Transform.scale(
                          scale:
                              0.2 + (0.8 * _animation.value), // Scale animation
                          child: Container(
                            width: widget.style.pointRadius * 2,
                            height: widget.style.pointRadius * 2,
                            decoration: BoxDecoration(
                              color: point.color ?? widget.style.pointColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Offset _calculatePointPosition(int index) {
    final chartArea = Rect.fromLTWH(
      widget.style.horizontalPadding,
      widget.style.horizontalPadding,
      widget.width - (widget.style.horizontalPadding * 2),
      widget.height - (widget.style.horizontalPadding * 2),
    );

    final timeRange = _getTimeRange();
    final totalDuration = timeRange.end.difference(timeRange.start);
    final point = widget.data[index];

    final x = chartArea.left +
        (point.startDate.difference(timeRange.start).inMilliseconds /
                totalDuration.inMilliseconds) *
            chartArea.width;
    final y = chartArea.top +
        widget.style.timelineYOffset +
        (index * widget.style.verticalSpacing);

    return Offset(x, y);
  }

  void _handleTap(GanttData point) {
    if (!widget.interactive) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16),
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (point.icon != null)
                      Icon(point.icon, color: point.color ?? Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      point.label,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  '${DateFormat.yMMMMd().format(point.startDate)} - ${DateFormat.yMMMMd().format(point.endDate)}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                if (point.description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    point.description!,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
                if (point.tapContent != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    point.tapContent!,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    widget.onPointTap?.call(point);
  }

  void _handleHover(bool isHovering, GanttData point, int index) {
    if (!widget.interactive) return;

    setState(() {
      _hoveredPointIndex = isHovering ? index : null;
    });

    if (isHovering) {
      widget.onPointHover?.call(point);
      debugPrint("Hovered point: ${point.label}");
    }
  }

  DateTimeRange _getTimeRange() {
    DateTime? earliest;
    DateTime? latest;

    for (final point in widget.data) {
      if (earliest == null || point.startDate.isBefore(earliest)) {
        earliest = point.startDate;
      }
      if (latest == null || point.endDate.isAfter(latest)) {
        latest = point.endDate;
      }
    }

    return DateTimeRange(
      start: earliest!.subtract(const Duration(days: 7)),
      end: latest!.add(const Duration(days: 7)),
    );
  }
}
