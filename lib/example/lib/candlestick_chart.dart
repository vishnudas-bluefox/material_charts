// import 'package:flutter/material.dart';
// import 'dart:math';

// // import 'package:material_charts_tests/examples/tests/test.dart';

// MaterialCandlestickChart exampleCandleStickChart() {
//   DateTime startDate = DateTime(2024, 1, 1);
//   List<CandlestickData> volatileStockData = generateStockData(startDate, 500);
//   return MaterialCandlestickChart(
//     data: [...volatileStockData],
//     width: 400,
//     height: 300,
//     backgroundColor: const Color.fromRGBO(39, 50, 51, 1),
//     style: const CandlestickStyle(
//       verticalLineColor: Colors.white,
//       verticalLineWidth: 1,
//       bullishColor: Color.fromARGB(255, 66, 148, 69),
//       bearishColor: Color.fromARGB(255, 185, 51, 42),
//       candleWidth: 200,
//       spacing: 0.2,
//       tooltipStyle: TooltipStyle(
//         backgroundColor: Colors.grey,
//         textStyle: TextStyle(
//           fontWeight: FontWeight.w500,
//           color: Colors.black,
//         ),
//         borderRadius: 10,
//       ),
//     ),
//     axisConfig: const ChartAxisConfig(
//       labelStyle: TextStyle(
//         color: Colors.white,
//         fontSize: 10,
//         fontWeight: FontWeight.w500,
//       ),
//       priceDivisions: 5,
//       dateDivisions: 6,
//     ),
//     showGrid: true,
//   );
// }
// // import 'dart:math';

// List<CandlestickData> generateStockData(DateTime startDate, int days) {
//   List<CandlestickData> stockData = [];
//   Random random = Random();

//   double previousClose = 100.0; // Starting close price
//   double volatility = 10.0; // Adjust this for more or less volatility

//   for (int i = 0; i < days; i++) {
//     DateTime date = startDate.add(Duration(days: i));

//     // Random price movements
//     double open = previousClose + (random.nextDouble() - 0.5) * volatility;
//     double close = open + (random.nextDouble() - 0.5) * volatility;

//     // Ensuring high and low values are within reasonable limits
//     double high = max(open, close) + (random.nextDouble() * volatility);
//     double low = min(open, close) - (random.nextDouble() * volatility);

//     // Create a new CandlestickData object
//     stockData.add(CandlestickData(
//       date: date,
//       open: open,
//       high: high,
//       low: low,
//       close: close,
//     ));

//     // Set previous close for next iteration
//     previousClose = close;
//   }

//   return stockData;
// }
