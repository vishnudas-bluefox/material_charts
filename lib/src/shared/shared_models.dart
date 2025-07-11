import 'package:flutter/material.dart';

/// Represents the style configuration for tooltips across all chart types.
///
/// Tooltips provide contextual information when a user hovers over a
/// data point, enhancing user experience by displaying relevant data
/// in a visually appealing manner.
class TooltipStyle {
  /// The background color of the tooltip.
  ///
  /// This property defines the color of the tooltip's background,
  /// allowing customization to improve visibility and aesthetics.
  final Color backgroundColor;

  /// The border color of the tooltip.
  ///
  /// This property defines the color of the tooltip's border, which can
  /// enhance its appearance and distinguish it from the chart background.
  final Color borderColor;

  /// The border radius of the tooltip.
  ///
  /// This property controls the roundness of the tooltip's corners,
  /// contributing to its overall shape and design.
  final double borderRadius;

  /// The text style used within the tooltip.
  ///
  /// This property defines the styling for the text displayed in the
  /// tooltip, including color, font size, and font weight.
  final TextStyle textStyle;

  /// The padding around the tooltip's content.
  ///
  /// This property specifies the amount of space between the tooltip's
  /// content and its border, improving readability and visual appeal.
  final EdgeInsets padding;

  const TooltipStyle({
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.grey,
    this.borderRadius = 5.0,
    this.textStyle = const TextStyle(color: Colors.black, fontSize: 12),
    this.padding = const EdgeInsets.all(8),
  });
}
