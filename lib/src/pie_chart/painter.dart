import 'dart:math';
import 'package:flutter/material.dart';
import 'models.dart';

/// Custom painter class for rendering a pie chart.
class PieChartPainter extends CustomPainter {
  /// List of data points for the pie chart slices.
  final List<PieChartData> data;

  /// Progress value for animation, ranging from 0.0 to 1.0.
  final double progress;

  /// Style properties for customizing the appearance of the pie chart.
  final PieChartStyle style;

  /// List of all the sizes that each slice will take
  final List<double> sliceSizes;

  /// Padding around the pie chart.
  final EdgeInsets padding;

  /// Index of the currently hovered segment, if any.
  final int? hoveredSegmentIndex;

  /// Bool for showing the label only on hover
  final bool showLabelOnlyOnHover;

  /// Constructor for [PieChartPainter].
  ///
  /// Requires [data], [progress], [style], [padding], and an optional
  /// [hoveredSegmentIndex] to customize the pie chart's appearance and behavior.
  PieChartPainter({
    required this.data,
    required this.progress,
    required this.style,
    required this.sliceSizes,
    required this.padding,
    required this.hoveredSegmentIndex,
    required this.showLabelOnlyOnHover,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Return early if there is no data to display.
    if (data.isEmpty) return;

    // Calculate the center and radius of the pie chart.
    final radius = min(
      (size.width - padding.horizontal) / 2,
      (size.height - padding.vertical) / 2,
    );

    final position = Offset(
      switch (style.chartAlignment.horizontal) {
        Horizontal.center => size.width / 2,
        Horizontal.left => radius + padding.left,
        Horizontal.right => size.width - (padding.right + radius),
      },
      switch (style.chartAlignment.vertical) {
        Vertical.center => size.height / 2,
        Vertical.top => radius + padding.top,
        Vertical.bottom => size.height - (padding.bottom + radius),
      },
    );

    // Draw the segments of the pie chart.
    _drawSegments(canvas, position, radius);

    // Draw the legend if it is enabled in the style.
    if (style.showLegend) {
      _drawLegend(canvas, size);
    }
  }

  /// Draws the segments of the pie chart.
  ///
  /// Iterates through each data point to calculate and render the pie slices.
  void _drawSegments(Canvas canvas, Offset center, double radius) {
    // Calculate the total value of all segments for percentage calculations.
    final total = data.fold(0.0, (sum, item) => sum + item.value);
    // Convert the starting angle from degrees to radians.
    var startAngle = style.startAngle * pi / 180;

    // Iterate through each data point to draw the respective pie slice.
    for (int i = 0; i < data.length; i++) {
      // Calculate the sweep angle for the current slice based on its value.
      final sweepAngle = (sliceSizes[i] / total) * 2 * pi * progress;
      // Determine the color for the segment, falling back to default colors if necessary.
      final segmentColor =
          data[i].color ?? style.defaultColors[i % style.defaultColors.length];

      // Create a paint object with the segment color.
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = hoveredSegmentIndex == i
            ? _lightenColor(segmentColor) // Lighten color if hovered
            : segmentColor;

      // Draw the segment, increasing radius if hovered for elevation effect.
      final segmentRadius = hoveredSegmentIndex == i ? radius * 1.05 : radius;

      // Draw the arc representing the segment of the pie chart.
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: segmentRadius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // Draw hole in the center if specified (for doughnut charts).
      if (style.holeRadius > 0) {
        canvas.drawCircle(
          center,
          radius * style.holeRadius,
          Paint()..color = style.backgroundColor,
        );
      }

      // Draw labels and values if enabled in the style.
      if ((style.showLabels || style.showValues) && (!showLabelOnlyOnHover || hoveredSegmentIndex == i)) {
        _drawLabelsAndValues(
          canvas,
          center,
          radius,
          startAngle,
          sweepAngle,
          i,
          total,
        );
      }

      // Update the starting angle for the next slice.
      startAngle += sweepAngle;
    }
  }

  /// Draws the labels and values for each pie chart segment.
  ///
  /// Calculates the position of the labels based on the angle and radius,
  /// and renders the text on the canvas.
  void _drawLabelsAndValues(
    Canvas canvas,
    Offset center,
    double radius,
    double startAngle,
    double sweepAngle,
    int index,
    double total,
  ) {
    // Calculate the mid-angle of the current segment for label positioning.
    final midAngle = startAngle + (sweepAngle / 2);
    // Calculate the percentage value of the current segment.
    final percentage = (data[index].value / total * 100).toStringAsFixed(1);
    // Determine if the label is on the right side for positioning logic.
    final isRightSide = cos(midAngle) > 0;

    // Determine label radius based on label position style.
    double labelRadius;
    if (style.labelPosition == LabelPosition.inside) {
      labelRadius = radius * 0.7; // Place label inside the segment
    } else {
      labelRadius =
          radius + style.labelOffset; // Place label outside with offset
    }

    // Calculate label position using polar coordinates.
    final x = center.dx + cos(midAngle) * labelRadius;
    final y = center.dy + sin(midAngle) * labelRadius;

    // Define text styles for labels and values, applying defaults if necessary.
    final labelStyle = style.labelStyle ??
        TextStyle(
          color: style.labelPosition == LabelPosition.inside
              ? Colors.white
              : Colors.black87,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        );

    final valueStyle = style.valueStyle ??
        TextStyle(
          color: style.labelPosition == LabelPosition.inside
              ? Colors.white
              : Colors.black87,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        );

    // Draw connector lines if labels are positioned outside and enabled in the style.
    if (style.labelPosition == LabelPosition.outside) {
      if (style.showConnectorLines) {
        final connectorPaint = Paint()
          ..color = style.connectorLineColor
          ..strokeWidth = style.connectorLineStrokeWidth
          ..style = PaintingStyle.stroke;

        // Calculate the inner and outer points for the connector line.
        final innerPoint = Offset(
          center.dx + cos(midAngle) * radius,
          center.dy + sin(midAngle) * radius,
        );

        final outerPoint = Offset(
          center.dx + cos(midAngle) * (radius + style.labelOffset / 2),
          center.dy + sin(midAngle) * (radius + style.labelOffset / 2),
        );

        // Determine the endpoint for the connector line based on label position.
        final endPoint = Offset(
          isRightSide ? x + 20 : x - 20,
          y,
        );

        // Draw the connector line using a path.
        canvas.drawPath(
          Path()
            ..moveTo(innerPoint.dx, innerPoint.dy)
            ..lineTo(outerPoint.dx, outerPoint.dy)
            ..lineTo(endPoint.dx, endPoint.dy),
          connectorPaint,
        );
      }
    }

    // Create a text span that includes the label and value (percentage).
    final textSpan = TextSpan(
      children: [
        TextSpan(text: data[index].label, style: labelStyle),
        if (style.showValues)
          TextSpan(text: ' ($percentage%)', style: valueStyle),
      ],
    );

    // Set up the text painter for rendering the text.
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();

    // Determine X position for text rendering based on label position.
    double textX;
    if (style.labelPosition == LabelPosition.inside) {
      textX = x - textPainter.width / 2; // Center the text inside the segment
    } else {
      textX =
          isRightSide ? x + 25 : x - textPainter.width - 25; // Offset outside
    }

    // Draw the text on the canvas.
    textPainter.paint(
      canvas,
      Offset(textX, y - textPainter.height / 2), // Center vertically
    );
  }

  /// Draws the legend for the pie chart, displaying the color and label for each segment.
  void _drawLegend(Canvas canvas, Size size) {
    const double itemHeight = 24; // Height of each legend item
    const double itemSpacing = 8; // Spacing between legend items
    const double iconSize = 16; // Size of the color box in the legend

    var currentY = padding.top; // Start Y position for the legend
    final legendLeft =
        size.width - padding.right - 120; // Calculate legend position

    // Iterate through each data point to create legend entries.
    for (int i = 0; i < data.length; i++) {
      // Determine color for the legend item.
      final color =
          data[i].color ?? style.defaultColors[i % style.defaultColors.length];

      final isHovered =
          hoveredSegmentIndex == i; // Check if the item is hovered
      final boxPaint = Paint()
        ..color = isHovered ? _lightenColor(color) : color
        ..style = PaintingStyle.fill;

      // Draw a rounded rectangle for the color box in the legend.
      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(legendLeft, currentY + 4, iconSize, iconSize),
        const Radius.circular(4),
      );
      canvas.drawRRect(rrect, boxPaint);

      // Create a text span for the legend label.
      final textSpan = TextSpan(
        text: data[i].label,
        style: style.labelStyle ??
            TextStyle(
              color: Colors.black87,
              fontSize: 12,
              fontWeight: isHovered ? FontWeight.bold : FontWeight.normal,
            ),
      );

      // Set up the text painter for rendering the legend label.
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      // Draw the label next to the color box.
      textPainter.paint(
        canvas,
        Offset(legendLeft + iconSize + itemSpacing, currentY + 4),
      );

      // Increment Y position for the next legend item.
      currentY += itemHeight;
    }
  }

  /// Lightens a color by a small amount for hover effects.
  Color _lightenColor(Color color) {
    final hslColor = HSLColor.fromColor(color); // Convert color to HSL format
    return hslColor
        .withLightness(
          (hslColor.lightness + 0.1).clamp(0.0, 1.0), // Increase lightness
        )
        .toColor(); // Convert back to Color
  }

  @override
  bool shouldRepaint(PieChartPainter oldDelegate) {
    // Redraw if any relevant properties have changed.
    return oldDelegate.progress != progress ||
        oldDelegate.data != data ||
        oldDelegate.style != style ||
        oldDelegate.hoveredSegmentIndex != hoveredSegmentIndex;
  }
}
