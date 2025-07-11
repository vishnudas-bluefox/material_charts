import 'package:flutter/material.dart';
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
