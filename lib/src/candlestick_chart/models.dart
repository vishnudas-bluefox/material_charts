import 'package:flutter/material.dart';
import 'dart:convert';

import '../shared/shared_models.dart';

/// Represents data for a single candlestick in a candlestick chart.
///
/// A candlestick encapsulates essential information about price movements
/// within a specific time frame, commonly used in financial trading.
/// Each candlestick displays the opening, closing, high, and low prices
/// within the designated period, helping traders visualize market trends.
class CandlestickData {
  /// The date and time of this candlestick.
  ///
  /// This field stores the moment in time when the candlestick
  /// data was recorded, allowing for chronological tracking of
  /// price movements.
  final DateTime date;

  /// The opening price of the candlestick.
  ///
  /// This value indicates the price at which the asset was traded at
  /// the beginning of the time period represented by this candlestick.
  final double open;

  /// The highest price during the time period of this candlestick.
  ///
  /// This value represents the maximum price reached by the asset
  /// during the specified time frame, providing insight into market
  /// volatility.
  final double high;

  /// The lowest price during the time period of this candlestick.
  ///
  /// This value indicates the minimum price recorded for the asset
  /// during the specified time frame, highlighting potential support levels.
  final double low;

  /// The closing price of the candlestick.
  ///
  /// This value indicates the price at which the asset was last traded
  /// at the end of the time period represented by this candlestick.
  final double close;

  /// Optional volume data for the candlestick.
  ///
  /// This field can hold the volume of trades executed during the
  /// time frame of this candlestick, providing additional context to
  /// price movements. It is nullable to allow flexibility when volume
  /// data is not available.
  final double? volume;

  const CandlestickData({
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    this.volume,
  });

  /// Determines whether this is a bullish (green) or bearish (red) candlestick.
  ///
  /// A candlestick is considered bullish if the closing price is greater
  /// than or equal to the opening price, indicating upward price movement.
  /// Conversely, it is bearish if the closing price is less than the
  /// opening price, indicating downward price movement.
  bool get isBullish => close >= open;

  /// Creates a CandlestickData from individual values at a specific index
  /// from Plotly-style arrays.
  factory CandlestickData.fromPlotlyArrays({
    required List<dynamic> x,
    required List<dynamic> open,
    required List<dynamic> high,
    required List<dynamic> low,
    required List<dynamic> close,
    List<dynamic>? volume,
    required int index,
  }) {
    DateTime parseDate(dynamic dateValue) {
      if (dateValue is String) {
        return DateTime.parse(dateValue);
      } else if (dateValue is DateTime) {
        return dateValue;
      } else if (dateValue is int) {
        return DateTime.fromMillisecondsSinceEpoch(dateValue);
      } else {
        throw ArgumentError('Invalid date format: $dateValue');
      }
    }

    double parseDouble(dynamic value) {
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.parse(value);
      throw ArgumentError('Invalid number format: $value');
    }

    return CandlestickData(
      date: parseDate(x[index]),
      open: parseDouble(open[index]),
      high: parseDouble(high[index]),
      low: parseDouble(low[index]),
      close: parseDouble(close[index]),
      volume: volume != null ? parseDouble(volume[index]) : null,
    );
  }
}

/// Represents the style configuration for candlesticks in the chart.
///
/// This class encapsulates various styling options for rendering
/// candlesticks, allowing users to customize the appearance of
/// the chart to fit their preferences or application theme.
class CandlestickStyle {
  /// The color used for bullish candlesticks.
  ///
  /// This property defines the color displayed for candlesticks
  /// where the closing price is greater than or equal to the
  /// opening price, typically represented in green.
  final Color bullishColor;

  /// The color used for bearish candlesticks.
  ///
  /// This property defines the color displayed for candlesticks
  /// where the closing price is less than the opening price,
  /// typically represented in red.
  final Color bearishColor;

  /// The width of the candlestick body.
  ///
  /// This property specifies the thickness of the candlestick's
  /// body, affecting the overall visual weight of each candlestick.
  final double candleWidth;

  /// The width of the candlestick wick.
  ///
  /// This property specifies the thickness of the line (wick)
  /// extending from the top and bottom of the candlestick body,
  /// representing the high and low prices.
  final double wickWidth;

  /// The spacing between candlesticks.
  ///
  /// This property defines the space between adjacent candlesticks,
  /// allowing for clearer visual separation and improved readability.
  final double spacing;

  /// The duration of the animation when rendering the candlesticks.
  ///
  /// This property specifies how long the animation will take when
  /// the candlestick chart is drawn or updated, providing a smoother
  /// visual transition.
  final Duration animationDuration;

  /// The curve used for the animation.
  ///
  /// This property defines the animation curve to be used during
  /// the candlestick rendering, allowing for variations in speed
  /// throughout the animation.
  final Curve animationCurve;

  /// The color for the vertical line indicators.
  ///
  /// This property defines the color of vertical lines that may be
  /// drawn for additional visual references on the chart, typically used
  /// to denote specific time points.
  final Color verticalLineColor;

  /// The width of the vertical line indicators.
  ///
  /// This property defines the thickness of the vertical lines,
  /// allowing for customization based on user preference or design.
  final double verticalLineWidth;

  /// Styling configuration for tooltips associated with candlesticks.
  final TooltipStyle tooltipStyle;

  const CandlestickStyle({
    this.bullishColor = Colors.green,
    this.bearishColor = Colors.red,
    this.candleWidth = 12.0,
    this.wickWidth = 2.0,
    this.spacing = 0.2,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.animationCurve = Curves.easeInOut,
    this.verticalLineColor = Colors.blue, // Default color
    this.verticalLineWidth = 1.0, // Default width
    this.tooltipStyle = const TooltipStyle(),
  });
}

/// Configuration class for chart axes.
///
/// This class provides settings for the appearance and behavior
/// of the axes in the candlestick chart, including label formatting
/// and divisions, enhancing the overall readability and usability
/// of the chart.
class ChartAxisConfig {
  /// The number of price divisions on the Y-axis.
  ///
  /// This property specifies how many distinct price levels
  /// will be represented on the Y-axis, allowing for better
  /// visualization of price movements.
  final int priceDivisions;

  /// The number of date divisions on the X-axis.
  ///
  /// This property specifies how many distinct time intervals
  /// will be represented on the X-axis, aiding in the chronological
  /// representation of candlestick data.
  final int dateDivisions;

  /// The text style for axis labels.
  ///
  /// This property defines the styling for the labels along the
  /// X-axis and Y-axis, including font size, color, and other
  /// text properties for better readability.
  final TextStyle? labelStyle;

  /// The width reserved for the Y-axis.
  ///
  /// This property specifies the amount of space allocated for
  /// the Y-axis, ensuring that labels and grid lines do not
  /// overlap with the chart's content.
  final double yAxisWidth;

  /// The height reserved for the X-axis.
  ///
  /// This property specifies the amount of space allocated for
  /// the X-axis, allowing for proper placement of time labels
  /// without crowding.
  final double xAxisHeight;

  /// Custom formatter for price labels.
  ///
  /// This property allows the user to define a custom function
  /// that formats price values displayed on the Y-axis, providing
  /// flexibility for different presentation styles.
  final String Function(double price)? priceFormatter;

  /// Custom formatter for date labels.
  ///
  /// This property allows the user to define a custom function
  /// that formats date values displayed on the X-axis, enhancing
  /// the readability of time-related data.
  final String Function(DateTime date)? dateFormatter;

  const ChartAxisConfig({
    this.priceDivisions = 5,
    this.dateDivisions = 5,
    this.labelStyle,
    this.yAxisWidth = 60.0,
    this.xAxisHeight = 30.0,
    this.priceFormatter,
    this.dateFormatter,
  });
}

/// Represents Plotly JSON layout configuration.
class PlotlyLayout {
  final String? title;
  final PlotlyAxis? xaxis;
  final PlotlyAxis? yaxis;

  const PlotlyLayout({this.title, this.xaxis, this.yaxis});

  factory PlotlyLayout.fromJson(Map<String, dynamic> json) {
    return PlotlyLayout(
      title: json['title']?.toString(),
      xaxis: json['xaxis'] != null ? PlotlyAxis.fromJson(json['xaxis']) : null,
      yaxis: json['yaxis'] != null ? PlotlyAxis.fromJson(json['yaxis']) : null,
    );
  }
}

/// Represents Plotly JSON axis configuration.
class PlotlyAxis {
  final String? title;
  final String? type;
  final List<dynamic>? range;

  const PlotlyAxis({this.title, this.type, this.range});

  factory PlotlyAxis.fromJson(Map<String, dynamic> json) {
    return PlotlyAxis(
      title: json['title']?.toString(),
      type: json['type']?.toString(),
      range: json['range'] as List<dynamic>?,
    );
  }
}

/// Represents a single Plotly candlestick trace.
class PlotlyTrace {
  final String type;
  final List<dynamic> x;
  final List<dynamic> open;
  final List<dynamic> high;
  final List<dynamic> low;
  final List<dynamic> close;
  final List<dynamic>? volume;
  final String? name;
  final bool? visible;
  final PlotlyLine? increasing;
  final PlotlyLine? decreasing;

  const PlotlyTrace({
    required this.type,
    required this.x,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    this.volume,
    this.name,
    this.visible,
    this.increasing,
    this.decreasing,
  });

  factory PlotlyTrace.fromJson(Map<String, dynamic> json) {
    return PlotlyTrace(
      type: json['type']?.toString() ?? 'candlestick',
      x: json['x'] as List<dynamic>? ?? [],
      open: json['open'] as List<dynamic>? ?? [],
      high: json['high'] as List<dynamic>? ?? [],
      low: json['low'] as List<dynamic>? ?? [],
      close: json['close'] as List<dynamic>? ?? [],
      volume: json['volume'] as List<dynamic>?,
      name: json['name']?.toString(),
      visible: json['visible'] as bool?,
      increasing: json['increasing'] != null
          ? PlotlyLine.fromJson(json['increasing'])
          : null,
      decreasing: json['decreasing'] != null
          ? PlotlyLine.fromJson(json['decreasing'])
          : null,
    );
  }

  /// Converts this trace to a list of CandlestickData objects.
  List<CandlestickData> toCandlestickData() {
    if (type != 'candlestick') {
      throw ArgumentError('Trace type must be "candlestick", got: $type');
    }

    final dataLength = x.length;
    if (open.length != dataLength ||
        high.length != dataLength ||
        low.length != dataLength ||
        close.length != dataLength) {
      throw ArgumentError(
        'All price arrays must have the same length as x array',
      );
    }

    if (volume != null && volume!.length != dataLength) {
      throw ArgumentError('Volume array must have the same length as x array');
    }

    final List<CandlestickData> candlesticks = [];
    for (int i = 0; i < dataLength; i++) {
      candlesticks.add(
        CandlestickData.fromPlotlyArrays(
          x: x,
          open: open,
          high: high,
          low: low,
          close: close,
          volume: volume,
          index: i,
        ),
      );
    }

    return candlesticks;
  }
}

/// Represents Plotly line styling (for increasing/decreasing candlesticks).
class PlotlyLine {
  final String? color;

  const PlotlyLine({this.color});

  factory PlotlyLine.fromJson(Map<String, dynamic> json) {
    return PlotlyLine(
      color: json['line']?['color']?.toString() ?? json['color']?.toString(),
    );
  }

  Color? toColor() {
    if (color == null) return null;

    // Handle hex colors
    if (color!.startsWith('#')) {
      return Color(int.parse(color!.substring(1), radix: 16) + 0xFF000000);
    }

    // Handle named colors
    switch (color!.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      default:
        return null;
    }
  }
}

/// Main Plotly JSON data structure that matches Python Plotly format.
class PlotlyJson {
  final List<PlotlyTrace> data;
  final PlotlyLayout? layout;

  const PlotlyJson({required this.data, this.layout});

  /// Creates PlotlyJson from a JSON map (typically from JSON.decode).
  factory PlotlyJson.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>? ?? [];
    final traces = dataList
        .map((item) => PlotlyTrace.fromJson(item as Map<String, dynamic>))
        .toList();

    return PlotlyJson(
      data: traces,
      layout: json['layout'] != null
          ? PlotlyLayout.fromJson(json['layout'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Creates PlotlyJson from a JSON string.
  factory PlotlyJson.fromJsonString(String jsonString) {
    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
    return PlotlyJson.fromJson(decoded);
  }

  /// Extracts all candlestick data from all traces.
  List<CandlestickData> toCandlestickData() {
    final List<CandlestickData> allData = [];

    for (final trace in data) {
      if (trace.type == 'candlestick' && (trace.visible ?? true)) {
        allData.addAll(trace.toCandlestickData());
      }
    }

    return allData;
  }

  /// Extracts style configuration from Plotly JSON.
  CandlestickStyle toStyle({CandlestickStyle? baseStyle}) {
    final base = baseStyle ?? const CandlestickStyle();

    // Try to extract colors from the first candlestick trace
    for (final trace in data) {
      if (trace.type == 'candlestick') {
        final increasingColor = trace.increasing?.toColor();
        final decreasingColor = trace.decreasing?.toColor();

        return CandlestickStyle(
          bullishColor: increasingColor ?? base.bullishColor,
          bearishColor: decreasingColor ?? base.bearishColor,
          candleWidth: base.candleWidth,
          wickWidth: base.wickWidth,
          spacing: base.spacing,
          animationDuration: base.animationDuration,
          animationCurve: base.animationCurve,
          verticalLineColor: base.verticalLineColor,
          verticalLineWidth: base.verticalLineWidth,
          tooltipStyle: base.tooltipStyle,
        );
      }
    }

    return base;
  }

  /// Extracts axis configuration from Plotly JSON.
  ChartAxisConfig toAxisConfig({ChartAxisConfig? baseConfig}) {
    final base = baseConfig ?? const ChartAxisConfig();

    return ChartAxisConfig(
      priceDivisions: base.priceDivisions,
      dateDivisions: base.dateDivisions,
      labelStyle: base.labelStyle,
      yAxisWidth: base.yAxisWidth,
      xAxisHeight: base.xAxisHeight,
      priceFormatter: base.priceFormatter,
      dateFormatter: base.dateFormatter,
    );
  }
}
