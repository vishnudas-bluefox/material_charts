import 'package:flutter/material.dart';
import 'models.dart';

/// Extension methods for [List<GanttData>] to enhance functionality related
/// to Gantt chart data manipulation.
extension GanttDataListExtension on List<GanttData> {
  /// Sorts the Gantt data points by their start date.
  ///
  /// This method creates a sorted copy of the original list of [GanttData]
  /// objects based on their [startDate] in ascending order.
  ///
  /// Returns a new list of [GanttData] sorted by start date.
  List<GanttData> sortByStartDate() {
    final sorted = [...this]; // Create a shallow copy of the list
    sorted.sort(
      (a, b) => a.startDate.compareTo(b.startDate),
    ); // Sort by start date
    return sorted; // Return the sorted list
  }

  /// Filters the Gantt data points by a specified date range.
  ///
  /// This method returns a list of [GanttData] objects that fall within the
  /// specified [DateTimeRange]. The method includes data points whose start date
  /// is on or after the range's start date and whose end date is on or before
  /// the range's end date.
  ///
  /// [range] The date range to filter the Gantt data points.
  ///
  /// Returns a list of [GanttData] that falls within the specified date range.
  List<GanttData> filterByDateRange(DateTimeRange range) {
    return where(
      (item) =>
          (item.startDate.isAfter(range.start) ||
              item.startDate.isAtSameMomentAs(range.start)) &&
          (item.endDate.isBefore(range.end) ||
              item.endDate.isAtSameMomentAs(range.end)),
    ).toList();
  }

  /// Groups the Gantt data points by a specified key.
  ///
  /// This method creates a map where each key is derived from the Gantt data points
  /// using the provided [keySelector] function. The values in the map are lists of
  /// [GanttData] that correspond to each key.
  ///
  /// [keySelector] A function that extracts the key from a [GanttData] object.
  ///
  /// Returns a map of keys to lists of [GanttData] grouped by the specified key.
  Map<T, List<GanttData>> groupBy<T>(T Function(GanttData) keySelector) {
    final map = <T, List<GanttData>>{}; // Create an empty map for grouping
    for (final item in this) {
      final key = keySelector(item); // Get the key for the current item
      map.putIfAbsent(key, () => []).add(item); // Group items by key
    }
    return map; // Return the grouped map
  }
}
