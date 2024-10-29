import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_charts/src/gantt_chart/models.dart';
import 'package:material_charts/src/gantt_chart/painter.dart';

/// A customizable Gantt Chart widget that displays tasks over a timeline.
///
/// This widget provides a graphical representation of tasks with
/// start and end dates. It supports user interactions such as taps
/// and hovers to provide more information about each task.
///
/// The chart can be customized using the provided style options.
class MaterialGanttChart extends StatefulWidget {
  /// A list of Gantt data representing the tasks.
  final List<GanttData> data;

  /// The width of the Gantt chart.
  final double width;

  /// The height of the Gantt chart.
  final double height;

  /// Style properties for customizing the appearance of the Gantt chart.
  final GanttChartStyle style;

  /// Enables or disables interactive features (hovering and tapping).
  final bool interactive;

  /// Callback function that is called when a point is tapped.
  final void Function(GanttData)? onPointTap;

  /// Callback function that is called when a point is hovered over.
  final void Function(GanttData)? onPointHover;

  /// Callback function that is called when the animation completes.
  final VoidCallback? onAnimationComplete;

  /// Constructs a [MaterialGanttChart] widget.
  ///
  /// Throws a [GanttChartException] if the provided data is empty
  /// or if the width and height are non-positive values.
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
  late AnimationController _controller; // Controller for animation
  late Animation<double> _animation; // Animation value from 0.0 to 1.0
  int? _hoveredPointIndex; // Index of the currently hovered point

  @override
  void initState() {
    super.initState();
    _setupAnimation(); // Initialize animation setup
  }

  /// Sets up the animation controller and the tween animation.
  void _setupAnimation() {
    _controller = AnimationController(
      duration: widget.style.animationDuration, // Duration defined in style
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.style.animationCurve, // Animation curve defined in style
      ),
    )
      ..addListener(() {
        setState(() {}); // Rebuild widget during animation progress
      })
      ..addStatusListener((status) {
        // Notify when animation completes
        if (status == AnimationStatus.completed) {
          widget.onAnimationComplete?.call();
        }
      });

    _controller.forward(); // Start the animation
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: widget.style.backgroundColor, // Background color from style
      child: Stack(
        children: [
          // Base timeline with animated drawing
          AnimatedBuilder(
            animation: _animation,
            builder: (context, _) {
              return CustomPaint(
                size: Size(widget.width, widget.height),
                painter: GanttBasePainter(
                  data: widget.data,
                  progress: _animation.value, // Progress from animation
                  style: widget.style,
                  hoveredIndex: _hoveredPointIndex, // Currently hovered point
                ),
              );
            },
          ),
          // Interactive points with MouseRegion and Tooltip
          ...List.generate(widget.data.length, (index) {
            final point = widget.data[index]; // Current Gantt data point
            final position =
                _calculatePointPosition(index); // Calculate position

            return Positioned(
              left: position.dx - 20, // Centering the point
              top: position.dy - 20,
              child: MouseRegion(
                onEnter: (_) =>
                    _handleHover(true, point, index), // Handle hover
                onExit: (_) => _handleHover(false, point, index),
                child: Tooltip(
                  message:
                      '${DateFormat.yMMMd().format(point.startDate)} - ${DateFormat.yMMMd().format(point.endDate)}', // Tooltip message
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _handleTap(point), // Handle tap
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        child: Transform.scale(
                          scale:
                              0.2 + (0.8 * _animation.value), // Scale animation
                          child: Container(
                            width: widget.style.pointRadius * 2, // Point radius
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

  /// Calculates the position of the Gantt data point in the chart.
  ///
  /// This method maps the start date of the task to its corresponding
  /// position on the horizontal axis, taking into account the total
  /// duration of the timeline.
  Offset _calculatePointPosition(int index) {
    final chartArea = Rect.fromLTWH(
      widget.style.horizontalPadding,
      widget.style.horizontalPadding,
      widget.width - (widget.style.horizontalPadding * 2),
      widget.height - (widget.style.horizontalPadding * 2),
    );

    final timeRange = _getTimeRange(); // Get the overall time range
    final totalDuration =
        timeRange.end.difference(timeRange.start); // Calculate total duration
    final point = widget.data[index]; // Current data point

    // Calculate x and y coordinates for the point
    final x = chartArea.left +
        (point.startDate.difference(timeRange.start).inMilliseconds /
                totalDuration.inMilliseconds) *
            chartArea.width;
    final y = chartArea.top +
        widget.style.timelineYOffset +
        (index * widget.style.verticalSpacing);

    return Offset(x, y); // Return calculated position
  }

  /// Handles the tap event on a Gantt point.
  ///
  /// Displays a dialog with details about the tapped task. If the
  /// interactive feature is disabled, no action will be taken.
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
                  '${DateFormat.yMMMMd().format(point.startDate)} - ${DateFormat.yMMMMd().format(point.endDate)}', // Date range for the task
                  style: TextStyle(color: Colors.grey[600]),
                ),
                if (point.description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    point.description!, // Task description
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
                if (point.tapContent != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    point.tapContent!, // Additional content on tap
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () =>
                        Navigator.of(context).pop(), // Close dialog
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    // Invoke tap callback if provided
    widget.onPointTap?.call(point);
  }

  /// Handles hover events on Gantt points.
  ///
  /// Updates the hovered point index and triggers hover callback
  /// if the interactive feature is enabled.
  void _handleHover(bool isHovering, GanttData point, int index) {
    if (!widget.interactive) return;

    setState(() {
      _hoveredPointIndex = isHovering ? index : null; // Update hovered index
    });

    if (isHovering) {
      widget.onPointHover?.call(point); // Trigger hover callback
      debugPrint("Hovered point: ${point.label}"); // Log hovered point
    }
  }

  /// Retrieves the overall time range covered by the Gantt tasks.
  ///
  /// This method determines the earliest start date and the latest end
  /// date among all tasks to establish a range for the timeline.
  DateTimeRange _getTimeRange() {
    DateTime? earliest;
    DateTime? latest;

    for (final point in widget.data) {
      if (earliest == null || point.startDate.isBefore(earliest)) {
        earliest = point.startDate; // Update earliest date
      }
      if (latest == null || point.endDate.isAfter(latest)) {
        latest = point.endDate; // Update latest date
      }
    }

    // Return a range with some padding on either side
    return DateTimeRange(
      start: earliest!.subtract(const Duration(days: 7)),
      end: latest!.add(const Duration(days: 7)),
    );
  }
}
