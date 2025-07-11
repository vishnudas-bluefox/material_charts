import 'package:flutter/material.dart';
import 'models.dart';

/// A utility class for handling date-related operations for Gantt charts.
class GanttDateUtils {
  /// Calculates the overall time range covered by the Gantt data points.
  ///
  /// This method iterates through the provided list of [GanttData] objects
  /// to find the earliest start date and the latest end date among all tasks.
  /// It then returns a [DateTimeRange] that encompasses this range, with
  /// additional padding of 7 days before the earliest date and after the latest date.
  ///
  /// [data] The list of Gantt data points for which the time range needs to be calculated.
  ///
  /// Returns a [DateTimeRange] representing the adjusted start and end dates.
  static DateTimeRange getTimeRange(List<GanttData> data) {
    DateTime? earliest; // Variable to track the earliest start date
    DateTime? latest; // Variable to track the latest end date

    // Iterate through each GanttData point to determine the earliest and latest dates
    for (final point in data) {
      if (earliest == null || point.startDate.isBefore(earliest)) {
        earliest = point.startDate; // Update earliest date
      }
      if (latest == null || point.endDate.isAfter(latest)) {
        latest = point.endDate; // Update latest date
      }
    }

    // Return the time range with additional padding of 7 days on each end
    return DateTimeRange(
      start: earliest!.subtract(
        const Duration(days: 7),
      ), // Padding before the earliest date
      end: latest!.add(
        const Duration(days: 7),
      ), // Padding after the latest date
    );
  }
}
