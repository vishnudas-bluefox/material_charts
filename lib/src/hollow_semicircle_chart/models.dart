import 'package:flutter/material.dart';

/// Specifies the style configuration for meter widgets
class ChartStyle {
  final Color activeColor;
  final Color inactiveColor;
  final Color? textColor;
  final TextStyle? percentageStyle;
  final TextStyle? legendStyle;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool showPercentageText;
  final bool showLegend;
  final String Function(double percentage)? percentageFormatter;
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
  final double percentage;
  final double size;
  final ChartStyle style;
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
